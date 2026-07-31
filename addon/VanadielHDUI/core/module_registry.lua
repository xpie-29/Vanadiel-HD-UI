local util = require('core.util');

local registry = {};
registry.__index = registry;

local function validate_descriptors(descriptors)
    local by_id = {};
    for _, descriptor in ipairs(descriptors) do
        assert(type(descriptor.id) == 'string' and descriptor.id ~= '',
            'module descriptor requires a stable id');
        assert(by_id[descriptor.id] == nil, 'duplicate module id: ' .. descriptor.id);
        assert(type(descriptor.factory) == 'function',
            'module descriptor requires a factory: ' .. descriptor.id);
        if descriptor.layout ~= nil then
            assert(descriptor.layout.default_movement == 'group'
                    or descriptor.layout.default_movement == 'independent',
                'invalid default movement: ' .. descriptor.id);
            local element_ids = {};
            for _, element in ipairs(descriptor.layout.elements or {}) do
                assert(type(element.id) == 'string' and element.id ~= '',
                    'layout element requires a stable id: ' .. descriptor.id);
                assert(element_ids[element.id] == nil,
                    'duplicate layout element: ' .. descriptor.id
                        .. '.' .. element.id);
                assert(type(element.x) == 'number'
                        and type(element.y) == 'number',
                    'layout element requires numeric offsets: '
                        .. descriptor.id .. '.' .. element.id);
                element_ids[element.id] = true;
            end
        end
        by_id[descriptor.id] = descriptor;
    end

    for _, descriptor in ipairs(descriptors) do
        for _, dependency in ipairs(descriptor.dependencies or {}) do
            assert(by_id[dependency] ~= nil,
                ('module %s has unknown dependency %s'):format(descriptor.id, dependency));
        end
    end

    local visiting = {};
    local visited = {};
    local function visit(id)
        assert(not visiting[id], 'module dependency cycle at: ' .. id);
        if visited[id] then
            return;
        end
        visiting[id] = true;
        for _, dependency in ipairs(by_id[id].dependencies or {}) do
            visit(dependency);
        end
        visiting[id] = nil;
        visited[id] = true;
    end
    for _, descriptor in ipairs(descriptors) do
        visit(descriptor.id);
    end
end

