# Vana'diel HD UI — Design Specification

**Status:** Transferred baseline; design and gameplay audit  
**Last updated:** 2026-08-01

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

## 2. Information boundary

A field or behavior is eligible only when all of the following are true:

- FFXI already communicates the information to the player in the same relevant
  context.
- The addon improves presentation rather than generating knowledge.
- The display does not expose hidden, normally unavailable, predicted, or
  inferred information.
- The behavior does not automate an action, reaction, target, command, or
  decision. A separately approved direct user action that recreates a suppressed
  native interaction is not automation.
- The display does not bypass an intentional inventory, equipment, currency,
  discovery, or Mog House interaction.
- The change does not create a meaningful gameplay advantage beyond
  readability.

Technical accessibility is not approval. Packet-, memory-, chat-, or
context-derived data must be reviewed field by field against the native player
experience. If equivalence cannot be demonstrated, the field is omitted.

D-014 is the only approved exception: the current enemy target may show
observed player-initiated effects with estimated remaining times. This is an
explicit, documented gameplay-boundary revision, not native equivalence and not
a precedent for other packet-derived displays.

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

Exact tokens for color, typography, dimensions, spacing, animation, and safe
areas remain design deliverables and must eventually live in a design-system
specification. Q-010 controls the approved scaling and validation targets.
The candidate tokens and first concept-art evaluation are recorded in
`VISUAL-SYSTEM.md`; they remain proposed until Xpie explicitly approves them.

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

Approved visual treatment under D-015:

- use a two-line identity area with the player name above
  `JOB LVL/SUBJOB LVL`;
- do not show level as a separate indicator;
- make HP approximately 10 percent taller than equal-height MP and TP bars;
- integrate three small TP-threshold pips tightly with the lower-right edge;
- use the approved horizontal bar and inset-frame style;
- reduce non-bar dark-blue infill approximately 20 percent from concept v2; and
- use the concept-v3 ornament scale as the current direction.

Exact pixel geometry, numeric formatting defaults, contextual visibility rules,
and production alpha values remain to be specified.

First live implementation slice, added 2026-07-31:

| Field | Native source/equivalent | Addon source | Timing and invalidation |
|---|---|---|---|
| Player identity/name | The native player/status HUD identifies the local player. | Ashita `MemoryManager` party wrapper local slot `0`, with the player wrapper as fallback. | Sampled during the addon's render/update loop; unavailable player data renders an unavailable/empty state and is cleared on reload or unload. |
| Main job/subjob and levels | Native status/menu presentation identifies the local player's current main job, subjob, and levels. | Ashita `MemoryManager` player wrapper job and level fields; numeric job IDs are rendered through the addon's original abbreviation table. | Sampled during the addon's render/update loop; unavailable job data omits the job line rather than inventing a value. |
| HP | The native player/status HUD displays the local player's HP state. | Ashita `MemoryManager` party wrapper local slot `0` HP/HPP or max-HP fields, with the player wrapper as fallback. | Sampled during the addon's render/update loop; invalid, absent, or zero-max values clamp to an empty bar rather than producing derived state. |
| MP | The native player/status HUD displays the local player's MP state. | Ashita `MemoryManager` party wrapper local slot `0` MP/MPP or max-MP fields, with the player wrapper as fallback. | Sampled during the addon's render/update loop; invalid, absent, or zero-max values clamp to an empty bar rather than producing derived state. |
| TP | The native player/status HUD displays the local player's TP. | Ashita `MemoryManager` party wrapper local slot `0` TP field, with the player wrapper as fallback if exposed. | Sampled during the addon's render/update loop; TP is clamped to the native 0-3000 presentation range. |

TP threshold pips are implemented as three visual markers for the native TP
thresholds 1000, 2000, and 3000. They are derived only from the already
approved local-player TP value, render inactive when TP is unavailable, and do
not imply action readiness, ability selection, recommendation, prediction, or
automation.

This slice does not include player casting, statuses, interaction, native UI
suppression, target information, target casting, target-of-target, automation,
or inferred/hidden information.

Player Frame module-specific font controls currently cover player name text,
job/subjob text, resource labels, and resource values. They are explicit-size
draw-list controls composed with global and module scale; they must not use
`SetWindowFontScale`. Resource values also expose left, center, and right
justification inside the bar with a small horizontal padding buffer. Resource
labels are fixed immediately outside the bar on the left for this functional
slice, while player name and job/subjob text align with the resource label
column so the later graphical pass can replace the temporary spacing without
changing field behavior.

