local util = require('core.util');
local defaults_module = require('core.config.defaults');
local migrations = require('core.config.migrations');
local schema = require('core.config.schema');

local service = {};
service.__index = service;

function service.new(store, descriptors, logger)
    return setmetatable({
        store = store,
        descriptors = descriptors,
        logger = logger,
        defaults = defaults_module.build(descriptors),
        settings = nil,
        report = {},
        listeners = {},
        loaded = false,
    }, service);
end

function service:_normalize(raw)
    local migrated, migration_report = migrations.apply(raw,
        defaults_module.SCHEMA_VERSION, self.defaults);
    if migrated == nil then
        local recovered = util.deepcopy(self.defaults);
        return recovered, migration_report;
    end

    local normalized, validation_report = schema.validate(
        migrated, self.defaults, self.descriptors);
    for _, item in ipairs(validation_report) do
        migration_report[#migration_report + 1] = item;
    end
    return normalized, migration_report;
end

function service:_notify()
    for _, listener in ipairs(self.listeners) do
        local ok, error_message = util.safe_call(listener, self.settings);
        if not ok then
            self.logger:error('configuration listener failed: ' .. tostring(error_message));
        end
    end
end

function service:_accept(raw, save)
    self.settings, self.report = self:_normalize(raw);
    if #self.report > 0 then
        self.logger:warn(('configuration recovered with %d adjustment(s)')
            :format(#self.report));
    end
    if save then
        self.store:save(self.settings);
    end
    self:_notify();
    return self.settings;
end

function service:load()
    local raw = self.store:load(self.defaults);
    self.loaded = true;
    self.store:set_change_handler(function (changed)
        self:_accept(changed, true);
    end);
    return self:_accept(raw, true);
end

function service:shutdown()
    if self.loaded and self.settings ~= nil then
        self.store:save(self.settings);
    end
    self.store:close();
    self.loaded = false;
end

function service:subscribe(listener)
    self.listeners[#self.listeners + 1] = listener;
end

function service:get()
    return util.deepcopy(self.settings);
end

function service:get_module(id)
    if self.settings == nil or self.settings.modules[id] == nil then
        return nil;
    end
    return util.deepcopy(self.settings.modules[id]);
end

function service:get_report()
    return util.deepcopy(self.report);
end

function service:_mutate(callback)
    local candidate = util.deepcopy(self.settings);
    callback(candidate);
    self:_accept(candidate, true);
end

function service:set_global(key, value)
    self:_mutate(function (candidate)
        candidate.global[key] = value;
    end);
end

function service:set_module(id, path, value)
    assert(self.settings.modules[id] ~= nil, 'unknown module: ' .. tostring(id));
    self:_mutate(function (candidate)
        local target = candidate.modules[id];
        for index = 1, #path - 1 do
            target = target[path[index]];
        end
        target[path[#path]] = value;
    end);
end

function service:set_module_enabled(id, enabled)
    self:set_module(id, { 'enabled' }, enabled == true);
end

function service:set_module_position(id, x, y)
    assert(self.settings.modules[id] ~= nil, 'unknown module: ' .. tostring(id));
    self:_mutate(function (candidate)
        candidate.modules[id].position.x = x;
        candidate.modules[id].position.y = y;
    end);
end

function service:set_module_layout_movement(id, movement)
    self:set_module(id, { 'layout', 'movement' }, movement);
end

function service:set_module_element_position(id, element_id, x, y)
    assert(self.settings.modules[id] ~= nil, 'unknown module: ' .. tostring(id));
    assert(self.settings.modules[id].layout.elements[element_id] ~= nil,
        'unknown module layout element: ' .. tostring(element_id));
    self:_mutate(function (candidate)
        local element = candidate.modules[id].layout.elements[element_id];
        element.x = x;
        element.y = y;
    end);
end
function service:reset_module(id)
    assert(self.defaults.modules[id] ~= nil, 'unknown module: ' .. tostring(id));
    self:_mutate(function (candidate)
        candidate.modules[id] = util.deepcopy(self.defaults.modules[id]);
    end);
end

function service:reset_all()
    self:_accept(util.deepcopy(self.defaults), true);
end

return service;
