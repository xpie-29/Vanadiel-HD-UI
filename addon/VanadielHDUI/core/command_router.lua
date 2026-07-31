local command_router = {};
command_router.__index = command_router;

local function tokenize(command)
    local result = {};
    for value in tostring(command or ''):gmatch('%S+') do
        result[#result + 1] = value;
    end
    return result;
end

local function parse_toggle(value, current)
    value = value and value:lower() or 'toggle';
    if value == 'on' then return true; end
    if value == 'off' then return false; end
    if value == 'toggle' then return not current; end
    return nil;
end

function command_router.new(application, logger)
    return setmetatable({ application = application, logger = logger }, command_router);
end

function command_router:handle(raw)
    local args = tokenize(raw);
    local root = args[1] and args[1]:lower() or '';
    if root ~= '/vhd' and root ~= '/vanadielhdui' then
        return false;
    end

    local action = args[2] and args[2]:lower() or 'config';
    if action == 'config' then
        self.application:toggle_config_window();
    elseif action == 'preview' then
        local desired = parse_toggle(args[3], self.application:is_preview_enabled());
        if desired == nil then
            self.logger:warn('usage: /vhd preview on|off|toggle');
        else
            self.application:set_preview(desired);
        end
    elseif action == 'module' then
        local id = args[3] and args[3]:lower() or '';
        local current = self.application:module_enabled(id);
        local desired = current ~= nil and parse_toggle(args[4], current) or nil;
        if desired == nil then
            self.logger:warn('usage: /vhd module <id> on|off|toggle');
        else
            self.application:set_module_enabled(id, desired);
        end
    elseif action == 'reset' and args[3] and args[3]:lower() == 'all' then
        self.application:reset_all();
    elseif action == 'reset' and args[3] and args[3]:lower() == 'module' and args[4] then
        self.application:reset_module(args[4]:lower());
    elseif action == 'status' then
        self.application:print_status();
    elseif action == 'help' then
        self.logger:info('/vhd config | preview on|off|toggle | module <id> on|off|toggle');
        self.logger:info('/vhd reset module <id> | reset all | status | help');
    else
        self.logger:warn('unknown command; use /vhd help');
    end
    return true;
end

return command_router;