D-029 extends the shared presentation layer with global text-outline controls
for explicit-size draw-list text. Outline is enabled by default and has
user-selectable outline size and color. The global font-family preference is
persisted and exposed for the future approved font-loading/caching layer; until
that layer exists, live text continues to render through the active Ashita
ImGui font handle. Player Frame text defaults to `#F1EAD8`, and the module
exposes separate color controls for player name, job/subjob, resource values,
and the HP, MP, and TP labels.

D-028 governs the Player Frame graphical layer pass. The current renderer uses
original production PNG layers for a full-coverage lowest-layer background,
fixed shared HP/MP/TP track treatment, two-color resource-bar fills, an
integrated lower-right inactive TP-pip backing, and active bright-blue TP jewel
overlays. The background layer has `background_enabled`; its separate
`background_opacity` control has been removed because the production
background opacity is baked into the image. The current production PNG assets
are `pframe_bg.png` 1930x815, `pframe_bars.png` 1930x815, and
`pframe_tpactive.png` 98x98 under
`addon/VanadielHDUI/assets/player_frame/`. The background and bar images share
the same transparent canvas and must be drawn at the same 0,0 layer origin.
The active jewel is positioned in the same production coordinate system and
drawn only for native TP thresholds that are currently met. The current
1930x815 runtime PNGs were supplied at a reduced source size. Module scale 1.0
is the intended default review size and draws the production canvas at
one-quarter of the PNG source dimensions, matching the in-game size previously
seen at module scale 0.50. The live Player Frame window must suppress ImGui default
chrome/background so only the module's own layers are visible; its `Begin`
call uses the Ashita-style open boolean and a unique no-title/no-resize/no-move
flag set rather than duplicating aggregate decoration flags. Production
textures are loaded from the addon-local PNG files through Ashita's D3D8
runtime when available and submitted to the ImGui draw list as texture
pointers. Once the shared bar-track image renders, the older draw-list track
fills, outlines, and TP-pip backing frame must be suppressed so the production
assets own the visible frame treatment. If the D3D texture path or any older
ImGui image helper is unavailable, the renderer falls back to draw-list
scaffolding and logs the texture-runtime diagnostic.

The active TP jewel may draw a configurable pulsing color overlay, enabled by
default with white, to make met native TP thresholds more noticeable during
gameplay. This is a visual emphasis effect only; it must not imply action
selection, tactical priority, prediction, or automation.

Outstanding Player Frame refinement tasks from the 2026-08-01 in-game review:

- `pframe_bg.png` transparency and decorative-element sizing require manual
  Photoshop adjustment in the production asset, followed by same-canvas
  registration checks against `pframe_bars.png`.
- Font sizing needs review against the default Player Frame scale and 4K
  living-room-distance legibility so labels do not require maximum configured
  sizes to be readable.
- The active TP-jewel flash requires in-game debugging because the current
  implementation does not yet behave as expected.
- Player Frame text placement should gain granular X/Y micro-position controls
  for name, job/subjob, HP label, MP label, TP label, and resource values.
- The configuration menu needs a layout/usability review. Player Frame options
  should be grouped and labeled clearly rather than relying only on the generic
  descriptor-option list.
- Recent Ashita-level configuration-menu warnings/errors must be captured from
  the Ashita logs or console and reviewed individually before the config UI is
  revised.

The initial release supports one active combat-frame runtime style:

**Style 1:** concept v3, preliminarily approved under D-015.

D-026 defers D-016's frameless Style 2 from the initial runtime and
configuration path. Any later style selection must not change field
availability, timing, precision, or behavior.

### 4.2 Target frame

The target frame is the visual counterpart to the player frame. It should use
mirrored or complementary geometry so the two read as one combat-HUD family.

Approved information:

- target identity/name;
- target HP presentation that matches information available natively;
- selection/relationship treatment; and
- native status icons without timers when the target is an eligible human party
  member under Q-003; or
- observed player-initiated debuffs/effects with estimated timers when the
  current target is an enemy, strictly under D-014/Q-003.

The target frame must not add predicted time-to-kill, threat, resistances,
hidden exact values, encounter intelligence, unobserved target effects, effect
potency, enemy-originated effects, or other inferred/unknown data. Estimated
target-effect timers must be visually distinguishable from authoritative
native timers and clear on observed removal, death/despawn, zoning, logout,
reload, stale target identity, or expiry. Mirroring is a visual relationship,
not a requirement that every player field also exist for targets.

