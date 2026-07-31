local util = require('core.util');

local ashita_store = {};
ashita_store.__index = ashita_store;

local function settings_table(value)
    if type(_G.T) == 'function' then
        return T(value);
    end
    return value;
end

function ashita_store.new(settings_library, alias, logger)
    return setmetatable({
        library = settings_library,
        alias = alias or 'settings',
        logger = logger,
        data = nil,
        change_handler = nil,
        callback_alias = 'vanadielhdui_config_store',
        registered = false,
    }, ashita_store);
end

function ashita_store:_existing_path()
    return self.library.settings_path() .. self.alias .. '.lua';
end

function ashita_store:_preserve_invalid_file()
    local path = self:_existing_path();
    if not ashita.fs.exists(path) then
        return;
    end

    local chunk, compile_error = loadfile(path);
    local valid = chunk ~= nil;
    if valid then
        local ok, value = pcall(chunk);
        valid = ok and type(value) == 'table';
    end
    if valid then
        return;
    end

    local source = io.open(path, 'rb');
    if source == nil then
        self.logger:warn('invalid settings detected but backup could not be read');
        return;
    end
    local contents = source:read('*all');
    source:close();

    local suffix = os.date('%Y%m%d-%H%M%S');
    local backup_path = self.library.settings_path()
        .. self.alias .. '.invalid-' .. suffix .. '.lua';
    local backup = io.open(backup_path, 'wb');
    if backup == nil then
        self.logger:warn('invalid settings detected but backup could not be written');
        return;
    end
    backup:write(contents);
    backup:close();
    self.logger:warn('invalid settings preserved before default recovery');
    if compile_error ~= nil then
        self.logger:debug('settings compilation failed before recovery');
    end
end

function ashita_store:load(defaults)
    self:_preserve_invalid_file();
    self.data = self.library.load(settings_table(util.deepcopy(defaults)), self.alias);
    return util.deepcopy(self.data);
end

function ashita_store:save(value)
    local cached = self.library.get(self.alias);
    if cached == nil then
        return false;
    end
    util.replace_table(cached, value);
    self.data = cached;
    return self.library.save(self.alias);
end

function ashita_store:set_change_handler(handler)
    self.change_handler = handler;
    if self.registered then
        return;
    end
    self.library.register(self.alias, self.callback_alias, function (changed)
        self.data = changed;
        if self.change_handler ~= nil then
            self.change_handler(util.deepcopy(changed));
        end
    end);
    self.registered = true;
end

function ashita_store:close()
    if self.registered then
        self.library.unregister(self.alias, self.callback_alias);
        self.registered = false;
    end
    self.change_handler = nil;
end

return ashita_store;
