# Original design-chat visual cross-check

**Status:** Reference-only extraction
**Source supplied by:** Xpie
**Source date:** Conversation supplied on 2026-07-30
**Authority:** This source does not supersede `DECISIONS.md`,
`DESIGN-SPEC.md`, or later explicit decisions.

## Purpose

Xpie supplied the original conversation that led to the visual-styling brief so
unsupported assumptions in the first concept could be checked. This document
records only the portions relevant to visual direction. Earlier exploratory
feature lists remain historical proposals and do not restore rejected scope.

## Explicit visual direction recovered

- The player frame has no portrait.
- HP, MP, and TP sit inside one decorative frame. HP is approximately 10
  percent taller than MP and TP.
- Player resource text may be hidden or overlaid on a bar with left, center, or
  right alignment. HP and MP support current value, percentage, or current over
  maximum; TP needs only its current value.
- Three small pips beneath the lower-right of the player frame represent the
  1,000, 2,000, and 3,000 TP thresholds.
- Player identity sits outside and above the frame. The original direction used
  a left-aligned name and a right-aligned level on the same line.
- Numeric distance appeared in the exploratory conversation but is rejected by
  Q-005 and must not appear.
- The player frame has a restrained decorative element on its left. The target
  frame should read as its reversed visual counterpart.
- The target must not gain fabricated MP or TP information. Q-001 and Q-002
  continue to exclude target-of-target and target casting.
- A small Check-status icon belongs at the target frame's lower-left, visually
  balancing the player's lower-right TP pips.
- Target type is expressed through configurable target-name color only; the
  frame, background, and resource construction do not change by target type.
- Player buffs and debuffs are detached configurable trays, with debuffs above
  and buffs below the player frame by default.
- Cast bars were described as independently configurable and physically
  detached. For the approved player-cast treatment, this is compatible with
  D-006 when the detached bar remains directly adjacent and visually integrated
  with the player-frame family.
- The center HUD direction uses a round centered minimap with a wide experience
  bar beneath it and independently configurable hotbar layouts. This agrees
  with the README and `DESIGN-SPEC.md`; the later styling brief's rectangular
  minimap statement is non-controlling.

## Concept-v1 assumptions corrected in v2

| Concept-v1 assumption | Recovered direction | Concept-v2 treatment |
|---|---|---|
| Cast bar merged into player-frame border | Separate configurable cast element | Detached adjacent player cast bar |
| Invented `DRK 51/WAR 25` line | Name left and level right | `Doover` and `Lv. 99` on one identity line |
| Large gemstone TP markers | Three small dots/pips beneath lower-right | Small brass-and-enamel pips |
| Large target shield above HP | Check icon at target lower-left | Small lower-left heraldic emblem |
| Hostile target name used neutral text | Target type changes name color only | Hostile crimson name; frame remains unchanged |
| Target silhouette was merely adjacent in style | Reversed player-frame visual relationship | Reversed outer silhouette with one HP row only |

## Scope retained

The source also contains exploratory target-of-target, target-casting,
equipment, distance, and other ideas that later decisions rejected or separated
from the core addon. They remain excluded. No implementation is authorized by
this cross-check.
