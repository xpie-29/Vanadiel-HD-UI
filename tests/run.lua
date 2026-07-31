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
        'core/util.lua',
        'core/config/ashita_store.lua',
        'core/config/defaults.lua',
        'core/config/migrations.lua',
        'core/config/schema.lua',
        'core/config/service.lua',
        'core/platform/ashita.lua',
        'modules/descriptors.lua',
        'modules/placeholder.lua',
        'ui/config_window.lua',
        'ui/theme.lua',
    };
    for _, path in ipairs(runtime_files) do
        local chunk, error_message = loadfile(
            root .. '/addon/VanadielHDUI/' .. path);
        truthy(chunk, path .. ': ' .. tostring(error_message));
    end
end);

test('configuration defaults round trip', function ()
    local store = fakes.memory_store(nil);
    local service = config_service.new(store, descriptors, fakes.logger());
    local loaded = service:load();
    equal(loaded.schema_version, 2, 'schema version');
    equal(loaded.modules.party.enabled, false, 'placeholder default');
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
    invalid.modules.party.enabled = 'yes';
    invalid.modules.party.style = 'rejected_proof';
    invalid.modules.party.position.x = math.huge;
    invalid.modules.party.options.font_size = 14.5;
    invalid.modules.party.options.show_group_labels = true;

    local service = config_service.new(
        fakes.memory_store(invalid), descriptors, fakes.logger());
    local loaded = service:load();
    equal(loaded.global.user_scale, 1.0, 'invalid scale recovered');
    equal(loaded.modules.party.enabled, false, 'invalid enabled recovered');
    equal(loaded.modules.party.style, 'proof_3', 'invalid style recovered');
    equal(loaded.modules.party.position.x, 0, 'invalid position recovered');
    equal(loaded.modules.party.options.font_size, 14, 'fractional font recovered');
    equal(loaded.modules.party.options.show_group_labels, true,
        'valid sibling survived');
    truthy(#service:get_report() >= 5, 'recoveries were reported');
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
