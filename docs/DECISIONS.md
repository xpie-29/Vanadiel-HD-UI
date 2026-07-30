# Vana'diel HD UI — Decision Record

**Last updated:** 2026-07-30

**Authority:** This is the highest-priority project design document.

Statuses:

- **Approved** — binding unless Xpie explicitly changes it.
- **Proposed** — candidate direction; not authorization to implement.
- **Deferred** — intentionally postponed.
- **Rejected** — out of scope.
- **Needs confirmation** — described inconsistently or incompletely in the
  transferred material; do not implement.
- **Superseded** — retained for history but no longer controlling.

## Approved decisions

### D-001 — Modernize presentation, not gameplay

- **Status:** Approved
- **Source:** README baseline and transfer request
- **Decision:** The project may improve clarity, organization, scaling, and
  visual cohesion only for information FFXI already communicates. It may not
  reveal, calculate, predict, infer, or automate gameplay information or
  actions.
- **Consequence:** Technical availability, including packet or memory access, is
  insufficient. Every field requires native-equivalence review unless Xpie
  records a named exception. D-014 is the sole current exception.

### D-002 — Preserve intentional inventory and currency friction

- **Status:** Approved
- **Source:** README baseline and transfer request
- **Decision:** Exclude capacity/free-space displays, storage or combined
  summaries, inventory-full gauges, proactive space warnings, inventory
  tracking, gil totals/session earnings, price/value metadata, and core
  equipment displays.
- **Clarification:** A native item, gil, acquisition-failure, or inventory-full
  message may appear temporarily because the event has already been disclosed.
  It may not be converted into persistent state, a forecast, or an analytical
  tool.

### D-003 — One modular core addon; separate optional packages

- **Status:** Approved
- **Source:** README baseline
- **Decision:** The overlay will be one Ashita v4 addon with independently
  configurable modules. Native UI replacements and external-addon themes remain
  separate, optional, reversible installation layers.

### D-004 — Compact player frame

- **Status:** Approved
- **Source:** README baseline and transfer request
- **Decision:** Use a compact configurable player frame near the action for
  identity, HP, MP, TP, and integrated player casting. Do not build the large
  redundant horizontal player-status display.
- **Still unresolved:** exact geometry, values, contextual visibility, and cast
  treatment.

### D-005 — Mirrored target-frame family

- **Status:** Approved
- **Source:** README baseline and transfer request
- **Decision:** The target frame should be visually mirrored or complementary to
  the player frame and communicate the current target clearly.
- **Limit:** This approves the visual relationship, not hidden exact values,
  target casting, unrestricted target statuses, or field-for-field symmetry.
  Q-003 separately permits native human-party target/focus icons and the narrow
  estimated current-enemy effect treatment governed by D-014.

### D-006 — Casting belongs in the combat HUD

- **Status:** Approved
- **Source:** README baseline and transfer request
- **Decision:** Player casting integrates with the player frame. Target casting
  is rejected under Q-002 because equivalent native identity, progress, timing,
  and interruption information was not established.

### D-007 — Unified status and recast tray

- **Status:** Approved
- **Source:** README “Timing system” and transfer request naming the status tray
- **Decision:** Player statuses and native recasts form one time-sensitive
  system with compatible icon/bar/hybrid views. They are not separate unrelated
  text lists.
- **Resolved presentation:** Q-003 and Q-006 approve player status icons with
  native-equivalent timers, user-selected recast bars, optional hybrid and
  threshold treatments, native player-status-icon suppression, preserved direct
  cancellation of eligible local-player statuses, and the narrow estimated
  target-effect exception in D-014.

### D-008 — Party-first group combat design

- **Status:** Approved
- **Source:** README baseline and transfer request
- **Decision:** The party list is the primary group-combat information center
  and highest-priority gameplay component. Use portrait-free frames and keep
  alliance parties distinct. D-021 supersedes the baseline's stacked and
  raid-style layout proposals with the approved three-group frame direction.
- **Resolved limits:** Q-004 rejects trust-level comparison. Q-005 approves
  local selection highlighting and direct user-initiated targeting, while
  rejecting passive party-member target data and numeric/continuous distance.

