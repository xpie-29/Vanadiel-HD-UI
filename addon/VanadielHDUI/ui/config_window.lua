local config_window = {};
config_window.__index = config_window;
local theme_module = require('ui.theme');
local util = require('core.util');

local anchors = {
    'top_left', 'top', 'top_right',
    'left', 'center', 'right',
    'bottom_left', 'bottom', 'bottom_right',
};

local function next_value(values, current)
    for index, value in ipairs(values) do
        if value == current then
            return values[(index % #values) + 1];
        end
    end
    return values[1];
end

function config_window.new(imgui, descriptors)
    return setmetatable({
        imgui = imgui,
        descriptors = descriptors,
        open = { false },
        theme = theme_module.new(imgui),
    }, config_window);
end

function config_window:toggle()
    self.open[1] = not self.open[1];
    return self.open[1];
end

function config_window:set_open(value)
    self.open[1] = value == true;
end

function config_window:_global_controls(application, settings)
    local imgui = self.imgui;
    imgui.TextColored(self.theme:color('bright_brass'), 'FOUNDATION CONFIGURATION');
    imgui.TextDisabled('Gameplay modules are placeholders in this phase.');

    local preview = { application:is_preview_enabled() };
    if imgui.Checkbox('Preview mode', preview) then
        application:set_preview(preview[1]);
    end
    imgui.TextDisabled('Preview windows: left-click and drag to reposition modules.');

    local user_scale = { settings.global.user_scale };
    if imgui.SliderFloat('Global scale', user_scale, 0.5, 2.0, '%.2f') then
        application:set_global('user_scale', user_scale[1]);
    end

    local opacity = { settings.global.opacity };
    if imgui.SliderFloat('Global opacity', opacity, 0.0, 1.0, '%.2f') then
        application:set_global('opacity', opacity[1]);
    end

    local pixel_snap = { settings.global.pixel_snap };
    if imgui.Checkbox('Pixel snapping', pixel_snap) then
        application:set_global('pixel_snap', pixel_snap[1]);
    end

    if imgui.Button('Reset all settings') then
        application:reset_all();
    end
end

function config_window:_module_controls(application, descriptor, module_settings)
    local imgui = self.imgui;
    imgui.Separator();
    imgui.TextColored(self.theme:color('warm_brass'), descriptor.name);
    if descriptor.notes ~= nil then
        imgui.TextDisabled(descriptor.notes);
    end

    local enabled = { module_settings.enabled };
    if imgui.Checkbox('Enabled##' .. descriptor.id, enabled) then
        application:set_module_enabled(descriptor.id, enabled[1]);
    end
    imgui.SameLine();
    imgui.TextDisabled(application:module_state(descriptor.id));

    if descriptor.layout ~= nil
            and #(descriptor.layout.elements or {}) > 1 then
        local movement = module_settings.layout.movement;
        local movement_label = movement == 'group'
            and 'Move elements as a group'
            or 'Move elements independently';
        imgui.Text('Positioning: ' .. movement_label);
        imgui.SameLine();
        if imgui.Button('Change positioning##' .. descriptor.id) then
            application:set_module_layout_movement(descriptor.id,
                next_value({ 'independent', 'group' }, movement));
        end
    end

    imgui.Text('Style: ' .. tostring(module_settings.style));
    imgui.SameLine();
    if imgui.Button('Next style##' .. descriptor.id) then
        application:set_module_value(descriptor.id, { 'style' },
            next_value(descriptor.styles, module_settings.style));
    end

    imgui.Text('Anchor: ' .. tostring(module_settings.position.anchor));
    imgui.SameLine();
    if imgui.Button('Next anchor##' .. descriptor.id) then
        application:set_module_value(descriptor.id, { 'position', 'anchor' },
            next_value(anchors, module_settings.position.anchor));
    end

    local scale = { module_settings.scale };
    if imgui.SliderFloat('Scale##' .. descriptor.id, scale, 0.5, 2.0, '%.2f') then
        application:set_module_value(descriptor.id, { 'scale' }, scale[1]);
    end
    local opacity = { module_settings.opacity };
    if imgui.SliderFloat('Opacity##' .. descriptor.id, opacity, 0.0, 1.0, '%.2f') then
        application:set_module_value(descriptor.id, { 'opacity' }, opacity[1]);
    end

    local x = { module_settings.position.x };
    if imgui.InputFloat('X offset##' .. descriptor.id, x, 1, 10, '%.0f') then
        application:set_module_value(descriptor.id, { 'position', 'x' }, x[1]);
    end
    local y = { module_settings.position.y };
    if imgui.InputFloat('Y offset##' .. descriptor.id, y, 1, 10, '%.0f') then
        application:set_module_value(descriptor.id, { 'position', 'y' }, y[1]);
    end

    for _, key in ipairs(application:module_option_keys(descriptor.id)) do
        local rule = descriptor.options[key];
        local value = module_settings.options[key];
        if rule.type == 'boolean' then
            local pointer = { value };
            if imgui.Checkbox(key .. '##' .. descriptor.id, pointer) then
                application:set_module_value(descriptor.id,
                    { 'options', key }, pointer[1]);
            end
        elseif rule.type == 'number' and rule.integer then
            local pointer = { value };
            if imgui.SliderInt(key .. '##' .. descriptor.id, pointer,
                    rule.minimum, rule.maximum) then
                application:set_module_value(descriptor.id,
                    { 'options', key }, pointer[1]);
            end
        elseif rule.type == 'number' then
            local pointer = { value };
            if imgui.SliderFloat(key .. '##' .. descriptor.id, pointer,
                    rule.minimum, rule.maximum, '%.1f') then
                application:set_module_value(descriptor.id,
                    { 'options', key }, pointer[1]);
            end
        elseif rule.type == 'enum' then
            imgui.Text(key .. ': ' .. tostring(value));
            imgui.SameLine();
            if imgui.Button('Next##' .. descriptor.id .. key) then
                application:set_module_value(descriptor.id,
                    { 'options', key }, next_value(rule.values, value));
            end
        end
    end

    if imgui.Button('Reset module##' .. descriptor.id) then
        application:reset_module(descriptor.id);
    end
end

function config_window:_render_window(application)
    local imgui = self.imgui;
    imgui.SetNextWindowSize({ 540, 720 }, ImGuiCond_FirstUseEver);
    if imgui.Begin("Vana'diel HD UI - Configuration", self.open, 0) then
        local settings = application:get_settings();
        self:_global_controls(application, settings);

        local report = application:get_recovery_report();
        if #report > 0 then
            imgui.Separator();
            imgui.TextColored({ 1.0, 0.75, 0.25, 1.0 },
                ('Recovered %d configuration value(s).'):format(#report));
        end

        imgui.Separator();
        imgui.TextColored(self.theme:color('bright_brass'), 'MODULES');
        imgui.BeginChild('##vanadielhdui_modules', { 0, 0 }, ImGuiChildFlags_Borders);
        for _, descriptor in ipairs(self.descriptors) do
            self:_module_controls(application, descriptor,
                settings.modules[descriptor.id]);
        end
        imgui.EndChild();
    end
    imgui.End();
end

function config_window:render(application)
    if not self.open[1] then
        return;
    end

    self.theme:push();
    local ok, error_message = util.safe_call(function ()
        self:_render_window(application);
    end);
    self.theme:pop();
    if not ok then
        error(error_message);
    end
end

return config_window;