Under D-015, retain the approved horizontal/inset visual family, reduce the
concept-v2 dark-blue infill approximately 20 percent, reduce the right ornament
approximately 10 percent, and use a compact round Check-indicator housing at the
lower-left edge. Exact alpha and dimensions remain production deliverables.

The approved D-017 Check family covers nine native results:

1. Too Weak to be Worthwhile.
2. Incredibly Easy Prey.
3. Easy Prey.
4. Decent Challenge.
5. Even Match.
6. Tough.
7. Very Tough.
8. Incredibly Tough.
9. Impossible to Gauge.

Icons must share identical outer dimensions and communicate state through both
color and internal geometry rather than color alone. They must contain no text
abbreviation. Exact Ashita result values and availability require technical
verification before implementation.

The bordered medallion construction is approved for inclusion in the final
draft. Its complete brass bezel counts as part of the icon bounds. The active
Style 1 target frame must revise the lower-left Check socket to fit that full
diameter with clear padding, without clipping, non-uniform scaling, or a second
competing bezel. Exact pixel dimensions remain subject to deterministic
production recreation and small-size legibility testing.

### 4.3 Target of target

Target-of-target is rejected under Q-001. The combat HUD must not reserve,
populate, or expose a passive target-of-target component.

### 4.4 Casting

Casting is part of the combat HUD rather than a detached general-purpose timer.

- Player casting belongs with or directly adjacent to the player frame.
- Target casting is rejected under Q-002.
- Presentation should make active casting immediately legible without adding
  prediction, decisions, interruption automation, or unavailable spell
  information.
- Cast data must be cleared safely on completion, interruption, zoning, target
  change, invalid state, and addon reload.

Exact player-cast labels, progress direction, latency treatment, interruption
cues, and whether recast information appears in the same geometry remain design
details. D-015 fixes the current visual treatment: no cast icon, outer
background, or enclosing decorative plate; only the cast name and approved
inset framed duration bar float directly over the game view.

### 4.5 Status and recast tray

The status tray and recast display are one time-sensitive information system
with multiple views, not unrelated text lists. The tray should visually belong
to the combat HUD and center utility family while remaining independently
positionable.

Approved categories:

- player buffs;
- player debuffs;
- current-enemy target effects under D-014;
- magic recasts;
- job-ability recasts; and
- other recasts the game natively provides.

Targeted-party treatment:

- show status icons without duration countdowns for the current target or
  subtarget only when it is a human party member;
- allow one manually locked human party member as a native-focus equivalent;
  and
- exclude enemies, NPCs, trusts, fellows, pets, and alliance members.

Current-enemy treatment:

- accept only effects observed as initiated by a player character;
- present remaining time as an estimate derived from the observed action/result
  and a reviewed duration table;
- do not imply server-authoritative status, potency, resistance, source
  ownership beyond the observed actor, or tactical priority; and
- show it only with the current target frame, while retaining tracked state no
  longer than needed for correct invalidation.

Approved views:

- player-status icons with native-equivalent numeric countdowns;
- compact bars for user-selected native recasts;
- an optional hybrid treatment;
- optional remaining-time color swatches and user-configured thresholds; and
- cooldown overlays on player-configured hotbars where the recast is otherwise
  approved.

Under D-018, status artwork uses compact square tiles with a thin understated
Aged Brass border, restrained corners, a narrow dark separator, and a subtle
color-complementary dark field behind the central glyph. This treatment is
distinct from the round Check medallions. Countdown text is rendered separately
by the addon below the tile and must never be baked into the icon texture.
Production artwork must retain color-plus-silhouette recognition at the
intended HUD size and remain legible without relying on the timer text.
Validate each icon at 32×32 px. A simple crisp primary silhouette and stable
color cue must carry recognition; fine detail, gradients, and antialiasing are
secondary finish and must not be necessary to tell icons apart.

The complete eleven-sheet icon family is approved for the final draft. Before
individual icon files are generated, all sheets must be reconciled to one
border template with consistent thickness, inset, corners, separator, and
outer bounds. Once individual files exist, perform a separate filename audit:
compare each icon's depicted meaning with its source filename and coverage-map
entry, and correct any naming or mapping discrepancy before final asset
approval.

“Important” means explicitly pinned, filtered, or configured by the user. The
addon must not infer tactical priority.

Local-player status cancellation:

