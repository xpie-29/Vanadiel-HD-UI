# Vana'diel HD UI — References and Provenance

**Last updated:** 2026-07-29

This register distinguishes authoritative policy/technical sources from
inspiration-only projects. A listing here is not permission to copy code or
assets and does not imply affiliation or endorsement.

## 1. Project-source provenance

| Source | Role | Notes |
|---|---|---|
| Repository `README.md` at commit `9ff9984` | Primary transferred baseline | Only substantive design artifact found in Git history as of 2026-07-29. |
| User transfer instruction dated 2026-07-29 | Scope and preservation requirement | Explicitly names player frame, target frame, target of target, casting, status tray, party, notifications, inventory exclusions, and native-information boundary. It does not contain the missing detailed conversation transcript. |
| Xpie privacy instruction dated 2026-07-29 | Binding naming requirement | The project owner must be identified only as Xpie in all current and future project-related references. |
| Earlier ChatGPT design conversation | Unavailable source | Not present in the repository. Any future excerpts should be recorded with date, provenance, and whether Xpie approves them. |

## 2. Official policy and platform references

These references were checked on 2026-07-29. Policies and platform
documentation can change and must be rechecked before release.

| Reference | Use | Project treatment |
|---|---|---|
| [Square Enix — Use of 3rd Party Programs](https://support.na.square-enix.com/faqarticle.php?id=20&kid=12800) | Official FFXI third-party-program policy | States that third-party programs impacting gameplay are prohibited regardless of unfair advantage. The project's ethical boundary is not a claim of Terms-of-Use compliance. |
| [Square Enix — Prohibited Activities in FINAL FANTASY XI](https://support.na.square-enix.com/faqarticle.php?id=20&kid=78029) | Official rules and prohibited-activities reference | Review again before any public release. |
| [Ashita v4 documentation](https://docs.ashitaxi.com/) | Platform behavior and user/developer documentation | Primary technical reference for supported Ashita features and terminology. |
| [Ashita v4 commands](https://docs.ashitaxi.com/usage/commands/) | Verified addon load/unload command syntax | Use when installation documentation is tested. |
| [Ashita v4 configurations](https://docs.ashitaxi.com/usage/configurations/) | Configuration location and settings behavior | Use when profile/persistence design begins. |
| [AshitaXI example addon](https://github.com/AshitaXI/example) | Minimal official/community-maintained v4 addon structure reference | Behavior/API study only unless exact license and intended reuse are reviewed. |

Ashita's ability to expose chat, packets, memory, commands, or rendering does not
override the native-information boundary. Capability and product approval are
separate questions.

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

### XIUI

The README permits studying XIUI for behavior and interface patterns, not
unreviewed copying. A current search identifies the public repository as
[tirem/HXUI (XIUI)](https://github.com/tirem/HXUI) and reports GPL-3.0, but the
exact commit, license file, asset provenance, and compatibility with the
project's final license must be reviewed before incorporating anything.

### EquipMon and other external addons

Support is limited to an optional matching theme/preset if the external addon's
structure and license allow it. Installation must be identified, optional,
reversible, version-specific, and must not silently overwrite another addon's
files. No supported version or reuse permission has been established.

### Native UI texture projects

XIView, XIPivot-delivered packages, native fonts, status graphics, cursors,
buttons, menu/window DAT changes, and chat textures require asset-by-asset
provenance. Technical replaceability is not redistribution permission.

## 5. Repository license issue

The repository contains the GNU General Public License version 3 text in
`LICENSE`, but the README still says the final project/release license is an open
question. The current file does not provide a project-specific copyright notice
or resolve whether the intent is GPLv3-only or GPLv3-or-later.

Treat the repository license intent as unresolved until Xpie confirms it.
Before release:

1. confirm the governing license and version option;
2. add the appropriate project copyright/license notice;
3. review compatibility for every dependency or incorporated work;
4. produce `THIRD-PARTY-NOTICES`; and
5. distinguish code licensing from original art/font/texture licensing where
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