### D-009 — Restrained unified notification feed

- **Status:** Approved
- **Source:** README baseline and transfer request
- **Decision:** Temporary native events use one cohesive fading feed, no
  background by default, with an optional shared background, configurable
  duration, and configurable maximum lines.
- **Limit:** Q-007 permits only exact-duplicate grouping within two seconds.
  Additional metadata is forbidden unless the native event communicated it and
  it passes boundary review.

### D-010 — On-demand histories are not analytical panels

- **Status:** Approved
- **Source:** README baseline
- **Decision:** Loot and synthesis histories may organize already communicated
  messages on demand. They may not become permanent inventory/currency panels or
  add prediction, profit, price, or capacity data.

### D-011 — Original implementation and license-aware reuse

- **Status:** Approved
- **Source:** README baseline
- **Decision:** Study outside projects for behavior and patterns. Write original
  code and create original assets unless a specific reuse has been reviewed for
  license compatibility, attribution, and provenance.

### D-012 — No enemy list or automation

- **Status:** Rejected
- **Source:** README confirmed exclusions and transfer request
- **Decision:** Enemy lists; automated targeting; action selection; command
  execution; predictive combat calculations; and hidden information are outside
  the project.
- **Clarification:** Direct user-initiated equivalents of native interactions
  are not automation when separately approved and tightly bounded. Q-005 covers
  party targeting; Q-006 covers cancellation of a removable local-player
  status. Neither permits queued, repeated, chained, or context-selected action.

### D-013 — Project-owner privacy and public name

- **Status:** Approved
- **Source:** Xpie privacy request dated 2026-07-29
- **Decision:** Refer to the project owner only as **Xpie** in all current and
  future project documentation, code comments, metadata, release materials,
  issue text, and project-related responses. Do not reproduce, infer, or publish
  another personal name for the project owner.
- **Consequence:** This naming rule applies to all future project work and
  supersedes any earlier personal-name reference.

### D-014 — Narrow target-effect timing exception

- **Status:** Approved
- **Date:** 2026-07-30
- **Source:** Xpie boundary revision; XIUI 1.8.2 behavior reference
- **Decision:** As a deliberate exception to D-001, the current enemy target may
  display icons and estimated remaining times for debuffs and other effects
  observed being initiated by player characters. This includes observed local,
  party, alliance, and other-player actions; it does not include effects whose
  player origin cannot be established.
- **Information source and timing:** State is reconstructed from observed action
  and result messages and a reviewed duration table. It is not an authoritative
  native target-status feed. Timers must be labeled and documented as estimates.
- **Limits:** Show the state only on the current target frame. Clear or
  invalidate it on observed removal, target death/despawn, zoning, logout, addon
  reload, stale identity, or expired estimate. Do not infer unobserved effects,
  potency, resistance, tactical priority, source identity beyond observed
  evidence, target casting, target-of-target, or enemy intelligence.
- **Risk treatment:** This adds combat knowledge and timing that native FFXI
  does not present equivalently. Xpie approved that narrow gameplay-boundary
  revision because it is required for this project. It does not create a general
  packet-derived-data exception or authorize XIUI source/assets.

### D-015 — Combat-frame visual system and concept-v3 refinement

- **Status:** Approved
- **Date:** 2026-07-30
- **Source:** Xpie review of combat HUD concept v2
- **Approved visual qualities:** Retain the demonstrated overall style and
  color scheme, font styles and colors, horizontal resource-bar layout, and
  inset-frame treatment around HP, MP, TP, and cast-duration bars.
- **Player identity:** Enlarge the identity background for two lines. Place the
  player name first and job/subjob information beneath it in
  `JOB LVL/SUBJOB LVL` format. Do not show a separate level indicator.
- **Player frame:** Reduce the opacity of dark-blue surfaces outside the inset
  resource frames by approximately 20 percent relative to concept v2. Make HP
  approximately 10 percent taller than equal-height MP and TP bars. Integrate
  the three approved small TP pips more tightly with the lower-right frame edge.
  Reduce the left ornament approximately 10 percent and remove the concept-v2
  lower-left edge artifact.
