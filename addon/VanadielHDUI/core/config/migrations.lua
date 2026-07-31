local util = require('core.util');

local migrations = {};

local function version_zero_to_one(settings)
    settings.global = type(settings.global) == 'table' and settings.global or {};
    settings.modules = type(settings.modules) == 'table' and settings.modules or {};

    if (settings.global.user_scale == nil and settings.global.ui_scale ~= nil) then
        settings.global.user_scale = settings.global.ui_scale;
    end
    settings.global.ui_scale = nil;

    for _, module_settings in pairs(settings.modules) do
        if (type(module_settings) == 'table') then
            if (module_settings.enabled == nil and module_settings.is_enabled ~= nil) then
                module_settings.enabled = module_settings.is_enabled;
            end
            module_settings.is_enabled = nil;
        end
    end

    settings.schema_version = 1;
    return settings;
end

local function version_one_to_two(settings, defaults)
    settings.modules = type(settings.modules) == 'table' and settings.modules or {};
    for id, fallback in pairs(defaults.modules) do
        local module_settings = settings.modules[id];
        if type(module_settings) == 'table' and module_settings.layout == nil then
            module_settings.layout = util.deepcopy(fallback.layout);
        end
    end
    settings.schema_version = 2;
    return settings;
end

local ordered = {
    [0] = version_zero_to_one,
    [1] = version_one_to_two,
};

function migrations.apply(raw, current_version, defaults)
    local settings = util.deepcopy(type(raw) == 'table' and raw or {});
    local source_version = tonumber(settings.schema_version) or 0;
    local report = {};

    if (source_version > current_version) then
        return nil, {
            ('future schema version %d is newer than supported version %d')
                :format(source_version, current_version),
        };
    end

    while source_version < current_version do
        local migrate = ordered[source_version];
        if (migrate == nil) then
            return nil, {
                ('no migration is registered from schema version %d'):format(source_version),
            };
        end
        settings = migrate(settings, defaults);
        report[#report + 1] = ('migrated schema %d to %d')
            :format(source_version, source_version + 1);
        source_version = source_version + 1;
    end

    return settings, report;
end

return migrations;
