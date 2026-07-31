local util = {};
local unpack_values = table.unpack or unpack;

function util.deepcopy(value, seen)
    if (type(value) ~= 'table') then
        return value;
    end

    seen = seen or {};
    if (seen[value] ~= nil) then
        return seen[value];
    end

    local copy = {};
    seen[value] = copy;
    for key, item in pairs(value) do
        copy[util.deepcopy(key, seen)] = util.deepcopy(item, seen);
    end
    return copy;
end

function util.replace_table(target, source)
    for key in pairs(target) do
        target[key] = nil;
    end
    for key, value in pairs(source) do
        target[key] = util.deepcopy(value);
    end
    return target;
end

function util.contains(values, expected)
    for _, value in ipairs(values or {}) do
        if (value == expected) then
            return true;
        end
    end
    return false;
end

function util.keys_sorted(values)
    local keys = {};
    for key in pairs(values or {}) do
        keys[#keys + 1] = key;
    end
    table.sort(keys);
    return keys;
end

function util.traceback(message)
    if (debug ~= nil and debug.traceback ~= nil) then
        return debug.traceback(tostring(message), 2);
    end
    return tostring(message);
end

function util.safe_call(callback, ...)
    local arguments = { ... };
    return xpcall(function ()
        return callback(unpack_values(arguments));
    end, util.traceback);
end

return util;
