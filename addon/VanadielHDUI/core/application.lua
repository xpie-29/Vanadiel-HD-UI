local util = require('core.util');

local application = {};
application.__index = application;

function application.new(dependencies)
    local descriptor_map = {};
    for _, descriptor in ipairs(dependencies.descriptors) do
        descriptor_map[descriptor.id] = descriptor;
    end
    return setmetatable({
        config = dependencies.config,
        registry = dependencies.registry,
        preview = dependencies.preview,
        platform = dependencies.platform,
        logger = dependencies.logger,
        descriptors = dependencies.descriptors,
        descriptor_map = descriptor_map,
        loaded = false,
        last_clock = nil,
    }, application);
end

function application:load()
    if self.loaded then
        return;
    end
    local settings = self.config:load();
    self.config:subscribe(function (changed)
        self.registry:apply_configuration(changed);
    end);
    self.registry:start(settings);
    self.last_clock = self.platform:clock();
    self.loaded = true;
    self.logger:info('core foundation loaded; gameplay modules are placeholders');
end

function application:unload()
    if not self.loaded then
        return;
    end
    self.preview:exit();
    self.registry:shutdown();
    self.config:shutdown();
    self.loaded = false;
    self.last_clock = nil;
    self.logger:info('core foundation unloaded');
end

function application:present()
    if not self.loaded then
        return;
    end
    local now = self.platform:clock();
    local delta = now - self.last_clock;
    self.last_clock = now;
    if delta < 0 then delta = 0; end
    if delta > 0.25 then delta = 0.25; end

    self.registry:update(delta);
    self.platform:begin_layout_frame(self);
    self.registry:render(self.platform:render_context());
    self.platform:render_config_window(self);
end

function application:toggle_config_window()
    return self.platform:toggle_config_window();
end

function application:is_preview_enabled()
    return self.preview.enabled;
end

function application:set_preview(enabled)
    if enabled then
        self.preview:enter();
    else
        self.preview:exit();
    end
end

function application:get_settings()
    return self.config:get();
end

function application:get_recovery_report()
    return self.config:get_report();
end

function application:set_global(key, value)
    self.config:set_global(key, value);
end

function application:module_enabled(id)
    local settings = self.config:get_module(id);
    return settings and settings.enabled or nil;
end

function application:module_state(id)
    local record = self.registry.records[id];
    return record and record.state or 'unknown';
end

function application:set_module_enabled(id, enabled)
    if self.descriptor_map[id] == nil then
        self.logger:warn('unknown module: ' .. tostring(id));
        return false;
    end
    self.config:set_module_enabled(id, enabled);
    return true;
end

function application:set_module_value(id, path, value)
    if self.descriptor_map[id] == nil then
        return false;
    end
    self.config:set_module(id, path, value);
    return true;
end

function application:set_module_position(id, x, y)
    if self.descriptor_map[id] == nil then
        return false;
    end
    local settings = self.config:get();
    if settings.global.pixel_snap then
        x = math.floor(x + 0.5);
        y = math.floor(y + 0.5);
    end
    self.config:set_module_position(id, x, y);
    return true;
end

function application:set_module_layout_movement(id, movement)
    local descriptor = self.descriptor_map[id];
    if descriptor == nil or descriptor.layout == nil then
        return false;
    end
    if movement ~= 'group' and movement ~= 'independent' then
        return false;
    end
    self.config:set_module_layout_movement(id, movement);
    return true;
end

function application:set_module_element_position(id, element_id, x, y)
    local descriptor = self.descriptor_map[id];
    if descriptor == nil or descriptor.layout == nil then
        return false;
    end
    local settings = self.config:get();
    if settings.modules[id].layout.elements[element_id] == nil then
        return false;
    end
    if settings.global.pixel_snap then
        x = math.floor(x + 0.5);
        y = math.floor(y + 0.5);
    end
    self.config:set_module_element_position(id, element_id, x, y);
    return true;
end

function application:module_option_keys(id)
    local descriptor = self.descriptor_map[id];
    return descriptor and util.keys_sorted(descriptor.options) or {};
end

function application:reset_module(id)
    if self.descriptor_map[id] == nil then
        self.logger:warn('unknown module: ' .. tostring(id));
        return false;
    end
    self.config:reset_module(id);
    return true;
end

function application:reset_all()
    self.preview:exit();
    self.config:reset_all();
end

function application:print_status()
    self.logger:info('preview: ' .. (self.preview.enabled and 'on' or 'off'));
    for _, item in ipairs(self.registry:status()) do
        local suffix = item.error and (' — ' .. item.error) or '';
        self.logger:info(('%s: %s%s'):format(item.id, item.state, suffix));
    end
end

return application;
