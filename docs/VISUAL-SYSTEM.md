# Vana'diel HD UI — Proposed Visual System

**Status:** Proposed concept direction; not approved production specification
**Date:** 2026-07-30
**Authority:** `DECISIONS.md` and `DESIGN-SPEC.md` override this document.

This document normalizes the visual-styling brief supplied by Xpie for the
design phase. It records candidate tokens and concept-art guidance without
approving component fields, implementation behavior, or third-party reuse.

## Visual identity

The interface should feel like a polished high-resolution evolution of a
classic Vana'diel interface: atmospheric, mature, compact, slightly ornate, and
highly legible. The material language is dark stone, painted enamel, aged
brass, and restrained magical illumination.

Use thin brass edges, small beveled corners, restrained endcaps, subtle
geometric motifs, and limited directional ornament. Avoid large filigree,
thick fantasy scrollwork, oversized corner pieces, glossy surfaces, pervasive
glow, and ornament that reduces usable information space.

## Candidate palette

These values are working tokens for concept evaluation. They are not approved
production values. Future approved assets and in-game readability tests may
supersede them.

### Configuration-shell implementation

D-023 authorizes these candidate navy, brass, and text tokens as a reversible
first-pass theme for the in-game configuration shell. That narrow use does not
make the numeric values final production tokens. The shell must be reviewed in
game for contrast, control-state clarity, density, and consistency before the
values or geometry are treated as settled.

| Group | Token | Hex | Candidate use |
|---|---|---:|---|
| Structure | Midnight Void | `#070B13` | External shadows and deepest outlines |
| Structure | Abyss Navy | `#0B1320` | Frame interiors and darkest panels |
| Structure | Vana'diel Navy | `#111E2E` | Primary UI background |
| Structure | Elevated Navy | `#182A3D` | Raised surfaces and inner bevels |
| Structure | Steel Blue | `#263D52` | Separators, inactive tracks, secondary edges |
| Structure | Mist Blue | `#5E7890` | Subdued cool accents |
| Metal | Brass Shadow | `#3F311B` | Deep metallic edge shadow |
| Metal | Tarnished Brass | `#6F5427` | Recessed ornament and dark gold edge |
| Metal | Aged Brass | `#9A7535` | Primary metallic border |
| Metal | Warm Brass | `#C49A4A` | Active border accents |
| Metal | Bright Brass | `#E1BD69` | Selection, pips, narrow highlights |
| Metal | Brass Glint | `#F3D991` | Very limited specular highlight |
| Text | Warm Ivory | `#F1EAD8` | Primary text |
| Text | Pale Parchment | `#D9D1BD` | Secondary text |
| Text | Muted Silver | `#AAB2BA` | Lower-priority text |
| Text | Slate Gray | `#737E88` | Inactive labels |
| Text | Outline Black | `#05070A` | Text outline and strongest separation |
| Resource | HP Green | `#3F9B68` | HP fill |
| Resource | MP Blue | `#397FB3` | MP fill |
| Resource | TP Teal | `#32A5A0` | TP fill |
| State | Buff Green | `#55A56A` | Beneficial status accent |
| State | Debuff Crimson | `#B64B55` | Harmful status accent |
| State | Warning Amber | `#D4943F` | User-configured warning treatment |
| State | Critical Red | `#D14B4B` | Critical warning treatment only |

Bright Brass and Brass Glint should be scarce. Most structure should use Aged
Brass or Warm Brass so selection and illuminated indicators retain hierarchy.
Pure white should generally give way to Warm Ivory.

## Candidate surface and frame treatment

Suggested main-frame opacity is 88–94 percent. Detached panels may begin at
80–90 percent; large native-window infill may begin at 68–82 percent. D-020
supersedes the earlier chat-infill suggestion: decorative chat frames default
to 100 percent opaque and expose a complete user range from 0–100 percent.
Opacity changes should preserve the underlying hue.

Candidate frame stack at 100 percent scale:

1. one-pixel Midnight Void external shadow;
2. one- or two-pixel navy or dark-brass structural edge;
3. one-pixel Aged Brass border;
4. selective one-pixel Warm Brass highlight;
5. dark navy inner bevel;
6. Abyss Navy interior; and
7. a very subtle cool reflection on upward-facing inner edges.

All graphical proportions scale uniformly. Individual bars, borders, endcaps,
motifs, pips, and icons must not be independently stretched.

## Current concept component direction

- Player frame: portrait-free HP, MP, and TP bars; HP slightly taller; restrained
  left-side directionality; three small brass-and-enamel TP threshold pips
  integrated closely with the lower-right edge.
- Player identity: enlarged two-line area with the name first and
  `JOB LVL/SUBJOB LVL` beneath it. Level is not a separate element.
- Player casting: the cast name and inset framed duration bar float directly on
  the game view. There is no icon, outer background, or enclosing plate.
- Target frame: compact reversed outer silhouette; identity and
  native-equivalent HP only; no reserved MP or TP spaces; a small Check-status
  emblem in a round lower-left housing where the approved source permits it.
- Target identity: configurable target-type color affects the name only. Frame,
  HP, background, and ornament remain structurally unchanged by target type.
- Player statuses: detached icon trays using native-equivalent timers and the
  interaction limits in Q-006.
- Current-enemy effects: a detached or frame-adjacent tray using an unmistakable
  estimate marker and the complete D-014 invalidation rules.

The concept must not contain target-of-target, target casting, numeric distance,
inventory or gil data, equipment in the core HUD, enemy lists, predictions,
recommendations, or automation.

## Approved concept qualities

D-015 approves the following qualities as shown by the concept family:

- overall navy, brass, resource, and text color direction;
- clean sans-serif font style and demonstrated font colors;
- horizontal resource-bar layout; and
- inset frame construction around HP, MP, TP, and cast-duration bars.

Concept v3 also applies the approved approximate 20-percent reduction to
non-bar dark-blue frame infill and approximate 10-percent reductions to the
player-left and target-right ornaments. These are relative visual directions,
not final production alpha or pixel measurements.

## Combat-frame style families

### Style 1 — preliminarily approved

Style 1 is represented by
`assets/concepts/combat-hud-visual-concept-v3-1920x1080.png`. It retains the
translucent outer identity plates, reduced ornaments, unified inner resource
containers, floating cast presentation, and round target Check housing defined
by D-015.

### Style 2 — preliminarily approved

Style 2 is represented by
`assets/concepts/combat-hud-style-2-concept-v1-1920x1080.png`.

- Player and target identity text floats directly over the game view.
- Outer plates, outer perimeters, and directional ornaments are removed.
- The player retains one unified inner HP/MP/TP container.
- The target retains one inner HP container and the round Check medallion.
- Inner-container non-track blue is approximately 20 percent less opaque than
  Style 1.
- Inactive bar tracks remain opaque.
- Fonts, colors, inset frames, resource proportions, pips, cast treatment, and
  status/effect trays remain shared with Style 1.

Style 2 is preliminarily approved but is not production artwork. The two styles
must remain informational and behavioral equivalents.

## Check-status medallion family

The approved D-017 final-draft direction is recorded in
`assets/concepts/check-status-icon-family-concept-v1-1920x1080.png`.

All nine icons use the same circular Aged Brass bezel and dark enamel center.
They rely on both hue and silhouette:

| Check state | Proposed hue | Proposed geometry |
|---|---|---|
| Too Weak to be Worthwhile | Slate Gray `#737E88` | Broken/downward diamond |
| Incredibly Easy Prey | Pale muted mint | Nested downward chevrons and dot |
| Easy Prey | Buff Green `#55A56A` | Downward chevron enclosing a diamond |
| Decent Challenge | Cool blue `#78A9D1` | Nearly balanced split diamond |
| Even Match | Bright Brass `#E1BD69` | Balanced diamond and horizontal axis |
| Tough | Warning Amber `#D4943F` | Single upward chevron and diamond |
| Very Tough | Burnt orange `#C86B42` | Double upward chevrons |
| Incredibly Tough | Critical Red `#D14B4B` | Triple upward spear points |
| Impossible to Gauge | Muted violet `#9A72C7` | Fractured orbit and asymmetric diamond |

