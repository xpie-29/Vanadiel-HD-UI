# Vana'diel HD UI — References and Provenance

**Last updated:** 2026-07-31

This register distinguishes authoritative policy/technical sources from
inspiration-only projects. A listing here is not permission to copy code or
assets and does not imply affiliation or endorsement.

## 1. Project-source provenance

| Source | Role | Notes |
|---|---|---|
| Repository `README.md` at commit `9ff9984` | Primary transferred baseline | Only substantive design artifact found in Git history as of 2026-07-29. |
| User transfer instruction dated 2026-07-29 | Scope and preservation requirement | Explicitly names player frame, target frame, target of target, casting, status tray, party, notifications, inventory exclusions, and native-information boundary. It does not contain the missing detailed conversation transcript. |
| Xpie privacy instruction dated 2026-07-29 | Binding naming requirement | The project owner must be identified only as Xpie in all current and future project-related references. |
| Earlier ChatGPT design conversation | Reference-only source; reviewed from pasted transcript | Xpie supplied the transcript on 2026-07-30 for cross-checking visual assumptions only. It does not supersede any recorded decision. The extracted visual direction and concept-v2 changes are documented in `ORIGINAL-CHAT-VISUAL-CROSSCHECK.md`. |
| Xpie visual-styling brief dated 2026-07-30 | Proposed palette, materials, and component styling | Normalized into `docs/VISUAL-SYSTEM.md`. Conflicting target-of-target, target-casting, numeric-distance, and core-equipment proposals are governed by C-009 and omitted from concept v1. |
| `assets/concepts/combat-hud-visual-concept-v1-1920x1080.png` | Historical concept-only visual reference | Initial review concept generated without repository screenshots or third-party asset inputs. Retained to show the assumptions corrected after the original-chat review. |
| `assets/concepts/combat-hud-visual-concept-v2-1920x1080.png` | Historical concept-only visual reference | Edited from concept v1 using the corrections recorded in `ORIGINAL-CHAT-VISUAL-CROSSCHECK.md`. Retained for comparison with concept v3. |
| `assets/concepts/combat-hud-visual-concept-v3-1920x1080.png` | Style 1, preliminarily approved concept reference | Edited from concept v2 following D-015. It records approved visual qualities and relative refinements but remains concept art rather than production texture. |
| `assets/concepts/combat-hud-style-2-concept-v1-1920x1080.png` | Style 2, preliminarily approved concept reference | Edited from Style 1 with the built-in OpenAI image-generation tool following D-016. It removes outer plates and ornaments while retaining the approved inner containers; exact geometry and alpha remain non-production. |
| `assets/concepts/check-status-icon-family-concept-v1-1920x1080.png` | Approved-direction original Check icon family | Generated with the built-in OpenAI image-generation tool without native or third-party icon inputs. Covers nine native Check states; Xpie approved the bordered medallion construction for final-draft inclusion under D-017. Deterministic production recreation and small-size validation remain pending. |
| `assets/concepts/central-hud-split-wings-concept-v1-1920x1080.png` | Approved central-HUD Style 1 reference | Generated with the built-in OpenAI image-generation tool using the approved project concept family as visual references. Establishes the centered round-minimap and modular split-hotbar layout family under D-019; exact geometry, slot counts, labels, default selection, and production pixels remain unresolved. |
| `assets/concepts/central-hud-right-docked-concept-v1-1920x1080.png` | Approved central-HUD Style 2 reference | Edited from the approved Style 1 concept with the built-in OpenAI image-generation tool. Uses uninterrupted two-row hotbars and a right-docked round minimap whose dock is reversible to the left. Approved for the final draft under D-019. |
| `assets/concepts/central-hud-lower-right-console-concept-v1-1920x1080.png` | Preliminarily approved central-HUD Style 3 reference | Edited from approved Style 2 with the built-in OpenAI image-generation tool. Places the utility family in an opaque lower-right coverage console intended to mask unsuppressible native UI without becoming a chat display. Its related chat-frame concept dependency is satisfied under D-020; production geometry remains pending. |
| `assets/concepts/chat-frames-mirrored-dual-concept-v1-1920x1080.png` | Approved mirrored dual-chat concept direction | Generated with the built-in OpenAI image-generation tool using the approved project concept family as visual references. Shows matching fully opaque 12-line lower-left and mirrored lower-right frames. |
| `assets/concepts/chat-frame-single-with-central-hud-style-3-concept-v1-1920x1080.png` | Approved single-chat/Style-3 concept direction | Generated with the built-in OpenAI image-generation tool from the chat-frame direction and Style 3 concept. Shows the approved alternate configuration without a second chat window. |
| `assets/concepts/chat-frame-height-options-concept-v1-1920x1080.png` | Approved chat-height concept direction | Generated and refined with the built-in OpenAI image-generation tool. Compares one fixed-width chat construction at 8, 12, and 16 exposed lines with height as the sole frame variable. |
| `assets/concepts/party-frames-stacked-concept-v1-1920x1080.png` | Rejected party-frame Proof 1 | Generated with the built-in OpenAI image-generation tool using the approved project concept family as visual references. Retained only as concept history. |
| `assets/concepts/party-frames-raid-grid-concept-v1-1920x1080.png` | Rejected party-frame Proof 2 | Edited from the stacked proposal with the built-in OpenAI image-generation tool. Retained only as concept history. |
| `assets/concepts/alliance-frames-three-party-concept-v1-1920x1080.png` | Approved party/alliance Proof 3 direction | Edited from the compact party proposal with the built-in OpenAI image-generation tool. Establishes Parties A, B, and C as three identical six-slot stacks without expanding approved data availability. Production geometry and long-name capacity remain pending implementation testing. |
| `addon/VanadielHDUI/assets/placeholders/player_frame/pframe_bg.png` | Player Frame placeholder background asset | Original deterministic refinement placeholder generated locally on 2026-07-31 for sizing/layer validation. PNG, 594x340, concept-v3-inspired dark glass/brass frame with left ornament; not final production art. |
| `addon/VanadielHDUI/assets/placeholders/player_frame/pframe_bars.png` | Player Frame placeholder bar-track cluster asset | Original deterministic refinement placeholder generated locally on 2026-07-31 for sizing/layer validation. PNG, 464x184, includes fixed HP/MP/TP track cluster and integrated TP-pip socket region; not final production art. |
| `addon/VanadielHDUI/assets/placeholders/player_frame/pframe_tpactive.png` | Player Frame active TP-pip placeholder asset | Original deterministic refinement placeholder generated locally on 2026-07-31 for sizing/layer validation. PNG, 18x18, enlarged bright-blue jewel direction; not final production art. |
| `addon/VanadielHDUI/assets/placeholders/player_frame/pframe_tpinactive.png` | Player Frame inactive TP-pip placeholder asset | Original deterministic refinement placeholder generated locally on 2026-07-31 for sizing/layer validation. PNG, 18x18, enlarged inactive jewel direction; not final production art. |

