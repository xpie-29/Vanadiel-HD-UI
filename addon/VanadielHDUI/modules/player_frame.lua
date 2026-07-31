local player_frame = {};
player_frame.__index = player_frame;

local function finite_number(value)
    if type(value) ~= 'number' or value ~= value
            or value == math.huge or value == -math.huge then
        return nil;
    end
    return value;
end

local function clamp(value, minimum, maximum)
    value = finite_number(value) or minimum;
    if value < minimum then
        return minimum;
    end
    if value > maximum then
        return maximum;
    end
    return value;
end

local function normalize_percent(value, current, maximum)
    local percent = finite_number(value);
    if percent ~= nil then
        if percent > 1 then
            percent = percent / 100;
        end
        return clamp(percent, 0, 1);
    end

    current = finite_number(current);
    maximum = finite_number(maximum);
    if current == nil or maximum == nil or maximum <= 0 then
        return 0;
    end
    return clamp(current / maximum, 0, 1);
end

local job_abbreviations = {
    [1] = 'WAR',
    [2] = 'MNK',
    [3] = 'WHM',
    [4] = 'BLM',
    [5] = 'RDM',
    [6] = 'THF',
    [7] = 'PLD',
    [8] = 'DRK',
    [9] = 'BST',
    [10] = 'BRD',
    [11] = 'RNG',
    [12] = 'SAM',
    [13] = 'NIN',
    [14] = 'DRG',
    [15] = 'SMN',
    [16] = 'BLU',
    [17] = 'COR',
    [18] = 'PUP',
    [19] = 'DNC',
    [20] = 'SCH',
    [21] = 'GEO',
    [22] = 'RUN',
};

local function normalize_job(value)
    if type(value) == 'string' then
        local text = value:upper():match('^%s*(.-)%s*$');
        if text ~= '' then
            return text;
        end
    end

    local number = finite_number(value);
    if number == nil then
        return nil;
    end
    return job_abbreviations[math.floor(number + 0.5)];
end

local function normalize_level(value)
    local number = finite_number(value);
    if number == nil or number < 1 then
        return nil;
    end
    return math.floor(number + 0.5);
end

local function format_job_text(snapshot)
    local main_job = normalize_job(snapshot.main_job);
    local main_level = normalize_level(snapshot.main_job_level);
    if main_job == nil or main_level == nil then
        return '';
    end

    local sub_job = normalize_job(snapshot.sub_job);
    local sub_level = normalize_level(snapshot.sub_job_level);
    if sub_job == nil or sub_level == nil then
        return ('%s %d'):format(main_job, main_level);
    end
    return ('%s %d/%s %d'):format(main_job, main_level, sub_job, sub_level);
end

local function normalize_snapshot(snapshot)
    if type(snapshot) ~= 'table' or snapshot.available ~= true then
        return { available = false };
    end

    local hp = finite_number(snapshot.hp) or 0;
    local mp = finite_number(snapshot.mp) or 0;
    local tp = finite_number(snapshot.tp) or 0;
    return {
        available = true,
        name = tostring(snapshot.name or '') ~= '' and tostring(snapshot.name)
            or 'Player',
        job_text = format_job_text(snapshot),
        hp = math.floor(math.max(0, hp) + 0.5),
        mp = math.floor(math.max(0, mp) + 0.5),
        tp = math.floor(clamp(tp, 0, 3000) + 0.5),
        hp_percent = normalize_percent(snapshot.hp_percent, hp, snapshot.hp_max),
        mp_percent = normalize_percent(snapshot.mp_percent, mp, snapshot.mp_max),
        tp_percent = clamp(tp / 3000, 0, 1),
    };
end

function player_frame.new(descriptor)
    return setmetatable({
        descriptor = descriptor,
        context = nil,
        config = nil,
        preview = nil,
        state = { available = false },
    }, player_frame);
end

function player_frame:init(context)
    self.context = context;
    self.config = context.config;
    self.state = { available = false };
    self.context.logger:debug('player frame initialized');
end

function player_frame:shutdown(reason)
    if self.context ~= nil then
        self.context.logger:debug('player frame shutdown: ' .. tostring(reason));
    end
    self.preview = nil;
    self.config = nil;
    self.context = nil;
    self.state = { available = false };
end

function player_frame:update(_)
    local adapter = self.context and self.context.game
        and self.context.game.local_player;
    if adapter == nil or type(adapter.snapshot) ~= 'function' then
        self.state = { available = false };
        return;
    end

    local ok, snapshot = pcall(adapter.snapshot, adapter);
    self.state = ok and normalize_snapshot(snapshot) or { available = false };
end

function player_frame:render(render_context)
    if self.preview ~= nil and render_context ~= nil then
        render_context:placeholder(self.descriptor, self.preview, self.config);
        return;
    end
    if render_context ~= nil
            and type(render_context.player_frame) == 'function' then
        render_context:player_frame(self.descriptor, self.state, self.config);
    end
end

function player_frame:command(_)
    return false;
end

function player_frame:config_changed(module_config)
    self.config = module_config;
end

function player_frame:preview_changed(enabled, preview_adapter)
    self.preview = enabled and preview_adapter or nil;
end

return player_frame;
