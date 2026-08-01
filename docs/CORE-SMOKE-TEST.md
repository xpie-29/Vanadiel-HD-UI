# Core Foundation Smoke Test

**Last run:** 2026-08-01

**Runtime:** LuaJIT 2.1.1779665312

**Scope:** Host-independent core behavior; no FFXI or Ashita process required

## Automated run

Use a LuaJIT/MoonJIT-compatible interpreter:

```powershell
.\tests\smoke.ps1 -Lua <path-to-luajit-or-lua>
```

The test entry point is `tests/run.lua`. On 2026-08-01 it was executed with
LuaJIT 2.1.1779665312 installed through Scoop. It was also executed with the
transient Fengari CLI as an independent Lua parser/runtime check.

Result:

```text
[PASS] all runtime Lua files compile
[PASS] addon asset root path normalizes trailing slash
[PASS] configuration defaults round trip
[PASS] legacy schema migrates before validation
[PASS] invalid fields recover independently
[PASS] future schema fails closed to defaults
[PASS] module and global resets are isolated
[PASS] multi-element layout positions and movement mode persist independently
[PASS] module failure is isolated and cleanup is reverse ordered
[PASS] local player capability exposes approved player frame fields
[PASS] local player capability prefers local party slot vitals
[PASS] player frame module normalizes job text and bounded vitals
[PASS] presentation draws configured font outline around explicit-size text
[PASS] player frame live renderer applies font, alignment, TP pips, and graphics
[PASS] player frame renderer uses production image assets when available
[PASS] player frame chrome flags can come from Ashita imgui table
[PASS] player frame renderer passes D3D texture pointers to AddImage
[PASS] player frame asset diagnostics include missing png paths
[PASS] preview initializes disabled party without persisting enablement
[PASS] event router registration and cleanup are deterministic
[PASS] configuration theme restores scoped ImGui style state
[PASS] single-style modules do not show style selector
[PASS] player frame does not show anchor selector
[PASS] layout editor commits generic module or element targets once on release
[PASS] preview rendering composes global and module opacity
[PASS] preview rendering composes global and module scale into window size
[PASS] party preview font size applies across all preview groups

27 test(s), 0 failure(s)
```

This run does not by itself prove Ashita binary compatibility or in-game ImGui
behavior. The reported in-game pass below covers the listed foundation
behaviors; the exact Ashita v4 build remains to be recorded.

## In-game foundation pass

Xpie reported a partial in-game acceptance pass from an installed Ashita v4
environment on 2026-07-30. The exact Ashita build remains to be recorded.

| Check | Result |
|---|---|
| Addon loads | Passed |
| Foundation-loaded notice identifies gameplay modules as placeholders | Passed |
| `/vhd` opens the configuration shell | Passed |
| Clicking Preview mode does not fault the addon or modules | Passed |
| Enabling a placeholder changes `disabled` to `running` | Passed in the earlier pass |
| Disabling the placeholder returns it to `disabled` | Passed |
| `/vhd preview on` shows only preview-labeled, non-live data | Passed |
| Independent mode moves only the selected declared element | Passed |
| Group mode moves every declared element by the same delta | Passed |
| Party A/B/C and six slots per group are unobscured and visually verifiable | Passed |
| Party group-label visibility applies to all three shared groups | Passed |
| Party title font-size changes apply to all three shared groups | Passed |
| `/vhd preview off` clears previews and retains disabled state | Passed |
| Position and opacity controls work and persist across unload/reload | Passed |
| Module scale changes rendered module size | Passed |
| Global scale changes every rendered module size | Passed |
| Enabled placeholder appears outside preview and disappears when disabled | Not applicable; no non-preview scaffold surface is designed for the current core phase |
| Passing setting values persist across unload/reload | Passed |
| `/vhd reset module party` resets only the party block | Passed |
| `/vhd reset all` resets scaffold settings and exits preview | Passed |
| Addon unload clears preview/configuration windows without an error | Passed |

The later `v0.1.1` preview-renderer work closed the earlier scaffold gaps for
party title sizing and composed module/global scaling. The reverted
window-font-scaling experiment remains historical context only; the current
build uses original explicit-size preview text rendering and does not render an
enabled placeholder outside preview.

After the first Player Frame in-game check showed the live frame but no local
player values, the `local_player` adapter was corrected to prefer Ashita
`MemoryManager` party slot `0` for name, HP, MP, and TP, with the player
wrapper retained only as a fallback. This correction has host smoke coverage
and was verified by Xpie in game on 2026-07-31.

The current host smoke pass adds coverage for Player Frame job/subjob
formatting, module-specific font controls, resource-value alignment, text color
validation, configured font-outline drawing, active TP-jewel flash overlays,
and single-style/player-anchor module configuration behavior. Those controls
still require an in-game visual/configuration recheck.

The 2026-08-01 in-game review left several Player Frame items that host smoke
tests cannot validate: manual `pframe_bg.png` transparency/decorative-element
asset changes, font-size legibility at 4K viewing distance, active TP-jewel
flash behavior, and granular text micro-positioning. The configuration menu
also needs an in-game usability pass, including review of recent Ashita-level
warnings/errors. Before revising the config UI further, locate the relevant
Ashita log or console output and record each warning/error message exactly so
it can be addressed one at a time.

Copy `addon/VanadielHDUI` to the Ashita v4 `addons` directory, then:

1. Run `/addon load VanadielHDUI`.
2. Confirm the console reports that the core foundation loaded and identifies
   gameplay modules as placeholders.
3. Run `/vhd`; confirm the configuration shell opens.
4. Enable one placeholder and confirm `/vhd status` reports it as `running`.
5. Disable it and confirm status returns to `disabled`.
6. Run `/vhd preview on`; confirm every preview is labeled as preview-only and
   contains no live game data. Confirm no critical error occurs.
7. Leave Party positioning at its default `Move elements independently`.
   Drag Party B and confirm Party A and C remain stationary.
8. Select `Move elements as a group`. Drag any party window and confirm Party
   A/B/C move by the same delta. Switch back to independent mode and confirm
   the individual arrangement was preserved.
9. Left-drag several other preview windows and confirm each follows the
   pointer. Release, unload/reload, and confirm all final positions and the
   selected movement mode persist.
10. Confirm the repositioned party preview shows Party A, B, and C with six
    slots each.
11. Change the Party A group-label and font-size options; confirm all three
    preview groups use the shared label visibility and title size.
12. Run `/vhd preview off`; confirm all preview windows disappear and disabled
    modules remain disabled.
13. Change a position, opacity, scale, and enabled state; unload/reload and
    confirm the settings persist for the current character. Do not expect a
    non-preview placeholder surface merely from enabling a scaffold module.
14. Run `/vhd reset module party`; confirm only the party block resets.
15. Run `/vhd reset all`; confirm all scaffold settings reset and preview exits.
16. Run `/addon unload VanadielHDUI`; confirm no preview or configuration
    windows remain and no unload error is printed.

Do not treat this checklist as full gameplay-module acceptance. The only live
game-state surface currently included is the first Player Frame local-player
name/job/HP/MP/TP slice with TP threshold pips derived from the reviewed local
TP value. No packet handling, targeting, cancellation, native-UI suppression,
target frame, target casting, target-of-target, or broader production HUD
behavior is included in this phase.
