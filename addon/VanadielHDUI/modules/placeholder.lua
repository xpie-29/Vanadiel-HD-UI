local placeholder = {};
placeholder.__index = placeholder;

function placeholder.new(descriptor)
    return setmetatable({
        descriptor = descriptor,
        context = nil,
        config = nil,
        preview = nil,
    }, placeholder);
end

function placeholder:init(context)
    self.context = context;
    self.config = context.config;
    self.context.logger:debug('placeholder initialized');
end

function placeholder:shutdown(reason)
    if (self.context ~= nil) then
        self.context.logger:debug('placeholder shutdown: ' .. tostring(reason));
    end
    self.preview = nil;
    self.config = nil;
    self.context = nil;
end

function placeholder:update(_)
end

function placeholder:render(render_context)
    if (self.preview ~= nil and render_context ~= nil) then
        render_context:placeholder(self.descriptor, self.preview, self.config);
    end
end

function placeholder:command(_)
    return false;
end

function placeholder:config_changed(module_config)
    self.config = module_config;
end

function placeholder:preview_changed(enabled, preview_adapter)
    self.preview = enabled and preview_adapter or nil;
end

return placeholder;
