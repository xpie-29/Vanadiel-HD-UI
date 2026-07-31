local placeholder = require('modules.placeholder');
local player_frame = require('modules.player_frame');

local function option_boolean(default)
    return { type = 'boolean', default = default };
end

local function option_number(default, minimum, maximum, integer)
    return {
        type = 'number',
        default = default,
        minimum = minimum,
        maximum = maximum,
        integer = integer == true,
    };
end

local function option_enum(default, values)
    return { type = 'enum', default = default, values = values };
end

local function descriptor(id, name, styles, options, notes, layout, capabilities,
        factory, controls)
    local value = {
        id = id,
        name = name,
        default_enabled = false,
        styles = styles or { 'standard' },
        dependencies = {},
        capabilities = capabilities or {},
        options = options or {},
        notes = notes,
        layout = layout,
        controls = controls or {},
    };
    value.factory = function ()
        if factory ~= nil then
            return factory(value);
        end
        return placeholder.new(value);
    end;
    return value;
end

local descriptors = {
    descriptor('player_frame', 'Player Frame', { 'style_1' },
        {
            name_font_size = option_number(15, 8, 32, true),
            job_font_size = option_number(11, 8, 24, true),
            resource_label_font_size = option_number(11, 8, 24, true),
            resource_value_font_size = option_number(11, 8, 24, true),
            resource_value_alignment = option_enum('right',
                { 'left', 'center', 'right' }),
            background_enabled = option_boolean(true),
            background_opacity = option_number(0.72, 0.0, 1.0, false),
        }, 'Live local player name, job/subjob, HP, MP, and TP.',
        nil, { 'local_player' }, function (value)
            return player_frame.new(value);
        end, { anchor = false }),
    descriptor('target_frame', 'Target Frame', { 'style_1' }),
    descriptor('party', 'Party and Alliance Frames', { 'proof_3' }, {
        show_group_labels = option_boolean(false),
        font_size = option_number(14, 8, 32, true),
    }, 'Party A owns shared presentation; each group owns its position.', {
        default_movement = 'independent',
        elements = {
            { id = 'A', x = 0, y = 0 },
            { id = 'B', x = 190, y = 0 },
            { id = 'C', x = 380, y = 0 },
        },
    }),
    descriptor('status_recast', 'Status and Recast Tray', { 'icons', 'bars', 'hybrid' }, {
        show_threshold_colors = option_boolean(false),
    }),
    descriptor('notifications', 'Notifications', { 'standard' }, {
        duration_seconds = option_number(6, 1, 30, false),
        maximum_lines = option_number(5, 1, 20, true),
        group_exact_duplicates = option_boolean(true),
    }),
    descriptor('loot_history', 'Loot History', { 'standard' }),
    descriptor('treasure_pool', 'Treasure Pool', { 'standard' }),
    descriptor('synthesis_history', 'Synthesis History', { 'standard' },
        {}, 'Live behavior remains blocked on native-source verification.'),
    descriptor('chat', 'Chat Display', { 'dual', 'single_with_central_style_3' }, {
        exposed_lines = option_enum(12, { 8, 12, 16 }),
        second_window_enabled = option_boolean(true),
    }),
    descriptor('minimap', 'Minimap', {
        'central_style_1', 'central_style_2', 'central_style_3',
    }),
    descriptor('hotbars', 'Hotbars', {
        'central_style_1', 'central_style_2', 'central_style_3',
    }),
    descriptor('experience', 'Experience and Limit-Point Bar', {
        'central_style_1', 'central_style_2', 'central_style_3',
    }),
    descriptor('job_pet', 'Job and Pet Unit Frame', { 'standard' },
        {}, 'Q-011B fields remain pending; this descriptor grants no game data.'),
};

for index, value in ipairs(descriptors) do
    value.preview_offset = {
        x = ((index - 1) % 4) * 240,
        y = math.floor((index - 1) / 4) * 100,
    };
end

return descriptors;
