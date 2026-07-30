# Status-Icon Source Provenance Review

**Reviewed:** 2026-07-30
**Reviewer:** Codex for Xpie
**Project treatment:** Reference and coverage evidence only

## Scope

This review covers the origin information Xpie supplied for the D-018 status
icon reference:

- [FFXIAH — Reworking Icons UI HD](https://www.ffxiah.com/forum/topic/58015/reworking-icons-ui-hd/)
- [FFXI Icons HD v1.2 release](https://github.com/ejouanchicot/FfxiIconsHD/releases/tag/FFXI_Icons_HDv1.2)
- the locally supplied `XIUI/assets/status/Tetsouou.zip`, identified in
  `docs/REFERENCES.md` by SHA-256

The FFXIAH author uses the handle `Tetsouou`. The thread's GitHub links now
resolve to the account `ejouanchicot`. This records the observed public
identities without asserting that every asset in the pack was authored by the
same person.

## Findings

### Authorship and upstream sources

The publisher describes the pack as a substantial redraw and refresh of FFXI
icons, while also stating that the exact origin of every asset is difficult to
track. The thread credits KenshiDRK, RadialArcana, TeoTwawki, Ashenbubs, and
the wider FFXI modding community.

That disclosure is useful attribution evidence, but it prevents an
asset-by-asset authorship or rights determination. The pack may contain
derivative visual material or high-resolution source textures whose individual
terms are not identified.

### Permission and license

A 2025-05-14 thread post says, “Feel free to use and share!” This is evidence
that the publisher intended the numbered PNG package to circulate. It is not a
formal license and does not state modification terms, commercial terms,
sublicensing conditions, required notices, or whether the publisher had the
right to license every upstream element.

The reviewed v1.2 GitHub tag contains the packaged archive but no LICENSE file
or other complete rights grant. Therefore:

- credit is necessary for provenance but is not a substitute for permission;
- the thread does not clear every asset for adaptation or redistribution; and
- Vana'diel HD UI must not copy, modify, bundle, or redistribute these images.

### Version consistency

The thread records a user report that some earlier numbered PNGs did not match
the DAT presentation for Bard songs and Corsair rolls. The publisher
acknowledged that older DAT and newer PNG work had diverged. A later update and
the v1.2 release claim PNG/DAT synchronization.

The local archive is controlled by its recorded hash rather than an assumed
equivalence to the GitHub v1.2 package. Its filenames remain valid as the
project's expressly supplied coverage set; no visual or binary identity with
v1.2 is inferred.

### Readability and accessibility

Thread feedback identifies a real small-icon risk: additional layers,
gradients, smoothing, and fine details can make icons slower to distinguish,
especially for users with limited vision. The v1.2 release separately states
that readability was optimized at 32×32 px.

This supports, but does not replace, Xpie's approved visual direction. D-018
therefore requires actual-size validation in which:

- the primary silhouette is simple and crisp;
- color and geometry both communicate the state;
- subtle backgrounds and borders remain subordinate to the glyph; and
- fine detail or gradients are never the only differentiator.

## Project consequence

The existing concept-proof treatment remains appropriate:

- use the archive only for filename coverage, exact-duplicate mapping, and
  semantic subject reference;
- keep all generated and production artwork original;
- retain this provenance record and source credit in project documentation;
- do not place a third-party asset notice in a release unless material is
  actually incorporated; and
- if incorporation is proposed later, stop and perform asset-level permission,
  provenance, license-compatibility, and notice review first.

No D-018 visual approval is revoked by this review. The source artwork remains
excluded, and the 32×32 legibility test is now an explicit production gate.
