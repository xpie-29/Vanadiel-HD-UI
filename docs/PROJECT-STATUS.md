# Vana'diel HD UI — Project Status

**Phase:** Core architecture and configuration foundation validated in game
**Last updated:** 2026-07-30

**Implementation status:** Foundation validated; live gameplay modules not started

## Current outcome

The visual conception phase is complete. The first implementation phase is
also complete: the repository now contains an original Ashita v4 addon
foundation under `addon/VanadielHDUI`, the architecture record in
`docs/CORE-ARCHITECTURE.md`, and host-independent tests under `tests/`.

The foundation provides the verified Ashita lifecycle/event entry point,
central routing, an explicit module registry, independently toggleable
placeholder descriptors, fault isolation, a versioned configuration service,
Ashita settings persistence, validation/migration/recovery, an ImGui
configuration shell, reversible preview state, and global/per-module resets.
All gameplay descriptors request zero live-game capabilities and start
disabled. No finished gameplay collection or module rendering has been
implemented.

Xpie's 2026-07-30 in-game pass confirmed addon load/unload behavior, lifecycle
chat notices, responsive configuration controls, persistence across
configuration close/reopen and addon unload/reload, and the expected
`disabled`-to-`running` state change when enabling a placeholder. The exact
Ashita v4 build used for that pass has not been recorded. The configuration
shell now also has a scoped first-pass navy/brass/ivory theme; its exact values
remain subject to in-game visual review.

A follow-up checklist pass also confirmed preview-only labeling and absence of
live data, preview shutdown behavior, full-reset behavior, position/scale/
opacity/enabled persistence, and clean unload. Party A/B/C visual inspection
and shared label/font verification remain pending because the forced
placeholder positions overlap. Party-only reset isolation also remains
pending. These are incomplete checks, not observed failures.

The core preview layout editor is now implemented to unblock those visual
checks. While preview is active, each placeholder can be left-dragged.
Descriptor-declared multi-element modules can move independently or as a
group; Party A/B/C default to independent positioning. Group mode shifts a
shared base without discarding element offsets. Movement saves once on release
through the existing configuration service and cancels if preview ends before
release. This behavior has host-test coverage and awaits in-game
reverification.

The subsequent 16-item in-game pass confirmed items 1–10, 12, and 14–16.
Item 11 found that shared party-label visibility worked but title font size did
not change. Item 13 confirmed opacity, position, and persistence for passing
settings but found no visible enabled-placeholder lifecycle. Xpie subsequently
clarified that both module and global scaling also failed.

The attempted correction was reverted at Xpie's direction after a subsequent
in-game run regressed the otherwise stable foundation. Loading emitted a
font-scaling-disabled warning and showed the Player Frame preview before
preview was enabled. Disabling preview removed only some visible content and
left module remnants. Module/global scale changed window dimensions without
proportionately scaling text. The current build therefore returns to the
verified pre-experiment preview lifecycle and preserves the schema-v2
drag/editor work. Font size and coherent module/global scaling remain
unimplemented pending an original explicit-size text-rendering architecture.

## Resume point — core checkpoint (2026-07-30)

Resume from this committed checkpoint, not from the reverted scaling
experiment. The stable baseline has schema-version-2 configuration, generic
preview-only drag/edit positioning, Party A/B/C independent/group movement,
scoped configuration theming, and twelve passing LuaJIT smoke checks.

The next focused work item is an original preview text-and-scale rendering
layer. First verify the installed Ashita ImGui font and draw-list API, then
design a narrow abstraction that initializes approved fonts outside the
per-frame render path, measures and draws text at explicit pixel sizes, and
scales geometry and text together. Do not restore `SetWindowFontScale`,
window-only scale multiplication, or enabled-placeholder rendering outside
preview. Keep XIUI strictly as a behavior reference and preserve D-001 through
D-025, especially the native-information boundary.

After that layer exists, rerun the LuaJIT suite and perform a focused in-game
test of Party A/B/C shared title sizing, module/global proportional scaling,
preview-on/off cleanup, and the existing drag/persistence controls.

The authoritative design specification, decision record, project status,
reference register, concept artifacts, and contributor instructions preserve
the approved directions and remaining production-validation items.

At the start of the transfer, Git history contained only the initial README and
its expanded baseline. The raw earlier ChatGPT conversation was not present in
the repository, so the initial transfer preserved:

- every concrete requirement available in the README;
- the user's explicit instruction that player-frame, target-frame,
  target-of-target, casting, status-tray, party, notification,
  inventory-exclusion, and native-information-boundary decisions must remain
  represented; and
- uncertainty wherever the exact subsequent decision was not recoverable.

Xpie later supplied the earlier conversation as a reference-only transcript.
Its recovered visual context is summarized in
`docs/ORIGINAL-CHAT-VISUAL-CROSSCHECK.md`; the raw transcript is not distributed
in this repository and does not supersede recorded decisions.

On 2026-07-30, a follow-up reconciliation aligned the README's module table,
party/timing notes, verification checklist, loot-history wording, and license
file description with the controlling decision gates. This was an editorial
normalization only: no unresolved feature, data source, interaction, or license
choice was approved.

Also on 2026-07-30, Xpie supplied a detailed visual-styling brief. Its
non-conflicting palette and material language were normalized into
`docs/VISUAL-SYSTEM.md`, and an original concept-only combat HUD image was
created. After Xpie supplied the original design conversation, unsupported
concept-v1 assumptions were cross-checked and revised in concept v2. Xpie then
approved the core style, palette, typography, horizontal bar layout, and
inset-frame treatment and requested the D-015 refinements now shown in
`assets/concepts/combat-hud-visual-concept-v3-1920x1080.png`. C-009 and C-010
preserve conflicts between exploratory material and controlling decisions.
Exact production dimensions and alpha values remain unresolved.

Concept v3 is now preserved as preliminarily approved Style 1. Frameless Style
2 is preliminarily approved at
`assets/concepts/combat-hud-style-2-concept-v1-1920x1080.png`.

The original nine-state bordered Check-status icon family at
`assets/concepts/check-status-icon-family-concept-v1-1920x1080.png` is approved
for inclusion in the final draft. Both target-frame styles now require a Check
socket revision sized around the complete bordered medallion.

The first complete square status-icon concept covers all 644 filenames from the
Xpie-supplied Tetsouou archive across eleven atlas pages. D-018 fixes the square
tile, thin understated border, complementary subtle background, and
timer-as-separate-text direction. Xpie has approved the icons across all eleven
pages for inclusion in the final draft. They are not yet production sprites:
border inconsistencies between sheets must be normalized before individual
files are generated, and filename-to-design verification is deferred until
those individual files exist. The source thread and linked v1.2 release have
been audited: attribution is recorded, but incomplete upstream provenance and
the absence of formal license terms keep all source artwork reference-only.

The first center-utility concept is now available at
`assets/concepts/central-hud-split-wings-concept-v1-1920x1080.png`. It tests the
controlling round-minimap direction, modular split hotbar wings, and a wide
experience/limit-point foundation. Xpie approved it as central-HUD Style 1.
Recast strips and utility launch buttons remain exploratory, and the approval
does not establish production geometry or default configuration.

Central-HUD Style 2 is recorded at
`assets/concepts/central-hud-right-docked-concept-v1-1920x1080.png`. It uses
uninterrupted hotbar rows with the round minimap docked on the right; the dock
is required to be user-reversible to the left. Xpie approved Style 2 for the
final draft.

Central-HUD Style 3 is proposed at
`assets/concepts/central-hud-lower-right-console-concept-v1-1920x1080.png`. It
places the utility family inside an opaque lower-right console sized to mask
native UI elements that cannot be suppressed, replacing the lower-right chat
panel's coverage role without becoming a chat display. Xpie preliminarily
approved Style 3; its chat-frame concept dependency is now satisfied under
D-020.

The approved chat-frame concept direction shows the mirrored dual-window
12-line layout, the single lower-left frame paired with Style 3, and the common
8/12/16-line height system. D-020 fixes the layout choices, height-only line
count behavior, 0–100 percent opacity range, and 100-percent opaque default.
The generated pixels remain non-production reference artwork.

Party-frame Proofs 1 and 2 are rejected. D-021 approves Proof 3's three
identical six-slot Party A/B/C stacks, shared Party A configuration, optional
group labels, selected-player treatment, configuration-mode preview, and
conditional gameplay visibility. Geometry and longest-Trust-name capacity move
forward as implementation-time validation items.

## Completed in this phase

