local util = require('core.util');
local config_window = require('ui.config_window');
local layout_editor_module = require('core.layout_editor');
local presentation_module = require('core.presentation');

local platform = {};
platform.__index = platform;

local render_context = {};
render_context.__index = render_context;

local player_frame_asset_files = {
    background = 'pframe_bg.png',
    bars = 'pframe_bars.png',
    tp_active = 'pframe_tpactive.png',
    tp_inactive = 'pframe_tpinactive.png',
};

local function read_only_empty()
    return setmetatable({}, {
        __newindex = function ()
            error('game-state adapter is read-only and empty in the core phase');
        end,
    });
end

local function call_method(object, name, ...)
    if object == nil then
        return nil;
    end
    local method = object[name];
    if type(method) ~= 'function' then
        return nil;
    end

    local ok, result = pcall(method, object, ...);
    if ok then
        return result;
    end
    ok, result = pcall(method, ...);
    if ok then
        return result;
    end
    ok, result = pcall(method);
    if ok then
        return result;
    end
    return nil;
end

local function call_first(object, names, ...)
    if object == nil then
        return nil;
    end
    for _, name in ipairs(names) do
        local result = call_method(object, name, ...);
        if result ~= nil then
            return result;
        end
    end
    return nil;
end

local function number_or_nil(value)
    local number = tonumber(value);
    if number == nil or number ~= number
            or number == math.huge or number == -math.huge then
        return nil;
    end
    return number;
end

local function integer_or_nil(value)
    local number = number_or_nil(value);
    if number == nil then
        return nil;
    end
    return math.floor(number + 0.5);
end

local local_player_adapter = {};
local_player_adapter.__index = local_player_adapter;

function local_player_adapter.new(ashita_core)
    return setmetatable({
        ashita_core = ashita_core,
    }, local_player_adapter);
end

function local_player_adapter:_player()
    local core = self.ashita_core or _G.AshitaCore;
    local memory = call_first(core, { 'GetMemoryManager' });
    return call_first(memory, { 'GetPlayer' });
end

function local_player_adapter:_party()
    local core = self.ashita_core or _G.AshitaCore;
    local memory = call_first(core, { 'GetMemoryManager' });
    return call_first(memory, { 'GetParty' });
end

function local_player_adapter:snapshot()
    local player = self:_player();
    local party = self:_party();
    if player == nil and party == nil then
        return { available = false };
    end

    local name = call_first(party, {
        'GetMemberName',
        'GetMemberAlias',
    }, 0) or call_first(player, { 'GetName' });
    local hp = number_or_nil(call_first(party, {
        'GetMemberHP',
        'GetMemberCurrentHP',
    }, 0)) or number_or_nil(call_first(player, { 'GetHP' }));
    local mp = number_or_nil(call_first(party, {
        'GetMemberMP',
        'GetMemberCurrentMP',
    }, 0)) or number_or_nil(call_first(player, { 'GetMP' }));
    local tp = number_or_nil(call_first(party, {
        'GetMemberTP',
    }, 0)) or number_or_nil(call_first(player, { 'GetTP' }));
    if hp == nil and mp == nil and tp == nil then
        return { available = false };
    end

    return {
        available = true,
        name = name,
        main_job = call_first(player, { 'GetMainJob' }),
        main_job_level = integer_or_nil(call_first(player, {
            'GetMainJobLevel',
            'GetMainLevel',
        })),
        sub_job = call_first(player, { 'GetSubJob' }),
        sub_job_level = integer_or_nil(call_first(player, {
            'GetSubJobLevel',
            'GetSubLevel',
        })),
        hp = hp,
        hp_percent = number_or_nil(call_first(party, {
            'GetMemberHPP',
            'GetMemberHPPercent',
        }, 0)) or number_or_nil(call_first(player, { 'GetHPP' })),
        hp_max = number_or_nil(call_first(party, {
            'GetMemberMaxHP',
            'GetMemberHPMax',
        }, 0)) or number_or_nil(call_first(player, { 'GetHPMax', 'GetMaxHP' })),
        mp = mp,
        mp_percent = number_or_nil(call_first(party, {
            'GetMemberMPP',
            'GetMemberMPPercent',
        }, 0)) or number_or_nil(call_first(player, { 'GetMPP' })),
        mp_max = number_or_nil(call_first(party, {
            'GetMemberMaxMP',
            'GetMemberMPMax',
        }, 0)) or number_or_nil(call_first(player, { 'GetMPMax', 'GetMaxMP' })),
        tp = tp,
    };
