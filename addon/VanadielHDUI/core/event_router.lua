local event_router = {};
event_router.__index = event_router;

function event_router.new(events, application, command_router, logger)
    return setmetatable({
        events = events,
        application = application,
        commands = command_router,
        logger = logger,
        registrations = {},
        bound = false,
    }, event_router);
end

function event_router:_register(event_name, alias, callback)
    self.events.register(event_name, alias, callback);
    self.registrations[#self.registrations + 1] = {
        event_name = event_name,
        alias = alias,
    };
end

function event_router:bind()
    if self.bound then
        return;
    end
    self.bound = true;
    self:_register('load', 'vanadielhdui_load', function ()
        self.application:load();
    end);
    self:_register('command', 'vanadielhdui_command', function (event)
        if self.commands:handle(event.command) then
            event.blocked = true;
        end
    end);
    self:_register('d3d_present', 'vanadielhdui_present', function ()
        self.application:present();
    end);
    self:_register('unload', 'vanadielhdui_unload', function ()
        self.application:unload();
        self:unbind();
    end);
end

function event_router:unbind()
    if not self.bound then
        return;
    end
    for index = #self.registrations, 1, -1 do
        local registration = self.registrations[index];
        local ok, error_message = pcall(self.events.unregister,
            registration.event_name, registration.alias);
        if not ok then
            self.logger:error('event cleanup failed: ' .. tostring(error_message));
        end
    end
    self.registrations = {};
    self.bound = false;
end

return event_router;