- a deliberate right-click on a displayed local-player status recreates the
  native tray's cancellation behavior;
- expose the interaction only when the current game resource marks the status
  cancellable, and revalidate that status at activation;
- send at most one native status-removal request (`0x0F1`) for the selected
  status per deliberate click;
- make target, party-member, and estimated enemy-target effect icons
  non-actionable; and
- fail without sending for stale, absent, invalid, non-cancellable, or ambiguous
  status state.

Cancellation must never run from hover, timers, thresholds, filtering, status
changes, or other context. Bulk cancellation, queues, retries, repeated sends,
automatic selection, and chained actions are prohibited.

When the replacement player-status tray is active, suppress the redundant
native player status-icon display. Suppression must be optional, reversible,
version-validated, fail closed on an unknown game build or mismatched state,
restore native presentation on normal unload and recoverable errors, and ship
with explicit recovery instructions. A technical prototype must choose the
safest viable method; Q-006 approves the result, not a specific memory patch.
Suppression must not remove native cancellation without replacement: it may
activate only when the approved replacement interaction is available.

### 4.6 Party frames

The party list is the primary group-combat information center and the
highest-priority gameplay component. Its approved presentation uses three
identical six-slot group stacks for Parties A, B, and C without portraits.

Information priority from the transferred baseline:

1. Name.
2. HP.
3. MP.
4. TP.
5. Level, only where the native source and equivalent timing are documented.
6. Main-job/subjob abbreviations.
7. The local player's current roster selection.
8. Important status effects, limited to approved native information.

D-021 approves Proof 3's three-group direction and rejects the single-stack and
2×3 raid proofs. Party A is the canonical configuration template; all
party-frame options applied to Party A automatically apply to Parties B and C.
Party-group labels must have a user enable/disable toggle.

Configuration mode shows all three groups at full six-slot capacity for
aesthetic and placement decisions. Those entries are preview-only. During
gameplay, only the groups expected by the unmodified game are visible:

- outside an alliance, Party A shows up to five other party members and omits
  the local player; and
- in an alliance, the active Party A/B/C frames show the available alliance
  roster, including the local player, up to the game's maximum available
  alliance membership.

Each portrait-free cell uses dominant HP, subordinate MP/TP, readable name/job
information, and the approved restrained Bright Brass selection edge and
directional marker. User font options include font-size control. Production
name-field width and maximum displayed character count remain pending testing
against the longest currently available in-game Trust name. Level numbers
remain conditional on their field-level source review. Only the selected human
local-party example may show native-focus status icons; approval does not
expand status visibility to every party/alliance member. Production geometry
and minor refinements remain implementation-time validation items.

### 4.7 Job-specific and pet unit frames

Q-011B preserves a job-specific unit-frame direction, primarily for pets, but
does not yet approve a field list. Candidate pet families are Beastmaster
charm/jug pets, Summoner avatars, Puppetmaster automatons, and Dragoon wyverns.

Before any pet or other job-specific element advances, document:

- the included job/entity family;
- every displayed field and its native on-screen source;
- update timing, absence/stale-state handling, and visibility rules; and
- whether the presentation is a unit frame or another job-specific indicator.

XIUI's pet bar is a behavior reference, not the specification. Its level,
distance, status, target, MP/TP, and command-recast displays are not approved by
association. Numeric distance and pet-target data remain rejected under Q-005,
and estimated job recasts require a separate exception if native equivalence
cannot be established.

Required options include opaque backing, for covering unavoidable native
lower-right elements, and a transparent mode for placement elsewhere.

Mouse/controller activation may select that roster member only as a direct,
user-initiated equivalent of native targeting. The interaction must not select
for the player, issue a command, or chain an action. Another member's target and
numeric or continuous distance are excluded.

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
- Collapse exact duplicates only when native event type, source, and verbatim
  text all match within two seconds. Replace the retained line with a `×N`
  count; do not group merely similar messages or calculate summaries.

The feed must not append vendor/market values, inventory totals or remaining
capacity, session earnings, predictions, or metadata the native event did not
communicate.

### 5.2 Loot history

Loot history is an on-demand record of recent native loot messages, opened from
the center HUD, a slash command, or a configurable binding. It is not a
persistent inventory panel.

It must not show gil messages or values, market/vendor value, inventory totals,
or remaining capacity. Literal native gil-acquisition messages remain transient
in native chat or the temporary feed.

### 5.3 Synthesis history

