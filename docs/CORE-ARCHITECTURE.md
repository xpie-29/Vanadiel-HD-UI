# Vana'diel HD UI — Core Architecture

**Status:** Approved implementation foundation

**Date:** 2026-07-30

**Scope:** Ashita v4 addon structure, configuration, placeholders, and test seams

This document defines the first implementation phase authorized by Xpie. It
does not authorize finished game-state collection, gameplay behavior, packet
handling, native-UI suppression, action execution, or production HUD rendering.

## 1. Directory layout

```text
addon/VanadielHDUI/
├── VanadielHDUI.lua             # Ashita metadata and lifecycle binding
├── core/
│   ├── application.lua          # Composition root and lifecycle coordinator
│   ├── command_router.lua       # Addon-only slash-command parsing
│   ├── event_router.lua         # Deterministic Ashita event registration
│   ├── logger.lua               # Stable, replaceable logging surface
│   ├── module_registry.lua      # Module contract, order, toggles, isolation
│   ├── preview.lua              # Reversible session-only preview state
│   ├── util.lua                 # Pure table and validation helpers
│   ├── config/
│   │   ├── ashita_store.lua     # Adapter for Ashita's bundled settings library
│   │   ├── defaults.lua         # Versioned defaults assembled from descriptors
│   │   ├── migrations.lua       # Ordered schema migrations
│   │   ├── schema.lua           # Validation and recovery rules
│   │   └── service.lua          # Config ownership, reset, save, reload
│   └── platform/
│       └── ashita.lua           # Ashita/ImGui boundary and restricted contexts
├── modules/
│   ├── descriptors.lua          # Explicit ordered placeholder registry
│   └── placeholder.lua          # Non-gameplay module implementation
└── ui/
    └── config_window.lua        # In-game configuration shell
tests/
├── run.lua                      # Host-independent smoke suite
└── support/                     # Memory store, logger, and module fakes
```

The distributable addon is the `addon/VanadielHDUI` directory. Tests live
outside it so they are not required at runtime.

`core/layout_editor.lua` owns preview-only drag state and the release-time
position commit boundary.

## 2. Entry point and lifecycle

`VanadielHDUI.lua` declares Ashita's `addon` metadata, loads `common`, and
constructs one application. A centralized event router registers named
callbacks for:

- `load` — load, migrate, and validate configuration; then initialize enabled
  modules in descriptor order;
- `command` — handle only `/vhd` and `/vanadielhdui` commands, block recognized
  addon commands, and route module subcommands without issuing game commands;
- `d3d_present` — calculate a bounded frame delta, update modules, render
  placeholder/preview output, and draw the configuration shell; and
- `unload` — exit preview, shut modules down in reverse order, persist valid
  settings, release settings callbacks, and unregister owned event aliases.

Ashita's current public example identifies `d3d_present` as the preferred
custom-rendering event. Every registration has a stable addon-prefixed alias,
and cleanup uses the exact event/alias pairs that were registered.

## 3. Module contract and registry

Descriptors are explicit data, not folder discovery. This keeps order,
configuration ownership, and future capability review deterministic. A
descriptor contains:

- stable `id`, display name, and development-only default enabled state;
- allowed style identifiers;
- module-specific default options and validation rules;
- declared dependencies, which default to none;
- requested adapter capabilities; and
- a factory returning a module instance.

The narrow optional instance hooks are:

```text
init(context)
shutdown(reason)
update(delta_seconds)
render(render_context)
command(args)
config_changed(module_config)
preview_changed(enabled, preview_adapter)
```

Modules never receive `AshitaCore`, the global `ashita` object, the settings
library, the full configuration tree, or another module instance. Their context
contains a scoped logger, a copy/view of their own configuration, session
preview state, a restricted game-state adapter assembled from reviewed
capability names, and a render facade.

The registry owns state transitions. Enabling initializes one module after
dependency checks; disabling shuts it down and retains its settings. A failed
hook is caught with `xpcall`, logged, and changes only that module's runtime
status to `faulted`. The persisted enabled choice is retained so a transient
failure does not silently rewrite user intent. Other modules continue.