## 2. Official policy and platform references

These references were checked on 2026-07-29. Policies and platform
documentation can change and must be rechecked before release.

| Reference | Use | Project treatment |
|---|---|---|
| [Square Enix — Use of 3rd Party Programs](https://support.na.square-enix.com/faqarticle.php?id=20&kid=12800) | Official FFXI third-party-program policy | States that third-party programs impacting gameplay are prohibited regardless of unfair advantage. The project's ethical boundary is not a claim of Terms-of-Use compliance. |
| [Square Enix — Prohibited Activities in FINAL FANTASY XI](https://support.na.square-enix.com/faqarticle.php?id=20&kid=78029) | Official rules and prohibited-activities reference | Review again before any public release. |
| [Ashita v4 documentation](https://docs.ashitaxi.com/) | Platform behavior and user/developer documentation | Primary technical reference for supported Ashita features and terminology. |
| [AshitaXI/Ashita-v4beta](https://github.com/AshitaXI/Ashita-v4beta) | Current public Ashita v4 beta distribution repository | Checked 2026-07-30. Its README identifies it as the current, most up-to-date publicly released v4 beta. Use with official documentation to verify platform/runtime behavior; do not copy files unless the exact file's license and intended reuse are reviewed. |
| [Ashita v4 commands](https://docs.ashitaxi.com/usage/commands/) | Verified addon load/unload command syntax | Use when installation documentation is tested. |
| [Ashita v4 configurations](https://docs.ashitaxi.com/usage/configurations/) | Configuration location and settings behavior | Use when profile/persistence design begins. |
| [AshitaXI example addon](https://github.com/AshitaXI/example) | Minimal official/community-maintained v4 addon structure reference | Behavior/API study only unless exact license and intended reuse are reviewed. Its addon notes document `addon.path` as the addon's root folder, used here only to locate project-local placeholder assets at runtime. |
| [Ashita v4 bundled `settings` library](https://github.com/AshitaXI/Ashita-v4beta/blob/main/addons/libs/settings.lua) | Current public load/save/reload/reset, callback, alias, and per-character-path behavior | API/behavior study only. The project wraps the installed library and does not copy its source. Checked 2026-07-30. |
| [Ashita v4 bundled `imgui` library](https://github.com/AshitaXI/Ashita-v4beta/blob/main/addons/libs/imgui.lua) | Current public ImGui color/style constants and scoped push/pop API | API/behavior study only. The project calls the installed binding and does not copy its source. Checked 2026-07-30. |
| [Ashita v4 bundled BluCheck addon](https://github.com/AshitaXI/Ashita-v4beta/tree/main/addons/blucheck) | Current public ImGui and `d3d_present` usage example | API/behavior study only. No source or UI structure copied. Checked 2026-07-30. |
| [Ashita v4 documentation and public examples](https://docs.ashitaxi.com/features/) | MemoryManager local player and party-wrapper behavior for name, job/subjob, HP, MP, and TP | API/behavior study only for the first Player Frame live slice. The addon calls the installed Ashita wrappers and does not copy Ashita source. Checked again 2026-07-31. |

Ashita's ability to expose chat, packets, memory, commands, or rendering does not
override the native-information boundary. Capability and product approval are
separate questions.

### Decision-audit evidence checked on 2026-07-30

| Reference | Native behavior established | Boundary consequence |
|---|---|---|
| [March 27, 2012 version update](https://forum.square-enix.com/ffxi/threads/22099) | F1–F6 target party members, F10–F12 target party/alliance roster positions, and a mouse click can target a PC, NPC, or object. | Supports a direct user-initiated targeting control, but not automated selection or passive display of another member's target. |
| [[dev1281] Quality of Life Improvements](https://forum.square-enix.com/ffxi/threads/47871) | Status icons are natively visible for targeted, sub-targeted, or focus-targeted human party members; alter egos, fellows, pets, and alliance members are excluded. | Does not authorize persistent all-party, trust, alliance, or enemy status displays. |
| [September 16, 2015 version update](https://forum.square-enix.com/ffxi/threads/48564) | Remaining duration is displayed for eligible status effects affecting the player, with native formatting and exclusions. | Supports player-status timers at native availability and precision only; it does not establish target or party duration equivalence. |
| [December 10, 2014 version update](https://forum.square-enix.com/ffxi/threads/45365) | Native FFXI supports two log windows, per-window log categories, sizing, and timestamps for named chat categories. | A custom chat proposal must preserve native input and should not claim that a two-window split is new game knowledge. |
| [March 2026 version update](https://forum.square-enix.com/ffxi/threads/63889) | The current Trust overhaul adds alter-ego-point stat upgrades, removes the filled-memory-gem level mechanism, and announces later alter-ego equipment. | Any trust comparison is version-sensitive and cannot rely on the transferred level-difference assumption. |
| [Ashita v4 features](https://docs.ashitaxi.com/features/) | Ashita can render custom UI, inspect game structures, work with chat output, and monitor, block, or inject input. | Confirms technical capability only. Input injection, memory access, or packet access does not establish product approval or native equivalence. |
| [FFXI Players Guide — Check states](https://forum.square-enix.com/ffxi/threads/61469-FFXI-Players-Guide?mode=threaded&p=658926) | Lists Too Weak to be Worthwhile, Incredibly Easy Prey, Easy Prey, Decent Challenge, Even Match, Tough, Very Tough, Incredibly Tough, and Impossible to Gauge. | Corrects the styling brief's omitted Incredibly Easy Prey state for concept coverage. Ashita value exposure still requires technical verification. |

## 3. Inspiration-only references

The README identifies the following as behavioral, layout, or aesthetic
references:

- XIUI
- EquipMon
- StatusTimers
- RecastPlus
- XIView
- XIPivot
- World of Warcraft raid-frame conventions
- OmniCC
- ElvUI
- Guild Wars 2
- Star Wars: The Old Republic

Default treatment for every item above:

- no source code or asset incorporation;
- no copied textures, icons, fonts, screenshots, or distinctive art;
- original implementation and visual assets;
- record the exact repository/product URL, version or commit, copyright owner,
  license, files used, modifications, and required notices before any reuse; and
- if the license or provenance is unclear, do not distribute the material.

## 4. Known project-specific reference notes

### StatusTimers

Xpie supplied a local `statustimers.zip` archive on 2026-07-30 for the Q-003
and Q-006 behavior review.

| Field | Reviewed value |
|---|---|
| Canonical project | [HealsCodes/statustimers](https://github.com/HealsCodes/statustimers) |
| Addon metadata | `statustimers` 4.3.0202 by Heals |
| Archive SHA-256 | `2B4474CC5BF55181D87BA7B64645104ECBA8DA138734A6A56EB9182ACFAD8E50` |
| Code notice | Copyright 2022–2026 Heals; GPL version 3 or later in source headers |
| Reviewed behavior | Player status icons/timers; targeted, subtargeted, and locked party-member status icons; configurable icon sizing, filters, colors, thresholds, and split bars; right-click cancellation only when the status resource reports `CanCancel`, using one outgoing `0x0F1` removal packet |
| Project use | Behavior reference only; no code or assets incorporated |

Q-006 uses the reviewed right-click/`CanCancel`/single-`0x0F1` flow as its
anticipated behavior because suppressing the native status tray would otherwise
remove an existing player interaction. This authorizes an original
implementation of that narrow behavior, not copied StatusTimers code. Q-006
also approves the outcome of reversibly suppressing redundant native player
status icons, subject to version validation, fail-closed behavior, restoration,
and recovery requirements. The bundled Tetsouou theme contains only a brief
credit line and no reviewed asset license; none of its images may be copied or
distributed by this project.

Xpie separately supplied the extracted theme archive at
`XIUI/assets/status/Tetsouou.zip` as the D-018 status-icon coverage reference.

| Field | Reviewed value |
|---|---|
| Origin discussion | [FFXIAH — Reworking Icons UI HD](https://www.ffxiah.com/forum/topic/58015/reworking-icons-ui-hd/) |
| Current release | [FFXI Icons HD v1.2](https://github.com/ejouanchicot/FfxiIconsHD/releases/tag/FFXI_Icons_HDv1.2), released 2025-05-18 at commit `30ff08bb116195fee023b08aac9766df112a96de` |
| Publisher identity | FFXIAH handle `Tetsouou`; the linked GitHub account now resolves to `ejouanchicot` |
| Archive SHA-256 | `6BC44B578B230927E762679B14D3AD3BAECCB0A258AE97DDD1B81306746B87FB` |
| Archive contents | 644 image files at 28–32 px; 567 unique file hashes and 77 exact duplicate aliases |
| Included notice | `credit to Tesouou on FFXIAH` only; no asset license was found in the archive |
| Thread permission | A 2025-05-14 post says the numbered PNG pack may be used and shared, but neither the thread nor the v1.2 tag provides formal license terms |
| Upstream provenance | The publisher says exact asset origins are difficult to track and credits KenshiDRK, RadialArcana, TeoTwawki, Ashenbubs, and the wider FFXI modding community |
| Consistency history | Users reported PNG/DAT mismatches in an earlier release; the publisher acknowledged them and the v1.2 release later claims full synchronization |
| Project use | Filename coverage, duplicate mapping, and semantic reference only |
| Project output | Original generated concept glyphs; no archive image is incorporated or distributed |

The informal sharing statement does not establish modification or
redistribution rights for every contributed or derivative asset. The
publisher's own incomplete-origin disclosure makes asset-level clearance
impossible from the available record. D-011 and D-018 therefore remain
controlling: retain credit for the reference and provenance trail, but do not
copy, adapt, bundle, or redistribute the supplied artwork. The complete review
and release-credit guidance are recorded in
`docs/STATUS-ICON-PROVENANCE-REVIEW.md`.

### XIUI

Xpie supplied a local `XIUI-1.8.2.zip` archive on 2026-07-30 for the Q-003
boundary revision and Q-011B pet-frame review.

| Field | Reviewed value |
|---|---|
| Canonical project named by addon metadata | [tirem/XIUI](https://github.com/tirem/XIUI) |
| Addon metadata | XIUI 1.8.2 by Team XIUI |
| Archive SHA-256 | `C0BD250AA5DDD7134D3C30512987BAE90C3990852D3BCAD4A8B54C243F5008A5` |
| Main-file notice | MIT License header; copyright 2023 tirem |
| Current upstream review | Checked 2026-07-30; public default branch `main`. The README documents a single Ashita v4 addon with in-game `/xiui` configuration and selectable features. The repository-level license is GNU GPL version 3. |
| Font/scaling behavior reviewed | At upstream commit `7d960b3bf47ea6979b3a580d97ce04e36829c0c9`, `XIUI/libs/imtext.lua` loads and caches font handles outside the per-frame render path, measures text at requested pixel sizes, and uses draw-list text calls with explicit font sizes. `XIUI/modules/partylist/display.lua` scales layout geometry separately and supplies configured font sizes to that text layer. |
| Texture behavior reviewed | Checked current public `XIUI/libs/texturemanager.lua` and `XIUI/libs/windowbackground.lua` on 2026-07-31 after Vana'diel HD UI's addon-local placeholder PNGs were found in game but not loaded through ImGui helper guesses. XIUI demonstrates the Ashita behavior pattern of loading file textures through the installed `d3d8` runtime and submitting texture pointers to ImGui draw lists. |
| Target-effect behavior reviewed | Reconstructs enemy effects from observed action/result messages, fixed or default duration estimates, wear-off/death messages, and zone clearing; target bar shows remaining estimates |
| Pet behavior reviewed | Separate Avatar, Charm, Jug, Automaton, and Wyvern configurations; demonstrates name/level, HP/MP/TP, distance, status, pet-target, and command-recast possibilities |
| Project use | Behavior reference only; no code, duration tables, submodules, or assets incorporated |

The archive contains independently sourced modules and a large asset set. A
MIT license header in the archived main file does not establish licensing or
provenance for every bundled file; the current upstream repository separately
labels the overall project GPL-3.0. It also contains functions outside this project's scope,
including enemy lists, inventory/gil tools, target casting, pet-target data,
distance, and analytics. None are authorized by the reference review. The
upstream check confirms the overall GPL-3.0 license and the one-addon, in-game
configuration pattern, but exact archive-to-upstream correspondence and
asset-by-asset provenance remain unverified. XIUI is therefore an
architecture/behavior reference only. Incorporation remains prohibited without
a separate file-specific intake decision, compatibility review, and
release-notice plan.

For D-022, the current public repository was checked only to confirm the
user-facing pattern described by its README: one Ashita v4 addon, an in-game
`/xiui` configuration surface, and selectable features. Vana'diel HD UI's
directory structure, lifecycle coordinator, module contract, event routing,
configuration schema, migrations, validation, preview adapters, and tests were
written independently and do not reproduce XIUI naming or implementation.

For D-025, the current upstream font and Party-list paths were reviewed only to
identify a working behavior pattern: initialize fonts outside the render
frame, use explicit text sizes for measurement/drawing, and scale geometry
separately. No source, outline routine, constants, font choices, or other
implementation detail was incorporated. Vana'diel HD UI's replacement remains
to be designed and written independently.

For D-028, the current upstream texture-manager and window-background paths
were reviewed only to identify the Ashita rendering behavior: custom PNGs are
loaded through the installed D3D8 binding and drawn through ImGui draw lists by
texture pointer. Vana'diel HD UI's placeholder assets, loader wrapper,
lifetime, diagnostics, and fallback renderer are original project code.

### EquipMon and other external addons

Support is limited to an optional matching theme/preset if the external addon's
structure and license allow it. Installation must be identified, optional,
reversible, version-specific, and must not silently overwrite another addon's
files. No supported version or reuse permission has been established.

### Native UI texture projects

XIView, XIPivot-delivered packages, native fonts, status graphics, cursors,
buttons, menu/window DAT changes, and chat textures require asset-by-asset
provenance. Technical replaceability is not redistribution permission.

## 5. Repository license

Xpie approved `GPL-3.0-or-later` and
`Copyright © 2026 Xpie` on 2026-07-30. The repository keeps the complete GNU
GPL version 3 text in `LICENSE`; `LICENSE-NOTICE.md` records the
project-specific grant and SPDX identifier.

Before release:

1. review compatibility for every dependency or incorporated work;
2. produce `THIRD-PARTY-NOTICES`; and
3. distinguish code licensing from original art/font/texture licensing where
   necessary.

## 6. Required third-party intake record

Before any third-party material is incorporated, record:

| Field | Required value |
|---|---|
| Project/material name | Exact name |
| Canonical URL | Repository or publisher URL |
| Version/commit | Immutable version where possible |
| Copyright owner | From source notice |
| License | Exact license and version |
| Material used | Specific files, code, or assets |
| Use type | Dependency, modified source, bundled asset, inspiration only |
| Modifications | Clear summary |
| Distribution location | Package path |
| Required notices | License/copyright/attribution text |
| Compatibility review | Reviewer, date, and conclusion |

Do not rely on a repository badge, search-result label, or assumption as the
final license review.