Synthesis history is an on-demand organization of native results, quality,
skill-up, and material-loss messages. It must not predict outcomes, calculate
profit, add market values, or infer hidden crafting state. Its reliable native
source remains to be verified.

### 5.4 Treasure pool

The treasure-pool module is an optional, on-demand presentation of the currently
available native pool. It may reorganize the same visible entries but must not
add alerts, history, analytics, valuation, inventory context, prediction, or lot
or pass controls.

## 6. Center utility dock

### 6.1 Utility dock

The round bottom-center minimap is the intended visual anchor. Hotbars,
experience/limit-point progress, approved recasts, and contextual utilities
share a construction language but remain independently configurable.

The minimap is the sole intended directional display; the redundant native
compass is excluded from the target layout. Proposed hotbar presets remain those
listed in the README and are not yet final defaults.

D-019 defines three central-HUD layout families. Style 1 uses a centered round
minimap with split hotbar wings and is approved as a concept direction. Style 2
uses uninterrupted hotbar rows with the round minimap docked at one horizontal
edge and is approved for the final draft; the user may reverse the dock between
right and left. Dock reversal must not change fields, behavior, slot order, or
module availability.

Style 3 is a proposed compact lower-right console that occupies the footprint
otherwise intended for a masking chat surface. Unlike Styles 1 and 2, it uses
an opaque or nearly opaque navy backing because covering unsuppressible native
lower-right UI is the preset's functional purpose. It contains the central-HUD
utility family, not chat content, and must not replace native chat behavior.
Exact geometry, coverage dimensions, slot counts, labels, default selection,
and production artwork remain pending.

### 6.2 Chat display

Provide two scalable decorative log displays with independent native-category
filters, presentation settings, and placement. Native text input, controller
entry, auto-translate, and tell history remain native; the addon must not replace
them. Filtering and input reliability require technical verification.

Under D-020, Chat Window 1 defaults to the lower-left corner and Chat Window 2
defaults to the lower-right as its horizontal mirror. The user may instead
select a single lower-left Chat Window 1 and place central-HUD Style 3 in the
lower-right coverage position.

Each chat frame offers exactly three exposed-line choices: 8, 12, and 16.
These choices use one fixed-width construction. Only body height changes by
integer text-row increments; header, border, corners, ornament, typography,
line height, padding, and controls remain unchanged. Mirrored Window 2 changes
directional geometry only, not dimensions or content capability.

Chat-frame background opacity is independently user configurable from 0 to
100 percent inclusive and defaults to 100 percent/full opaque. At zero
background opacity, text legibility treatment and interaction behavior remain
subject to validation; opacity must not change filtering, message availability,
input behavior, or persistence.

## 7. Configuration requirements

Every module should support independent enable/disable, position, scale, style,
and persistence where technically appropriate. Anchor controls are exposed only
where the module descriptor keeps them useful; D-027 hides the Player Frame
anchor selector for the initial release while preserving the generic persisted
position structure. The configuration system
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

The canonical layout is 1920×1080. Initial validation targets are 1920×1080,
2560×1440, and 3840×2160. Layout scaling is uniform from display height, uses
pixel snapping where needed, and includes a user override. Ultrawide and 16:10
layouts must remain anchor-compatible but are not supported until validated.

Configuration must not turn informational modules into automation.

### 7.1 Implemented core configuration architecture

D-022 established schema version 1. D-024 advances the current schema to
version 2 for generic multi-element positioning; the implementation boundary
is documented in `CORE-ARCHITECTURE.md`.

- The core addon lives at `addon/VanadielHDUI` and uses one entry point.
- Only the core event router owns Ashita lifecycle, command, and render-event
  registrations.
- Module descriptors are explicit and ordered. The Player Frame now requests
  the reviewed `local_player` read capability; remaining placeholder modules
  request no live game-state capability.
- Persisted module blocks own enabled state, an approved style identifier,
  anchor/base position, scale, opacity, descriptor-reviewed options, and a
  layout block containing movement mode and declared element offsets.
- The configuration service migrates before validation, recovers invalid
  fields independently, rejects unsupported future schemas, and provides
  module/global reset.
- Configuration-window and preview-open state are session-only and clear on
  unload.
- Preview mode may initialize a disabled placeholder temporarily without
  changing its persisted enabled state.
- The party preview always supplies three preview-only Party A/B/C groups with
  six slots each. Party A owns shared presentation options, while A/B/C own
  independent positions. No fixed name width or maximum character count exists
  in the schema.
