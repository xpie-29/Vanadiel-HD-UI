local util = require('core.util');
local config_window = require('ui.config_window');
local layout_editor_module = require('core.layout_editor');
local presentation_module = require('core.presentation');

local platform = {};
platform.__index = platform;

local render_context = {};
render_context.__index = render_context;

local function read_only_empty()
    return setmetatable({}, {
        __newindex = function ()
            error('game-state adapter is read-only and empty in the core phase');
        end,
    });
end

function render_context.new(imgui)
    return setmetatable({
        imgui = imgui,
        layout_editor = layout_editor_module.new(),
        presentation = presentation_module.new(imgui),
        global_opacity = 1.0,
        global_scale = 1.0,
    }, render_context);
end

local function vector_xy(value, second)
    if type(value) == 'number' then
        return value, tonumber(second) or 0;
    end
    if type(value) ~= 'table' then
        return 0, 0;
    end
    return tonumber(value.x or value[1]) or 0,
        tonumber(value.y or value[2]) or 0;
end

function render_context:begin_frame(application)
    local settings = application:get_settings();
    if settings ~= nil and settings.global ~= nil then
        self.global_opacity = tonumber(settings.global.opacity) or 1.0;
        self.global_scale = tonumber(settings.global.user_scale) or 1.0;
    else
        self.global_opacity = 1.0;
        self.global_scale = 1.0;
    end
    local raw_x, raw_y =
        self.imgui.GetMouseDragDelta(ImGuiMouseButton_Left, 0);
    local delta_x, delta_y = vector_xy(raw_x, raw_y);
    self.layout_editor:begin_frame(application:is_preview_enabled(), {
        clicked = self.imgui.IsMouseClicked(ImGuiMouseButton_Left),
        released = self.imgui.IsMouseReleased(ImGuiMouseButton_Left),
        delta_x = delta_x,
        delta_y = delta_y,
    }, function (target, x, y)
        if target.kind == 'element' then
            application:set_module_element_position(
                target.module_id, target.element_id, x, y);
        else
            application:set_module_position(target.module_id, x, y);
        end
    end);
end

function render_context:_effective_opacity(module_config)
    local module_opacity = tonumber(module_config.opacity) or 1.0;
    local global_opacity = tonumber(self.global_opacity) or 1.0;
    local effective = global_opacity * module_opacity;
    if effective < 0.0 then
        return 0.0;
    end
    if effective > 1.0 then
        return 1.0;
    end
    return effective;
end

function render_context:_effective_scale(module_config)
    local module_scale = tonumber(module_config.scale) or 1.0;
    local global_scale = tonumber(self.global_scale) or 1.0;
    local effective = global_scale * module_scale;
    if effective < 0.25 then
        return 0.25;
    end
    if effective > 4.0 then
        return 4.0;
    end
    return effective;
end

function render_context:_window_origin()
    if self.imgui.GetWindowPos == nil then
        return 0, 0;
    end
    local x, y = vector_xy(self.imgui.GetWindowPos());
    return x, y;
end

local function module_target(descriptor)
    return {
        kind = 'module',
        key = 'module:' .. descriptor.id,
        module_id = descriptor.id,
    };
end

local function element_target(descriptor, element_id)
    return {
        kind = 'element',
        key = 'module:' .. descriptor.id .. ':element:' .. element_id,
        module_id = descriptor.id,
        element_id = element_id,
    };
end

function render_context:_position(descriptor, module_config, element_id)
    local owner = module_target(descriptor);
    local base_x, base_y = self.layout_editor:position(
        owner.key, module_config.position);
    if element_id == nil then
        return base_x, base_y;
    end

    local persisted = module_config.layout.elements[element_id];
    local element_x, element_y = persisted.x, persisted.y;
    if module_config.layout.movement == 'independent' then
        local target = element_target(descriptor, element_id);
        element_x, element_y = self.layout_editor:position(
            target.key, persisted);
    end
    return base_x + element_x, base_y + element_y;