- **Player cast:** Show no cast icon and no outer cast-panel background or
  enclosing decorative plate. The cast name and inset framed duration bar float
  directly over the game view while remaining adjacent to and visually
  integrated with the player-frame family.
- **Target frame:** Reduce the main dark-blue surface opacity approximately 20
  percent relative to concept v2, reduce the right ornament approximately 10
  percent, and use a compact round Check-indicator housing rather than a shield.
- **Limit:** Percentages describe the approved concept-relative direction.
  Exact production alpha and pixel dimensions require deterministic asset
  specification and in-game validation. Placeholder status and Check artwork
  remains subject to later refinement.

- **Style designation:** Preserve concept v3 as **Style 1** with preliminary
  approval. Preliminary approval fixes its design direction for comparison and
  further specification; it does not make the generated bitmap a production
  asset or finalize pixel measurements.

## Additional visual decisions

### D-016 — Frameless combat-frame Style 2

- **Status:** Approved
- **Date:** 2026-07-30
- **Source:** Xpie request following preliminary approval of Style 1
- **Style family:** Offer Style 1 and Style 2 as user-selectable presentations
  of the same approved player/target information and bar geometry.
- **Player treatment:** Remove the outer background plate, perimeter, and left
  ornament. Float the name and `JOB LVL/SUBJOB LVL` text directly over the game
  view. Retain only the unified inner HP/MP/TP container, reduce its non-track
  blue background opacity approximately 20 percent relative to Style 1, keep
  inactive bar tracks opaque, and retain the integrated TP pips.
- **Target treatment:** Remove the outer background plate, perimeter, and right
  ornament. Float the target name directly over the game view. Retain only the
  inner HP container, opaque inactive track, and round Check indicator; reduce
  only the container's non-track blue background opacity approximately 20
  percent relative to Style 1.
- **Shared treatment:** Retain Style 1's approved fonts, colors, horizontal bar
  layout, inset frames, resource proportions, floating cast presentation, and
  status/effect trays.
- **Style designation:** Preserve
  `combat-hud-style-2-concept-v1-1920x1080.png` as **Style 2** with preliminary
  approval. Preliminary approval fixes its design direction for comparison and
  further specification; generated geometry and alpha remain non-production.

### D-017 — Check-status icon family

- **Status:** Approved
- **Date:** 2026-07-30
- **Source:** Xpie request following preliminary approval of Style 2; official
  FFXI Players Guide state list
- **Native states:** Cover all nine native Check results: Too Weak to be
  Worthwhile, Incredibly Easy Prey, Easy Prey, Decent Challenge, Even Match,
  Tough, Very Tough, Incredibly Tough, and Impossible to Gauge.
- **Concept direction:** Use one coherent family of equal-diameter round
  brass-and-enamel medallions. Make every state distinguishable through both
  color and internal geometry, with no text abbreviation inside the icon.
- **Progression:** Use subdued/downward forms for weaker states, balanced forms
  around Even Match, upward forms for Tough through Incredibly Tough, and a
  distinct non-ordinal violet fractured-orbit form for Impossible to Gauge.
- **Reuse:** Create original artwork. Do not copy native FFXI, XIUI, or other
  third-party icons.
- **Approval:** Xpie approved
  `check-status-icon-family-concept-v1-1920x1080.png` for inclusion in the
  final draft. The complete bordered medallion construction is the preferred
  and controlling direction; the border is part of the icon rather than an
  optional frame ornament.
- **Frame integration:** Revise the Check socket in both Style 1 and Style 2 to
  accommodate the complete bordered icon with clear padding. The socket must
  not clip the medallion, distort its scale, or create a visually competing
  second bezel.
- **Production limit:** Approval fixes the icon-family direction, not the
  generated pixels. Exact dimensions, deterministic production artwork, and
  small-size validation remain production work. Implementation must separately
  verify which Check result values Ashita exposes.

### D-018 — Square status-icon family