## 4. Dependency policy

Dependencies must be declared by stable module ID, must be acyclic, and must
refer only to another registered module. The registry validates the graph
before initialization. No placeholder has a dependency in this phase.

Shared behavior belongs in core services or narrow adapters, not by reaching
into another module. A future dependency may establish lifecycle order, but it
does not grant access to the dependency's private state.

## 5. Events and commands

Only the core event router registers Ashita events. Future low-level event
adapters may subscribe centrally and publish reviewed, immutable domain events
to modules whose descriptor requests the matching capability. Modules may not
register arbitrary packet, text, input, or render callbacks.

The command router recognizes:

```text
/vhd
/vhd config
/vhd preview on|off|toggle
/vhd module <id> on|off|toggle
/vhd reset module <id>
/vhd reset all
/vhd status
/vhd help
```

The no-argument command toggles the configuration shell. These commands alter
only addon configuration or preview state. They do not select targets, execute
actions, inject packets, or send game commands.

## 6. Game-state and render boundaries

The platform adapter is the only core object allowed to know about Ashita
globals. Its adapter factory accepts a descriptor's reviewed capability list
and returns only those named read surfaces. This phase registers placeholders
with no live-game capabilities, making accidental packet or memory access
impossible through the module context.

The render facade similarly prevents modules from owning the global ImGui
configuration window. Placeholder modules can draw only through a preview
surface provided by the platform adapter. Production render APIs and game-state
adapters must be added later, field by field, after the native-source and
boundary gates in `DESIGN-SPEC.md`.

## 7. Configuration ownership and persistence

Schema version `2` has:

- `schema_version`;
- `global` settings for layout scale, opacity, and approved layout/style
  identifiers; and
- `modules.<id>` blocks containing `enabled`, `style`, base `position`,
  `scale`, `opacity`, descriptor-owned `options`, and `layout`; and
- `layout.movement` plus descriptor-declared `layout.elements.<id>` X/Y
  offsets for generic multi-element positioning.

Preview state and whether the configuration window is open are session-only.
They are deliberately not persisted, so reload/unload always returns to normal
gameplay mode.

The configuration service is the sole writer. Its load pipeline is:

1. ask the store for raw settings;
2. reject a future schema version and recover to defaults;
3. run every ordered migration from the stored version to the current version;
4. validate every known field and recover invalid values independently;
5. drop unknown top-level and module keys from the active settings;
6. record a recovery report; and
7. persist the normalized current schema.

Version `0` is a pre-release compatibility seam. It accepts the early prototype
names `global.ui_scale` and `modules.<id>.is_enabled` and maps them to the
version-1 names. Version `1` migrates to version `2` by retaining each module
base position and adding descriptor defaults for movement mode and element
offsets. No released schema predates version 1.

The Ashita store wraps the current bundled `settings` library. That library
provides per-character paths, merge/save/reload/reset behavior, and callbacks
when the active character changes. Before delegating a load, the adapter
preserves a byte-for-byte `.invalid-<timestamp>.lua` sibling when the existing
settings file cannot compile, execute, or return a table. The bundled library
then performs its documented default recovery. Validation failures that still
form a table recover field by field and are reported without discarding valid
siblings.

Global reset rebuilds the whole schema from defaults. Module reset replaces
only that module's block. Resets are saved immediately. Module toggles use the
same configuration service and lifecycle registry transaction.

The placeholder defaults are development safeguards, not final product
defaults: gameplay modules start disabled until their live behavior is
authorized and implemented.

The version-1 descriptor grouping is likewise scaffold organization, not final
configuration taxonomy. When field-level module work shows that a grouped
placeholder must become multiple independently configurable sections, the
descriptor and schema change together through an explicit migration that
preserves compatible settings.

## 8. Configuration UI and preview

The ImGui shell exposes global settings, module enabled state, approved style
choices, common layout fields, approved module-specific options, recovery
messages, and reset controls. Controls mutate through the configuration
service; the UI never writes the persisted table directly.

