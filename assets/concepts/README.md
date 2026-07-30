# Combat HUD visual concept

`combat-hud-visual-concept-v3-1920x1080.png` is preserved as **Style 1** with
preliminary approval. It applies Xpie's approved style decisions and requested
player/target refinements to concept v2. Its original generator output is
retained as `combat-hud-visual-concept-v3.png`.

`combat-hud-style-2-concept-v1-1920x1080.png` is the current **Style 2**
proposal. It removes the outer player/target plates and ornaments while keeping
the approved functional inner containers. Its generator output is retained as
`combat-hud-style-2-concept-v1.png`.

`check-status-icon-family-concept-v1-1920x1080.png` is the approved-direction
original Check-status medallion family for the final draft. It includes all nine
native Check states and uses both color and internal geometry. Its complete
bordered construction is preferred; both target-frame styles must revise their
Check sockets to accommodate that border without clipping or a duplicate bezel.
Its generator output is retained as
`check-status-icon-family-concept-v1.png`.

`status-icon-family-square-concept-v1-page-01.png` through
`status-icon-family-square-concept-v1-page-11.png` form the complete
final-draft-approved status-icon concept atlas under D-018. They use the
concept-v3 square tile, thin restrained border, and subtle complementary
background treatment. Timer text is intentionally absent because the addon
will render it separately below the icon. Border construction varies between
some sheets and must be normalized to one deterministic template before
individual icon files are generated.

`status-icon-source-coverage-v1.csv` maps every one of the 644 supplied archive
filenames to an atlas page and cell and identifies 77 exact duplicate aliases
across 567 unique file hashes. The supplied Tetsouou artwork was used only to
determine coverage and semantic subject; none of its images are included here.
Individual generated glyphs remain proposed and must be recreated
deterministically for production. Once individual icon files exist, each
depicted design must be compared with its source filename and coverage-map
entry; naming or mapping corrections are required before final asset approval.

`central-hud-split-wings-concept-v1-1920x1080.png` is the first bottom-center
HUD proof and is approved as **central-HUD Style 1**. It uses a round centered
minimap anchor, two-row split hotbar wings, a wide experience/limit-point
foundation, detachable recast strips, and small on-demand utility launch
points. Approval establishes the layout family and visual direction, not exact
dimensions, slot counts, labels, default placement, or production pixels. Its
unscaled generator output is retained as
`central-hud-split-wings-concept-v1.png`.

`central-hud-right-docked-concept-v1-1920x1080.png` is the proposed
**central-HUD Style 2** proof and is approved for the final draft. It combines
the hotbars into two uninterrupted rows and docks the round minimap at the
right edge. The dock must be horizontally reversible so a user can place the
minimap on the left. Its unscaled generator output is retained as
`central-hud-right-docked-concept-v1.png`.

`central-hud-lower-right-console-concept-v1-1920x1080.png` is the proposed
**central-HUD Style 3** review proof. It moves the same utility family into a
compact opaque lower-right console intended to cover native UI elements that
cannot be suppressed and to replace the lower-right chat panel's masking role.
It does not replace chat behavior or add chat content. Style 3 is pending Xpie
final approval after preliminary approval; its related chat-frame concept
dependency is satisfied under D-020. Its unscaled generator output is retained as
`central-hud-lower-right-console-concept-v1.png`.

The chat-frame v1 package contains:

- `chat-frames-mirrored-dual-concept-v1-1920x1080.png`, showing matching
  12-line lower-left and mirrored lower-right chat frames;
- `chat-frame-single-with-central-hud-style-3-concept-v1-1920x1080.png`,
  showing the alternate single lower-left chat frame paired with Style 3; and
- `chat-frame-height-options-concept-v1-1920x1080.png`, comparing the same
  frame at 8, 12, and 16 exposed lines.

The chat concepts show the required 100-percent opaque default. Runtime opacity
is user controlled from 0–100 percent. The line-count options alter height only;
width, border, header, typography, controls, spacing, and ornament remain one
shared construction. Xpie accepted the concept direction; the generated pixels
remain non-production reference artwork.

The party-frame v1 review concluded:

- `party-frames-stacked-concept-v1-1920x1080.png` is rejected Proof 1 and is
  retained only as concept history;
- `party-frames-raid-grid-concept-v1-1920x1080.png`, the same six members in a
  compact healer/support 2×3 grid, is rejected Proof 2 and retained only as
  concept history; and
- `alliance-frames-three-party-concept-v1-1920x1080.png` is the approved Proof 3
  direction, using three identical six-slot stacks for Parties A, B, and C.

Proof 3 prioritizes HP, subordinate MP and TP, retains job/subjob abbreviations,
and uses the approved narrow brass edge/arrow selection treatment. Status icons
appear only on the selected human local-party member used to demonstrate the
approved native-focus boundary. Exact geometry, font metrics, long-name
capacity, and production artwork remain implementation-time work.

Concepts v1 and v2 and their generator sources remain in this directory as
historical comparison artifacts.

Provenance and treatment:

- generated with the built-in OpenAI image-generation tool;
- no repository screenshot or third-party asset was used as an input;
- the fantasy gameplay backdrops and interface icon artwork are original
  generated references;
- target-of-target, target casting, numeric distance, equipment, inventory,
  gil, and other excluded fields were intentionally omitted; and
- the image must not be used as a production texture. Rebuild approved assets
  deterministically after visual review.

Exact edit prompts are recorded beside each concept. Candidate tokens, style
definitions, and review questions are recorded in `docs/VISUAL-SYSTEM.md`.
