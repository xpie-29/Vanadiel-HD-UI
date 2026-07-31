# Core Foundation Smoke Test

**Last run:** 2026-07-30

**Runtime:** LuaJIT 2.1.1779665312

**Scope:** Host-independent core behavior; no FFXI or Ashita process required

## Automated run

Use a LuaJIT/MoonJIT-compatible interpreter:

```powershell
.\tests\smoke.ps1 -Lua <path-to-luajit-or-lua>
```

The test entry point is `tests/run.lua`. On 2026-07-30 it was executed with
LuaJIT 2.1.1779665312 installed through Scoop. It was also executed with the
transient Fengari CLI as an independent Lua parser/runtime check.

Result:

```text
[PASS] all runtime Lua files compile
[PASS] configuration defaults round trip
[PASS] legacy schema migrates before validation
[PASS] invalid fields recover independently
[PASS] future schema fails closed to defaults
[PASS] module and global resets are isolated
[PASS] multi-element layout positions and movement mode persist independently
[PASS] module failure is isolated and cleanup is reverse ordered
[PASS] preview initializes disabled party without persisting enablement
[PASS] event router registration and cleanup are deterministic
[PASS] configuration theme restores scoped ImGui style state
[PASS] layout editor commits generic module or element targets once on release

12 test(s), 0 failure(s)
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
| Clicking Preview mode does not fault the addon or modules | Passed before the scaling experiment; the later regression-producing experiment has been reverted |
| Enabling a placeholder changes `disabled` to `running` | Passed in the earlier pass |
| Disabling the placeholder returns it to `disabled` | Passed |
| `/vhd preview on` shows only preview-labeled, non-live data | Passed |
| Independent mode moves only the selected declared element | Passed |
| Group mode moves every declared element by the same delta | Passed |
| Party A/B/C and six slots per group are unobscured and visually verifiable | Passed |
| Party group-label visibility applies to all three shared groups | Passed |
| Party title font-size changes apply to all three shared groups | Failed; replacement rendering architecture pending |
| `/vhd preview off` clears previews and retains disabled state | Passed |
| Position and opacity controls work and persist across unload/reload | Passed |
| Module scale changes rendered module size | Failed; replacement rendering architecture pending |
| Global scale changes every rendered module size | Failed; replacement rendering architecture pending |
| Enabled placeholder appears outside preview and disappears when disabled | Failed; no non-preview scaffold surface is currently rendered |
| Passing setting values persist across unload/reload | Passed |
| `/vhd reset module party` resets only the party block | Passed |
| `/vhd reset all` resets scaffold settings and exits preview | Passed |
| Addon unload clears preview/configuration windows without an error | Passed |

The reported pass completed the drag-mode, unobscured party, shared-label,
party-only reset, reset-all, and cleanup checks. It exposed four implementation
gaps: font size, module scale, and global scale were persisted but not applied,
and a running placeholder had no non-preview render path.

An experimental correction was subsequently reverted at Xpie's direction. On
load it warned that font scaling was disabled and displayed the Player Frame
preview before preview was enabled. Turning preview off removed only some
content and left remnants from multiple modules. Window dimensions changed
under module/global scaling, but text did not scale proportionately. The
reverted code used an optional ImGui window-font scaling call and rendered an
enabled placeholder outside preview. Neither behavior remains in the current
build. Focused scaling and font-size retesting is paused until an original,
explicit-size text renderer is implemented.

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
13. Change a position, opacity, and enabled state; unload/reload and confirm the
    settings persist for the current character. Scaling and visible
    enabled-placeholder behavior remain deferred and must not be marked passed
    from this build.
14. Run `/vhd reset module party`; confirm only the party block resets.
15. Run `/vhd reset all`; confirm all scaffold settings reset and preview exits.
16. Run `/addon unload VanadielHDUI`; confirm no preview or configuration
    windows remain and no unload error is printed.

Do not treat this checklist as gameplay-module acceptance. No live game-state,
packet, targeting, cancellation, native-UI suppression, or production HUD
behavior is included in this phase.