end

function render_context:_drag_target(descriptor, module_config, element_id)
    if element_id ~= nil
            and module_config.layout.movement == 'independent' then
        return element_target(descriptor, element_id),
            module_config.layout.elements[element_id];
    end
    return module_target(descriptor), module_config.position;
end

function render_context:_offer_drag(descriptor, module_config, element_id)
    local hovered = self.imgui.IsWindowHovered(ImGuiHoveredFlags_None);
    if hovered then
        self.imgui.SetMouseCursor(ImGuiMouseCursor_ResizeAll);
    end
    local target, persisted =
        self:_drag_target(descriptor, module_config, element_id);
    self.layout_editor:offer_drag_surface(target, persisted, hovered);
end

function render_context:_generic_lines(descriptor, module_config, scale)
    local presenter = self.presentation;
    local primary = presenter:scaled_size(16, scale, 8);
    local body = presenter:scaled_size(12, scale, 8);
    local hint = presenter:scaled_size(11, scale, 8);
    local spacing = presenter:scaled_size(4, scale, 0);
    return {
        {
            text = descriptor.name,
            size = primary,
            color = 0xFFF3D9A6,
            spacing_after = spacing,
        },
        {
            text = 'PREVIEW ONLY - no live game data',
            size = body,
            color = 0xFF9FB0BD,
            spacing_after = spacing,
        },
        {
            text = 'LEFT-DRAG TO MOVE',
            size = hint,
            color = 0xFF7F8C97,
            spacing_after = spacing,
        },
        {
            text = ('Scale: %.2fx'):format(scale),
            size = body,
            color = 0xFFD9E0E5,
            spacing_after = spacing,
        },
        {
            text = 'Style: ' .. tostring(module_config.style),
            size = body,
            color = 0xFFD9E0E5,
        },
    };
end

function render_context:_party_lines(group, module_config, scale)
    local presenter = self.presentation;
    local title_size = presenter:scaled_size(module_config.options.font_size, scale, 8);
    local body = presenter:scaled_size(12, scale, 8);
    local hint = presenter:scaled_size(11, scale, 8);
    local title_spacing = presenter:scaled_size(6, scale, 0);
    local row_spacing = presenter:scaled_size(3, scale, 0);
    local lines = {};

    if module_config.options.show_group_labels then
        lines[#lines + 1] = {
            text = 'Party ' .. group.id,
            size = title_size,
            color = 0xFFF3D9A6,
            spacing_after = title_spacing,
        };
    end

    lines[#lines + 1] = {
        text = 'PREVIEW ONLY',
        size = body,
        color = 0xFF9FB0BD,
        spacing_after = row_spacing,
    };
    lines[#lines + 1] = {
        text = module_config.layout.movement == 'independent'
            and ('LEFT-DRAG TO MOVE PARTY ' .. group.id)
            or 'LEFT-DRAG TO MOVE ALL PARTIES',
        size = hint,
        color = 0xFF7F8C97,
        spacing_after = row_spacing,
    };
    lines[#lines + 1] = {
        text = ('Title font: %.1f px'):format(title_size),
        size = body,
        color = 0xFFD9E0E5,
        spacing_after = title_spacing,
    };

    for index = 1, #group.slots do
        lines[#lines + 1] = {
            text = group.slots[index].name,
            size = body,
            color = 0xFFE5EAEE,
            spacing_after = index < #group.slots and row_spacing or 0,
        };
    end

    return lines;
end

