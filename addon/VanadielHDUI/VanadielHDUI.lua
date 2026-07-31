addon.name = 'VanadielHDUI';
addon.author = 'Xpie';
addon.version = '0.1.1';
addon.desc = "Core architecture and configuration foundation for Vana'diel HD UI.";

require('common');

local imgui = require('imgui');
local settings = require('settings');

local descriptors = require('modules.descriptors');
local logger_module = require('core.logger');
local ashita_store = require('core.config.ashita_store');
local config_service = require('core.config.service');
local preview_module = require('core.preview');
local module_registry = require('core.module_registry');
local platform_module = require('core.platform.ashita');
local application_module = require('core.application');
local command_router = require('core.command_router');
local event_router = require('core.event_router');

local logger = logger_module.new('VanaHD');
local platform = platform_module.new(imgui, descriptors, logger);
local store = ashita_store.new(settings, 'settings', logger:scoped('config-store'));
local config = config_service.new(store, descriptors, logger:scoped('config'));
local preview = preview_module.new();
local registry = module_registry.new(
    descriptors,
    function (descriptor, module_config)
        return platform:create_module_context(descriptor, module_config);
    end,
    logger:scoped('modules'),
    preview);
local application = application_module.new({
    config = config,
    registry = registry,
    preview = preview,
    platform = platform,
    logger = logger,
    descriptors = descriptors,
});
local commands = command_router.new(application, logger:scoped('commands'));
local events = event_router.new(ashita.events, application, commands,
    logger:scoped('events'));

events:bind();
