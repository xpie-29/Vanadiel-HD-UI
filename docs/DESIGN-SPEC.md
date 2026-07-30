# Vana'diel HD UI — Design Specification

**Status:** Transferred baseline; design and gameplay audit  
**Last updated:** 2026-07-29  
**Authority:** Approved decisions in `DECISIONS.md` override this specification.

This document converts the repository README and the named design areas from the
earlier design conversation into an implementation-independent specification.
It deliberately does not invent details that were not preserved in the
repository. Unresolved choices are listed in `DECISIONS.md`.

## 1. Product definition

Vana'diel HD UI is a modernization layer for Final Fantasy XI on Ashita v4. It
improves the legibility, organization, scaling, and visual cohesion of
information the game already gives the player while preserving FFXI's
deliberate limitations and management systems.

The intended product has three separately installed layers:

1. One core Ashita v4 overlay addon with internally independent modules.
2. An optional native-interface texture/DAT package.
3. Optional, reversible themes and presets for compatible external addons.

The core addon must not silently modify either of the other layers.

## 2. Non-negotiable information boundary

A field or behavior is eligible only when all of the following are true:

- FFXI already communicates the information to the player in the same relevant
  context.
- The addon improves presentation rather than generating knowledge.
- The display does not expose hidden, normally unavailable, predicted, or
  inferred information.
- The behavior does not automate an action, reaction, target, command, or
  decision.
- The display does not bypass an intentional inventory, equipment, currency,
  discovery, or Mog House interaction.
- The change does not create a meaningful gameplay advantage beyond
  readability.

Technical accessibility is not approval. Packet-, memory-, chat-, or
context-derived data must be reviewed field by field against the native player
experience. If equivalence cannot be demonstrated, the field is omitted.

### 2.1 Allowed event presentation versus prohibited tracking

Native messages such as receiving an item, obtaining gil, failing to receive an
item, or an inventory-full message may be repeated in a temporary event feed or
on-demand history because the game has already communicated that event.

That allowance does not permit:

- current or remaining inventory capacity;
- a full-inventory gauge or proactive warning;
- storage or combined-inventory summaries;
- persistent gil totals or session earnings;
- vendor, market, or projected values;
- forecasts based on acquisition history; or
- a feature designed to avoid FFXI's native inventory, currency, equipment, or
  Mog House interfaces.

## 3. Shared visual and interaction language

- Dark navy foundations and bright brass highlights.
- Crisp, restrained borders; purposeful Vana'diel-inspired ornament.
- Compact information density and strong hierarchy.
- Shared panel geometry, insets, separators, and endcaps.
- Modules must look intentional alone and when assembled.
- Controller-first placement and readability, with modern-resolution scaling.
- Major anchors may be richly framed; frequently repeated combat elements
  should remain compact.
- Screen space must be earned and redundant displays removed.

Exact tokens for color, typography, dimensions, spacing, animation, safe areas,
and scaling remain unresolved and must eventually live in a design-system
specification.

## 4. Combat HUD

### 4.1 Player frame

The player frame is a compact, configurable combat anchor near the avatar. It
replaces the proposed large redundant horizontal player-status HUD.

Required information:

- player identity/name;
- HP;
- MP;
- TP; and
- current player cast state, visually integrated with the frame.

Required behavior:

- contextual visibility and independent enable/disable;
- configurable position, anchor, scale, and styling;
- sufficient prominence for HP and current casting without duplicating the
  richer party frame unnecessarily; and
- no inventory, gil, equipment, prediction, or automated-action information.

Exact geometry, numeric formatting, contextual visibility rules, and the
relationship between the frame and cast bar remain to be specified.

### 4.2 Target frame

The target frame is the visual counterpart to the player frame. It should use
mirrored or complementary geometry so the two read as one combat-HUD family.

Candidate information from the transferred baseline:

- target identity/name;
- target HP presentation that matches information available natively;
- selection/relationship treatment; and
- target casting, but only after the native-information and technical review in
  `DECISIONS.md`.

The target frame must not add predicted time-to-kill, threat, resistances,
hidden exact values, encounter intelligence, or other inferred/unknown data.
Mirroring is a visual relationship, not a requirement that every player field
also exist for targets.

### 4.3 Target of target

Target-of-target is a reserved combat-HUD component, not yet authorized for
implementation. Its purpose is to present a target relationship more clearly
only if that relationship is already natively available to the player in the
same context.

Before approval, the project must document:

- the native equivalent and when it is visible;
- the exact proposed fields;
- the source and update timing;
- whether the display creates persistent knowledge that native FFXI does not;
  and
- behavior for missing, stale, self, party, trust, player, and NPC targets.

No assumptions about click-to-target behavior or continuous availability are
approved.

### 4.4 Casting

Casting is part of the combat HUD rather than a detached general-purpose timer.

- Player casting belongs with or directly adjacent to the player frame.
- Target casting belongs with or directly adjacent to the target frame only if
  approved after native-equivalence review.
- Presentation should make active casting immediately legible without adding
  prediction, decisions, interruption automation, or unavailable spell
  information.
- Cast data must be cleared safely on completion, interruption, zoning, target
  change, invalid state, and addon reload.

