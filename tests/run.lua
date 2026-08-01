local script = arg and arg[0] or 'tests/run.lua';
local root = script:gsub('[\\/]+tests[\\/]run%.lua$', '');
if root == script or root == '' then
    root = '.';
end
package.path = table.concat({
    root .. '/addon/VanadielHDUI/?.lua',
    root .. '/addon/VanadielHDUI/?/init.lua',
    root .. '/tests/?.lua',
    root .. '/tests/?/init.lua',
    package.path,
}, ';');

local util = require('core.util');
local descriptors = require('modules.descriptors');
local defaults_module = require('core.config.defaults');
local config_service = require('core.config.service');
local preview_module = require('core.preview');
local registry_module = require('core.module_registry');
local event_router = require('core.event_router');
local layout_editor_module = require('core.layout_editor');
local fakes = require('support.fakes');

local tests = {};

local function test(name, callback)
    tests[#tests + 1] = { name = name, callback = callback };
end

local function equal(actual, expected, message)
    if actual ~= expected then
        error(('%s (expected %s, got %s)'):format(
            message or 'values differ', tostring(expected), tostring(actual)), 2);
    end
end

local function truthy(value, message)
    if not value then
        error(message or 'expected truthy value', 2);
    end
end

test('all runtime Lua files compile', function ()
    local runtime_files = {
        'VanadielHDUI.lua',
        'core/application.lua',
        'core/command_router.lua',
        'core/event_router.lua',
        'core/layout_editor.lua',
        'core/logger.lua',
        'core/module_registry.lua',
        'core/preview.lua',
        'core/presentation.lua',
        'core/color.lua',
        'core/util.lua',
        'core/config/ashita_store.lua',
        'core/config/defaults.lua',
        'core/config/migrations.lua',
        'core/config/schema.lua',
        'core/config/service.lua',
        'core/platform/ashita.lua',
        'modules/descriptors.lua',
        'modules/placeholder.lua',
        'modules/player_frame.lua',
        'ui/config_window.lua',
        'ui/theme.lua',
    };
    for _, path in ipairs(runtime_files) do
        local chunk, error_message = loadfile(
            root .. '/addon/VanadielHDUI/' .. path);
        truthy(chunk, path .. ': ' .. tostring(error_message));
    end
end);

test('addon asset root path normalizes trailing slash', function ()
    local source = assert(io.open(root .. '/addon/VanadielHDUI/VanadielHDUI.lua',
        'rb')):read('*a');
    truthy(source:find("path:gsub", 1, true) ~= nil,
        'addon path collapses repeated separators before appending assets');
    truthy(source:find("assets\\\\player_frame", 1, true) ~= nil,
        'player frame asset root points inside addon folder');
end);

test('configuration defaults round trip', function ()
    local store = fakes.memory_store(nil);
    local service = config_service.new(store, descriptors, fakes.logger());
    local loaded = service:load();
    equal(loaded.schema_version, 2, 'schema version');
    equal(loaded.modules.party.enabled, false, 'placeholder default');
    equal(loaded.modules.player_frame.options.name_font_size, 18,
        'player name font default');
    equal(loaded.modules.player_frame.options.job_font_size, 13,
        'player job font default');
    equal(loaded.modules.player_frame.options.resource_label_font_size, 16,
        'player resource label font default');
    equal(loaded.modules.player_frame.options.resource_value_font_size, 16,
        'player resource value font default');
    equal(loaded.modules.player_frame.options.resource_value_alignment, 'right',
        'player resource value alignment default');
    equal(loaded.global.font_family, 'default', 'global font family default');
    equal(loaded.global.font_outline_enabled, true,
        'global font outline enabled default');
    equal(loaded.global.font_outline_size, 2,
        'global font outline size default');
    equal(loaded.global.font_outline_color, '#000000',
        'global font outline color default');
    equal(loaded.modules.player_frame.options.name_font_color, '#F1EAD8',
        'player name font color default');
    equal(loaded.modules.player_frame.options.hp_label_font_color, '#F1EAD8',
        'player HP label font color default');
    equal(loaded.modules.player_frame.options.tp_jewel_flash_enabled, true,
        'player TP jewel flash enabled default');
    equal(loaded.modules.player_frame.options.tp_jewel_flash_color, '#FFFFFF',
        'player TP jewel flash color default');
    equal(loaded.modules.player_frame.options.background_enabled, true,
        'player background enabled default');
    equal(loaded.modules.player_frame.options.background_opacity, nil,
        'player background opacity option removed');
    equal(loaded.modules.party.options.font_size, 14, 'party font default');
    equal(loaded.modules.party.layout.movement, 'independent',
        'party movement default');
    equal(loaded.modules.party.layout.elements.B.x, 190,
        'party B default offset');
    truthy(store.saves >= 1, 'normalized settings were saved');

    local second_store = fakes.memory_store(store.value);
    local second = config_service.new(second_store, descriptors, fakes.logger());
    local reloaded = second:load();
    equal(reloaded.global.user_scale, 1.0, 'round-trip global scale');
    equal(reloaded.modules.party.style, 'proof_3', 'round-trip party style');
end);

test('legacy schema migrates before validation', function ()
    local legacy = {
        global = { ui_scale = 1.25, opacity = 0.8, pixel_snap = true },
        modules = {
            party = {
                is_enabled = true,
                style = 'proof_3',
                position = { anchor = 'center', x = 10, y = 20 },
                scale = 1,
                opacity = 1,
                options = { show_group_labels = true, font_size = 18 },
            },
        },
    };
    local service = config_service.new(
        fakes.memory_store(legacy), descriptors, fakes.logger());
    local loaded = service:load();
    equal(loaded.schema_version, 2, 'migrated version');
    equal(loaded.global.user_scale, 1.25, 'renamed global scale');
    equal(loaded.modules.party.enabled, true, 'renamed enabled flag');
    equal(loaded.modules.party.layout.movement, 'independent',
        'layout defaults added by migration');
    truthy(#service:get_report() >= 1, 'migration was reported');
end);

test('invalid fields recover independently', function ()
    local invalid = defaults_module.build(descriptors);
    invalid.global.user_scale = 'large';
    invalid.global.font_family = 'papyrus';
    invalid.global.font_outline_size = 1.5;
    invalid.global.font_outline_color = 'black';
    invalid.modules.party.enabled = 'yes';
    invalid.modules.party.style = 'rejected_proof';
    invalid.modules.party.position.x = math.huge;
    invalid.modules.party.options.font_size = 14.5;
    invalid.modules.party.options.show_group_labels = true;
    invalid.modules.player_frame.options.hp_label_font_color = 'red';

    local service = config_service.new(
        fakes.memory_store(invalid), descriptors, fakes.logger());
    local loaded = service:load();
    equal(loaded.global.user_scale, 1.0, 'invalid scale recovered');
    equal(loaded.global.font_family, 'default',
        'invalid font family recovered');
    equal(loaded.global.font_outline_size, 2,
        'invalid outline size recovered');
    equal(loaded.global.font_outline_color, '#000000',
        'invalid outline color recovered');
    equal(loaded.modules.party.enabled, false, 'invalid enabled recovered');
    equal(loaded.modules.party.style, 'proof_3', 'invalid style recovered');
    equal(loaded.modules.party.position.x, 0, 'invalid position recovered');
    equal(loaded.modules.party.options.font_size, 14, 'fractional font recovered');
    equal(loaded.modules.party.options.show_group_labels, true,
        'valid sibling survived');
    equal(loaded.modules.player_frame.options.hp_label_font_color, '#F1EAD8',
        'invalid module color recovered');
    truthy(#service:get_report() >= 9, 'recoveries were reported');
end);

test('future schema fails closed to defaults', function ()
    local future = defaults_module.build(descriptors);
    future.schema_version = 99;
    future.modules.party.enabled = true;
    local service = config_service.new(
        fakes.memory_store(future), descriptors, fakes.logger());
    local loaded = service:load();
    equal(loaded.schema_version, 2, 'future version recovered');
    equal(loaded.modules.party.enabled, false, 'future values were not trusted');
end);

test('module and global resets are isolated', function ()
    local store = fakes.memory_store(nil);
    local service = config_service.new(store, descriptors, fakes.logger());
    service:load();
    service:set_global('user_scale', 1.5);
    service:set_module('party', { 'options', 'font_size' }, 20);
    service:set_module_enabled('party', true);
    service:reset_module('party');
    equal(service:get().global.user_scale, 1.5, 'module reset kept global value');
    equal(service:get_module('party').options.font_size, 14, 'module reset font');
    equal(service:get_module('party').enabled, false, 'module reset enabled state');
    service:reset_all();
    equal(service:get().global.user_scale, 1.0, 'global reset restored default');
end);

test('multi-element layout positions and movement mode persist independently',
        function ()
    local store = fakes.memory_store(nil);
    local service = config_service.new(store, descriptors, fakes.logger());
    service:load();
    local saves = store.saves;

    service:set_module_element_position('party', 'B', 260, 40);
    local party = service:get_module('party');
    equal(party.layout.elements.A.x, 0, 'party A position unchanged');
    equal(party.layout.elements.B.x, 260, 'party B x changed');
    equal(party.layout.elements.B.y, 40, 'party B y changed');
    equal(party.layout.elements.C.x, 380, 'party C position unchanged');
    equal(store.saves, saves + 1, 'element position saved atomically');

    service:set_module_layout_movement('party', 'group');
    party = service:get_module('party');
    equal(party.layout.movement, 'group', 'group movement selected');
    equal(party.layout.elements.B.x, 260, 'independent offset preserved');

    service:set_module_position('party', 25, -10);
    party = service:get_module('party');
    equal(party.position.x, 25, 'group base x changed');
    equal(party.position.y, -10, 'group base y changed');
    equal(party.layout.elements.B.x, 260, 'element offset retained');
end);

test('module failure is isolated and cleanup is reverse ordered', function ()
    local calls = {};
    local function make_descriptor(id, fails)
        local descriptor = {
            id = id,
            name = id,
            default_enabled = true,
            styles = { 'standard' },
            dependencies = {},
            capabilities = {},
            options = {},
        };
        descriptor.factory = function ()
            return {
                init = function () calls[#calls + 1] = 'init:' .. id; end,
                update = function ()
                    calls[#calls + 1] = 'update:' .. id;
                    if fails then error('expected failure'); end
                end,
                shutdown = function (_, reason)
                    calls[#calls + 1] = 'shutdown:' .. id .. ':' .. reason;
                end,
            };
        end;
        return descriptor;
    end
    local local_descriptors = {
        make_descriptor('first', true),
        make_descriptor('second', false),
    };
    local defaults = defaults_module.build(local_descriptors);
    local preview = preview_module.new();
    local registry = registry_module.new(local_descriptors,
        function () return { logger = fakes.logger(), config = {} }; end,
        fakes.logger(), preview);
    registry:start(defaults);
    registry:update(0.016);
    equal(registry.records.first.state, 'faulted', 'failed module faulted');
    equal(registry.records.second.state, 'running', 'other module kept running');
    registry:shutdown();
    equal(calls[#calls], 'shutdown:second:addon_unload',
        'remaining modules shut down in reverse order');
end);

test('local player capability exposes approved player frame fields', function ()
    local platform_module = require('core.platform.ashita');
    local fake_player = {
        GetName = function () return 'Xpie'; end,
        GetHP = function () return 1234; end,
        GetHPP = function () return 75; end,
        GetMP = function () return 321; end,
        GetMPP = function () return 50; end,
        GetTP = function () return 1250; end,
        GetMainJob = function () return 1; end,
        GetMainJobLevel = function () return 99; end,
        GetSubJob = function () return 19; end,
        GetSubJobLevel = function () return 49; end,
    };
    local fake_core = {
        GetMemoryManager = function ()
            return {
                GetPlayer = function () return fake_player; end,
            };
        end,
    };
    local platform = platform_module.new({}, descriptors, fakes.logger(), {
        ashita_core = fake_core,
    });
    local context = platform:create_module_context(descriptors[1],
        defaults_module.build(descriptors).modules.player_frame);
    local snapshot = context.game.local_player:snapshot();
    equal(snapshot.available, true, 'local player is available');
    equal(snapshot.name, 'Xpie', 'local player name');
    equal(snapshot.hp, 1234, 'local player HP');
    equal(snapshot.hp_percent, 75, 'local player HP percent');
    equal(snapshot.mp, 321, 'local player MP');
    equal(snapshot.mp_percent, 50, 'local player MP percent');
    equal(snapshot.tp, 1250, 'local player TP');
    equal(snapshot.main_job, 1, 'local player main job');
    equal(snapshot.main_job_level, 99, 'local player main job level');
    equal(snapshot.sub_job, 19, 'local player sub job');
    equal(snapshot.sub_job_level, 49, 'local player sub job level');

    local ok = pcall(function ()
        platform:create_module_context({
            id = 'blocked',
            capabilities = { 'target_state' },
        }, {});
    end);
    equal(ok, false, 'unknown live capability rejected');
end);

test('local player capability prefers local party slot vitals', function ()
    local platform_module = require('core.platform.ashita');
    local fake_party = {
        GetMemberName = function (_, index)
            return index == 0 and 'Xpie' or nil;
        end,
        GetMemberHP = function (_, index)
            return index == 0 and 2345 or nil;
        end,
        GetMemberHPP = function (_, index)
            return index == 0 and 80 or nil;
        end,
        GetMemberMP = function (_, index)
            return index == 0 and 456 or nil;
        end,
        GetMemberMPP = function (_, index)
            return index == 0 and 60 or nil;
        end,
        GetMemberTP = function (_, index)
            return index == 0 and 1750 or nil;
        end,
    };
    local fake_core = {
        GetMemoryManager = function ()
            return {
                GetPlayer = function ()
                    return {
                        GetName = function () return 'Fallback'; end,
                        GetHP = function () return 1; end,
                        GetMP = function () return 2; end,
                        GetTP = function () return 3; end,
                        GetMainJob = function () return 5; end,
                        GetMainJobLevel = function () return 75; end,
                        GetSubJob = function () return 20; end,
                        GetSubJobLevel = function () return 37; end,
                    };
                end,
                GetParty = function () return fake_party; end,
            };
        end,
    };
    local platform = platform_module.new({}, descriptors, fakes.logger(), {
        ashita_core = fake_core,
    });
    local context = platform:create_module_context(descriptors[1],
        defaults_module.build(descriptors).modules.player_frame);
    local snapshot = context.game.local_player:snapshot();
    equal(snapshot.name, 'Xpie', 'party slot name preferred');
    equal(snapshot.hp, 2345, 'party slot HP preferred');
    equal(snapshot.hp_percent, 80, 'party slot HP percent preferred');
    equal(snapshot.mp, 456, 'party slot MP preferred');
    equal(snapshot.mp_percent, 60, 'party slot MP percent preferred');
    equal(snapshot.tp, 1750, 'party slot TP preferred');
    equal(snapshot.main_job, 5, 'player wrapper main job retained');
    equal(snapshot.main_job_level, 75, 'player wrapper main level retained');
    equal(snapshot.sub_job, 20, 'player wrapper sub job retained');
    equal(snapshot.sub_job_level, 37, 'player wrapper sub level retained');
end);

test('player frame module normalizes job text and bounded vitals', function ()
    local player_frame = require('modules.player_frame');
    local module = player_frame.new(descriptors[1]);
    local snapshots = {
        {
            available = true,
            name = 'Xpie',
            main_job = 1,
            main_job_level = 99,
            sub_job = 19,
            sub_job_level = 49,
            hp = 500,
            hp_percent = 150,
            mp = 25,
            mp_percent = 0.5,
            tp = 4500,
        },
        { available = false },
    };
    local index = 0;
    module:init({
        logger = fakes.logger(),
        config = defaults_module.build(descriptors).modules.player_frame,
        game = {
            local_player = {
                snapshot = function ()
                    index = index + 1;
                    return snapshots[index];
                end,
            },
        },
    });
    module:update(0.016);
    equal(module.state.available, true, 'snapshot accepted');
    equal(module.state.name, 'Xpie', 'name retained');
    equal(module.state.job_text, 'WAR 99/DNC 49', 'job line formatted');
    equal(module.state.hp_percent, 1, 'HP percent clamped');
    equal(module.state.mp_percent, 0.5, 'MP fractional percent retained');
    equal(module.state.tp, 3000, 'TP clamped to native scale cap');
    equal(module.state.tp_percent, 1, 'TP fill clamped');
    module:update(0.016);
    equal(module.state.available, false, 'unavailable snapshot clears state');
end);

test('presentation draws configured font outline around explicit-size text',
        function ()
    local presentation = require('core.presentation');
    local text_calls = {};
    local draw_list = {
        AddText = function (_, position, call_color, text)
            text_calls[#text_calls + 1] = {
                position = position,
                color = call_color,
                text = text,
            };
        end,
    };
    local presenter = presentation.new({
        GetTextLineHeight = function () return 16; end,
        CalcTextSize = function (text) return #text * 8; end,
    });
    presenter:set_options({
        font_outline_enabled = true,
        font_outline_size = 2,
        font_outline_color = '#112233',
    });
    presenter:draw_text(draw_list, 'Xpie', 10, 20, 0xFFFFFFFF, 18);

    equal(#text_calls, 9, 'outline draws eight passes plus fill text');
    equal(text_calls[1].color, 0xFF332211, 'outline color packed for ImGui');
    equal(text_calls[9].color, 0xFFFFFFFF, 'fill text drawn last');
    equal(text_calls[9].position[1], 10, 'fill x unchanged');
    equal(text_calls[9].position[2], 20, 'fill y unchanged');
end);

test('player frame live renderer applies font, alignment, TP pips, and graphics',
        function ()
    local platform_module = require('core.platform.ashita');
    local text_calls = {};
    local filled_rects = {};
    local gradient_rects = {};
    local rects = {};
    local sizes = {};
    local window_background_alpha = nil;
    local begin_flags = nil;
    local pushed_style_vars = 0;
    local popped_style_vars = 0;
    local globals = {
        ImGuiCond_Always = _G.ImGuiCond_Always,
        ImGuiWindowFlags_NoResize = _G.ImGuiWindowFlags_NoResize,
        ImGuiWindowFlags_NoMove = _G.ImGuiWindowFlags_NoMove,
        ImGuiWindowFlags_NoSavedSettings = _G.ImGuiWindowFlags_NoSavedSettings,
        ImGuiWindowFlags_NoTitleBar = _G.ImGuiWindowFlags_NoTitleBar,
        ImGuiWindowFlags_NoDecoration = _G.ImGuiWindowFlags_NoDecoration,
        ImGuiWindowFlags_NoBackground = _G.ImGuiWindowFlags_NoBackground,
        ImGuiStyleVar_WindowBorderSize = _G.ImGuiStyleVar_WindowBorderSize,
        ImGuiStyleVar_WindowPadding = _G.ImGuiStyleVar_WindowPadding,
    };
    _G.ImGuiCond_Always = 0;
    _G.ImGuiWindowFlags_NoResize = 1;
    _G.ImGuiWindowFlags_NoMove = 2;
    _G.ImGuiWindowFlags_NoSavedSettings = 4;
    _G.ImGuiWindowFlags_NoTitleBar = 8;
    _G.ImGuiWindowFlags_NoDecoration = 16;
    _G.ImGuiWindowFlags_NoBackground = 32;
    _G.ImGuiStyleVar_WindowBorderSize = 64;
    _G.ImGuiStyleVar_WindowPadding = 128;

    local draw_list = {
        AddText = function (_, a, b, c, d, e)
            if e ~= nil then
                text_calls[#text_calls + 1] = {
                    size = b,
                    position = c,
                    text = e,
                };
            else
                text_calls[#text_calls + 1] = { size = nil, text = d };
            end
        end,
        AddRectFilled = function (_, minimum, maximum, color)
            filled_rects[#filled_rects + 1] = {
                minimum = minimum,
                maximum = maximum,
                color = color,
            };
        end,
        AddRectFilledMultiColor = function (_, minimum, maximum, left_top,
                right_top, right_bottom, left_bottom)
            gradient_rects[#gradient_rects + 1] = {
                minimum = minimum,
                maximum = maximum,
                left_top = left_top,
                right_top = right_top,
                right_bottom = right_bottom,
                left_bottom = left_bottom,
            };
        end,
        AddRect = function (_, minimum, maximum, color)
            rects[#rects + 1] = {
                minimum = minimum,
                maximum = maximum,
                color = color,
            };
        end,
    };
    local fake_imgui = {
        SetNextWindowPos = function () end,
        SetNextWindowSize = function (value) sizes[#sizes + 1] = value; end,
        SetNextWindowBgAlpha = function (value)
            window_background_alpha = value;
        end,
        Begin = function (_, _, flags)
            begin_flags = flags;
            return true;
        end,
        End = function () end,
        PushStyleVar = function () pushed_style_vars = pushed_style_vars + 1; end,
        PopStyleVar = function (count) popped_style_vars = count; end,
        GetWindowPos = function () return 0, 0; end,
        GetWindowDrawList = function () return draw_list; end,
        GetFont = function () return {}; end,
        GetTextLineHeight = function () return 16; end,
        CalcTextSize = function (text) return #text * 8; end,
        Dummy = function () end,
    };
    local platform = platform_module.new(fake_imgui, descriptors, fakes.logger());
    local renderer = platform:render_context();
    renderer:player_frame(descriptors[1], {
        available = true,
        name = 'Xpie',
        job_text = 'WAR 99/DNC 49',
        hp = 1234,
        hp_percent = 0.75,
        mp = 321,
        mp_percent = 0.5,
        tp = 1250,
        tp_percent = 1250 / 3000,
    }, {
        style = 'style_1',
        scale = 1.0,
        opacity = 1.0,
        position = { x = 0, y = 0 },
        options = {
            name_font_size = 18,
            job_font_size = 13,
            resource_label_font_size = 10,
            resource_value_font_size = 12,
            resource_value_alignment = 'center',
            background_enabled = true,
        },
        layout = { movement = 'group', elements = {} },
    });
    truthy(#sizes == 1, 'player frame size submitted');
    equal(sizes[1][1], 482.5, 'player frame default width uses review scale');
    equal(sizes[1][2], 203.75, 'player frame default height uses review scale');
    equal(window_background_alpha, 0.0,
        'native ImGui window background is transparent');
    truthy(begin_flags >= 63, 'player frame window chrome flags applied');
    equal(pushed_style_vars, 2, 'player frame style vars pushed');
    equal(popped_style_vars, 2, 'player frame style vars restored');
    equal(text_calls[1].text, 'Xpie', 'name rendered');
    equal(text_calls[1].size, 18, 'name font size applied');
    equal(text_calls[2].text, 'WAR 99/DNC 49', 'job text rendered');
    equal(text_calls[2].size, 13, 'job font size applied');
    equal(text_calls[3].text, 'HP', 'resource label rendered');
    equal(text_calls[3].size, 10, 'resource label font size applied');
    equal(text_calls[3].position[1], 94.25, 'resource label sits outside bar');
    equal(text_calls[4].text, '1234', 'resource value rendered');
    equal(text_calls[4].size, 12, 'resource value font size applied');
    equal(text_calls[1].position[1], 88.75, 'name uses production canvas x');
    equal(text_calls[2].position[1], 88.75, 'job uses production canvas x');
    equal(text_calls[4].position[1], 286.25,
        'resource value center alignment applied');
    equal(filled_rects[1].color, 0xFF0E1A26,
        'player frame fallback background rendered fully opaque');
    equal(gradient_rects[1].left_top, 0xDD6C6CE2,
        'HP bar uses two-color gradient start');
    equal(gradient_rects[1].right_top, 0xDD9C9CFA,
        'HP bar uses two-color gradient end');
    equal(gradient_rects[3].left_top, 0xDDCE9838,
        'TP bar uses two-color gradient start');
    equal(gradient_rects[3].right_top, 0xDDEEC478,
        'TP bar uses two-color gradient end');
    equal(filled_rects[5].minimum[1], 372.875,
        'TP pips align to TP bar right edge');
    equal(filled_rects[5].minimum[2], 176.125,
        'TP pips sit below TP bar');
    equal(filled_rects[5].color, 0xFF7DD6FF,
        'first TP threshold pip filled at 1250 TP');
    equal(#rects, 7, 'fallback background, resource bars, and TP pips are framed');

    for name, value in pairs(globals) do
        _G[name] = value;
    end
end);

test('player frame renderer uses production image assets when available',
        function ()
    local platform_module = require('core.platform.ashita');
    local image_calls = {};
    local loaded_paths = {};
    local rects = {};
    local filled_rects = {};
    local globals = {
        ImGuiCond_Always = _G.ImGuiCond_Always,
        ImGuiWindowFlags_NoResize = _G.ImGuiWindowFlags_NoResize,
        ImGuiWindowFlags_NoMove = _G.ImGuiWindowFlags_NoMove,
        ImGuiWindowFlags_NoSavedSettings = _G.ImGuiWindowFlags_NoSavedSettings,
        ImGuiWindowFlags_NoTitleBar = _G.ImGuiWindowFlags_NoTitleBar,
        ImGuiWindowFlags_NoDecoration = _G.ImGuiWindowFlags_NoDecoration,
        ImGuiWindowFlags_NoBackground = _G.ImGuiWindowFlags_NoBackground,
    };
    _G.ImGuiCond_Always = 0;
    _G.ImGuiWindowFlags_NoResize = 1;
    _G.ImGuiWindowFlags_NoMove = 2;
    _G.ImGuiWindowFlags_NoSavedSettings = 4;
    _G.ImGuiWindowFlags_NoTitleBar = 8;
    _G.ImGuiWindowFlags_NoDecoration = 16;
    _G.ImGuiWindowFlags_NoBackground = 32;

    local draw_list = {
        AddText = function () end,
        AddRectFilled = function (_, minimum, maximum, color)
            filled_rects[#filled_rects + 1] = {
                minimum = minimum,
                maximum = maximum,
                color = color,
            };
        end,
        AddRectFilledMultiColor = function () end,
        AddRect = function (_, minimum, maximum, color)
            rects[#rects + 1] = {
                minimum = minimum,
                maximum = maximum,
                color = color,
            };
        end,
        AddImage = function (_, texture, minimum, maximum, ...)
            image_calls[#image_calls + 1] = {
                texture = texture,
                minimum = minimum,
                maximum = maximum,
                extra = { ... },
            };
        end,
    };
    local fake_imgui = {
        CreateTextureFromFile = function (_, path)
            loaded_paths[#loaded_paths + 1] = path;
            return 'texture:' .. path;
        end,
        SetNextWindowPos = function () end,
        SetNextWindowSize = function () end,
        SetNextWindowBgAlpha = function () end,
        Begin = function () return true; end,
        End = function () end,
        GetWindowPos = function () return 0, 0; end,
        GetWindowDrawList = function () return draw_list; end,
        GetFont = function () return {}; end,
        GetTextLineHeight = function () return 16; end,
        CalcTextSize = function (text) return #text * 8; end,
        Dummy = function () end,
    };
    local platform = platform_module.new(fake_imgui, descriptors,
        fakes.logger(), {
            asset_root = 'addon\\VanadielHDUI\\assets\\player_frame',
        });
    platform:render_context():player_frame(descriptors[1], {
        available = true,
        name = 'Xpie',
        job_text = 'WAR 99/DNC 49',
        hp = 1234,
        hp_percent = 0.75,
        mp = 321,
        mp_percent = 0.5,
        tp = 2500,
        tp_percent = 2500 / 3000,
    }, defaults_module.build(descriptors).modules.player_frame);

    equal(#loaded_paths, 3, 'player frame production assets loaded');
    equal(loaded_paths[1]:find('pframe_', 1, true) ~= nil, true,
        'production asset path used');
    equal(#image_calls, 6,
        'background, bars, active TP pips, and flash overlays drawn');
    equal(image_calls[1].minimum[1], 0, 'background image at window origin');
    equal(image_calls[2].minimum[1], 0, 'bar image shares canvas origin');
    equal(image_calls[3].minimum[1], 372.875,
        'first active TP jewel image at lower right');
    equal(#rects, 0,
        'image-backed bars and TP pips do not draw legacy outlines');
    equal(#filled_rects, 0,
        'image-backed bars and TP pips do not draw legacy tracks');

    for name, value in pairs(globals) do
        _G[name] = value;
    end
end);

test('player frame chrome flags can come from Ashita imgui table', function ()
    local platform_module = require('core.platform.ashita');
    local begin_flags = nil;
    local globals = {
        ImGuiCond_Always = _G.ImGuiCond_Always,
        ImGuiWindowFlags_NoResize = _G.ImGuiWindowFlags_NoResize,
        ImGuiWindowFlags_NoMove = _G.ImGuiWindowFlags_NoMove,
        ImGuiWindowFlags_NoSavedSettings = _G.ImGuiWindowFlags_NoSavedSettings,
        ImGuiWindowFlags_NoTitleBar = _G.ImGuiWindowFlags_NoTitleBar,
        ImGuiWindowFlags_NoDecoration = _G.ImGuiWindowFlags_NoDecoration,
        ImGuiWindowFlags_NoBackground = _G.ImGuiWindowFlags_NoBackground,
        ImGuiWindowFlags_NoCollapse = _G.ImGuiWindowFlags_NoCollapse,
        ImGuiWindowFlags_NoScrollbar = _G.ImGuiWindowFlags_NoScrollbar,
        ImGuiWindowFlags_NoScrollWithMouse =
            _G.ImGuiWindowFlags_NoScrollWithMouse,
    };
    _G.ImGuiCond_Always = 0;
    _G.ImGuiWindowFlags_NoResize = nil;
    _G.ImGuiWindowFlags_NoMove = nil;
    _G.ImGuiWindowFlags_NoSavedSettings = nil;
    _G.ImGuiWindowFlags_NoTitleBar = nil;
    _G.ImGuiWindowFlags_NoDecoration = nil;
    _G.ImGuiWindowFlags_NoBackground = nil;
    _G.ImGuiWindowFlags_NoCollapse = nil;
    _G.ImGuiWindowFlags_NoScrollbar = nil;
    _G.ImGuiWindowFlags_NoScrollWithMouse = nil;

    local fake_imgui = {
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
        SetNextWindowPos = function () end,
        SetNextWindowSize = function () end,
        SetNextWindowBgAlpha = function () end,
        Begin = function (_, is_open, flags)
            equal(is_open, true, 'player frame Begin uses Ashita-style open flag');
            begin_flags = flags;
            return true;
        end,
        End = function () end,
        GetWindowPos = function () return 0, 0; end,
        GetWindowDrawList = function ()
            return {
                AddText = function () end,
                AddRectFilled = function () end,
                AddRectFilledMultiColor = function () end,
                AddRect = function () end,
            };
        end,
        GetFont = function () return {}; end,
        GetTextLineHeight = function () return 16; end,
        CalcTextSize = function (text) return #text * 8; end,
        Dummy = function () end,
    };
    local platform = platform_module.new(fake_imgui, descriptors, fakes.logger());
    platform:render_context():player_frame(descriptors[1], {
        available = true,
        name = 'Xpie',
        job_text = 'WAR 99/DNC 49',
        hp = 1,
        hp_percent = 1,
        mp = 1,
        mp_percent = 1,
        tp = 1,
        tp_percent = 1 / 3000,
    }, defaults_module.build(descriptors).modules.player_frame);

    equal(begin_flags, 139711, 'player frame uses imgui-table chrome flags');

    for name, value in pairs(globals) do
        _G[name] = value;
    end
end);

test('player frame renderer passes D3D texture pointers to AddImage',
        function ()
    local previous_platform = package.loaded['core.platform.ashita'];
    local previous_ffi = package.loaded.ffi;
    local previous_d3d8 = package.loaded.d3d8;
    local previous_common = package.loaded.common;
    local previous_preload_d3d8 = package.preload.d3d8;
    local previous_preload_common = package.preload.common;
    package.loaded['core.platform.ashita'] = nil;
    package.loaded.ffi = {
        C = {
            S_OK = 0,
            D3DXCreateTextureFromFileA = function (_, _, texture_out)
                texture_out[0] = 'native-texture';
                return 0;
            end,
        },
        new = function () return {}; end,
        cast = function (kind, value)
            if kind == 'uint32_t' then
                return 90210;
            end
            return value;
        end,
    };
    package.loaded.d3d8 = nil;
    package.preload.d3d8 = function ()
        return {
            get_device = function () return 'device'; end,
            gc_safe_release = function (texture) return texture; end,
        };
    end;
    package.loaded.common = true;
    package.preload.common = function () return true; end;

    local platform_module = require('core.platform.ashita');
    local image_calls = {};
    local globals = {
        ImGuiCond_Always = _G.ImGuiCond_Always,
        ImGuiWindowFlags_NoResize = _G.ImGuiWindowFlags_NoResize,
        ImGuiWindowFlags_NoMove = _G.ImGuiWindowFlags_NoMove,
        ImGuiWindowFlags_NoSavedSettings = _G.ImGuiWindowFlags_NoSavedSettings,
        ImGuiWindowFlags_NoTitleBar = _G.ImGuiWindowFlags_NoTitleBar,
        ImGuiWindowFlags_NoDecoration = _G.ImGuiWindowFlags_NoDecoration,
        ImGuiWindowFlags_NoBackground = _G.ImGuiWindowFlags_NoBackground,
    };
    _G.ImGuiCond_Always = 0;
    _G.ImGuiWindowFlags_NoResize = 1;
    _G.ImGuiWindowFlags_NoMove = 2;
    _G.ImGuiWindowFlags_NoSavedSettings = 4;
    _G.ImGuiWindowFlags_NoTitleBar = 8;
    _G.ImGuiWindowFlags_NoDecoration = 16;
    _G.ImGuiWindowFlags_NoBackground = 32;

    local draw_list = {
        AddText = function () end,
        AddRectFilled = function () end,
        AddRectFilledMultiColor = function () end,
        AddRect = function () end,
        AddImage = function (_, texture)
            image_calls[#image_calls + 1] = texture;
        end,
    };
    local fake_imgui = {
        SetNextWindowPos = function () end,
        SetNextWindowSize = function () end,
        SetNextWindowBgAlpha = function () end,
        Begin = function () return true; end,
        End = function () end,
        GetWindowPos = function () return 0, 0; end,
        GetWindowDrawList = function () return draw_list; end,
        GetFont = function () return {}; end,
        GetTextLineHeight = function () return 16; end,
        CalcTextSize = function (text) return #text * 8; end,
        Dummy = function () end,
    };
    local platform = platform_module.new(fake_imgui, descriptors,
        fakes.logger(), {
            asset_root = 'addon\\VanadielHDUI\\assets\\player_frame',
        });
    platform:render_context():player_frame(descriptors[1], {
        available = true,
        name = 'Xpie',
        job_text = 'WAR 99/DNC 49',
        hp = 1234,
        hp_percent = 0.75,
        mp = 321,
        mp_percent = 0.5,
        tp = 2500,
        tp_percent = 2500 / 3000,
    }, defaults_module.build(descriptors).modules.player_frame);

    equal(image_calls[1], 90210, 'D3D texture pointer passed to AddImage');

    for name, value in pairs(globals) do
        _G[name] = value;
    end
    package.loaded['core.platform.ashita'] = previous_platform;
    package.loaded.ffi = previous_ffi;
    package.loaded.d3d8 = previous_d3d8;
    package.loaded.common = previous_common;
    package.preload.d3d8 = previous_preload_d3d8;
    package.preload.common = previous_preload_common;
end);

test('player frame asset diagnostics include missing png paths', function ()
    local platform_module = require('core.platform.ashita');
    local logger = fakes.logger();
    platform_module.new({}, descriptors, logger, {
        asset_root = 'Z:\\missing\\player_frame',
    });

    local found_png_path = false;
    for _, entry in ipairs(logger.entries) do
        if entry:find('pframe_bg.png', 1, true) ~= nil then
            found_png_path = true;
        end
    end
    truthy(found_png_path, 'missing asset diagnostic includes png path');
end);

test('preview initializes disabled party without persisting enablement', function ()
    local defaults = defaults_module.build(descriptors);
    local preview = preview_module.new();
    local registry = registry_module.new(descriptors,
        function (_, module_config)
            return { logger = fakes.logger(), config = util.deepcopy(module_config) };
        end,
        fakes.logger(), preview);
    registry:start(defaults);
    equal(registry.records.party.state, 'disabled', 'party starts disabled');
    preview:enter();
    equal(registry.records.party.state, 'previewing', 'party preview lifecycle');
    local adapter = registry.records.party.instance.preview;
    equal(#adapter.groups, 3, 'three preview groups');
    equal(#adapter.groups[1].slots, 6, 'six slots in Party A');
    equal(#adapter.groups[2].slots, 6, 'six slots in Party B');
    equal(#adapter.groups[3].slots, 6, 'six slots in Party C');
    equal(adapter.shared_configuration_owner, 'A', 'Party A owns shared config');
    equal(defaults.modules.party.enabled, false, 'preview did not mutate config');
    preview:exit();
    equal(registry.records.party.state, 'disabled', 'preview cleanup');
end);

test('event router registration and cleanup are deterministic', function ()
    local events = fakes.events();
    local application = {
        load = function () end,
        unload = function () end,
        present = function () end,
    };
    local commands = { handle = function () return true; end };
    local router = event_router.new(events, application, commands, fakes.logger());
    router:bind();
    equal(#events.registered, 4, 'registered event count');
    local command = events.callbacks['command:vanadielhdui_command'];
    local command_event = { command = '/vhd', blocked = false };
    command(command_event);
    equal(command_event.blocked, true, 'recognized command blocked');
    router:unbind();
    equal(#events.unregistered, 4, 'unregistered event count');
    equal(events.unregistered[1], 'unload:vanadielhdui_unload',
        'cleanup starts in reverse order');
end);

test('configuration theme restores scoped ImGui style state', function ()
    local globals = {
        ImGuiCol_Text = _G.ImGuiCol_Text,
        ImGuiCol_WindowBg = _G.ImGuiCol_WindowBg,
        ImGuiStyleVar_WindowPadding = _G.ImGuiStyleVar_WindowPadding,
        ImGuiStyleVar_WindowRounding = _G.ImGuiStyleVar_WindowRounding,
    };
    _G.ImGuiCol_Text = 0;
    _G.ImGuiCol_WindowBg = 2;
    _G.ImGuiStyleVar_WindowPadding = 4;
    _G.ImGuiStyleVar_WindowRounding = 5;

    local pushed_colors = 0;
    local pushed_variables = 0;
    local popped_colors = 0;
    local popped_variables = 0;
    local fake_imgui = {
        PushStyleColor = function () pushed_colors = pushed_colors + 1; end,
        PushStyleVar = function () pushed_variables = pushed_variables + 1; end,
        PopStyleColor = function (count) popped_colors = count; end,
        PopStyleVar = function (count) popped_variables = count; end,
    };
    local local_theme = require('ui.theme').new(fake_imgui);
    local_theme:push();
    truthy(pushed_colors >= 2, 'available color slots were pushed');
    truthy(pushed_variables >= 2, 'available style variables were pushed');
    local_theme:pop();
    equal(popped_colors, pushed_colors, 'color stack restored');
    equal(popped_variables, pushed_variables, 'style-variable stack restored');

    local render_pushes = 0;
    local render_pops = 0;
    local window = require('ui.config_window').new({}, {});
    window.open[1] = true;
    window.theme = {
        push = function () render_pushes = render_pushes + 1; end,
        pop = function () render_pops = render_pops + 1; end,
    };
    window._render_window = function () error('expected render failure'); end;
    local rendered = xpcall(function () window:render({}); end, debug.traceback);
    equal(rendered, false, 'render failure propagated');
    equal(render_pushes, 1, 'render theme pushed once');
    equal(render_pops, 1, 'render theme restored after failure');

    for name, value in pairs(globals) do
        _G[name] = value;
    end
    if globals.ImGuiCol_Text == nil then _G.ImGuiCol_Text = nil; end
    if globals.ImGuiCol_WindowBg == nil then _G.ImGuiCol_WindowBg = nil; end
    if globals.ImGuiStyleVar_WindowPadding == nil then
        _G.ImGuiStyleVar_WindowPadding = nil;
    end
    if globals.ImGuiStyleVar_WindowRounding == nil then
        _G.ImGuiStyleVar_WindowRounding = nil;
    end
end);

test('single-style modules do not show style selector', function ()
    local config_window_module = require('ui.config_window');
    local button_labels = {};
    local text_labels = {};
    local fake_imgui = {
        Separator = function () end,
        TextColored = function (_, text) text_labels[#text_labels + 1] = text; end,
        TextDisabled = function (text) text_labels[#text_labels + 1] = text; end,
        Text = function (text) text_labels[#text_labels + 1] = text; end,
        SameLine = function () end,
        Checkbox = function () return false; end,
        Button = function (label)
            button_labels[#button_labels + 1] = label;
            return false;
        end,
        SliderFloat = function () return false; end,
        SliderInt = function () return false; end,
        InputFloat = function () return false; end,
    };
    local application = {
        module_state = function () return 'disabled'; end,
        module_option_keys = function () return {}; end,
    };
    local window = config_window_module.new(fake_imgui, descriptors);
    window:_module_controls(application, descriptors[1], {
        enabled = false,
        style = 'style_1',
        scale = 1.0,
        opacity = 1.0,
        position = { anchor = 'top_left', x = 0, y = 0 },
        options = {},
        layout = { movement = 'group', elements = {} },
    });

    for _, label in ipairs(button_labels) do
        truthy(label:find('Next style##player_frame', 1, true) == nil,
            'single-style selector button hidden');
    end
    for _, label in ipairs(text_labels) do
        truthy(tostring(label):find('Style:', 1, true) == nil,
            'single-style selector text hidden');
    end
end);

test('player frame does not show anchor selector', function ()
    local config_window_module = require('ui.config_window');
    local button_labels = {};
    local text_labels = {};
    local fake_imgui = {
        Separator = function () end,
        TextColored = function (_, text) text_labels[#text_labels + 1] = text; end,
        TextDisabled = function (text) text_labels[#text_labels + 1] = text; end,
        Text = function (text) text_labels[#text_labels + 1] = text; end,
        SameLine = function () end,
        Checkbox = function () return false; end,
        Button = function (label)
            button_labels[#button_labels + 1] = label;
            return false;
        end,
        SliderFloat = function () return false; end,
        SliderInt = function () return false; end,
        InputFloat = function () return false; end,
    };
    local application = {
        module_state = function () return 'disabled'; end,
        module_option_keys = function () return {}; end,
    };
    local window = config_window_module.new(fake_imgui, descriptors);
    window:_module_controls(application, descriptors[1], {
        enabled = false,
        style = 'style_1',
        scale = 1.0,
        opacity = 1.0,
        position = { anchor = 'center', x = 0, y = 0 },
        options = {},
        layout = { movement = 'group', elements = {} },
    });

    for _, label in ipairs(button_labels) do
        truthy(label:find('Next anchor##player_frame', 1, true) == nil,
            'player frame anchor button hidden');
    end
    for _, label in ipairs(text_labels) do
        truthy(tostring(label):find('Anchor:', 1, true) == nil,
            'player frame anchor text hidden');
    end
end);

test('layout editor commits generic module or element targets once on release',
        function ()
    local editor = layout_editor_module.new();
    local commits = {};
    local function commit(target, x, y)
        commits[#commits + 1] = { target = target, x = x, y = y };
    end
    local target = {
        kind = 'element',
        key = 'module:party:element:B',
        module_id = 'party',
        element_id = 'B',
    };

    editor:begin_frame(true, {
        clicked = true,
        released = false,
        delta_x = 0,
        delta_y = 0,
    }, commit);
    truthy(editor:offer_drag_surface(
        target, { x = 10, y = 20 }, true), 'element drag started');
    equal(editor:is_dragging(target.key), true, 'element owns drag');

    editor:begin_frame(true, {
        clicked = false,
        released = false,
        delta_x = 35,
        delta_y = -15,
    }, commit);
    local x, y = editor:position(target.key, { x = 10, y = 20 });
    equal(x, 45, 'transient element x');
    equal(y, 5, 'transient element y');
    equal(#commits, 0, 'drag does not save every frame');

    editor:begin_frame(true, {
        clicked = false,
        released = true,
        delta_x = 35,
        delta_y = -15,
    }, commit);
    equal(#commits, 1, 'release commits once');
    equal(commits[1].target.kind, 'element', 'element target committed');
    equal(commits[1].target.element_id, 'B', 'party B committed');
    equal(commits[1].x, 45, 'committed x');
    equal(commits[1].y, 5, 'committed y');
    equal(editor:is_dragging(target.key), false, 'drag released');
end);

test('preview rendering composes global and module opacity', function ()
    local platform_module = require('core.platform.ashita');
    local bg_alphas = {};
    local globals = {
        ImGuiMouseButton_Left = _G.ImGuiMouseButton_Left,
        ImGuiHoveredFlags_None = _G.ImGuiHoveredFlags_None,
        ImGuiMouseCursor_ResizeAll = _G.ImGuiMouseCursor_ResizeAll,
        ImGuiCond_Always = _G.ImGuiCond_Always,
        ImGuiWindowFlags_NoResize = _G.ImGuiWindowFlags_NoResize,
        ImGuiWindowFlags_NoMove = _G.ImGuiWindowFlags_NoMove,
        ImGuiWindowFlags_NoSavedSettings = _G.ImGuiWindowFlags_NoSavedSettings,
    };
    _G.ImGuiMouseButton_Left = 0;
    _G.ImGuiHoveredFlags_None = 0;
    _G.ImGuiMouseCursor_ResizeAll = 0;
    _G.ImGuiCond_Always = 0;
    _G.ImGuiWindowFlags_NoResize = 1;
    _G.ImGuiWindowFlags_NoMove = 2;
    _G.ImGuiWindowFlags_NoSavedSettings = 4;
    local draw_list = { AddText = function () end };
    local fake_imgui = {
        GetMouseDragDelta = function () return 0, 0; end,
        IsMouseClicked = function () return false; end,
        IsMouseReleased = function () return false; end,
        SetNextWindowPos = function () end,
        SetNextWindowSize = function () end,
        SetNextWindowBgAlpha = function (value)
            bg_alphas[#bg_alphas + 1] = value;
        end,
        Begin = function () return true; end,
        End = function () end,
        GetWindowPos = function () return 0, 0; end,
        GetWindowDrawList = function () return draw_list; end,
        GetFont = function () return {}; end,
        GetTextLineHeight = function () return 16; end,
        CalcTextSize = function (text) return #text * 8; end,
        Dummy = function () end,
        IsWindowHovered = function () return false; end,
        SetMouseCursor = function () end,
    };
    local app = {
        is_preview_enabled = function () return true; end,
        get_settings = function ()
            return {
                global = { opacity = 0.4 },
            };
        end,
    };
    local platform = platform_module.new(fake_imgui, descriptors, fakes.logger());
    local renderer = platform:render_context();
    platform:begin_layout_frame(app);
    renderer:placeholder({
        id = 'player',
        name = 'Player Frame',
        preview_offset = { x = 0, y = 0 },
    }, {}, {
        style = 'standard',
        opacity = 0.5,
        position = { x = 0, y = 0 },
        layout = { movement = 'group', elements = {} },
    });
    equal(#bg_alphas, 1, 'one preview window alpha applied');
    equal(bg_alphas[1], 0.2, 'global and module opacity composed');

    for name, value in pairs(globals) do
        _G[name] = value;
    end
end);

test('preview rendering composes global and module scale into window size',
        function ()
    local platform_module = require('core.platform.ashita');
    local sizes = {};
    local text_calls = {};
    local globals = {
        ImGuiMouseButton_Left = _G.ImGuiMouseButton_Left,
        ImGuiHoveredFlags_None = _G.ImGuiHoveredFlags_None,
        ImGuiMouseCursor_ResizeAll = _G.ImGuiMouseCursor_ResizeAll,
        ImGuiCond_Always = _G.ImGuiCond_Always,
        ImGuiWindowFlags_NoResize = _G.ImGuiWindowFlags_NoResize,
        ImGuiWindowFlags_NoMove = _G.ImGuiWindowFlags_NoMove,
        ImGuiWindowFlags_NoSavedSettings = _G.ImGuiWindowFlags_NoSavedSettings,
    };
    _G.ImGuiMouseButton_Left = 0;
    _G.ImGuiHoveredFlags_None = 0;
    _G.ImGuiMouseCursor_ResizeAll = 0;
    _G.ImGuiCond_Always = 0;
    _G.ImGuiWindowFlags_NoResize = 1;
    _G.ImGuiWindowFlags_NoMove = 2;
    _G.ImGuiWindowFlags_NoSavedSettings = 4;
    local draw_list = {
        AddText = function (_, a, b, c, d, e)
            if e ~= nil then
                text_calls[#text_calls + 1] = { size = b, text = e };
            else
                text_calls[#text_calls + 1] = { size = nil, text = d };
            end
        end,
    };
    local fake_imgui = {
        GetMouseDragDelta = function () return 0, 0; end,
        IsMouseClicked = function () return false; end,
        IsMouseReleased = function () return false; end,
        SetNextWindowPos = function () end,
        SetNextWindowSize = function (value)
            sizes[#sizes + 1] = value;
        end,
        SetNextWindowBgAlpha = function () end,
        Begin = function () return true; end,
        End = function () end,
        GetWindowPos = function () return 0, 0; end,
        GetWindowDrawList = function () return draw_list; end,
        GetFont = function () return {}; end,
        GetTextLineHeight = function () return 16; end,
        CalcTextSize = function (text) return #text * 8; end,
        Dummy = function () end,
        IsWindowHovered = function () return false; end,
        SetMouseCursor = function () end,
    };
    local app = {
        is_preview_enabled = function () return true; end,
        get_settings = function ()
            return {
                global = { opacity = 1.0, user_scale = 1.5 },
            };
        end,
    };
    local platform = platform_module.new(fake_imgui, descriptors, fakes.logger());
    local renderer = platform:render_context();
    platform:begin_layout_frame(app);
    renderer:placeholder({
        id = 'player_frame',
        name = 'Player Frame',
        preview_offset = { x = 0, y = 0 },
    }, {}, {
        style = 'style_1',
        scale = 0.5,
        opacity = 1.0,
        position = { x = 0, y = 0 },
        layout = { movement = 'group', elements = {} },
    });
    equal(#sizes, 1, 'one preview size submitted');
    equal(sizes[1][1], 165, 'scaled preview width');
    equal(sizes[1][2], 77.25, 'scaled preview height');
    truthy(#text_calls >= 4, 'draw-list text path used');
    equal(text_calls[1].size, 12, 'title size scaled explicitly');

    for name, value in pairs(globals) do
        _G[name] = value;
    end
end);

test('party preview font size applies across all preview groups', function ()
    local platform_module = require('core.platform.ashita');
    local title_sizes = {};
    local globals = {
        ImGuiMouseButton_Left = _G.ImGuiMouseButton_Left,
        ImGuiHoveredFlags_None = _G.ImGuiHoveredFlags_None,
        ImGuiMouseCursor_ResizeAll = _G.ImGuiMouseCursor_ResizeAll,
        ImGuiCond_Always = _G.ImGuiCond_Always,
        ImGuiWindowFlags_NoResize = _G.ImGuiWindowFlags_NoResize,
        ImGuiWindowFlags_NoMove = _G.ImGuiWindowFlags_NoMove,
        ImGuiWindowFlags_NoSavedSettings = _G.ImGuiWindowFlags_NoSavedSettings,
        ImGuiWindowFlags_NoCollapse = _G.ImGuiWindowFlags_NoCollapse,
    };
    _G.ImGuiMouseButton_Left = 0;
    _G.ImGuiHoveredFlags_None = 0;
    _G.ImGuiMouseCursor_ResizeAll = 0;
    _G.ImGuiCond_Always = 0;
    _G.ImGuiWindowFlags_NoResize = 1;
    _G.ImGuiWindowFlags_NoMove = 2;
    _G.ImGuiWindowFlags_NoSavedSettings = 4;
    _G.ImGuiWindowFlags_NoCollapse = 8;
    local draw_list = {
        AddText = function (_, a, b, c, d, e)
            if e ~= nil and tostring(e):match('^Party ') then
                title_sizes[#title_sizes + 1] = b;
            end
        end,
    };
    local fake_imgui = {
        GetMouseDragDelta = function () return 0, 0; end,
        IsMouseClicked = function () return false; end,
        IsMouseReleased = function () return false; end,
        SetNextWindowPos = function () end,
        SetNextWindowSize = function () end,
        SetNextWindowBgAlpha = function () end,
        Begin = function () return true; end,
        End = function () end,
        GetWindowPos = function () return 0, 0; end,
        GetWindowDrawList = function () return draw_list; end,
        GetFont = function () return {}; end,
        GetTextLineHeight = function () return 16; end,
        CalcTextSize = function (text) return #text * 8; end,
        Dummy = function () end,
        IsWindowHovered = function () return false; end,
        SetMouseCursor = function () end,
    };
    local app = {
        is_preview_enabled = function () return true; end,
        get_settings = function ()
            return {
                global = { opacity = 1.0, user_scale = 1.0 },
            };
        end,
    };
    local platform = platform_module.new(fake_imgui, descriptors, fakes.logger());
    local renderer = platform:render_context();
    platform:begin_layout_frame(app);
    renderer:placeholder({
        id = 'party',
        name = 'Party and Alliance Frames',
        preview_offset = { x = 0, y = 0 },
    }, {
        groups = {
            { id = 'A', slots = { { name = 'One' }, { name = 'Two' }, { name = 'Three' }, { name = 'Four' }, { name = 'Five' }, { name = 'Six' } } },
            { id = 'B', slots = { { name = 'One' }, { name = 'Two' }, { name = 'Three' }, { name = 'Four' }, { name = 'Five' }, { name = 'Six' } } },
            { id = 'C', slots = { { name = 'One' }, { name = 'Two' }, { name = 'Three' }, { name = 'Four' }, { name = 'Five' }, { name = 'Six' } } },
        },
    }, {
        style = 'proof_3',
        scale = 1.25,
        opacity = 1.0,
        position = { x = 0, y = 0 },
        options = { show_group_labels = true, font_size = 20 },
        layout = {
            movement = 'independent',
            elements = {
                A = { x = 0, y = 0 },
                B = { x = 190, y = 0 },
                C = { x = 380, y = 0 },
            },
        },
    });
    equal(#title_sizes, 3, 'all party groups drew titles');
    equal(title_sizes[1], 25, 'party A title scaled');
    equal(title_sizes[2], 25, 'party B title scaled');
    equal(title_sizes[3], 25, 'party C title scaled');

    for name, value in pairs(globals) do
        _G[name] = value;
    end
end);

local failures = 0;
for _, item in ipairs(tests) do
    local ok, error_message = xpcall(item.callback, debug.traceback);
    if ok then
        io.write('[PASS] ' .. item.name .. '\n');
    else
        failures = failures + 1;
        io.write('[FAIL] ' .. item.name .. '\n' .. tostring(error_message) .. '\n');
    end
end

io.write(('\n%d test(s), %d failure(s)\n'):format(#tests, failures));
if failures > 0 then
    os.exit(1);
end