- [x] Repository and Git-history inventory.
- [x] README baseline extraction.
- [x] Governing document precedence and contributor guardrails.
- [x] Native-information and intentional-friction rules.
- [x] Player-frame direction.
- [x] Target-frame visual relationship.
- [x] Conditional target-of-target record.
- [x] Player/target casting separation and review gates.
- [x] Unified status/recast tray direction.
- [x] Party-first and alliance layout direction.
- [x] Notification and on-demand history boundaries.
- [x] Inventory and gil exclusions.
- [x] Project-owner privacy rule: use only the public name Xpie.
- [x] Contradiction register.
- [x] README reconciliation with controlling decision gates.
- [x] Gameplay-audit resolution pass for Q-001 through Q-011; Q-011B retains an
  approved direction but awaits field-level definition.
- [x] `statustimers` behavior/provenance review for Q-003 and Q-006.
- [x] Q-006 native cancellation-preservation scope and safety limits.
- [x] XIUI 1.8.2 behavior/provenance review for target-effect and pet-frame
  decision scoping.
- [x] Q-007 exact-duplicate grouping decision.
- [x] GPL-3.0-or-later project grant and copyright notice.
- [x] D-014 narrow target-effect boundary exception.
- [x] Reference and licensing register.
- [x] Proposed visual-system brief normalized without expanding gameplay scope.
- [x] First original combat-HUD concept sheet for visual review.
- [x] Original design-chat visual cross-check and corrected concept v2.
- [x] D-015 visual approvals and refined combat HUD concept v3.
- [x] Style 1 preservation and separate Style 2 comparison concept.
- [x] Preliminary Style 2 approval.
- [x] D-017 bordered Check icon family approved for the final draft.
- [x] D-018 square status-icon construction and complete 644-file concept
  coverage.
- [x] D-018 eleven-page status-icon family approved for the final draft.
- [x] Tetsouou/FFXI Icons HD thread, release, provenance, and legibility review.
- [x] First central-HUD split-wings concept proof.
- [x] Central-HUD Style 1 concept approval recorded.
- [x] Central-HUD right-docked Style 2 concept proof.
- [x] Central-HUD Style 2 approved for the final draft.
- [x] Central-HUD lower-right coverage-console Style 3 concept proof.
- [x] Central-HUD Style 3 preliminarily approved; chat-frame dependency
  satisfied.
- [x] Mirrored dual-chat and single-chat-with-Style-3 concept proofs.
- [x] Chat-frame 8/12/16-line height comparison.
- [x] D-020 chat layout, exposed-line, and opacity requirements recorded.
- [x] Stacked and compact six-member party-frame concept proofs.
- [x] Three-party 18-member alliance-frame concept proof.
- [x] Party-frame Proofs 1 and 2 rejected; Proof 3 approved as three identical
  Party A/B/C six-slot stacks.
- [x] Shared Party A configuration, label toggle, selection treatment,
  configuration preview, and gameplay visibility rules recorded.
- [x] Core addon structure/configuration-system starter prompt prepared for the
  implementation conversation.
- [x] D-022 core architecture and configuration decision.
- [x] Durable core architecture record.
- [x] Ashita v4 addon metadata, load/unload/command/`d3d_present` lifecycle,
  and deterministic event cleanup.
- [x] Explicit ordered module descriptors and narrow optional lifecycle
  contract.
- [x] Independent placeholder enable/disable with reverse shutdown and
  per-module runtime fault isolation.
- [x] Restricted module contexts with no live game-state capabilities in the
  foundation phase.
- [x] Schema-version-2 defaults and validation, version-0/1 migrations,
  descriptor-driven element layout, persistence, per-field recovery,
  future-version fail-closed recovery, and module/global resets.
- [x] Invalid settings-file preservation adapter around Ashita's bundled
  per-character settings library.
- [x] In-game ImGui configuration shell and session-only preview mode.
- [x] In-game foundation pass for load/unload, lifecycle notices, responsive
  controls, persistence, and placeholder enable-state transition.
- [x] Scoped navy/brass/ivory configuration-shell theme with balanced ImGui
  style restoration.
- [x] D-024 core preview drag/edit positioning with generic independent/group
  movement and atomic release-time persistence.
- [x] Party preview adapter for Party A/B/C at six slots each, with Party A
  settings ownership, label toggle, font-size control, and no fixed name limit.
