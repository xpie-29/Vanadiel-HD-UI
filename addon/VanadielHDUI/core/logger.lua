local logger = {};
logger.__index = logger;

function logger.new(prefix, sink, level)
    return setmetatable({
        prefix = prefix or 'VanaHD',
        sink = sink or print,
        level = level or 'info',
    }, logger);
end

local ranks = { debug = 1, info = 2, warn = 3, error = 4 };

function logger:_write(level, message)
    if ranks[level] < ranks[self.level] then
        return;
    end
    self.sink(('[%s][%s] %s'):format(self.prefix, level:upper(), tostring(message)));
end

function logger:scoped(component)
    return logger.new(self.prefix .. ':' .. component, self.sink, self.level);
end

function logger:debug(message) self:_write('debug', message); end
function logger:info(message) self:_write('info', message); end
function logger:warn(message) self:_write('warn', message); end
function logger:error(message) self:_write('error', message); end

return logger;