The family, including its bordered medallion construction, is approved for
inclusion in the final draft. The generated sheet remains a visual reference
rather than production pixels. Production work must test recognition at
intended HUD sizes, grayscale distinction, color-vision accessibility, and
contrast over both Style 1 and Style 2 target treatments.

### Border and target-frame integration

The outer Aged Brass ring belongs to each Check icon. Both target-frame styles
must enlarge or reshape their Check socket around the complete ring and retain
a narrow area of visual separation around it. The frame must not crop the
border, squeeze the medallion, or add another strong ring that reads as a
duplicate bezel. Style 1 and Style 2 should use a common medallion diameter and
socket geometry wherever practical.

## Status-icon family

D-018 establishes a separate construction for status icons:

- square tiles rather than Check medallions;
- a thin, understated Aged Brass keyline;
- tiny restrained corner details and a narrow dark inner separator;
- a subdued dark inset whose hue complements the central glyph;
- crisp simplified glyphs distinguished by color and silhouette; and
- no baked-in countdown or duration text.

The live addon places timer typography below the icon as a separate rendering
layer. The icon asset must remain complete and legible when no timer is shown.

The first full-coverage concept is recorded across
`assets/concepts/status-icon-family-square-concept-v1-page-01.png` through
`status-icon-family-square-concept-v1-page-11.png`. The controlling
filename-to-cell record is
`assets/concepts/status-icon-source-coverage-v1.csv`. The archive supplies 644
filenames, 567 unique file hashes, and 77 exact duplicate aliases. Exact
duplicate aliases may share one production visual, but every filename must
remain mapped.

The construction rules and all eleven concept atlases are approved for the
final draft. Generated glyphs must not be exported directly as addon textures.
Production work must first normalize border inconsistencies, recreate approved
glyphs deterministically as individual files, verify filename-to-design
mapping, validate them at 32×32 and intended scaled sizes, and test contrast,
grayscale distinction, and common color-vision deficiencies.

## Typography direction

Use a clean readable sans serif similar in character to Trebuchet MS, subject
to font availability and licensing review. Candidate text uses Warm Ivory,
subtle dark outlining, safe edge padding, and crisp pixel-aligned placement.
Gameplay values must not use decorative fantasy lettering.

## Chat-frame family

D-020 establishes one fixed-width chat-frame construction at three exposed
heights: 8, 12, and 16 text lines. Only body height changes. Header, borders,
corners, directional ornament, typography, row spacing, padding, and controls
remain fixed.

The default dual layout places Chat Window 1 at lower left and its mirrored
Chat Window 2 at lower right. The alternate coverage layout pairs one
lower-left Chat Window 1 with central-HUD Style 3 on the right. Chat backgrounds
default to 100 percent opaque and allow user control from 0–100 percent. The
visual frame does not add a replacement text-entry field.

## Concept artifact

`assets/concepts/combat-hud-visual-concept-v3-1920x1080.png` is the preserved
Style 1 review copy. `assets/concepts/combat-hud-style-2-concept-v1-1920x1080.png`
is the current Style 2 review copy. Generator sources and earlier concepts
remain available for comparison.

It is not approved production art, does not establish exact geometry or font
metrics, and must not be exported directly as addon textures. Production assets
must be rebuilt deterministically with exact dimensions, crisp transparency,
consistent pixel edges, and no generated lettering or copied third-party art.

## Review questions

Before promoting any part of this concept:

1. Is the brass border too bright or visually heavy?
2. Is the main navy surface sufficiently legible in both bright and dark scenes?
3. Does the reversed target silhouette feel related without implying
   unavailable player-resource symmetry?
4. Does the detached cast bar remain visually integrated while preserving
   enough negative space to read as independently configurable?
5. Are TP pips clear without resembling generic pasted-on circles?
6. Are estimated enemy-effect timers unmistakably non-authoritative?
7. Should the final direction reduce ornament further before exact wireframes?