- [x] Host-independent Lua smoke harness.
- [x] Twelve smoke checks passing under LuaJIT 2.1.1779665312: runtime
  compilation, defaults/round trip, migration, invalid/future recovery, resets,
  fault isolation, reverse cleanup, party preview lifecycle, and deterministic
  event cleanup, configuration-theme stack restoration, independent layout
  persistence, and generic module/element drag commits.

## Not started

- Live Ashita game-state/data-source adapters.
- Final visual tokens, exact component dimensions, or production mockups.
- Status-icon border normalization and individual-file generation.
- Post-export status-icon filename-to-design verification.
- Finished gameplay-module state management and production rendering.
- Production positioning behavior beyond the verified scaffold drag controls.
- Original font loading, measurement, and draw-list text abstraction that is
  initialized outside the render loop and supports explicit pixel sizes.
- Coherent module/global scaling that applies to geometry, spacing, icons, and
  text without relying on ImGui window-font scaling.
- Focused in-game retest of shared party title sizing and module/global scale
  behavior after that replacement architecture is implemented.
- Named profiles, resolution presets, and import/export.
- Native DAT/texture package.
- External-addon themes.
- Remaining party preview/shared-presentation and party-only-reset checks, plus
  the Ashita-version compatibility matrix.
- Installation, update, migration, and rollback validation.
- Release packaging and third-party notices.

## Requirements coverage

| Area | Preserved direction | Readiness |
|---|---|---|
| Player frame | Compact HP/MP/TP/identity anchor with integrated player casting | Design direction approved; details needed |
| Target frame | Complementary/mirrored frame; native party icons and estimated observed player-initiated enemy effects | Direction approved; D-014 technical prototype required |
| Target of target | Excluded | Rejected under Q-001 |
| Casting | Player casting integrated; target casting excluded | Approved/rejected split resolved |
| Status tray | Player-status icons, recast views, native-icon suppression, and direct cancellation of eligible local-player statuses | Presentation/interaction approved; suppression and one-request cancellation must be prototyped safely |
| Party/alliance | Three identical six-slot Party A/B/C stacks; Party A settings shared to B/C; configuration preview and conditional gameplay visibility | Direction approved; geometry and longest-Trust-name capacity require implementation testing; trust comparison, passive member target, and distance excluded |
| Notifications | Unified temporary feed with exact duplicates collapsed within two seconds as `×N` | Approved |
| Loot/synthesis histories | On-demand native-message records; gil excluded from history | Loot/gil boundary resolved; synthesis source unresolved |
| Treasure pool | Optional on-demand faithful native-pool mirror | Approved with analytics/actions excluded |
| Chat | Two decorative log displays with native input retained | Scope approved; technical verification required |
| Scaling | 1920×1080 canonical; 1080p, 1440p, and 4K validation targets | Approved |
| EquipMon | Separate optional theme/preset | Approved in principle; license/version intake required |
| Job/pet UI | Native job-specific unit-frame direction, primarily pets | Q-011B field list and sources pending |
| Inventory/gil | Tracking, capacity, values, and aggregation excluded | Approved and binding |
| Native-information boundary | Native equivalence required except the narrow D-014 target-effect exception | Approved and binding |

## Current blockers and decisions needed from Xpie

1. Define Q-011B's included pet families, exact fields, native sources,
   visibility rules, and any non-pet job indicators.
2. Identify and verify the synthesis-history native source.
3. Choose the first live module implementation after its native-source matrix
   and acceptance tests are approved.

## Recommended next work

1. Complete Q-011B's field-by-field definition.
2. Convert any supplied conversation excerpts or screenshots into dated decision
   records with provenance.
3. Create field-by-field native-source matrices for player, target,
   target-of-target, casts, statuses, party/alliance, and notifications.
4. Define component wireframes and interaction/state tables after the field
   matrices are approved.
5. Use the party module as the first live module after its field matrix,
   invalidation table, and in-game Ashita adapter checks are approved. Keep
   long-name capacity as a measured implementation result rather than a schema
   constant.
6. Specify design tokens, safe areas, scaling, and 1920×1080 reference layouts.
7. Write acceptance criteria and an in-game verification plan.

## Definition of ready for implementation

Implementation may begin only when Xpie explicitly authorizes it and the
selected component has:

- no controlling contradiction;
- approved fields and behaviors;
- a documented native source/equivalent or explicit approved exception;
- boundary and interaction review;
- visual/state specification;
- edge-case and invalidation rules; and
- acceptance tests.