end

local function join_path(root, file_name)
    if root == nil or root == '' then
        return nil;
    end
    local last = root:sub(-1);
    if last == '\\' or last == '/' then
        return root .. file_name;
    end
    return root .. '\\' .. file_name;
end

local function file_exists(path)
    if path == nil then
        return false;
    end
    local file = io.open(path, 'rb');
    if file == nil then
        return false;
    end
    file:close();
    return true;
end

local d3d_texture_runtime = nil;

local function get_d3d_texture_runtime()
    if d3d_texture_runtime ~= nil then
        return d3d_texture_runtime;
    end

    d3d_texture_runtime = { available = false };
    pcall(require, 'common');
    local ok_ffi, ffi = pcall(require, 'ffi');
    local ok_d3d8, d3d8 = pcall(require, 'd3d8');
    if not ok_ffi or not ok_d3d8 or ffi == nil or d3d8 == nil
            or type(d3d8.get_device) ~= 'function'
            or type(d3d8.gc_safe_release) ~= 'function' then
        return d3d_texture_runtime;
    end

    d3d_texture_runtime = {
        available = true,
        ffi = ffi,
        d3d8 = d3d8,
    };
    return d3d_texture_runtime;
end

local function texture_pointer(texture)
    if texture == nil then
        return nil;
    end
    if type(texture) ~= 'table' then
        return texture;
    end
    if texture.pointer ~= nil then
        return texture.pointer;
    end
    if texture.image == nil then
        return texture;
    end

    local runtime = get_d3d_texture_runtime();
    if not runtime.available then
        return texture;
    end
    local ok, pointer = pcall(function ()
        return tonumber(runtime.ffi.cast('uint32_t', texture.image));
    end);
    return ok and pointer or texture;
end

local function load_d3d_texture(path)
    local runtime = get_d3d_texture_runtime();
    if not runtime.available then
        return nil;
    end

    local ok, texture = pcall(function ()
        local device = runtime.d3d8.get_device();
        if device == nil then
            return nil;
        end

        local texture_out = runtime.ffi.new('IDirect3DTexture8*[1]');
        local result = runtime.ffi.C.D3DXCreateTextureFromFileA(
            device, path, texture_out);
        if result ~= runtime.ffi.C.S_OK or texture_out[0] == nil then
            return nil;
        end

        local image = runtime.d3d8.gc_safe_release(
            runtime.ffi.cast('IDirect3DTexture8*', texture_out[0]));
        return {
            image = image,
            pointer = tonumber(runtime.ffi.cast('uint32_t', image)),
        };
    end);
    if ok then
        return texture;
    end
    return nil;
end

local function load_texture(imgui, path)
    if path == nil then
        return nil;
    end

    local texture = load_d3d_texture(path);
    if texture ~= nil then
        return texture;
    end

    for _, name in ipairs({
            'CreateTextureFromFile',
            'LoadTextureFromFile',
            'CreateImage',
            'LoadImage',
        }) do
        texture = call_method(imgui, name, path);
        if texture ~= nil then
            return texture;
        end
    end
    return nil;
end

