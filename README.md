# Vana'diel HD UI

> **Project status:** Core foundation validated in game; first Player Frame live slice in validation
> **Current working version:** `0.1.1` (`v0.1.0` archived as the stable checkpoint tag)
> This README is a living draft. Features, installation steps, file locations, and configuration commands marked **TBD** will be completed and verified as development progresses.

> **Document authority:** This README preserves the transferred baseline and
> remains an overview. `docs/DECISIONS.md` controls approval status, and
> `docs/DESIGN-SPEC.md` controls current component constraints. A feature named
> here is not authorized when either document marks its data or behavior as
> conditional, deferred, or unresolved.

Vana'diel HD UI is a modernization project for the Final Fantasy XI interface, designed for Ashita v4. Its purpose is to make information the game already communicates clearer, more cohesive, and more readable at modern resolutions while preserving the character, friction, and deliberate limitations that are part of FFXI's identity.

The eventual goal is one cohesive addon with internally independent modules, supported by a separate set of native interface textures and optional themes for compatible external addons. It should look and feel like one interface without becoming one fragile piece of code.

## Development foundation

The first authorized implementation phase is present under
`addon/VanadielHDUI`. It provides the Ashita v4 lifecycle entry point, explicit
module registry, versioned configuration and recovery, an in-game ImGui
configuration shell, reversible preview mode, and module descriptors for
approved modules. Only the Player Frame has live gameplay behavior so far.
The first in-game foundation pass confirmed load/unload, lifecycle notices,
responsive controls, persistence, and placeholder enable-state transitions.
The configuration shell uses a scoped first-pass navy/brass/ivory theme whose
exact values remain subject to visual review.
Preview mode also provides core left-drag positioning for placeholder modules.
Multi-element modules can expose independent or grouped movement; Party A/B/C
default to independent positions. Final positions and movement mode persist on
release.

The first live gameplay slice is now present for the Player Frame only. It
shows the local player's native-equivalent name, job/subjob, HP, MP, and TP
through a reviewed Ashita `MemoryManager` local-player adapter. It does not
implement target data, target casting, target-of-target, player casting,
statuses, automation, or inferred/hidden information. Player Frame font
controls now cover name, job/subjob, resource labels, and resource values, with
left/center/right resource-value justification inside each bar. The initial
release uses a single active combat-frame style; the earlier frameless Style 2
concept is deferred and is not exposed as an initial configuration choice. The
Player Frame also hides anchor selection for the initial release while keeping
normal X/Y positioning.

Player Frame graphical refinement has started with original placeholder
draw-list layers: a configurable full-frame background layer, fixed bar tracks,
two-color resource fills, and an integrated lower-right TP-pip backing with
bright blue TP indicators. These placeholders are for in-game sizing and layer
validation before final production assets. The first nontransparent PNG
placeholder set lives under `addon/VanadielHDUI/assets/placeholders/player_frame/`.

The architecture is documented in
[`docs/CORE-ARCHITECTURE.md`](docs/CORE-ARCHITECTURE.md). Host-independent smoke
tests live in `tests/` and can be run with:

```powershell
.\tests\smoke.ps1 -Lua <path-to-luajit-or-lua>
```

The scaffold recognizes `/vhd` and `/vanadielhdui`. `/vhd help` lists the
configuration, preview, module-toggle, reset, and status commands. These
commands alter addon state only; they do not execute gameplay actions.

## Design philosophy

### Modernize presentation, not gameplay

Vana'diel HD UI may improve the presentation, organization, and usability of information FFXI already gives the player. It should not reveal hidden information, automate actions, make decisions for the player, or remove intentional gameplay systems.

The design target is:

> A modern, modular MMO HUD constructed from Vana'diel-inspired architectural pieces—compact in combat, richly framed at its major anchors, and visually unified without becoming bulky.

### Native-information boundary

Every feature will be reviewed against the following standard:

| Question | Required outcome |
|---|---|
| Does FFXI already communicate this information? | Yes |
| Are we improving presentation instead of creating new knowledge? | Yes |
| Does the feature reveal hidden or normally unavailable information? | No |
| Does it calculate, predict, or infer information for the player? | No |
| Does it automate an action, reaction, target, or decision? | No |
| Does it remove an intentional management or discovery system? | No |
| Could it create a meaningful gameplay advantage beyond readability? | If possibly yes, stop and review |

Features based on contextual, aggregated, inferred, or packet-derived information require individual review even when they are technically possible.

The sole approved exception is D-014/Q-003: the current enemy target may show
observed player-initiated debuffs/effects with estimated timers. This is an
explicit project-boundary revision, not a claim of native equivalence and not a
general authorization for packet-derived combat information.

### Preserve intentional friction

FFXI's inventory, equipment, currency, Mog House, and related menu systems are part of the game's intended experience. The project will not add persistent inventory-capacity indicators, storage summaries, gil tracking, market values, session earnings, or other tools that reduce those systems to passive HUD data.

Native messages such as receiving an item, obtaining gil, or being unable to obtain an item may still appear in chat or the temporary event feed. The addon will not turn those messages into proactive inventory management.

### One addon, internally modular

The overlay will load as a single addon, but each major system should remain independently configurable and maintainable. Modules should be individually enabled, disabled, positioned, and styled without creating unnecessary dependencies between unrelated features.

### Designed around actual play

Screen space must be earned. The interface will prioritize information the player actually looks at during combat and remove redundant displays.

- The party list is the primary group-combat information center.
- Player, target, and player-casting information belong near the action.
- The bottom-center HUD is a unified family of utilities rather than a collection of unrelated overlays.
- The minimap is the single directional display; the redundant native compass is not part of the intended layout.
- Important timing information should be immediately legible without flooding the screen.

### Original implementation and responsible reuse

The project may study the behavior and general interface patterns of existing addons, but its core implementation and visual assets should be original.

- Use documented Ashita interfaces and game data.
- Write original event handling, state management, rendering, and configuration code.
- Create original textures and visual assets.
- Do not copy source code unless its license explicitly permits the intended use.
- Preserve required license notices and provide clear attribution for any incorporated work.
- Treat familiar UI patterns—tabs, toggles, drag positioning, profiles, icon timers, and unit frames—as design references rather than source material.

## Visual language

The current visual direction is established, with exact values to be refined during component design.

- Dark navy foundations
- Bright brass highlights
- Crisp, restrained borders
- Compact information density
- Clear visual hierarchy
- Limited, purposeful ornament
- Matching panel geometry, insets, separators, and endcaps
- Modular pieces that look intentional both alone and when assembled
- Controller-friendly placement and readability
- Modern resolution support without losing FFXI's Vana'diel character

Color, typography, spacing, border, and animation specifications will eventually be maintained in a separate design-system document.

## Legal and use disclaimer

Vana'diel HD UI is an unofficial third-party project for Ashita v4. It is not affiliated with, sponsored by, approved by, or endorsed by Square Enix, Ashita, or the authors of other addons referenced during design.

Square Enix's published policies prohibit third-party programs that affect gameplay, whether or not they provide an unfair advantage. There is no official exception for visual or quality-of-life addons. Anyone choosing to use Ashita or Vana'diel HD UI does so at their own risk and is responsible for reviewing the current rules governing FINAL FANTASY XI.

The project's ethical limits—no automation, cheating, hidden information, unfair advantage, or erosion of intentional gameplay systems—are development principles. They are **not** a claim of Terms-of-Use compliance and do not guarantee that use will be ignored or permitted.

Official references:

- [Square Enix: Use of 3rd Party Programs](https://support.na.square-enix.com/faqarticle.php?id=20&kid=12800)
- [Square Enix: Prohibited Activities in FINAL FANTASY XI](https://support.na.square-enix.com/faqarticle.php?id=20&kid=78029)

## Project scope

### Planned core addon modules

| System | Intended purpose | Current direction |
|---|---|---|
| Player frame | Compact HP, MP, TP, identity, and casting information near the avatar | Live slice implements local player name, job/subjob, HP, MP, TP, and TP threshold pips; casting remains a future slice |
| Target frame | Clear information about the current target | Mirrored with the player frame; target casting is excluded; observed player-initiated effects may use clearly estimated timers under D-014 |
| Target-of-target | Passive target-relationship display | Rejected and excluded from the core addon |
| Party frames | Primary group-combat display | Party A uses the approved six-slot group template, omits the local player outside an alliance, and retains strong HP, MP, TP, job/subjob, selection highlighting, and direct user-initiated targeting |
| Alliance frames | Compact information for Parties A, B, and C | Three identical six-slot group stacks using Party A's shared configuration; active alliance groups include the local player |
| Trust-level indication | Compare a trust's level with the player | Rejected and excluded from the core addon |
| Cast display | Show current player casting clearly | Visually integrated with the player frame; target casting is excluded |
| Minimap | Provide compact location and direction information | Round, centered default; replaces the need for the native compass |
| Hotbars | Present player-configured abilities in a cohesive utility dock | Multiple layout presets plus custom positioning |
| Experience bar | Display native experience or limit-point progress | Wide foundation along the bottom-center HUD |
| Timing system | Unify active buffs, debuffs, magic recasts, job-ability recasts, and eligible targeted-party status icons | Player icons, user-selected recast bars, optional hybrid/threshold views, and no inferred priority |
| Job/pet unit frames | Present job-specific unit information that FFXI natively displays | Pet-frame direction retained; exact pet families and fields remain pending under Q-011B |
| Notifications | Show restrained, temporary native event information | Unified fading feed instead of a separate background tab for each line |
| Loot history | Provide recent native loot messages on demand | Collapsible history; no gil messages, tracking, aggregation, market values, or inventory totals |
| Treasure pool | Restyle the currently available native pool on demand | Optional faithful mirror; no alerts, history, analytics, valuation, inventory context, or lot/pass controls |
| Synthesis history | Organize native crafting results without adding predictions or hidden information | Collapsible log for results, quality, skill-ups, and material-loss messages |
| Chat display | Modernize chat readability while retaining native behavior | Two configurable decorative log displays; native input, auto-translate, and tell history remain native |
| Configuration and edit mode | Control modules, layouts, profiles, and positioning | Cohesive themed interface with live positioning and recovery controls |

### Native interface and texture package

These changes affect FFXI's native interface rather than the modern overlay and should remain a separate installation layer:

- XIView-style native menu and window DAT changes
- Custom menu cursors and buttons
- Native fonts and status graphics
- Chat-window textures
- XIPivot-delivered texture replacements
- Other verified native interface assets

### Optional external-addon themes

Some useful systems do not belong in the core addon but may receive an optional matching theme and configuration guide.

| External addon | Intended support |
|---|---|
| EquipMon | Optional matching assets, recommended placement, and configuration preset if its structure permits clean theming |
| Other addons | Evaluated individually; inclusion is not assumed |

The Vana'diel HD UI installer should not silently modify another addon's files. Any external theme should be clearly identified, optional, reversible, and accompanied by attribution and compatibility notes.

### Confirmed exclusions

- Enemy list
- Automated targeting, action selection, or command execution; narrowly
  approved direct native-equivalent interactions remain user initiated
- Predictive combat calculations
- Hidden or normally unavailable game information
- Large redundant horizontal player-status display
- Redundant in-game compass
- Inventory capacity, free-space, or storage indicators
- Inventory-full gauges or proactive space warnings
- Combined inventory summaries
- Gil totals, session earnings, or enhanced gil tracking
- Item vendor, market, or projected gil values
- Equipment display in the core addon
- Features whose primary purpose is to avoid using FFXI's intended inventory, equipment, currency, or Mog House interfaces

## Functional design notes

### Party and alliance frames

The party list is currently the highest-priority gameplay component.

Each member appears in an individual frame without a portrait. Each frame should prioritize:

1. Name
2. HP
3. MP
4. TP
5. Level, only where its native source and timing are documented
6. Main job/subjob abbreviations
7. The local player's current roster selection
8. Important status effects, limited to approved native information

The approved direction uses three identical six-slot group stacks for Parties
A, B, and C. Party A is the shared configuration template; its options
automatically apply to Parties B and C. Party-group labels can be enabled or
disabled.

Configuration mode previews all three groups at full capacity for aesthetic and
placement work. Gameplay shows only the groups expected by the game. Outside an
alliance, Party A omits the local player and shows up to five other members. In
an alliance, the active groups include the available alliance roster, including
the local player.

User font options include font-size control. Production name-field width and
maximum character capacity remain pending testing against the longest currently
available in-game Trust name. The approved selection highlight uses a restrained
Bright Brass edge and directional marker.

Background options should include an opaque plate for covering unavoidable native lower-right elements and a transparent mode for placement elsewhere.

Mouse/controller activation may select a roster member only as a direct,
user-initiated equivalent of native targeting. Passive display of another
member's target and numeric or continuous distance are excluded.

### Center HUD and utility dock

The round minimap is the bottom-center visual anchor. Hotbars, experience progress, recasts, and contextual utilities should share a construction language and appear intentionally assembled even when each module has its own frame.

Proposed hotbar presets:

- Split wings around the minimap
- Two continuous horizontal rows
- Compact left and right banks
- One long horizontal bank
- Controller-oriented grouped banks
- Freeform custom layout

### Timing system

Status timers and recasts should be treated as one time-sensitive information system with different views, not unrelated text lists.

Approved categories:

- Player cast
- Player buffs
- Player debuffs
- Status icons without timers for the targeted, subtargeted, or one manually
  locked human party member
- Observed player-initiated debuffs/effects on the current enemy target, with
  estimated timers under D-014
- Magic recasts
- Job-ability recasts
- Other native ability recasts

Approved display modes:

- Player-status icons with native-equivalent numeric countdowns
- Compact bars for user-selected recasts
- Optional hybrid and user-configured threshold/color treatments
- Hotbar cooldown overlays for otherwise approved recasts

The guiding rule is:

> Show important timers continuously, ordinary timers contextually, and everything else only on demand.

“Important” is always explicitly pinned, filtered, or configured by the user.
The core addon will not infer tactical priority or copy third-party suppression
or cancellation code/assets. To preserve behavior lost when the native tray is
suppressed, a deliberate right-click may cancel a currently cancellable
local-player status. The addon sends at most one native removal request for that
selected status per click. Target/party icons are not actionable, and automatic,
bulk, queued, retried, repeated, or chained cancellation is excluded.

While the replacement tray is active, it will suppress the redundant native
player status icons using an optional, reversible, version-validated method that
fails closed and has documented recovery. Suppression may activate only when
the replacement cancellation interaction is available.

### Notifications, loot, and synthesis

Temporary notifications should behave like a clean event feed:

- One cohesive list rather than disconnected tabs
- No background by default, with an optional shared background
- New entries added consistently and faded as a group
- Optional duplicate grouping
- Adjustable duration and maximum visible lines
- Key items visually distinguished using an FFXI-inspired treatment
- Important native failures, including inventory-full messages, allowed without proactive inventory tracking

Default notifications should not show vendor value, market value, total inventory, remaining capacity, or other metadata that diminishes item discovery.

Loot and synthesis histories may be opened from the center HUD, slash commands, or configurable bindings. They are on-demand records of information already communicated by the game, not permanent analytical panels.

### Chat

The preferred direction is a custom scalable display with native chat input retained:

- Left window for conversation and primary messages
- Right window for combat and system information
- Independent filters, fonts, opacity, auto-hide behavior, and placement
- Matching decorative construction
- Ability for the right window or another opaque module to cover unavoidable native lower-right UI elements

The default layout places Chat Window 1 in the lower-left corner and a mirrored
Chat Window 2 in the lower-right. An alternate preset uses only the lower-left
window and places central-HUD Style 3 in the lower-right coverage position.
Each chat frame supports 8, 12, or 16 exposed lines by changing height only.
Background opacity is user configurable from 0–100 percent and defaults to
100 percent/full opaque.

A replacement of controller text entry, auto-translate, tell history, or other
native input behavior is excluded. Technical verification must establish that
the two decorative log displays preserve reliable native filtering and input.

## Installation template

> **Not ready for use.** This section is a framework for verified instructions. Do not publish it as an installation guide until every step has been tested from a clean Ashita v4 setup.

### Supported environment

| Requirement | Supported/tested value |
|---|---|
| FINAL FANTASY XI client | TBD |
| Ashita version | Ashita v4 — exact tested build TBD |
| Windows version | TBD |
| Display resolution | 1920×1080 baseline; additional resolutions TBD |
| UI scaling | TBD |
| Controller/mouse assumptions | Controller-first; exact requirements TBD |
| Required plugins/addons | TBD |
| Optional plugins/addons | TBD |

### Before installation

1. Review the legal and use disclaimer above.
2. Confirm that FINAL FANTASY XI and the supported Ashita v4 build launch correctly before adding Vana'diel HD UI.
3. Close FINAL FANTASY XI and Ashita.
4. Back up every file or folder that the installation will replace or modify.
5. Record the current locations of:
   - Ashita v4
   - The FFXI installation
   - Addons
   - Configuration files
   - XIPivot
   - Any existing native UI texture packages
6. Remove or disable known conflicting addons and texture replacements listed in the compatibility section.

### Package contents

```text
VanadielHDUI/
├── addon/VanadielHDUI/    # Core Ashita addon foundation
├── assets/                 # Original overlay textures and fonts — TBD
├── native-ui/              # Optional native DAT/texture package — TBD
├── external-themes/        # Optional themes for compatible addons — TBD
├── presets/                # Tested layout and configuration presets — TBD
├── docs/                   # Detailed guides and reference images — TBD
├── LICENSE                 # GNU GPL version 3 license text
├── LICENSE-NOTICE.md       # GPL-3.0-or-later project grant and copyright
├── THIRD-PARTY-NOTICES     # Required attribution and license notices — TBD
└── README.md
```

### Core addon installation

1. Download the release package from **TBD**.
2. Verify the release version and checksum: **TBD**.
3. Copy the core addon folder to:

   ```text
   <Ashita v4>\addons\VanadielHDUI
   ```

4. Load the addon using:

   ```text
   /addon load VanadielHDUI
   ```

5. To load it automatically, add the verified command to the appropriate Ashita startup script: **TBD**.
6. Launch the game and complete the verification checklist below.

### Optional native interface package

1. Confirm that the required XIPivot version is installed and working: **TBD**.
2. Back up or disable conflicting native UI packages.
3. Copy the Vana'diel HD UI native package to: **TBD**.
4. Add the required XIPivot configuration or load order: **TBD**.
5. Restart the game completely.
6. Verify menus, cursors, chat windows, fonts, status icons, and character selection.

### Optional external-addon themes

For each theme:

1. Confirm the exact supported addon and version.
2. Back up its current settings and custom assets.
3. Copy only the documented theme files.
4. Import or manually apply the provided preset.
5. Restart or reload the external addon.
6. Confirm that the external addon remains independently removable.

### First launch

1. Open configuration mode using `/vhd`.
2. Select a resolution/layout preset.
3. Confirm that all active modules fit within the safe screen area.
4. Choose whether the party frame or right chat panel covers the native lower-right UI.
5. Confirm controller, mouse, and keyboard interaction.
6. Save the profile.
7. Reload the addon and confirm that the profile persists.

### Verification checklist

- [ ] Game launches without an Ashita error.
- [ ] Addon loads without console errors.
- [ ] Configuration window opens and closes.
- [ ] Edit mode allows intended modules to move.
- [ ] Saved positions persist after reload.
- [ ] Player and target frames update correctly.
- [ ] Party and alliance frames update correctly.
- [ ] The local player's selected party/alliance row is unmistakable.
- [ ] Job information is accurate; no trust-level comparison is displayed.
- [ ] HP, MP, and TP values update correctly.
- [ ] Player casting behaves correctly; no target-cast display is present.
- [ ] Minimap position and orientation are correct.
- [ ] Hotbar interaction remains controller-safe.
- [ ] Approved buff, debuff, and recast timers match their documented native
      source and precision, or the explicitly estimated D-014 source.
- [ ] Eligible targeted-party status icons appear without duration countdowns.
- [ ] Current-enemy target effects are player-initiated, observed, visibly
      estimated, and invalidated under D-014.
- [ ] Native player status icons are suppressed only while the replacement tray
      is active and recover after unload or a failed validation.
- [ ] A right-click cancels only a current local-player status marked
      cancellable, sends one request, and never affects target/party icons.
- [ ] Stale, absent, invalid, or non-cancellable statuses produce no
      cancellation request.
- [ ] Notifications do not disclose excluded inventory or value information.
- [ ] Chat filters and input behavior remain reliable.
- [ ] Native textures appear correctly at the supported resolution.
- [ ] No module automates an action or exposes unavailable information.

### Updating

1. Read the release notes and breaking-change warnings.
2. Back up the current addon folder, configuration, presets, and modified native assets.
3. Follow the version-specific update instructions: **TBD**.
4. Do not overwrite user profiles unless the release explicitly requires a migration.
5. Complete the verification checklist again.

### Uninstalling and rollback

1. Close FINAL FANTASY XI and Ashita.
2. Unload the core addon with `/addon unload VanadielHDUI`, then remove its
   folder if desired.
3. Remove the Vana'diel HD UI XIPivot package or restore the prior native UI files.
4. Restore external-addon assets and settings from backup.
5. Remove the automatic load command.
6. Launch the game and verify that the previous interface is restored.

## Configuration template

Each module should be documented using this same structure as it is implemented and tested.

### Module: `[Module name]`

**Purpose:**  
`What native FFXI information this module presents and why it earns screen space.`

**Native source and boundary:**  
`Where FFXI normally communicates the information and any fair-play limitations.`

**Default behavior:**  
`When it appears, what it shows, and how it responds to game context.`

**Enable or disable:**

```text
Command or configuration path: TBD
Default: Enabled | Disabled
```

**Position and anchor:**

| Setting | Default | Options/notes |
|---|---|---|
| Anchor | TBD | TBD |
| X position | TBD | TBD |
| Y position | TBD | TBD |
| Scale | TBD | TBD |
| Expansion direction | TBD | TBD |
| Screen-edge behavior | TBD | TBD |

**Layout:**

| Setting | Default | Options/notes |
|---|---|---|
| Preset | TBD | TBD |
| Orientation | TBD | TBD |
| Rows/columns | TBD | TBD |
| Spacing | TBD | TBD |
| Alignment | TBD | TBD |
| Background | TBD | Opaque, translucent, or off where supported |

**Information display:**

| Setting | Default | Options/notes |
|---|---|---|
| Visible fields | TBD | TBD |
| Numeric values | TBD | TBD |
| Icons | TBD | TBD |
| Labels | TBD | TBD |
| Sorting | TBD | TBD |
| Filtering | TBD | TBD |

**Appearance:**

| Setting | Default | Options/notes |
|---|---|---|
| Theme | Vana'diel HD | TBD |
| Font | TBD | TBD |
| Font size | TBD | TBD |
| Opacity | TBD | TBD |
| Border treatment | TBD | TBD |
| Highlight behavior | TBD | TBD |

**Interaction:**

- Mouse behavior: TBD
- Controller behavior: TBD
- Keyboard or slash commands: TBD
- Selection and targeting behavior: TBD

**Compatibility and conflicts:**

- Known compatible versions: TBD
- Known conflicts: TBD
- Required load order: TBD
- Performance considerations: TBD

**Verification:**

- [ ] Module loads without error.
- [ ] Displayed information matches the native game.
- [ ] Position and scale persist.
- [ ] Contextual visibility behaves correctly.
- [ ] Mouse/controller input is not blocked.
- [ ] No excluded or unavailable information is exposed.

**Known limitations:**  
`TBD`

### Global configuration categories

The configuration interface is expected to include:

- Profiles
- Resolution and layout presets
- Module enable/disable controls
- Live edit/position mode
- Anchoring and scaling
- Shared typography
- Shared colors and opacity
- Background and border options
- Timing and animation preferences
- Input and controller-safe behavior
- Import/export or backup, if implemented safely
- Reset module
- Reset layout
- Recovery from off-screen or invalid positions

## Compatibility record template

| Component | Version tested | Status | Required action | Notes |
|---|---:|---|---|---|
| Ashita v4 | TBD | TBD | TBD | TBD |
| FINAL FANTASY XI client | TBD | TBD | TBD | TBD |
| XIPivot | TBD | TBD | TBD | TBD |
| XIView/native UI package | TBD | TBD | TBD | TBD |
| EquipMon theme | TBD | TBD | TBD | Optional external support |
| Other addons | TBD | TBD | TBD | Add only after testing |

## Development decision record template

Use this record whenever a proposed feature could alter the project's native-information boundary or scope.

### Decision: `[Feature or change]`

- **Date:** YYYY-MM-DD
- **Status:** Proposed | Approved | Rejected | Deferred | Superseded
- **Player need:** TBD
- **Native FFXI equivalent:** TBD
- **Information source:** TBD
- **Presentation improvement:** TBD
- **Potential gameplay advantage:** TBD
- **Effect on intentional friction or immersion:** TBD
- **Automation or inference risk:** TBD
- **Licensing or attribution concern:** TBD
- **Decision and reasoning:** TBD
- **Verification required:** TBD

## Credits and attribution

Vana'diel HD UI is informed by long-term playtesting and by interface patterns found across Final Fantasy XI addons and modern MMOs. Inspiration does not imply affiliation or endorsement.

Projects or products considered as behavioral or layout references include:

- Ashita v4
- XIUI
- EquipMon
- StatusTimers
- RecastPlus
- XIView
- XIPivot
- World of Warcraft and its raid-frame conventions
- OmniCC
- ElvUI
- Guild Wars 2
- Star Wars: The Old Republic

Before any public release, this section must be replaced or supplemented by a complete `THIRD-PARTY-NOTICES` record identifying every distributed dependency, incorporated source fragment, modified work, asset, license, copyright notice, and required attribution.

Original project material designated as covered by the project license is
licensed under `GPL-3.0-or-later`, with
`Copyright © 2026 Xpie`. See [LICENSE-NOTICE.md](LICENSE-NOTICE.md).

## Roadmap

1. Complete the remaining gameplay audit.
2. Refine and document the visual design system.
3. Produce the authoritative layout and component specification.
4. Define the shared addon framework and module boundaries.
5. Prototype the native-information and technical uncertainties.
6. Build the essential combat HUD.
7. Add the center utility dock and timing system.
8. Add chat, notification, and history modules.
9. Create optional native UI and external-addon theme packages.
10. Test installation, updates, rollback, compatibility, and supported resolutions.
11. Complete licensing, attribution, release notes, and public documentation.

## Current open questions

- Exact pet families, fields, native sources, visibility, and any non-pet
  job-specific indication under Q-011B
- Most reliable native source for synthesis history
- Exact installation, updating, and rollback procedures