Exact labels, progress direction, latency treatment, interruption cues, and
whether recast information appears in the same geometry remain unresolved.

### 4.5 Status and recast tray

The status tray and recast display are one time-sensitive information system
with multiple views, not unrelated text lists. The tray should visually belong
to the combat HUD and center utility family while remaining independently
positionable.

Eligible categories, subject to native-source verification:

- player buffs;
- player debuffs;
- magic recasts;
- job-ability recasts; and
- other recasts the game natively provides.

Provisional categories requiring additional boundary review:

- target effects; and
- any status duration not natively communicated with equivalent precision.

Possible views, not yet approved defaults:

- icons with numeric countdowns;
- horizontal timer bars;
- a hybrid in which an icon becomes a bar below a threshold;
- cooldown overlays on player-configured hotbars; and
- threshold-based visibility.

The governing priority is: important timers continuously, ordinary timers
contextually, and everything else on demand. Sorting must not imply tactical
recommendations or hidden priority.

### 4.6 Party frames

The party list is the primary six-person group-combat information center and
the highest-priority gameplay component. Default presentation is a vertical
stack of individual frames without portraits.

Information priority from the transferred baseline:

1. Name.
2. HP.
3. MP.
4. TP.
5. Level and a possible trust-level difference treatment.
6. Main-job/subjob abbreviations.
7. Current target selection, subject to source and boundary verification.
8. Important status effects, limited to approved native information.
9. Optional low-priority distance, subject to source and boundary verification.

Required layout families:

- richer stacked party frames for ordinary play; and
- compact raid-style horizontal or grid frames suitable for healers/support
  players nearer the screen center.

Alliance mode should keep Parties A, B, and C visually distinct. HP and targeting
have the greatest prominence; MP, TP, and approved status information may use a
denser treatment.

Required options include opaque backing, for covering unavoidable native
lower-right elements, and a transparent mode for placement elsewhere.

Displaying a member's target is separate from interaction. Mouse/controller
click-to-target behavior is not approved until it is confirmed to be a direct,
user-initiated equivalent of native targeting and technically safe.

## 5. Notifications and histories

### 5.1 Temporary event feed

Notifications are a restrained, temporary presentation of native events.

- Use one cohesive fading list rather than a separate permanent tab/background
  for each line.
- Add new entries consistently and fade the visible group coherently.
- Default to no background; allow an optional shared background.
- Allow configurable duration and maximum visible lines.
- Key-item events may receive a distinct FFXI-inspired visual treatment.
- Important native failures, including inventory-full messages, are allowed as
  events.
- Duplicate grouping is provisional until its aggregation behavior is defined
  and reviewed.

The feed must not append vendor/market values, inventory totals or remaining
capacity, session earnings, predictions, or metadata the native event did not
communicate.

### 5.2 Loot history

Loot history is an on-demand record of recent native loot messages, opened from
the center HUD, a slash command, or a configurable binding. It is not a
persistent inventory panel.

It must not show gil valuation, market/vendor value, inventory totals, or
remaining capacity. Whether literal native gil-acquisition messages belong in
loot history, the general event feed, or chat is unresolved.

### 5.3 Synthesis history

Synthesis history is an on-demand organization of native results, quality,
skill-up, and material-loss messages. It must not predict outcomes, calculate
profit, add market values, or infer hidden crafting state. Its reliable native
source remains to be verified.

## 6. Center utility dock

The round bottom-center minimap is the intended visual anchor. Hotbars,
experience/limit-point progress, approved recasts, and contextual utilities
share a construction language but remain independently configurable.

The minimap is the sole intended directional display; the redundant native
compass is excluded from the target layout. Proposed hotbar presets remain those
listed in the README and are not yet final defaults.

## 7. Configuration requirements

Every module should support independent enable/disable, position, anchor, scale,
style, and persistence where technically appropriate. The configuration system
is expected to provide:

- profiles and resolution/layout presets;
- live edit/position mode;
- shared typography, color, opacity, background, border, timing, and animation
  controls;
- controller-safe input behavior;
- module and whole-layout reset;
- recovery from invalid or off-screen positions; and
- safe import/export or backup only if it can be implemented without hidden
  state or fragile coupling.

Configuration must not turn informational modules into automation.

## 8. Confirmed exclusions

- Enemy list.
- Automated targeting, action selection, or command execution.
- Predictive combat calculations or tactical recommendations.
- Hidden or normally unavailable game information.
- Large redundant horizontal player-status display.
- Redundant in-game compass.
- Inventory capacity, free-space, storage, or combined-inventory indicators.
- Inventory-full gauges and proactive space warnings.
- Gil totals, session earnings, or enhanced gil tracking.
- Item vendor, market, or projected gil values.
- Equipment display in the core addon.
- Any feature primarily intended to bypass FFXI's native inventory, equipment,
  currency, discovery, or Mog House experience.

## 9. Verification gates

No component moves from design to implementation until it has:

1. a named native source/equivalent for every displayed field;
2. a boundary review covering persistence, precision, inference, and timing;
3. defined invalidation behavior for zoning, target change, party change,
   death, logout, reload, and unavailable data;
4. an interaction review for mouse, keyboard, and controller;
5. a visual specification or approved prototype; and
6. documented acceptance tests that compare the addon display with native game
   state.
