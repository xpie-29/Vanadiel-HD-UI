# Core Addon Structure and Configuration System — Starter Prompt

Copy the prompt below into the new project conversation.

---

You are continuing development of **Vana'diel HD UI** in:

`D:\Xpie Addons\Final Fantasy XI\Vanadiel-HD-UI`

Xpie explicitly authorizes implementation of the **core Ashita v4 addon
structure and configuration system only** in this phase. Do not implement the
finished gameplay or rendering behavior of individual HUD modules yet, except
for minimal placeholders, interfaces, and preview/test adapters needed to prove
the core architecture.

Before doing any project work, read `AGENTS.md`, then read these files completely
in this precedence order:

1. `docs/DECISIONS.md`
2. `docs/DESIGN-SPEC.md`
3. `docs/PROJECT-STATUS.md`
4. `README.md`
5. `docs/REFERENCES.md`

If they conflict, follow that precedence. Do not silently reconcile a conflict:
record it in the contradiction register in `docs/DECISIONS.md` and ask Xpie
before a material choice depends on it. Refer to the project owner only as
**Xpie**.

## Goal

Build an original Ashita v4 addon foundation that supports the approved
single-addon, independently configurable module model. Establish:

- the Ashita addon entry point and lifecycle;
- an explicit module registry and narrow module contract;
- independent module enable/disable controls;
- safe module initialization, shutdown, update, render, command, and
  configuration ownership;
- centralized event routing with deterministic registration and cleanup;
- separation between game-state adapters, module state, rendering, and
  configuration;
- versioned configuration schema, defaults, validation, persistence, migration,
  and safe recovery from invalid or older settings;
- global settings plus per-module settings such as enabled state, approved style
  choice, position, scale, opacity, and approved module-specific options;
- an in-game configuration UI shell and reversible configuration/preview mode;
- safe global and per-module reset-to-default behavior;
- logging and fault isolation so one disabled or failing module does not corrupt
  configuration or unnecessarily disable unrelated modules; and
- a small validation or smoke-test harness appropriate to the repository.

Determine the correct Lua/runtime conventions and Ashita v4 APIs from current
official Ashita documentation and examples. Do not guess API names.

## Reference boundary

Use these references when needed:

- <https://github.com/AshitaXI/Ashita-v4beta> — current public Ashita v4 beta
  distribution/platform reference.
- <https://github.com/tirem/XIUI> — reference for the user-facing pattern of one
  addon with an in-game configuration surface and selectable modules.

XIUI is GPL-3.0, but it is **architecture and behavior inspiration only** for
this task. Write original event handling, state management, configuration,
rendering interfaces, and assets. Do not copy XIUI code, assets, configuration
schema, naming, or implementation structure merely because it is public. If
exact reuse becomes desirable, stop before copying and document the precise
source files, license compatibility, attribution, modification plan, and
release-notice requirements in `docs/REFERENCES.md`. The project itself is
GPL-3.0-or-later.

## Required architecture work

1. Inspect the repository and working tree first. Preserve unrelated or
   user-owned changes.
2. Review current official Ashita v4 material and only the portions of XIUI
   needed to understand its modular/configuration interaction pattern.
3. Before substantial coding, write a concise architecture proposal covering:
   - directory layout;
   - entry point and lifecycle;
   - module interface and registry;
   - dependency policy;
   - event and command routing;
   - game-state adapter boundary;
   - render boundary;
   - configuration ownership, schema versioning, validation, migrations, and
     persistence;
   - configuration UI and preview behavior;
   - error containment and logging; and
   - test seams.
4. Add durable architecture/configuration documentation to the repository, then
   implement the scaffold. Do not stop after planning unless a material decision
   is genuinely blocked.
5. Register descriptors or placeholders for the approved modules so their
   enable/disable and configuration boundaries can be exercised, but do not
   build their final live behavior in this phase.
6. Keep module APIs narrow enough that future modules cannot casually access
   unrelated packet or game-state data.
7. Validate configuration round trips, defaults, invalid-value recovery,
   migrations, module toggling, lifecycle cleanup, and preview-mode entry/exit.
8. Update `docs/DECISIONS.md`, `docs/DESIGN-SPEC.md`,
   `docs/PROJECT-STATUS.md`, and `docs/REFERENCES.md` for material architecture
   decisions, implementation progress, and source provenance before finishing.
9. Do not commit, push, or open a pull request unless Xpie asks.

## Party-module requirements the core must support

The party module's approved visual direction is Proof 3: three identical
six-slot Party A/B/C stacks.

- Party A is the canonical party-frame configuration; its options automatically
  apply to Parties B and C.
- Party-group labels have a user enable/disable toggle.
- Font options include configurable font size.
- Name-field width and maximum displayed character count remain unresolved
  until tested against the longest currently available in-game Trust name; do
  not hard-code a product decision now.
- Configuration mode displays all three groups at full six-slot capacity as
  preview-only data for aesthetic and placement work.
- During gameplay, only groups the game currently expects are visible.
- Outside an alliance, Party A shows up to five other party members and omits the
  local player.
- In an alliance, the active Party A/B/C frames show the available alliance
  roster, including the local player, up to the game's maximum available
  alliance membership.
- The selected-player highlight is an approved presentation requirement.

The core configuration design must express these shared, conditional, and
preview-only behaviors without implementing the full party module yet.

## Binding product and safety boundaries

All exclusions and approvals in `AGENTS.md` and `docs/DECISIONS.md` remain
binding. In particular:

- Modernize information the unmodified game already communicates; do not create
  new player knowledge except the narrow D-014/Q-003 target-effect timing
  exception.
- Do not add automation, action selection, automated command execution,
  predictive or inferred combat information, hidden information, enemy lists,
  inventory tracking, storage/free-space/gil/market displays, equipment
  displays, passive party targets, target-of-target, target casting, continuous
  distance, or Trust-level comparison.
- Packet availability is not permission to display a field.
- Keep direct user actions limited to those explicitly approved.
- The product is one Ashita v4 addon with independently configurable modules;
  DAT replacements and external-addon themes remain optional separate layers.
- Do not implement D-014/Q-003 or other specialized gameplay exceptions in this
  core phase; only leave clean, restrictive extension seams where necessary.

## Expected deliverables

- A documented, original core architecture.
- A loadable Ashita v4 addon scaffold using verified current APIs.
- A versioned, validated, persistent configuration system with migration and
  recovery behavior.
- A module registry/lifecycle and independently toggleable placeholder modules.
- An in-game configuration UI shell and preview-mode foundation.
- Focused tests or repeatable smoke checks plus their results.
- Updated project status, decisions, design specification, and references.
- A concise handoff identifying files changed, verification performed, remaining
  risks, and the next recommended module-development step.

Use informed, reversible assumptions where the documents already constrain the
answer. Ask Xpie only when a missing choice would materially change the public
configuration schema, architecture, gameplay boundary, or reuse/licensing
posture.

---
