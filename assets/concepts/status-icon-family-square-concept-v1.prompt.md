# Status icon family square concept v1 — generation brief

**Use case:** `stylized-concept`

**Coverage reference:** Xpie-supplied `Tetsouou.zip`, used only to determine the
included filenames, semantic subjects, alternates, and exact duplicate aliases.
The source artwork is not incorporated.

**Controlling style reference:** The status-icon crop from the approved combat
HUD concept v3 supplied by Xpie on 2026-07-30.

## Prompt

Create one original Vana'diel HD UI status-icon concept for every occupied
source cell while preserving the supplied left-to-right, top-to-bottom coverage
order.

Each icon is a compact square tile, never a round medallion. Use a very thin,
understated Aged Brass keyline, tiny restrained corner details, a narrow dark
inner separator, and a subtle dark color-tinted background that complements the
central glyph. The field may use a quiet vertical or radial tonal gradient but
must remain subordinate to the glyph. Central glyphs should be crisp,
simplified, high contrast, distinguishable through color and silhouette, and
designed for later validation at 32×32 pixels.

Keep explicit stage or stack numbers only where they are part of the status
meaning. Prefer pictograms over abbreviations. Do not include timer values,
countdown text, filenames, catalog labels, titles, or watermarks in any icon.
Runtime timers will be rendered separately by the addon below the icon.

Create original glyph construction. Do not trace or copy FFXI, XIUI, Tetsouou,
or other third-party artwork. These images are concept references rather than
production sprites.

## Atlas method

- Pages 1–6 and 8–10 use exact 8×8 semantic matrices.
- Page 7 uses four exact 4×4 quadrants recombined into one audited 8×8 page
  because full-page generation repeatedly introduced an extra column.
- Page 11 is a four-icon horizontal strip for the archive's final four files.
- `status-icon-source-coverage-v1.csv` is the controlling filename-to-page/cell
  map and records exact binary duplicates.