function registry.new(descriptors, context_factory, logger, preview_service)
    validate_descriptors(descriptors);
    local value = setmetatable({
        descriptors = descriptors,
        context_factory = context_factory,
        logger = logger,
        preview = preview_service,
        records = {},
        order = {},
        started = false,
        current_settings = nil,
    }, registry);

    for _, descriptor in ipairs(descriptors) do
        value.records[descriptor.id] = {
            descriptor = descriptor,
            instance = nil,
            state = 'disabled',
            error = nil,
        };
        value.order[#value.order + 1] = descriptor.id;
    end

    preview_service:subscribe(function (enabled)
        value:preview_changed(enabled);
    end);
    return value;
end

function registry:_fault(record, hook, error_message)
    record.state = 'faulted';
    record.error = tostring(error_message);
    self.logger:error(('module %s failed in %s: %s')
        :format(record.descriptor.id, hook, tostring(error_message)));
    if record.instance ~= nil and hook ~= 'shutdown' then
        util.safe_call(function ()
            record.instance:shutdown('fault:' .. hook);
        end);
    end
    record.instance = nil;
end

function registry:_invoke(record, hook, ...)
    if record.instance == nil or type(record.instance[hook]) ~= 'function' then
        return true;
    end
    local ok, result = util.safe_call(record.instance[hook], record.instance, ...);
    if not ok then
        self:_fault(record, hook, result);
        return false;
    end
    return true, result;
end

function registry:_create_instance(record, module_config, target_state)
    for _, dependency in ipairs(record.descriptor.dependencies or {}) do
        if self.records[dependency].state ~= 'running' then
            record.error = 'dependency is not running: ' .. dependency;
            self.logger:warn(('module %s not started; %s')
                :format(record.descriptor.id, record.error));
            return false;
        end
    end

    record.error = nil;
    record.state = 'initializing';
    local ok, instance = util.safe_call(record.descriptor.factory);
    if not ok or type(instance) ~= 'table' then
        self:_fault(record, 'factory', instance or 'factory did not return a table');
        return false;
    end
    record.instance = instance;

    local context = self.context_factory(record.descriptor, module_config);
    if not self:_invoke(record, 'init', context) then
        return false;
    end
    record.state = target_state;
    if self.preview.enabled then
        self:_invoke(record, 'preview_changed', true,
            self.preview:adapter_for(record.descriptor));
    end
    return record.state == target_state;
end

function registry:enable(id, module_config)
    local record = assert(self.records[id], 'unknown module: ' .. tostring(id));
    if record.state == 'running' then
        return true;
    end
    if record.state == 'previewing' then
        record.state = 'running';
        return true;
    end
    return self:_create_instance(record, module_config, 'running');
end

function registry:disable(id, reason)
    local record = assert(self.records[id], 'unknown module: ' .. tostring(id));
    if record.state == 'disabled' then
        return true;
    end
    if record.instance ~= nil then
        self:_invoke(record, 'shutdown', reason or 'disabled');
    end
    record.instance = nil;
    record.state = 'disabled';
    record.error = nil;
    return true;
end

function registry:start(settings)
    if self.started then
        return;
    end
    self.started = true;
    self.current_settings = util.deepcopy(settings);
    for _, id in ipairs(self.order) do
        if settings.modules[id].enabled then
            self:enable(id, settings.modules[id]);
        end
    end
end

function registry:apply_configuration(settings)
    if not self.started then
        return;
    end
    self.current_settings = util.deepcopy(settings);
    for _, id in ipairs(self.order) do
        local record = self.records[id];
        local module_config = settings.modules[id];
        if module_config.enabled and record.state == 'previewing' then
            record.state = 'running';
            self:_invoke(record, 'config_changed', util.deepcopy(module_config));
        elseif module_config.enabled and record.state == 'disabled' then
            self:enable(id, module_config);
        elseif not module_config.enabled and record.state == 'running'
                and self.preview.enabled then
            record.state = 'previewing';
            self:_invoke(record, 'config_changed', util.deepcopy(module_config));
        elseif not module_config.enabled and record.state ~= 'disabled'
                and record.state ~= 'previewing' then
            self:disable(id, 'configuration');
        elseif module_config.enabled and record.state == 'running' then
            self:_invoke(record, 'config_changed', util.deepcopy(module_config));
        elseif not module_config.enabled and record.state == 'previewing' then
            self:_invoke(record, 'config_changed', util.deepcopy(module_config));
        end
    end
end

function registry:preview_changed(enabled)
    for _, id in ipairs(self.order) do
        local record = self.records[id];
        if enabled and record.state == 'disabled' and self.current_settings ~= nil then
            self:_create_instance(record, self.current_settings.modules[id], 'previewing');
        elseif record.state == 'running' then
            self:_invoke(record, 'preview_changed', enabled,
                enabled and self.preview:adapter_for(record.descriptor) or nil);
        elseif not enabled and record.state == 'previewing' then
            self:_invoke(record, 'preview_changed', false, nil);
            self:disable(id, 'preview_exit');
        end
    end
end

function registry:update(delta_seconds)
    for _, id in ipairs(self.order) do
        local record = self.records[id];
        if record.state == 'running' or record.state == 'previewing' then
            self:_invoke(record, 'update', delta_seconds);
        end
    end
end

function registry:render(render_context)
    for _, id in ipairs(self.order) do
        local record = self.records[id];
        if record.state == 'running' or record.state == 'previewing' then
            self:_invoke(record, 'render', render_context);
        end
    end
end

function registry:shutdown()
    for index = #self.order, 1, -1 do
        self:disable(self.order[index], 'addon_unload');
    end
    self.started = false;
    self.current_settings = nil;
end

function registry:status()
    local result = {};
    for _, id in ipairs(self.order) do
        result[#result + 1] = {
            id = id,
            state = self.records[id].state,
            error = self.records[id].error,
        };
    end
    return result;
end

return registry;