function render_context:_party(descriptor, preview_data, module_config)
    local imgui = self.imgui;
    local presenter = self.presentation;
    local scale = self:_effective_scale(module_config);
    local padding_x = presenter:scaled_size(12, scale, 4);
    local padding_y = presenter:scaled_size(12, scale, 4);
    local minimum_width = presenter:scaled_size(180, scale, 60);
    local minimum_height = presenter:scaled_size(210, scale, 80);
    for _, group in ipairs(preview_data.groups) do
        local offset_x, offset_y =
            self:_position(descriptor, module_config, group.id);
        local lines = self:_party_lines(group, module_config, scale);
        local text_width, text_height = presenter:measure_lines(lines);
        local width = math.max(minimum_width, text_width + padding_x * 2);
        local height = math.max(minimum_height, text_height + padding_y * 2);
        imgui.SetNextWindowPos(
            { 80 + offset_x, 120 + offset_y }, ImGuiCond_Always);
        imgui.SetNextWindowSize({ width, height }, ImGuiCond_Always);
        imgui.SetNextWindowBgAlpha(self:_effective_opacity(module_config));
        local title = '##vhd_party_preview_' .. group.id;
        if imgui.Begin(title, nil,
                ImGuiWindowFlags_NoResize + ImGuiWindowFlags_NoCollapse
                + ImGuiWindowFlags_NoMove + ImGuiWindowFlags_NoSavedSettings) then
            self:_offer_drag(descriptor, module_config, group.id);
            local draw_list = imgui.GetWindowDrawList();
            local window_x, window_y = self:_window_origin();
            presenter:draw_lines(draw_list,
                window_x + padding_x, window_y + padding_y, lines);
            if imgui.Dummy ~= nil then
                imgui.Dummy({ width, height });
            end
        end
        imgui.End();
    end
end

function render_context:placeholder(descriptor, preview_data, module_config)
    if descriptor.id == 'party' then
        self:_party(descriptor, preview_data, module_config);
        return;
    end

    local imgui = self.imgui;
    local presenter = self.presentation;
    local scale = self:_effective_scale(module_config);
    local offset_x, offset_y = self:_position(descriptor, module_config);
    local lines = self:_generic_lines(descriptor, module_config, scale);
    local padding_x = presenter:scaled_size(12, scale, 4);
    local padding_y = presenter:scaled_size(12, scale, 4);
    local text_width, text_height = presenter:measure_lines(lines);
    local width = math.max(
        presenter:scaled_size(220, scale, 80),
        text_width + padding_x * 2);
    local height = math.max(
        presenter:scaled_size(96, scale, 40),
        text_height + padding_y * 2);
    imgui.SetNextWindowPos({
        40 + descriptor.preview_offset.x + offset_x,
        80 + descriptor.preview_offset.y + offset_y,
    }, ImGuiCond_Always);
    imgui.SetNextWindowSize({ width, height }, ImGuiCond_Always);
    imgui.SetNextWindowBgAlpha(self:_effective_opacity(module_config));
    if imgui.Begin('##vhd_preview_' .. descriptor.id, nil,
            ImGuiWindowFlags_NoResize
            + ImGuiWindowFlags_NoMove
            + ImGuiWindowFlags_NoSavedSettings) then
        self:_offer_drag(descriptor, module_config);
        local draw_list = imgui.GetWindowDrawList();
        local window_x, window_y = self:_window_origin();
        presenter:draw_lines(draw_list,
            window_x + padding_x, window_y + padding_y, lines);
        if imgui.Dummy ~= nil then
            imgui.Dummy({ width, height });
        end
    end
    imgui.End();
end

function platform.new(imgui, descriptors, logger)
    return setmetatable({
        imgui = imgui,
        logger = logger,
        window = config_window.new(imgui, descriptors),
        renderer = render_context.new(imgui),
    }, platform);
end

function platform:clock()
    return os.clock();
end

function platform:create_module_context(descriptor, module_config)
    assert(#(descriptor.capabilities or {}) == 0,
        'live game capabilities are not available in the core phase');
    return {
        logger = self.logger:scoped(descriptor.id),
        config = util.deepcopy(module_config),
        game = read_only_empty(),
    };
end

function platform:render_context()
    return self.renderer;
end

function platform:begin_layout_frame(application)
    self.renderer:begin_frame(application);
end

function platform:render_config_window(application)
    self.window:render(application);
end

function platform:toggle_config_window()
    return self.window:toggle();
end

return platform;
