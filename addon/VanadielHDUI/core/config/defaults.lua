local util = require('core.util');

local defaults = {};
defaults.SCHEMA_VERSION = 2;

local function module_defaults(descriptor)
    local options = {};
    for key, rule in pairs(descriptor.options or {}) do
        options[key] = util.deepcopy(rule.default);
    end
    local layout = {
        movement = 'group',
        elements = {},
    };
    if descriptor.layout ~= nil then
        layout.movement = descriptor.layout.default_movement or 'independent';
        for _, element in ipairs(descriptor.layout.elements or {}) do
            layout.elements[element.id] = {
                x = element.x or 0,
                y = element.y or 0,
            };
        end
    end

    return {
        enabled = descriptor.default_enabled == true,
        style = descriptor.styles[1],
        position = {
            anchor = 'center',
            x = 0,
            y = 0,
        },
        scale = 1.0,
        opacity = 1.0,
        options = options,
        layout = layout,
    };
end

function defaults.build(descriptors)
    local result = {
        schema_version = defaults.SCHEMA_VERSION,
        global = {
            user_scale = 1.0,
            opacity = 1.0,
            pixel_snap = true,
        },
        modules = {},
    };

    for _, descriptor in ipairs(descriptors) do
        result.modules[descriptor.id] = module_defaults(descriptor);
    end
    return result;
end

return defaults;