- The shared party `font_size` option changes the visible Party A/B/C group
  title size in the current preview scaffold and must continue to do so in the
  finished renderer.
- The current preview scaffold composes global and module scale coherently for
  geometry and text through an original explicit-size draw-list path.
- A finished module renderer must apply global and module scale coherently to
  geometry, spacing, icons, and text. Effective background opacity is the
  global opacity multiplied by module opacity. Persisted presentation controls
  must not remain display-only values.
- The first live Player Frame renderer applies the same composed global/module
  scale and opacity path to local-player name, job/subjob, HP, MP, TP, and TP
  threshold pips. Its geometry, font defaults, and colors are implementation
  scaffolding pending in-game visual review, not final production tokens.
- Production module text must not rely on `SetWindowFontScale`. The replacement
  architecture must preload and cache approved fonts outside the per-frame
  render path, measure and draw text at explicit pixel sizes, and contain font
  setup failures at the platform boundary.
- XIUI demonstrates the relevant behavior pattern, but its implementation is
  reference-only. Vana'diel HD UI must use original font management,
  measurement, drawing, outlining, and scale composition.
- Placeholder enablement remains a lifecycle/status state. It does not by
  itself render a non-preview scaffold window. Preview mode is the only current
  placeholder visualization and continues to show all module previews for
  layout editing regardless of persisted enabled state.
- A module failure is isolated to that module's runtime state and does not
  silently alter the user's enabled choice.

The initial values in version 2 are development-safe scaffold defaults, not
final product-default approval. All gameplay placeholders start disabled.
Finished state adapters and renderers remain subject to the verification gates
in section 9.

### 7.2 Configuration-shell presentation and section ownership

The configuration shell uses a locally scoped navy/brass/ivory ImGui theme
consistent with D-015. It must restore its pushed ImGui colors and style
variables after rendering so it does not restyle unrelated addon windows. The
current token values and geometry are a reversible first implementation and
remain subject to in-game readability and visual validation.

Placeholder descriptor groupings are not final configuration taxonomy. As
modules are defined, grouped placeholders may become unique independently
configurable sections when field ownership and behavior are verified. Any
change to persisted module IDs or blocks requires a schema migration that
retains compatible user choices; no speculative gameplay fields should be
added in advance.

### 7.3 Core preview drag/edit positioning

Preview mode is the foundation edit-positioning mode. A visible module surface
may be left-click dragged, with the core layout editor owning mouse state,
transient movement, pixel snapping, and persistence. The configuration service
must receive one atomic X/Y update on release rather than saving every render
frame.

Modules provide stable descriptor-declared element IDs, drag surfaces, and
render at positions supplied by the core context. They must not implement
separate input or persistence systems. Multi-element modules expose independent
and grouped movement. Independent mode changes only the selected element;
grouped mode changes the common module base. Switching modes retains every
element offset. Party A/B/C default to independent movement. Leaving preview
cancels an unfinished drag. This interaction changes addon layout only and may
not execute or automate gameplay actions.

## 8. Confirmed exclusions

- Enemy list.
- Automated targeting, action selection, or command execution. Direct
  user-initiated interactions approved under Q-005 and Q-006 are not automation.
- Predictive combat calculations or tactical recommendations.
- Hidden or normally unavailable game information.
- Target-of-target and target casting.
- Trust-level comparison, passive party-member target data, and numeric or
  continuous distance.
- Large redundant horizontal player-status display.
- Redundant in-game compass.
- Inventory capacity, free-space, storage, or combined-inventory indicators.
- Inventory-full gauges and proactive space warnings.
- Gil totals, session earnings, or enhanced gil tracking.
- Gil messages in on-demand history.
- Item vendor, market, or projected gil values.
- Equipment display in the core addon.
- Target-effect data outside the D-014 exception.
- Any feature primarily intended to bypass FFXI's native inventory, equipment,
  currency, discovery, or Mog House experience.

## 9. Verification gates

No component moves from design to implementation until it has:

1. a named native source/equivalent for every displayed field, or an explicit
   approved exception such as D-014;
2. a boundary review covering persistence, precision, inference, and timing;
3. defined invalidation behavior for zoning, target change, party change,
   death, logout, reload, and unavailable data;
4. an interaction review for mouse, keyboard, and controller;
5. a visual specification or approved prototype; and
6. documented acceptance tests that compare the addon display with native game
   state.
