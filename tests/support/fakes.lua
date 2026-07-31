local util = require('core.util');

local fakes = {};

function fakes.memory_store(initial)
    local store = {
        value = util.deepcopy(initial),
        saves = 0,
        closed = false,
        handler = nil,
    };
    function store:load(defaults)
        if self.value == nil then
            self.value = util.deepcopy(defaults);
        end
        return util.deepcopy(self.value);
    end
    function store:save(value)
        self.value = util.deepcopy(value);
        self.saves = self.saves + 1;
        return true;
    end
    function store:set_change_handler(handler)
        self.handler = handler;
    end
    function store:simulate_change(value)
        self.value = util.deepcopy(value);
        if self.handler ~= nil then
            self.handler(util.deepcopy(value));
        end
    end
    function store:close()
        self.closed = true;
        self.handler = nil;
    end
    return store;
end

function fakes.logger()
    local value = { entries = {} };
    function value:_add(level, message)
        self.entries[#self.entries + 1] = level .. ':' .. tostring(message);
    end
    function value:debug(message) self:_add('debug', message); end
    function value:info(message) self:_add('info', message); end
    function value:warn(message) self:_add('warn', message); end
    function value:error(message) self:_add('error', message); end
    function value:scoped(_)
        return self;
    end
    return value;
end

function fakes.events()
    local value = {
        callbacks = {},
        registered = {},
        unregistered = {},
    };
    function value.register(event_name, alias, callback)
        value.callbacks[event_name .. ':' .. alias] = callback;
        value.registered[#value.registered + 1] = event_name .. ':' .. alias;
    end
    function value.unregister(event_name, alias)
        value.callbacks[event_name .. ':' .. alias] = nil;
        value.unregistered[#value.unregistered + 1] = event_name .. ':' .. alias;
    end
    return value;
end

return fakes;