- **Status:** Approved for final draft; normalization and export checks pending
- **Date:** 2026-07-30
- **Source:** Xpie correction using the approved combat HUD concept-v3 status
  tray; Xpie-supplied `Tetsouou.zip` coverage reference; publisher's
  [FFXIAH origin thread](https://www.ffxiah.com/forum/topic/58015/reworking-icons-ui-hd/)
- **Coverage:** Recreate an original concept for every asset filename included
  in the supplied archive and no additional status assets. The archive contains
  644 image files representing 567 unique file hashes and 77 exact duplicate
  aliases. Preserve every filename in the coverage map while allowing exact
  duplicate aliases to share one visual concept.
- **Construction:** Use compact square tiles with a thin, understated Aged
  Brass border, restrained corner treatment, narrow dark separator, and a
  subtle color-complementary dark field behind a crisp central glyph. Status
  icons do not use the round bordered-medallion construction approved for Check
  states.
- **Timer separation:** Countdown text below a status icon is live addon text
  and is not part of the icon asset. Do not bake timer digits or duration text
  into status artwork.
- **Reuse:** The Tetsouou theme supplies coverage and semantic reference only.
  Create original glyphs; do not copy or distribute its images, linework,
  silhouettes, shading, or other distinctive artwork. The origin thread's
  informal sharing statement is not a complete license, and its publisher
  expressly reports incomplete upstream provenance.
- **Legibility gate:** At actual HUD size, each concept must prioritize a
  simple, crisp silhouette and stable color cue. Fine interior detail,
  gradients, and smoothing may support the approved material style but must not
  be required to distinguish states. Validate at 32×32 px and include
  low-vision/color-independence review before production approval.
- **Final-draft approval:** Xpie reviewed all eleven
  `status-icon-family-square-concept-v1-page-*.png` atlases and approved the
  depicted icon family for inclusion in the final draft.
- **Border-normalization gate:** Border construction is not fully consistent
  between the eleven sheets. Before generating individual icon files, normalize
  border thickness, inset spacing, corner treatment, separator placement, and
  icon bounds to one deterministic template.
- **Post-export naming gate:** Filename-to-design verification is deferred until
  the individual icon files exist. After export, compare every icon's depicted
  meaning with the corresponding source filename and coverage-map entry;
  correct any naming or mapping mismatch before final asset approval.
- **Production limit:** The atlas approval does not make the current sheet
  pixels production sprites. Individual files still require deterministic
  recreation, normalized borders, filename verification, and small-size
  validation.

### D-019 — Central-HUD layout families

- **Status:** Style 1 approved as concept; Style 2 approved for final draft;
  Style 3 preliminarily approved with its chat-frame dependency satisfied
- **Date:** 2026-07-30
- **Source:** Xpie approval and revision direction
- **Shared construction:** Central-HUD layouts use a round minimap, modular
  hotbars, a wide experience/limit-point foundation, and independently
  configurable utility-family components in the established navy-and-brass
  visual system.
- **Style 1:** `central-hud-split-wings-concept-v1-1920x1080.png` is approved
  as the centered-minimap, split-hotbar layout family.
- **Style 2:** `central-hud-right-docked-concept-v1-1920x1080.png` is approved
  for the final draft. It uses two uninterrupted hotbar rows and docks the round
  minimap on the right. The player may reverse the dock to the left without
  changing fields, behavior, or available modules.
- **Style 3 proposal:**
  `central-hud-lower-right-console-concept-v1-1920x1080.png` places the same
  utility family inside a compact opaque lower-right console. Its backing is
  intentionally sized to cover native lower-right UI elements that cannot be
  suppressed and replaces the lower-right chat panel's masking role; it is not
  a chat display and contains no chat content. Xpie preliminarily approved this
  direction, and the related chat-frame concept review is now complete under
  D-020.
- **Modularity:** The minimap, hotbars, experience/limit-point bar, recasts, and
  utility launch points remain independently configurable. Styles 1 and 2 do
  not authorize one permanent opaque background plate around the entire group.
  Style 3 is the narrow exception because opaque coverage is its purpose.
- **Approval limit:** Style 1 concept approval, Style 2 final-draft approval,
  and the Style 3 proposal do not fix exact pixel dimensions, slot counts,
  labels, recast placement, utility buttons, production artwork, or the default
  layout preset.

### D-020 — Chat-frame layouts, heights, and opacity

- **Status:** Layout, behavior, and concept direction approved
- **Date:** 2026-07-30
- **Source:** Xpie direction
- **Dual layout:** Chat Window 1 occupies the lower-left corner. Chat Window 2
  occupies the lower-right corner as a horizontal mirror of Window 1. The
  windows use the same width, frame construction, typography, spacing, and
  controls.
- **Single layout:** The user may instead enable only the lower-left Chat
  Window 1 and use central-HUD Style 3 in the lower-right coverage position.
- **Exposed lines:** Each chat frame supports 8-, 12-, and 16-line choices.
  These are one component at three heights: changing exposed lines changes
  body height only. Width, header, border, corner treatment, ornament,
  typography, line spacing, inner padding, and controls remain unchanged.
- **Opacity:** Each chat frame supports user-controlled background opacity from
  0 through 100 percent inclusive. Default opacity is 100 percent/full opaque.
- **Native behavior:** Decorative chat frames do not replace native text entry,
  controller entry, auto-translate, tell history, or other native input
  behavior. Filtering and input reliability retain Q-009's technical gate.
- **Concept approval:** Xpie accepted the mirrored-dual,
  single-with-Style-3, and 8/12/16-height concept direction before proceeding
  to the party-frame review. Generated pixels remain reference artwork, not
  production assets.

### D-021 — Party and alliance frame concept family

- **Status:** Approved direction
- **Date:** 2026-07-30
- **Source:** Xpie's review of the three party/alliance concept proofs
- **Approved proof:** `alliance-frames-three-party-concept-v1-1920x1080.png`
  establishes three identical six-slot group stacks for Parties A, B, and C.
- **Rejected proofs:** The richer single-stack Proof 1 and compact 2×3 raid
  Proof 2 are rejected and retained only as concept history.
- **Shared configuration:** Party A is the canonical configuration template.
  Its party-frame options automatically apply to Parties B and C so all three
  group entities remain identical. Party-group labels have a user
  enable/disable toggle.
- **Selection:** The demonstrated narrow Bright Brass edge and restrained arrow
  are approved for the currently selected player.
- **Typography and capacity:** User font options must include font-size control.
  The production name-field width and any maximum displayed character count
  remain pending implementation testing against the longest currently
  available in-game Trust name. No fixed character limit is approved yet.
- **Configuration mode:** Show all three groups at full six-slot capacity for
  aesthetic and placement decisions. These entries are preview-only and must
  not be represented as live game state.
- **Gameplay visibility:** Show only the groups the unmodified game currently
  expects. Outside an alliance, Party A displays up to five other party members
  and omits the local player as redundant with the player frame. In an
  alliance, the active Party A/B/C frames display the available alliance
  roster, including the local player, up to the game's maximum available
  alliance membership.
- **Shared hierarchy:** HP is primary. MP and TP use thinner subordinate tracks.
  Name and main-job/subjob remain readable. Level numbers remain conditional on
  the field-level native-source review.
- **Status boundary:** Only the selected human local-party row may demonstrate
  small native-focus status icons without timers. Approval does not expand
  status visibility to every party or alliance member.
- **Exclusions:** No portraits, passive member-target data, distance,
  trust-level comparison, automation, or other rejected information.
- **Production limit:** Exact geometry, typography metrics, name capacity,
  values, status glyphs, production pixels, and minor module refinements remain
  implementation-time validation items. Direct user-initiated party targeting
  remains governed by Q-005.

## Gameplay-audit decisions and remaining questions

### Q-001 — Target-of-target authorization

- **Status:** Rejected
- **Date:** 2026-07-30
- **Source:** Xpie confirmation
- **Transferred ambiguity:** The original README baseline listed
  target-of-target as a planned module, but also made it conditional on the
  native-information boundary and left native availability open. The README now
  records the final rejection.
- **Decision:** Do not include a target-of-target component. A passive native
  equivalent with matching fields and timing was not established.

### Q-002 — Target casting

- **Status:** Rejected
- **Date:** 2026-07-30
- **Source:** Xpie confirmation
- **Issue:** The transferred baseline described target casting as supported, but
  the repository does not establish whether native FFXI reveals the same
  spell/action identity, progress, timing, and interruption state at the same
  precision. The README now records the final rejection.
- **Decision:** Do not display target spell/action identity, progress, timing,
  or interruption state. Player casting remains approved under D-006.

### Q-003 — Target-frame status effects

- **Status:** Approved
- **Date:** 2026-07-30
- **Source:** Xpie confirmation and boundary revision; official native
  status-party behavior; `statustimers` 4.3.0202 and XIUI 1.8.2 behavior
  references
- **Decision:** For a targeted, subtargeted, or one manually locked human party
  member, display the status icons the native game exposes, without duration
  countdowns. For the current enemy target, display icons and estimated timers
  for observed player-initiated debuffs and effects under D-014.
- **Exclusions:** Do not claim estimated enemy-target timers are native or
  authoritative. Do not display unobserved effects, enemy-originated effects,
  effect potency, or inferred tactical priority. The party-member treatment does
  not expand to NPCs, trusts, fellows, pets, or alliance members.
- **Reuse:** StatusTimers and XIUI are behavior references only. No source,
  icons, themes, duration tables, or other assets are incorporated by this
  decision.

### Q-004 — Trust identification and level comparison

- **Status:** Rejected
- **Date:** 2026-07-30
- **Source:** Xpie confirmation
- **Issue:** The transferred party priority included a trust-level difference
  treatment while reliable trust identification, level reporting, and native
  equivalence remained unverified. The README now records the final rejection.
- **Decision:** Do not identify or compare a trust's level in the core HUD.
  Ordinary party identity and otherwise approved native party fields are
  unaffected.

### Q-005 — Party member target, distance, and interaction

- **Status:** Approved
- **Date:** 2026-07-30
- **Source:** Xpie confirmation; official native party-targeting controls
- **Issue:** The transferred party design prioritized current target selection
  and optional distance while target-selection interaction and source
  availability remained open. The README now records the approved interaction
  and rejected passive fields separately.
- **Decision:** Clearly highlight the party/alliance row selected by the local
  player. Allow a mouse click or controller activation to select that roster
  member only as a direct, user-initiated equivalent of native targeting.
- **Exclusions:** Do not passively display another party member's target. Do not
  display numeric or continuous distance. Do not automate selection, choose a
  target, issue a command, or chain an action after selection.

### Q-006 — Status-tray presentation

- **Status:** Approved
- **Date:** 2026-07-30
- **Source:** Xpie confirmation; `statustimers` 4.3.0202 behavior reference
- **Decision:** Use icons with native-equivalent numeric countdowns for eligible
  player buffs and debuffs. Use compact bars for user-selected native recasts.
  Allow optional hybrid, color-swatch, and user-configured remaining-time
  threshold treatments.
- **Priority rule:** “Important” is defined only by explicit user pinning,
  filtering, or configuration. The addon must not infer tactical importance.
- **Target treatment:** Target, subtarget, and locked-party-member status icons
  follow Q-003 and do not receive duration countdowns. Current-enemy target
  effects follow the separate D-014 exception and use estimated timers.
- **Native-display suppression:** Suppress the native player status-icon display
  while the replacement tray is active because it is redundant. The method must
  be optional, reversible, version-validated, fail closed when signatures or
  state do not match, restore the native display on unload/error where possible,
  and have documented recovery steps. Approval is for the outcome, not for
  copying StatusTimers code.
- **Native-interaction preservation:** Recreate the native cancel interaction
  that suppression would otherwise remove. A deliberate right-click on a
  current local-player status may request cancellation only when the current
  game resource marks that status cancellable. Following the StatusTimers
  behavior reference, the implementation may send one native status-removal
  packet (`0x0F1`) for that selected status and that click.
- **Safety limits:** Cancellation applies only to the local player's displayed
  statuses. Do not make target, party-member, or estimated target-effect icons
  actionable. Do not cancel on hover or ordinary selection; bulk-cancel, queue,
  retry, repeat, automatic/contextual cancellation, and action chaining are
  prohibited. Revalidate cancellability at activation and fail without sending
  when the status is stale, absent, invalid, non-cancellable, or ambiguous.
  Suppression must not activate unless the replacement tray provides this
  interaction.
- **Reuse:** StatusTimers supplies the anticipated behavior only. Write original
  input handling and packet construction; do not copy its code or assets.

### Q-007 — Notification duplicate grouping

- **Status:** Approved
- **Date:** 2026-07-30
- **Source:** Xpie confirmation, option B
- **Decision:** Collapse only exact duplicates with the same native event type,
  source, and verbatim text when they arrive within two seconds. Present the
  retained line with a `×N` occurrence count.
- **Limits:** The two-second window is measured from the most recent matching
  event. A nonmatching line does not merge. Do not normalize wording, group
  semantically similar events, combine values, or derive summaries.

### Q-008 — Native gil messages in histories

- **Status:** Rejected
- **Date:** 2026-07-30
- **Source:** Xpie confirmation
- **Issue:** The transferred README allowed a native “obtained gil” event in
  chat/feed, described loot history as having “no gil values,” and forbade
  enhanced gil tracking. The README now distinguishes literal messages from
  tracking and aggregation, but message placement is still undecided.
- **Decision:** Literal native gil messages may appear transiently in native
  chat or the temporary feed only. Exclude them from on-demand history.
  Persistent totals, session aggregation, and enhanced tracking remain
  prohibited.

### Q-009 — Custom chat scope

- **Status:** Approved
- **Date:** 2026-07-30
- **Source:** Xpie confirmation; official native two-window log behavior
- **Decision:** Provide two scalable decorative log displays with independent
  native-category filters, presentation settings, and placement while retaining
  native text input.
- **Exclusions:** Do not replace controller text entry, auto-translate, tell
  history, or other native input behavior. Technical verification must prove
  that filtering and input remain reliable before implementation.

### Q-010 — Final visual system, scaling, and supported resolutions

- **Status:** Approved
- **Date:** 2026-07-30
- **Source:** Xpie confirmation
- **Decision:** Use a 1920×1080 canonical layout. Treat 1920×1080, 2560×1440,
  and 3840×2160 as initial validation targets. Scale uniformly from display
  height, use pixel snapping where needed, and provide a user scale override.
- **Limit:** Ultrawide and 16:10 layouts must remain anchor-compatible but are
  not supported until separately validated. Exact visual tokens remain a design
  deliverable, not an unresolved scope decision.

### Q-011 — Treasure pool, job-specific information, and EquipMon theming

- **Status:** Superseded
- **Date:** 2026-07-30
- **Decision:** Split into Q-011A, Q-011B, and Q-011C so each scope is decided
  independently.

### Q-011A — Treasure-pool presentation

- **Status:** Approved
- **Date:** 2026-07-30
- **Source:** Xpie confirmation
- **Decision:** Provide an optional, on-demand presentation that faithfully
  mirrors the currently available native treasure pool.
- **Exclusions:** No alerts, history, analytics, valuation, inventory context,
  prediction, or automated/manual lot or pass controls.

### Q-011B — Job-specific UI

- **Status:** Pending field definition
- **Date:** 2026-07-30
- **Source:** Xpie option C direction; XIUI 1.8.2 behavior reference
- **Approved direction:** Provide job-specific unit-frame elements or another
  job-specific on-screen indication where FFXI natively displays that
  information. Pet unit frames are the primary case.
- **Candidate scope, not yet approved field by field:** Beastmaster charm/jug
  pets, Summoner avatars, Puppetmaster automatons, and Dragoon wyverns. XIUI
  also demonstrates pet name/level, HP/MP/TP, distance, statuses, target, and
  job-command recasts; that reference does not approve those fields.
- **Required decision:** Define the included pet families, exact fields, native
  source and timing for each field, visibility rules, and whether any non-pet
  job indication is required. Numeric distance, pet-target data, inferred
  level, and non-native recast estimates remain excluded unless separately
  approved.

### Q-011C — EquipMon theme

- **Status:** Approved
- **Date:** 2026-07-30
- **Source:** Xpie confirmation
- **Decision:** Permit a separate optional EquipMon theme and placement/config
  preset after exact version, structure, license, provenance, compatibility,
  attribution, and reversibility review.
- **Limit:** The core addon and installer must not silently modify EquipMon or
  incorporate its code or assets without a separate reuse decision.

## Contradiction register

This register retains the transferred ambiguities even when their wording has
been aligned. “Editorially reconciled” means the documents now describe the
same gate; it does not approve the underlying feature or resolve the linked
question.

| ID | Status | Sources | Contradiction or ambiguity | Controlling treatment |
|---|---|---|---|---|
| C-001 | Resolved | README module table, roadmap, and open questions | Target-of-target appeared planned but was explicitly conditional and unverified. | Q-001 rejects the component. |
| C-002 | Resolved | `LICENSE` and README licensing wording | The repository contained the GPLv3 license text without a project-specific grant or version option. | Xpie approved `GPL-3.0-or-later` and `Copyright © 2026 Xpie`; `LICENSE-NOTICE.md` records the project grant. |
| C-003 | Resolved by explicit exception | README target-frame/timing descriptions and native-information rule | Target casting and target effects were presented without documented native equivalence or precision. | Q-002 rejects target casting. Q-003/D-014 explicitly approve only observed player-initiated target effects with estimated timers, while retaining native party-member icons without durations. |
| C-004 | Resolved | README party priorities and open questions | Trust level, party target, distance, and target interaction were prioritized while their data/behavior was unverified. | Q-004 rejects trust-level comparison. Q-005 approves only local selection highlighting and direct user-initiated targeting; passive member-target data and distance are rejected. |
| C-005 | Resolved | README notification allowance and loot-history wording | Literal native gil events are allowed, but “no gil values” made history placement ambiguous. | Q-008 limits literal gil messages to transient chat/feed and excludes them from history. |
| C-006 | Resolved | README installation template and repository state | README labeled `LICENSE` as wholly TBD even though a GPLv3 text file exists. | README and `LICENSE-NOTICE.md` now identify the `GPL-3.0-or-later` project grant. |
| C-007 | Resolved by explicit exception | D-001 native-information boundary and Q-003 target-effect requirement | Estimated enemy-target effects add knowledge and timing that native FFXI does not expose equivalently. | D-014 records Xpie's narrow exception, its source, risk, presentation, and invalidation limits; D-001 remains controlling elsewhere. |
| C-008 | Resolved by preserved native interaction | D-012 command-execution exclusion, Q-006 native-tray suppression, and native status cancellation | Suppressing the native status tray would remove its direct status-cancellation interaction, while the project generally excludes command execution. | Q-006 permits exactly one user-initiated native removal request for a currently cancellable local-player status. Automatic, bulk, target/party, queued, retried, or chained cancellation remains prohibited. |
| C-009 | Resolved for current concepts; source retained | Xpie visual-styling brief dated 2026-07-30 and Q-001/Q-002/Q-005/D-002 | The styling brief proposed target-of-target, target casting, numeric distance, and core equipment presentation after those fields had been rejected or separated from the core addon. | The binding decisions control. Concepts v1 and v2 omit target-of-target, target casting, numeric distance, and equipment. EquipMon remains a separate optional theme under Q-011C. The brief's non-conflicting palette and material language remain proposed, not approved. |
| C-010 | Resolved for current design direction | Original design conversation, visual-styling brief, README, and `DESIGN-SPEC.md` | The original conversation specifies a centered round minimap, while the later styling brief says the established minimap is rectangular. | The README and `DESIGN-SPEC.md` retain the round bottom-center minimap direction. The styling brief's rectangular-minimap statement is non-controlling unless Xpie records a later explicit change. |
| C-011 | Resolved for concept scope; implementation verification remains | Visual-styling brief and official FFXI Players Guide | The styling brief listed eight Check states and omitted Incredibly Easy Prey. | D-017 concept work covers all nine native states, including Incredibly Easy Prey. Implementation still requires verification of Ashita's exposed result values. |

## Decision-change procedure

For any decision that changes scope or the native-information boundary, record:

- date and status;
- player need and native equivalent;
- exact information source and timing;
- proposed presentation improvement;
- gameplay-advantage, persistence, precision, automation, and inference risks;
- effect on intentional friction;
- licensing/attribution concerns; and
- verification and acceptance criteria.

Do not delete superseded decisions; mark them superseded and link the replacement.
