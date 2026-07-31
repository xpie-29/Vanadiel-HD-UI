local layout_editor = {};
layout_editor.__index = layout_editor;

local function number_or_zero(value)
    if type(value) == 'number' and value == value
            and value ~= math.huge and value ~= -math.huge then
        return value;
    end
    return 0;
end

function layout_editor.new()
    return setmetatable({
        enabled = false,
        input = {},
        active = nil,
        transient = {},
        commit = nil,
    }, layout_editor);
end

function layout_editor:begin_frame(enabled, input, commit)
    self.enabled = enabled == true;
    self.input = input or {};
    self.commit = commit;

    if not self.enabled then
        self.active = nil;
        self.transient = {};
        return;
    end
    if self.active == nil then
        return;
    end

    local x = self.active.start_x + number_or_zero(self.input.delta_x);
    local y = self.active.start_y + number_or_zero(self.input.delta_y);
    self.transient[self.active.target.key] = { x = x, y = y };

    if self.input.released == true then
        if type(self.commit) == 'function' then
            self.commit(self.active.target, x, y);
        end
        self.active = nil;
        self.transient = {};
    end
end

function layout_editor:position(key, persisted)
    local current = self.transient[key];
    if current ~= nil then
        return current.x, current.y;
    end
    return number_or_zero(persisted and persisted.x),
        number_or_zero(persisted and persisted.y);
end

function layout_editor:offer_drag_surface(target, persisted, hovered)
    if not self.enabled or self.active ~= nil or hovered ~= true
            or self.input.clicked ~= true or type(target) ~= 'table'
            or type(target.key) ~= 'string' then
        return false;
    end

    local x, y = self:position(target.key, persisted);
    self.active = {
        target = target,
        start_x = x,
        start_y = y,
    };
    self.transient[target.key] = { x = x, y = y };
    return true;
end

function layout_editor:is_dragging(key)
    return self.active ~= nil and self.active.target.key == key;
end

return layout_editor;
