local theme = {};
theme.__index = theme;

local colors = {
    midnight_void = { 0.027, 0.043, 0.075, 1.00 },
    abyss_navy = { 0.043, 0.075, 0.125, 1.00 },
    vanadiel_navy = { 0.067, 0.118, 0.180, 1.00 },
    elevated_navy = { 0.094, 0.165, 0.239, 1.00 },
    steel_blue = { 0.149, 0.239, 0.322, 1.00 },
    mist_blue = { 0.369, 0.471, 0.565, 1.00 },
    brass_shadow = { 0.247, 0.192, 0.106, 1.00 },
    tarnished_brass = { 0.435, 0.329, 0.153, 1.00 },
    aged_brass = { 0.604, 0.459, 0.208, 1.00 },
    warm_brass = { 0.769, 0.604, 0.290, 1.00 },
    bright_brass = { 0.882, 0.741, 0.412, 1.00 },
    brass_glint = { 0.953, 0.851, 0.569, 1.00 },
    warm_ivory = { 0.945, 0.918, 0.847, 1.00 },
    pale_parchment = { 0.851, 0.820, 0.741, 1.00 },
    muted_silver = { 0.667, 0.698, 0.729, 1.00 },
    slate_gray = { 0.451, 0.494, 0.533, 1.00 },
    warning_amber = { 0.831, 0.580, 0.247, 1.00 },
};

local color_slots = {
    { 'Text', colors.warm_ivory },
    { 'TextDisabled', colors.slate_gray },
    { 'WindowBg', { 0.067, 0.118, 0.180, 0.94 } },
    { 'ChildBg', { 0.043, 0.075, 0.125, 0.92 } },
    { 'PopupBg', { 0.043, 0.075, 0.125, 0.98 } },
    { 'Border', colors.aged_brass },
    { 'BorderShadow', colors.midnight_void },
    { 'FrameBg', colors.abyss_navy },
    { 'FrameBgHovered', colors.elevated_navy },
    { 'FrameBgActive', colors.steel_blue },
    { 'TitleBg', colors.abyss_navy },
    { 'TitleBgActive', colors.vanadiel_navy },
    { 'TitleBgCollapsed', colors.abyss_navy },
    { 'MenuBarBg', colors.abyss_navy },
    { 'ScrollbarBg', colors.midnight_void },
    { 'ScrollbarGrab', colors.tarnished_brass },
    { 'ScrollbarGrabHovered', colors.aged_brass },
    { 'ScrollbarGrabActive', colors.warm_brass },
    { 'CheckMark', colors.bright_brass },
    { 'SliderGrab', colors.warm_brass },
    { 'SliderGrabActive', colors.bright_brass },
    { 'Button', colors.vanadiel_navy },
    { 'ButtonHovered', colors.elevated_navy },
    { 'ButtonActive', colors.steel_blue },
    { 'Header', colors.vanadiel_navy },
    { 'HeaderHovered', colors.elevated_navy },
    { 'HeaderActive', colors.steel_blue },
    { 'Separator', colors.aged_brass },
    { 'SeparatorHovered', colors.warm_brass },
    { 'SeparatorActive', colors.bright_brass },
    { 'ResizeGrip', colors.tarnished_brass },
    { 'ResizeGripHovered', colors.warm_brass },
    { 'ResizeGripActive', colors.bright_brass },
    { 'TextSelectedBg', { 0.149, 0.239, 0.322, 0.80 } },
    { 'NavCursor', colors.bright_brass },
    { 'ModalWindowDimBg', { 0.027, 0.043, 0.075, 0.72 } },
};

local style_vars = {
    { 'WindowPadding', { 12, 10 } },
    { 'WindowRounding', 3 },
    { 'WindowBorderSize', 1 },
    { 'ChildRounding', 2 },
    { 'ChildBorderSize', 1 },
    { 'PopupRounding', 2 },
    { 'PopupBorderSize', 1 },
    { 'FramePadding', { 8, 4 } },
    { 'FrameRounding', 2 },
    { 'FrameBorderSize', 1 },
    { 'ItemSpacing', { 8, 6 } },
    { 'ItemInnerSpacing', { 6, 4 } },
    { 'ScrollbarSize', 12 },
    { 'ScrollbarRounding', 2 },
    { 'GrabMinSize', 8 },
    { 'GrabRounding', 2 },
};

function theme.new(imgui)
    return setmetatable({
        imgui = imgui,
        color_count = 0,
        variable_count = 0,
    }, theme);
end

function theme:color(name)
    return colors[name];
end

function theme:push()
    assert(self.color_count == 0 and self.variable_count == 0,
        'configuration theme was pushed without a matching pop');

    for _, entry in ipairs(color_slots) do
        local slot = _G['ImGuiCol_' .. entry[1]];
        if slot ~= nil then
            self.imgui.PushStyleColor(slot, entry[2]);
            self.color_count = self.color_count + 1;
        end
    end
    for _, entry in ipairs(style_vars) do
        local slot = _G['ImGuiStyleVar_' .. entry[1]];
        if slot ~= nil then
            self.imgui.PushStyleVar(slot, entry[2]);
            self.variable_count = self.variable_count + 1;
        end
    end
end

function theme:pop()
    if self.variable_count > 0 then
        self.imgui.PopStyleVar(self.variable_count);
    end
    if self.color_count > 0 then
        self.imgui.PopStyleColor(self.color_count);
    end
    self.variable_count = 0;
    self.color_count = 0;
end

return theme;
