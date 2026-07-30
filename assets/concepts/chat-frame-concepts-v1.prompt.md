# Chat frame concepts v1 prompt set

**Tool:** Built-in OpenAI image generation
**Use cases:** `ui-mockup`, `precise-object-edit`
**Date:** 2026-07-30
**Status:** Historical generation prompts; concept direction approved

## Shared direction

Use the established Vana'diel HD UI Midnight Void, navy, Aged Brass, Warm
Brass, sparse Bright Brass, and Warm Ivory visual family. Chat frames use a
thin external shadow and brass keyline, dark navy inner bevel, restrained
directional ornament, crisp sans-serif text, and a slim integrated header.

The runtime frame supports user opacity from 0–100 percent and defaults to
100 percent opaque. Native chat input, controller entry, auto-translate, and
tell history remain native and are not redrawn.

## Mirrored dual-chat proof

Create two equal 12-line chat frames over the split bright/dark gameplay
backdrop. Place `CHAT 1 — GENERAL` in the lower-left corner and
`CHAT 2 — COMBAT` in the lower-right as its true horizontal mirror. Keep equal
width, height, padding, line spacing, header, controls, border thickness, and
bottom safe margin. Use full opaque navy infill and short original placeholder
chat lines. Add no replacement input field.

## Single-chat plus Style 3 proof

Preserve the complete central-HUD Style 3 coverage console in the lower-right
corner. Add the same fully opaque 12-line `CHAT 1 — GENERAL` frame in the
lower-left corner, leaving a clear central gap. Do not add Chat Window 2. Match
the two modules' border weight, navy depth, brass brightness, typography
character, and bottom alignment without joining them into a full-width plate.

## Height-options proof

Place three instances of the same Chat Window 1 component side by side and
align their bottom edges. Label them `8 LINES`, `12 LINES`, and `16 LINES`.
Keep width, header, controls, border, ornament, typography, row height, line
spacing, top padding, and bottom padding identical. Only body height and the
integer number of visible rows change. The 12-line frame is four row increments
taller than the 8-line frame; the 16-line frame is four row increments taller
than the 12-line frame. Show exactly the named row count and avoid unused body
space below the final line.

## Exclusions

Do not include a replacement chat input, player/target/party frames, extra
central-HUD modules, equipment, inventory panels, gil, market data, enemy
lists, target-of-target, target casting, numeric distance, prediction,
recommendations, analytics, automation, portraits, logos, watermarks, copied
game UI, or third-party proprietary art.