The shell applies its navy/brass/ivory theme only around its own render call.
Supported ImGui color and style slots are discovered from the installed
binding, and the exact number pushed is popped even when rendering reports an
error. This avoids leaking Vana'diel HD UI styling into unrelated ImGui
surfaces. Token values and geometry remain reversible pending in-game review.

Preview mode also enables the core layout editor. Each rendered placeholder
offers one or more visible drag surfaces to the render context. On left-click,
the editor captures the owning module ID and its persisted X/Y offsets. ImGui's
cumulative mouse-drag delta supplies a transient position while held; release
performs one atomic configuration update. If pixel snapping is enabled, the
application rounds the final offsets before saving.

For a single-surface module, or a multi-element module in grouped mode, the
drag target is the module base position. In independent mode, the target is a
descriptor-declared element offset. The editor receives only generic target
records and contains no Party A/B/C conditions. Switching modes preserves the
base and every element offset. Party defaults to independent positioning.
Ending preview discards an unfinished drag. Preview windows use
`NoSavedSettings`, so ImGui's private window-position persistence cannot
compete with the addon's versioned configuration.

Preview background alpha is now an active scaffold behavior rather than a
display-only stored value: the render context composes effective opacity as
global opacity multiplied by per-module opacity before submitting each preview
window.

The scaffold preview renderer now also composes effective scale as global
scale multiplied by per-module scale. A narrow presentation helper measures
text against the active ImGui line height, submits draw-list text at explicit
pixel sizes where the binding supports it, and sizes preview windows from the
same scaled geometry/text inputs. This activates preview-only scale and shared
party-title font-size behavior without returning to `SetWindowFontScale`.

Entering preview captures one session token and notifies initialized modules.
Exiting preview clears all preview adapters and notifies modules once.
Unload/error cleanup always calls exit. Preview data is visibly labeled and
cannot enter the game-state adapter.

Placeholder enablement controls lifecycle and status only. A placeholder draws
when preview has supplied its labeled, non-live adapter; it does not create a
separate window merely because the module is enabled.

The current scaffold consumer for scale and font-size is preview-only. An
earlier experiment that scaled ImGui window dimensions and called
`SetWindowFontScale` was reverted after it caused load warnings, premature
placeholder display, incomplete preview cleanup, and text/window scaling
mismatch in game. The replacement path now uses original explicit-size
measurement/drawing for preview scaffolds. Approved production font assets and
future gameplay-module renderers still require their own controlled extension
of that pattern.

The party placeholder's preview adapter expresses the approved Proof 3
contract: Party A/B/C, six preview slots each, shared Party A configuration,
optional labels, configurable font size, and no fixed name-character limit.
It does not simulate gameplay roster visibility or claim preview names are live.

## 9. Logging and error containment

The logger provides `debug`, `info`, `warn`, and `error` methods with stable
component prefixes. Core lifecycle failures are logged once with a traceback.
Module hook failures include module ID and hook name and fault only that module.
Configuration recovery logs a summary without printing user character names or
raw settings content.

Shutdown is best-effort and reverse ordered. Each cleanup action is isolated so
one failure cannot prevent later modules, preview state, settings callbacks, or
event aliases from being released.

## 10. Test seams and acceptance

Core code depends on injected stores, loggers, clocks, event APIs, adapter
factories, and UI/render facades. `tests/run.lua` uses memory fakes and does not
require Ashita or FFXI. It covers:

- default creation and normalized round trips;
- legacy version-0 migration;
- invalid-value field recovery and future-version recovery;
- global and per-module reset;
- enable/disable initialization and shutdown;
- failure isolation between modules;
- reverse-order cleanup;
- deterministic event registration/unregistration;
- preview entry, party preview shape, exit, and unload cleanup;
- balanced configuration-theme color/style restoration;
- version-1 to version-2 layout migration and independent element storage; and
- generic module/element drag targets with one persistence commit on release.

The suite is intended to run under LuaJIT/MoonJIT compatible with Ashita v4.
Xpie's first in-game pass verified load/unload, lifecycle notices, responsive
controls, persistence, and the placeholder enable-state transition. The
remaining preview/reset items and exact Ashita-version compatibility are
tracked in `CORE-SMOKE-TEST.md`.
