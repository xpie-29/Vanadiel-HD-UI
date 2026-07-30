# Vana'diel HD UI — Project Status

**Phase:** Design transfer and gameplay audit  
**Last updated:** 2026-07-29  
**Implementation status:** Not started

## Current outcome

The repository has been inspected and the README baseline has been normalized
into an authoritative design specification, decision record, project status,
reference register, and contributor instructions. No addon code, textures,
configuration, prototypes, or installation artifacts exist yet, and no
implementation was started during this transfer.

Git history contains only the initial README and its expanded baseline. The
earlier ChatGPT conversation itself, mockups, screenshots, and later detailed
notes are not present in the repository. Therefore the transfer preserves:

- every concrete requirement available in the README;
- the user's explicit instruction that player-frame, target-frame,
  target-of-target, casting, status-tray, party, notification,
  inventory-exclusion, and native-information-boundary decisions must remain
  represented; and
- uncertainty wherever the exact subsequent decision was not recoverable.

The documents do not pretend that missing detail was recovered.

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
- [x] Reference and licensing register.

## Not started

- Addon architecture or code.
- Ashita API/data-source prototypes.
- Visual tokens, component dimensions, or production mockups.
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
| Target frame | Complementary/mirrored combat frame | Visual direction approved; data fields need review |
| Target of target | Reserved relationship component | Blocked on native-information decision |
| Casting | Player casting integrated; target casting conditional | Player direction approved; target data blocked |
| Status tray | Unified player-status and recast system | Direction approved; layouts/data precision unresolved |
| Party/alliance | Primary combat display; stacked and raid-style families | Direction approved; several fields/interactions blocked |
| Notifications | Unified temporary feed with strict metadata limits | Direction approved; grouping details unresolved |
| Loot/synthesis histories | On-demand native-message records | Direction approved; sources/edge cases unresolved |
| Inventory/gil | Tracking, capacity, values, and aggregation excluded | Approved and binding |
| Native-information boundary | Native equivalence required field by field | Approved and binding |

## Current blockers and decisions needed from Xpie

1. Confirm whether target-of-target is approved in principle but gated, or still
   only a candidate.
2. Supply or restate any detailed player/target/cast/status/party/notification
   decisions from the earlier conversation that go beyond the README. These
   cannot be reconstructed from the repository.
3. Confirm the intended project license: GPLv3 only, GPLv3-or-later, or another
   choice, and identify the project copyright holder/notice.
4. Decide which unresolved technical/native-information questions should be
   prototyped first once implementation work is authorized.
5. Select or approve the visual-token and supported-resolution design pass.

## Recommended next design work (no implementation)

1. Reconcile the contradiction register with Xpie.
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
- a documented native source/equivalent;
- boundary and interaction review;
- visual/state specification;
- edge-case and invalidation rules; and
- acceptance tests.
