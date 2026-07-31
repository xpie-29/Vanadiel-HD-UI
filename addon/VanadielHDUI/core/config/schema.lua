local util = require('core.util');

local schema = {};

local anchors = {
    'top_left', 'top', 'top_right',
    'left', 'center', 'right',
    'bottom_left', 'bottom', 'bottom_right',
};
local movement_modes = { 'group', 'independent' };

local function recover(report, path, reason, fallback)
    report[#report + 1] = ('%s recovered (%s)'):format(path, reason);
    return util.deepcopy(fallback);
end

local function boolean_value(value, fallback, path, report)
    if (type(value) == 'boolean') then
        return value;
    end
    return recover(report, path, 'expected boolean', fallback);
end

local function number_value(value, fallback, minimum, maximum, integer, path, report)
    if (type(value) ~= 'number' or value ~= value
            or value == math.huge or value == -math.huge) then
        return recover(report, path, 'expected finite number', fallback);
    end
    if minimum ~= nil and value < minimum then
        return recover(report, path, 'below minimum', fallback);
    end
    if maximum ~= nil and value > maximum then
        return recover(report, path, 'above maximum', fallback);
    end
    if integer and value ~= math.floor(value) then
        return recover(report, path, 'expected integer', fallback);
    end
    return value;
end

local function enum_value(value, fallback, values, path, report)
    if util.contains(values, value) then
        return value;
    end
    return recover(report, path, 'unsupported choice', fallback);
end

local function option_value(value, rule, path, report)
    if rule.type == 'boolean' then
        return boolean_value(value, rule.default, path, report);
    end
    if rule.type == 'number' then
        return number_value(value, rule.default, rule.minimum, rule.maximum,
            rule.integer, path, report);
    end
    if rule.type == 'enum' then
        return enum_value(value, rule.default, rule.values, path, report);
    end
    return recover(report, path, 'unknown schema rule', rule.default);
end

function schema.validate(settings, defaults, descriptors)
    settings = type(settings) == 'table' and settings or {};
    local report = {};
    local normalized = util.deepcopy(defaults);
    local raw_global = type(settings.global) == 'table' and settings.global or {};

    normalized.schema_version = defaults.schema_version;
    normalized.global.user_scale = number_value(raw_global.user_scale,
        defaults.global.user_scale, 0.5, 2.0, false, 'global.user_scale', report);
    normalized.global.opacity = number_value(raw_global.opacity,
        defaults.global.opacity, 0.0, 1.0, false, 'global.opacity', report);
    normalized.global.pixel_snap = boolean_value(raw_global.pixel_snap,
        defaults.global.pixel_snap, 'global.pixel_snap', report);

    local raw_modules = type(settings.modules) == 'table' and settings.modules or {};
    for _, descriptor in ipairs(descriptors) do
        local id = descriptor.id;
        local path = 'modules.' .. id;
        local raw = type(raw_modules[id]) == 'table' and raw_modules[id] or {};
        local fallback = defaults.modules[id];
        local output = normalized.modules[id];

        output.enabled = boolean_value(raw.enabled, fallback.enabled,
            path .. '.enabled', report);
        output.style = enum_value(raw.style, fallback.style, descriptor.styles,
            path .. '.style', report);
        output.scale = number_value(raw.scale, fallback.scale, 0.5, 2.0, false,
            path .. '.scale', report);
        output.opacity = number_value(raw.opacity, fallback.opacity, 0.0, 1.0,
            false, path .. '.opacity', report);

        local position = type(raw.position) == 'table' and raw.position or {};
        output.position.anchor = enum_value(position.anchor, fallback.position.anchor,
            anchors, path .. '.position.anchor', report);
        output.position.x = number_value(position.x, fallback.position.x,
            -16384, 16384, false, path .. '.position.x', report);
        output.position.y = number_value(position.y, fallback.position.y,
            -16384, 16384, false, path .. '.position.y', report);

        local layout = type(raw.layout) == 'table' and raw.layout or {};
        local allowed_movement = descriptor.layout ~= nil
            and movement_modes or { 'group' };
        output.layout.movement = enum_value(layout.movement,
            fallback.layout.movement, allowed_movement,
            path .. '.layout.movement', report);
        local elements = type(layout.elements) == 'table'
            and layout.elements or {};
        for _, element in ipairs(
                descriptor.layout and descriptor.layout.elements or {}) do
            local element_path = path .. '.layout.elements.' .. element.id;
            local raw_element = type(elements[element.id]) == 'table'
                and elements[element.id] or {};
            local fallback_element = fallback.layout.elements[element.id];
            output.layout.elements[element.id].x = number_value(
                raw_element.x, fallback_element.x, -16384, 16384, false,
                element_path .. '.x', report);
            output.layout.elements[element.id].y = number_value(
                raw_element.y, fallback_element.y, -16384, 16384, false,
                element_path .. '.y', report);
        end

        local options = type(raw.options) == 'table' and raw.options or {};
        for key, rule in pairs(descriptor.options or {}) do
            output.options[key] = option_value(options[key], rule,
                path .. '.options.' .. key, report);
        end
    end

    return normalized, report;
end

return schema;
