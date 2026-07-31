local util = require('core.util');
local config_window = require('ui.config_window');
local layout_editor_module = require('core.layout_editor');

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

function render_context:_party(descriptor, preview_data, module_config)
    local imgui = self.imgui;
    for _, group in ipairs(preview_data.groups) do
        local offset_x, offset_y =
            self:_position(descriptor, module_config, group.id);
        imgui.SetNextWindowPos(
            { 80 + offset_x, 120 + offset_y }, ImGuiCond_Always);
        imgui.SetNextWindowSize({ 180, 210 }, ImGuiCond_Always);
        imgui.SetNextWindowBgAlpha(module_config.opacity);
        local title = '##vhd_party_preview_' .. group.id;
        if imgui.Begin(title, nil,
                ImGuiWindowFlags_NoResize + ImGuiWindowFlags_NoCollapse
                + ImGuiWindowFlags_NoMove + ImGuiWindowFlags_NoSavedSettings) then
            self:_offer_drag(descriptor, module_config, group.id);
            if module_config.options.show_group_labels then
                imgui.Text('Party ' .. group.id);
                imgui.Separator();
            end
            imgui.TextDisabled('PREVIEW ONLY');
            if module_config.layout.movement == 'independent' then
                imgui.TextDisabled('LEFT-DRAG TO MOVE PARTY ' .. group.id);
            else
                imgui.TextDisabled('LEFT-DRAG TO MOVE ALL PARTIES');
            end
            imgui.TextDisabled(('Font size setting: %d')
                :format(module_config.options.font_size));
            for _, slot in ipairs(group.slots) do
                imgui.Text(slot.name);
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
    local offset_x, offset_y = self:_position(descriptor, module_config);
    imgui.SetNextWindowPos({
        40 + descriptor.preview_offset.x + offset_x,
        80 + descriptor.preview_offset.y + offset_y,
    }, ImGuiCond_Always);
    imgui.SetNextWindowBgAlpha(module_config.opacity);
    if imgui.Begin('##vhd_preview_' .. descriptor.id, nil,
            ImGuiWindowFlags_AlwaysAutoResize
            + ImGuiWindowFlags_NoMove
            + ImGuiWindowFlags_NoSavedSettings) then
        self:_offer_drag(descriptor, module_config);
        imgui.Text(descriptor.name);
        imgui.TextDisabled('PREVIEW ONLY - no live game data');
        imgui.TextDisabled('LEFT-DRAG TO MOVE');
        imgui.Text('Style: ' .. tostring(module_config.style));
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