local function describe_texture_loader_methods(imgui)
    local names = {
        'CreateTextureFromFile',
        'LoadTextureFromFile',
        'CreateImage',
        'LoadImage',
        'Image',
        'ImageButton',
    };
    local found = {};
    for _, name in ipairs(names) do
        if type(imgui[name]) == 'function' then
            found[#found + 1] = name;
        end
    end
    return #found > 0 and table.concat(found, ', ') or 'none';
end

local function describe_texture_runtime()
    local runtime = get_d3d_texture_runtime();
    if runtime.available then
        return 'd3d8';
    end
    return 'none';
end

local function load_player_frame_assets(imgui, asset_root)
    local result = {};
    for key, file_name in pairs(player_frame_asset_files) do
        local path = join_path(asset_root, file_name);
        local exists = file_exists(path);
        result[key] = {
            path = path,
            exists = exists,
            texture = exists and load_texture(imgui, path) or nil,
        };
    end
    return result;
end

local function count_loaded_assets(assets)
    local count = 0;
    for _, asset in pairs(assets or {}) do
        if asset.texture ~= nil then
            count = count + 1;
        end
    end
    return count;
end

local function count_existing_assets(assets)
    local count = 0;
    for _, asset in pairs(assets or {}) do
        if asset.exists then
            count = count + 1;
        end
    end
    return count;
end

local window_flag_fallbacks = {
    ImGuiWindowFlags_NoTitleBar = 1,
    ImGuiWindowFlags_NoResize = 2,
    ImGuiWindowFlags_NoMove = 4,
    ImGuiWindowFlags_NoScrollbar = 8,
    ImGuiWindowFlags_NoScrollWithMouse = 16,
    ImGuiWindowFlags_NoCollapse = 32,
    ImGuiWindowFlags_NoBackground = 128,
    ImGuiWindowFlags_NoSavedSettings = 256,
    ImGuiWindowFlags_NoBringToFrontOnFocus = 8192,
    ImGuiWindowFlags_NoNavFocus = 131072,
    ImGuiWindowFlags_NoDecoration = 43,
};

local function window_flag(imgui, name)
    return _G[name] or (imgui and imgui[name])
        or window_flag_fallbacks[name] or 0;
end

function render_context.new(imgui, asset_root, logger)
    local player_frame_assets = load_player_frame_assets(imgui, asset_root);
    local loaded_assets = count_loaded_assets(player_frame_assets);
    local existing_assets = count_existing_assets(player_frame_assets);
    if logger ~= nil then
        if asset_root == nil then
            logger:warn('player frame placeholder asset root unavailable');
        elseif existing_assets < 4 then
            logger:warn(('player frame placeholder files found: %d/4 in %s')
                :format(existing_assets, tostring(asset_root)));
            for key, asset in pairs(player_frame_assets) do
                if not asset.exists then
                    logger:warn(('missing player frame placeholder %s: %s')
                        :format(key, tostring(asset.path)));
                end
            end
        elseif loaded_assets == 0 then
            logger:warn(('player frame placeholder files found but textures '
                .. 'were not loaded from %s; using draw-list fallback graphics')
                :format(tostring(asset_root)));
            logger:warn('available D3D texture runtime: '
                .. describe_texture_runtime());
            logger:warn('available imgui image/texture helper methods: '
                .. describe_texture_loader_methods(imgui));
        else
            logger:info(('player frame placeholder files found: %d/4; '
                .. 'textures loaded: %d/4'):format(existing_assets,
                loaded_assets));
        end
    end

    return setmetatable({
        imgui = imgui,
        layout_editor = layout_editor_module.new(),
        presentation = presentation_module.new(imgui),
        player_frame_assets = player_frame_assets,
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

local function clamp(value, minimum, maximum)
    value = tonumber(value) or minimum;
    if value < minimum then
        return minimum;
    end
    if value > maximum then
        return maximum;
    end
    return value;
end

local function draw_rect(draw_list, filled, x1, y1, x2, y2, color)
    if filled and draw_list.AddRectFilled ~= nil then
        draw_list:AddRectFilled({ x1, y1 }, { x2, y2 }, color);
    elseif not filled and draw_list.AddRect ~= nil then
        draw_list:AddRect({ x1, y1 }, { x2, y2 }, color);
    end
end

local function color_with_opacity(color, opacity)
    local alpha = math.floor(clamp(opacity, 0, 1) * 255 + 0.5);
    return alpha * 0x01000000 + color % 0x01000000;
end

local function draw_gradient_rect(draw_list, x1, y1, x2, y2, left_color,
        right_color)
    if draw_list.AddRectFilledMultiColor ~= nil then
        draw_list:AddRectFilledMultiColor({ x1, y1 }, { x2, y2 },
            left_color, right_color, right_color, left_color);
    else
        draw_rect(draw_list, true, x1, y1, x2, y2, left_color);
    end
end

local function draw_image(draw_list, asset, x, y, width, height, color)
    if asset == nil or draw_list.AddImage == nil then
        return false;
    end
    if asset.texture == nil and asset.exists and asset.path ~= nil then
        asset.texture = load_d3d_texture(asset.path);
    end
    if asset.texture == nil then
        return false;
    end

    local ok = pcall(function ()
        draw_list:AddImage(texture_pointer(asset.texture), { x, y },
            { x + width, y + height }, { 0, 0 }, { 1, 1 },
            color or 0xFFFFFFFF);
    end);
    if ok then
        return true;
    end

    ok = pcall(function ()
        draw_list:AddImage(texture_pointer(asset.texture), { x, y },
            { x + width, y + height });
    end);
    return ok;
end

function render_context:_draw_resource_bar(draw_list, presenter, origin_x,
        origin_y, width, height, label, value, percent, colors, scale,
        label_size, value_size, value_alignment, draw_track)
    local label_gap = 4 * scale;
    local label_width = 24 * scale;
    local bar_x = origin_x + label_width + label_gap;
    local value_padding = 8 * scale;
    local value_text = tostring(value);
    local value_width = presenter:measure_text(value_text, value_size);
    local value_x = bar_x + width - value_width - value_padding;
    if value_alignment == 'left' then
        value_x = bar_x + value_padding;
    elseif value_alignment == 'center' then
        value_x = bar_x + (width - value_width) / 2;
    end
    if value_x < bar_x + value_padding then
        value_x = bar_x + value_padding;
    end
    local max_x = bar_x + width - value_padding;
    if value_x + value_width > max_x then
        value_x = math.max(bar_x + value_padding, max_x - value_width);
    end

    presenter:draw_text(draw_list, label, origin_x,
        origin_y + 2 * scale, 0xFFF3D9A6, label_size);
    if draw_track then
        draw_rect(draw_list, true, bar_x, origin_y, bar_x + width,
            origin_y + height, 0xCC142131);
    end
    local fill_width = width * clamp(percent, 0, 1);
    if fill_width > 0 then
        draw_gradient_rect(draw_list, bar_x, origin_y, bar_x + fill_width,
            origin_y + height, colors[1], colors[2]);
    end
    if draw_track then
        draw_rect(draw_list, false, bar_x, origin_y, bar_x + width,
            origin_y + height, 0xFFD0A64A);
    end
    presenter:draw_text(draw_list, value_text, value_x,
        origin_y + 2 * scale, 0xFFE5EAEE, value_size);
end

function render_context:_draw_player_background(draw_list, x, y, width, height,
        opacity)
    if draw_image(draw_list, self.player_frame_assets.background, x, y, width,
            height, color_with_opacity(0xFFFFFFFF, opacity)) then
        return;
    end

    draw_rect(draw_list, true, x, y, x + width, y + height,
        color_with_opacity(0xFF0E1A26, opacity));
    draw_rect(draw_list, false, x, y, x + width, y + height,
        color_with_opacity(0xFFD0A64A, math.min(1, opacity + 0.18)));
end

function render_context:_draw_tp_pips(draw_list, x, y, tp, scale, draw_backing)
    local pip_size = 6.5 * scale;
    local pip_gap = 3 * scale;
    local backing_pad = 3 * scale;
    if draw_backing then
        local backing_width = pip_size * 3 + pip_gap * 2 + backing_pad * 2;
        local backing_height = pip_size + backing_pad * 2;
        draw_rect(draw_list, true, x - backing_pad, y - backing_pad,
            x - backing_pad + backing_width, y - backing_pad + backing_height,
            0xCC142131);
        draw_rect(draw_list, false, x - backing_pad, y - backing_pad,
            x - backing_pad + backing_width, y - backing_pad + backing_height,
            0xFFD0A64A);
    end

    local thresholds = { 1000, 2000, 3000 };
    for index, threshold in ipairs(thresholds) do
        local pip_x = x + (index - 1) * (pip_size + pip_gap);
        local asset = tp >= threshold and self.player_frame_assets.tp_active
            or self.player_frame_assets.tp_inactive;
        if not draw_image(draw_list, asset, pip_x, y, pip_size, pip_size) then
            local fill_color = tp >= threshold and 0xFF7DD6FF or 0x99384955;
            draw_rect(draw_list, true, pip_x, y, pip_x + pip_size,
                y + pip_size, fill_color);
            draw_rect(draw_list, false, pip_x, y, pip_x + pip_size,
                y + pip_size, 0xFFBDEBFF);
        end
    end
end

function render_context:player_frame(descriptor, state, module_config)
    if module_config == nil then
        return;
    end

    local imgui = self.imgui;
    local presenter = self.presentation;
    local scale = self:_effective_scale(module_config);
    local options = module_config.options or {};
    local name_size = presenter:scaled_size(options.name_font_size or 15, scale, 8);
    local job_size = presenter:scaled_size(options.job_font_size or 11, scale, 8);
    local label_size = presenter:scaled_size(
        options.resource_label_font_size or 11, scale, 8);
    local value_size = presenter:scaled_size(
        options.resource_value_font_size or 11, scale, 8);
    local value_alignment = options.resource_value_alignment or 'right';
    local background_enabled = options.background_enabled ~= false;
    local background_opacity = clamp(options.background_opacity or 0.72, 0, 1)
        * self:_effective_opacity(module_config);
    local offset_x, offset_y = self:_position(descriptor, module_config);
    local width = presenter:scaled_size(220, scale, 80);
    local padding = presenter:scaled_size(10, scale, 4);
    local label_width = presenter:scaled_size(24, scale, 10);
    local label_gap = presenter:scaled_size(4, scale, 2);
    local pip_size = presenter:scaled_size(6.5, scale, 2);
    local pip_gap = presenter:scaled_size(3, scale, 1);
    local pip_top_gap = presenter:scaled_size(3, scale, 1);
    local hp_height = presenter:scaled_size(18, scale, 8);
    local small_height = presenter:scaled_size(16, scale, 8);
    local gap = presenter:scaled_size(5, scale, 2);
    local identity_gap = presenter:scaled_size(2, scale, 0);
    local height = math.max(presenter:scaled_size(108, scale, 48),
        padding * 2 + name_size + identity_gap + job_size + gap
        + hp_height + gap + small_height + gap + small_height
        + pip_top_gap + pip_size);
    imgui.SetNextWindowPos({ 40 + offset_x, 80 + offset_y }, ImGuiCond_Always);
    imgui.SetNextWindowSize({ width, height }, ImGuiCond_Always);
    imgui.SetNextWindowBgAlpha(0.0);

    local window_flags = window_flag(imgui, 'ImGuiWindowFlags_NoResize')
        + window_flag(imgui, 'ImGuiWindowFlags_NoMove')
        + window_flag(imgui, 'ImGuiWindowFlags_NoSavedSettings')
        + window_flag(imgui, 'ImGuiWindowFlags_NoTitleBar')
        + window_flag(imgui, 'ImGuiWindowFlags_NoCollapse')
        + window_flag(imgui, 'ImGuiWindowFlags_NoScrollbar')
        + window_flag(imgui, 'ImGuiWindowFlags_NoScrollWithMouse')
        + window_flag(imgui, 'ImGuiWindowFlags_NoBackground')
        + window_flag(imgui, 'ImGuiWindowFlags_NoBringToFrontOnFocus')
        + window_flag(imgui, 'ImGuiWindowFlags_NoNavFocus');

    local pushed_style_vars = 0;
    if imgui.PushStyleVar ~= nil
            and _G.ImGuiStyleVar_WindowBorderSize ~= nil then
        imgui.PushStyleVar(_G.ImGuiStyleVar_WindowBorderSize, 0.0);
        pushed_style_vars = pushed_style_vars + 1;
    end
    if imgui.PushStyleVar ~= nil
            and _G.ImGuiStyleVar_WindowPadding ~= nil then
        imgui.PushStyleVar(_G.ImGuiStyleVar_WindowPadding, { 0, 0 });
        pushed_style_vars = pushed_style_vars + 1;
    end

    if imgui.Begin('VanaHD_PlayerFrame##vhd_player_frame_live', true,
            window_flags) then
        local draw_list = imgui.GetWindowDrawList();
        local window_x, window_y = self:_window_origin();
        local label_x = window_x + padding;
        if background_enabled then
            self:_draw_player_background(draw_list, window_x, window_y, width,
                height, background_opacity);
        end
        local name = state and state.available and state.name or 'Player';
        presenter:draw_text(draw_list, name, label_x,
            window_y + padding, 0xFFF3D9A6, name_size);
        local job_text = state and state.available and state.job_text or '';
        if job_text ~= '' then
            presenter:draw_text(draw_list, job_text, label_x,
                window_y + padding + name_size + identity_gap,
                0xFF9FB0BD, job_size);
        end

        local bar_y = window_y + padding + name_size + identity_gap
            + job_size + gap;
        local bar_width = width - padding * 2 - label_width - label_gap;
        local bar_x = label_x + label_width + label_gap;
        local drew_bar_asset = draw_image(draw_list, self.player_frame_assets.bars, bar_x, bar_y,
            bar_width, hp_height + gap + small_height + gap + small_height
            + pip_top_gap + pip_size + 6 * scale);
        local live = state and state.available;
        self:_draw_resource_bar(draw_list, presenter, label_x, bar_y, bar_width,
            hp_height, 'HP', live and state.hp or 0,
            live and state.hp_percent or 0, { 0xDD1E724B, 0xDD45C984 }, scale,
            label_size, value_size, value_alignment, not drew_bar_asset);
        bar_y = bar_y + hp_height + gap;
        self:_draw_resource_bar(draw_list, presenter, label_x, bar_y, bar_width,
            small_height, 'MP', live and state.mp or 0,
            live and state.mp_percent or 0, { 0xDD244B87, 0xDD68A8E6 }, scale,
            label_size, value_size, value_alignment, not drew_bar_asset);
        bar_y = bar_y + small_height + gap;
        self:_draw_resource_bar(draw_list, presenter, label_x, bar_y, bar_width,
            small_height, 'TP', live and state.tp or 0,
            live and state.tp_percent or 0, { 0xDD8F7621, 0xDDE2C45D }, scale,
            label_size, value_size, value_alignment, not drew_bar_asset);
        local pips_width = pip_size * 3 + pip_gap * 2;
        self:_draw_tp_pips(draw_list, bar_x + bar_width - pips_width,
            bar_y + small_height + pip_top_gap, live and state.tp or 0, scale,
            not drew_bar_asset);
        if imgui.Dummy ~= nil then
            imgui.Dummy({ width, height });
        end
    end
    imgui.End();
    if pushed_style_vars > 0 and imgui.PopStyleVar ~= nil then
        imgui.PopStyleVar(pushed_style_vars);
    end
end

function platform.new(imgui, descriptors, logger, options)
    return setmetatable({
        imgui = imgui,
        logger = logger,
        ashita_core = options and options.ashita_core or nil,
        window = config_window.new(imgui, descriptors),
        renderer = render_context.new(imgui, options and options.asset_root,
            logger and logger:scoped('renderer')),
    }, platform);
end

function platform:clock()
    return os.clock();
end

function platform:create_module_context(descriptor, module_config)
    local game = read_only_empty();
    for _, capability in ipairs(descriptor.capabilities or {}) do
        assert(capability == 'local_player',
            'unsupported live game capability: ' .. tostring(capability));
        game = {
            local_player = local_player_adapter.new(self.ashita_core),
        };
    end
    return {
        logger = self.logger:scoped(descriptor.id),
        config = util.deepcopy(module_config),
        game = game,
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
