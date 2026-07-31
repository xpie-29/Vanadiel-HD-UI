local util = require('core.util');

local preview = {};
preview.__index = preview;

local function generic_adapter(descriptor)
    return {
        kind = 'placeholder',
        label = descriptor.name .. ' — preview only',
        live = false,
    };
end

local function party_adapter()
    local groups = {};
    for group_index = 1, 3 do
        local group = {
            id = ({ 'A', 'B', 'C' })[group_index],
            slots = {},
        };
        for slot = 1, 6 do
            group.slots[slot] = {
                name = ('Preview %s%d'):format(group.id, slot),
                live = false,
            };
        end
        groups[group_index] = group;
    end
    return {
        kind = 'party_proof_3',
        label = 'Party A/B/C — preview only',
        live = false,
        shared_configuration_owner = 'A',
        groups = groups,
    };
end

function preview.new()
    return setmetatable({
        enabled = false,
        generation = 0,
        listeners = {},
    }, preview);
end

function preview:subscribe(listener)
    self.listeners[#self.listeners + 1] = listener;
end

function preview:adapter_for(descriptor)
    if descriptor.id == 'party' then
        return party_adapter();
    end
    return generic_adapter(descriptor);
end

function preview:_notify()
    for _, listener in ipairs(self.listeners) do
        util.safe_call(listener, self.enabled, self.generation);
    end
end

function preview:enter()
    if self.enabled then
        return false;
    end
    self.enabled = true;
    self.generation = self.generation + 1;
    self:_notify();
    return true;
end

function preview:exit()
    if not self.enabled then
        return false;
    end
    self.enabled = false;
    self.generation = self.generation + 1;
    self:_notify();
    return true;
end

function preview:toggle()
    if self.enabled then
        self:exit();
    else
        self:enter();
    end
    return self.enabled;
end

return preview;
