# Vana'diel HD UI — Project Status

**Phase:** Visual conception complete; core architecture handoff prepared
**Last updated:** 2026-07-30

**Implementation status:** Not started

## Current outcome

The visual conception phase is complete. The authoritative design
specification, decision record, project status, reference register, concept
artifacts, and contributor instructions now preserve the approved directions
and remaining production-validation items. No addon code, configuration,
runtime prototypes, or installation artifacts exist yet.

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

## Not started

- Addon architecture or code.
- Ashita API/data-source prototypes.
- Approved visual tokens, exact component dimensions, or production mockups.
- Status-icon border normalization and individual-file generation.
- Post-export status-icon filename-to-design verification.
- Rendering, state management, configuration, profiles, or edit mode.
- Native DAT/texture package.
- External-addon themes.
- Automated or in-game tests.
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
3. Decide which approved technical questions should be prototyped first once
   implementation work is explicitly authorized.

## Recommended next design work (no implementation)

1. Complete Q-011B's field-by-field definition.
2. Convert any supplied conversation excerpts or screenshots into dated decision
   records with provenance.
3. Create field-by-field native-source matrices for player, target,
   target-of-target, casts, statuses, party/alliance, and notifications.
4. Define component wireframes and interaction/state tables after the field
   matrices are approved.
5. Specify design tokens, safe areas, scaling, and 1920×1080 reference layouts.
6. Write acceptance criteria and an in-game verification plan.

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
