# Vana'diel HD UI — Decision Record

**Last updated:** 2026-07-29  
**Authority:** This is the highest-priority project design document.

Statuses:

- **Approved** — binding unless Xpie explicitly changes it.
- **Proposed** — candidate direction; not authorization to implement.
- **Deferred** — intentionally postponed.
- **Rejected** — out of scope.
- **Needs confirmation** — described inconsistently or incompletely in the
  transferred material; do not implement.
- **Superseded** — retained for history but no longer controlling.

## Approved decisions

### D-001 — Modernize presentation, not gameplay

- **Status:** Approved
- **Source:** README baseline and transfer request
- **Decision:** The project may improve clarity, organization, scaling, and
  visual cohesion only for information FFXI already communicates. It may not
  reveal, calculate, predict, infer, or automate gameplay information or
  actions.
- **Consequence:** Technical availability, including packet or memory access, is
  insufficient. Every field requires native-equivalence review.

### D-002 — Preserve intentional inventory and currency friction

- **Status:** Approved
- **Source:** README baseline and transfer request
- **Decision:** Exclude capacity/free-space displays, storage or combined
  summaries, inventory-full gauges, proactive space warnings, inventory
  tracking, gil totals/session earnings, price/value metadata, and core
  equipment displays.
- **Clarification:** A native item, gil, acquisition-failure, or inventory-full
  message may appear temporarily because the event has already been disclosed.
  It may not be converted into persistent state, a forecast, or an analytical
  tool.

### D-003 — One modular core addon; separate optional packages

- **Status:** Approved
- **Source:** README baseline
- **Decision:** The overlay will be one Ashita v4 addon with independently
  configurable modules. Native UI replacements and external-addon themes remain
  separate, optional, reversible installation layers.

### D-004 — Compact player frame

- **Status:** Approved
- **Source:** README baseline and transfer request
- **Decision:** Use a compact configurable player frame near the action for
  identity, HP, MP, TP, and integrated player casting. Do not build the large
  redundant horizontal player-status display.
- **Still unresolved:** exact geometry, values, contextual visibility, and cast
  treatment.

### D-005 — Mirrored target-frame family

- **Status:** Approved
- **Source:** README baseline and transfer request
- **Decision:** The target frame should be visually mirrored or complementary to
  the player frame and communicate the current target clearly.
- **Limit:** This approves the visual relationship, not hidden exact values,
  target casting, target statuses, or field-for-field symmetry.

### D-006 — Casting belongs in the combat HUD

- **Status:** Approved
- **Source:** README baseline and transfer request
- **Decision:** Player casting integrates with the player frame. If target
  casting passes review, it integrates with the target frame rather than living
  in a disconnected timer panel.
- **Limit:** Target-cast availability and precision remain unapproved under
  Q-002.

### D-007 — Unified status and recast tray

- **Status:** Approved
- **Source:** README “Timing system” and transfer request naming the status tray
- **Decision:** Player statuses and native recasts form one time-sensitive
  system with compatible icon/bar/hybrid views. They are not separate unrelated
  text lists.
- **Limit:** Exact default view, sorting, thresholds, target effects, and status
  duration precision remain unresolved.

### D-008 — Party-first group combat design

- **Status:** Approved
- **Source:** README baseline and transfer request
- **Decision:** The party list is the primary group-combat information center
  and highest-priority gameplay component. Provide portrait-free stacked frames
  and a compact raid-style family; keep alliance parties distinct.
- **Limit:** Trust comparison, party-target data, distance, status selection,
  and click-to-target interaction each require separate verification.

### D-009 — Restrained unified notification feed

- **Status:** Approved
- **Source:** README baseline and transfer request
- **Decision:** Temporary native events use one cohesive fading feed, no
  background by default, with an optional shared background, configurable
  duration, and configurable maximum lines.
- **Limit:** Duplicate grouping is provisional; additional metadata is forbidden
  unless the native event communicated it and it passes boundary review.

### D-010 — On-demand histories are not analytical panels

- **Status:** Approved
- **Source:** README baseline
- **Decision:** Loot and synthesis histories may organize already communicated
  messages on demand. They may not become permanent inventory/currency panels or
  add prediction, profit, price, or capacity data.

### D-011 — Original implementation and license-aware reuse

- **Status:** Approved
- **Source:** README baseline
- **Decision:** Study outside projects for behavior and patterns. Write original
  code and create original assets unless a specific reuse has been reviewed for
  license compatibility, attribution, and provenance.

### D-012 — No enemy list or automation

- **Status:** Rejected
- **Source:** README confirmed exclusions and transfer request
- **Decision:** Enemy lists; automated targeting; action selection; command
  execution; predictive combat calculations; and hidden information are outside
  the project.

### D-013 — Project-owner privacy and public name

- **Status:** Approved
- **Source:** Xpie privacy request dated 2026-07-29
- **Decision:** Refer to the project owner only as **Xpie** in all current and
  future project documentation, code comments, metadata, release materials,
  issue text, and project-related responses. Do not reproduce, infer, or publish
  another personal name for the project owner.
- **Consequence:** This naming rule applies to all future project work and
  supersedes any earlier personal-name reference.

## Unresolved questions and required reviews

### Q-001 — Target-of-target authorization

- **Status:** Needs confirmation
- **Conflict:** The README lists target-of-target as a planned module, but also
  says it is included only after confirming the native-information boundary and
  lists its exact native availability as an open question.
- **Required decision:** Is the component approved in principle but gated, or
  merely a candidate? Define its native equivalent, fields, update timing, and
  interaction before implementation.

### Q-002 — Target casting

- **Status:** Needs confirmation
- **Issue:** Target casting is described as supported, but the repository does
  not establish whether native FFXI reveals the same spell/action identity,
  progress, timing, and interruption state at the same precision.
- **Required decision:** Approve only the subset demonstrably equivalent to
  native information.

### Q-003 — Target effects and duration precision

- **Status:** Needs confirmation
- **Issue:** “Target effects” appears as a possible timing category, but the
  native source, visibility, and duration precision are not documented.
- **Required decision:** Define eligible effects and precision or exclude the
  category.

### Q-004 — Trust identification and level comparison

- **Status:** Needs confirmation
- **Issue:** Party priority includes a trust-level difference treatment while
  the README says reliable trust identification and level reporting require
  verification.
- **Required decision:** Confirm the source and native equivalence before
  displaying the treatment.

### Q-005 — Party member target, distance, and interaction

- **Status:** Needs confirmation
- **Issue:** The party design prioritizes current target selection and optional
  distance, while target-selection interaction and source availability remain
  open.
- **Required decision:** Review display fields separately from direct
  user-initiated click/controller targeting. No automated selection is allowed.

### Q-006 — Status-tray presentation

- **Status:** Needs confirmation
- **Issue:** Icon, bar, hybrid, cooldown-overlay, and threshold views are listed
  as possibilities, not selected defaults. “Important” versus “ordinary” timer
  classification is also undefined.
- **Required decision:** Choose layouts and user-controlled rules without adding
  tactical recommendation or inferred priority.

### Q-007 — Notification duplicate grouping

- **Status:** Needs confirmation
- **Issue:** Duplicate grouping is proposed but its time window, count behavior,
  and treatment of semantically similar versus identical native messages are
  unspecified.
- **Required decision:** Limit grouping to faithful presentation of already
  disclosed events and prevent inferred summaries.

### Q-008 — Native gil messages in histories

- **Status:** Needs confirmation
- **Issue:** The README allows a native “obtained gil” event in chat/feed, says
  loot history has no gil values, and forbids enhanced gil tracking.
- **Required decision:** Determine whether literal transient gil messages stay
  only in chat/feed or may appear in on-demand history. Persistent totals and
  session aggregation remain prohibited either way.

### Q-009 — Custom chat scope

- **Status:** Deferred
- **Issue:** A scalable display with native input is preferred, but controller
  text entry, auto-translate, tell history, and native behavior need technical
  investigation.

### Q-010 — Final visual system, scaling, and supported resolutions

- **Status:** Needs confirmation
- **Issue:** Visual direction and a 1920×1080 baseline exist, but exact tokens,
  safe areas, scaling rules, and supported resolutions do not.

### Q-011 — Treasure pool, job-specific information, and EquipMon theming

- **Status:** Deferred
- **Issue:** These remain candidates requiring independent scope, information,
  technical, and licensing reviews.

## Contradiction register

| ID | Sources | Contradiction or ambiguity | Controlling treatment |
|---|---|---|---|
| C-001 | README module table, roadmap, and open questions | Target-of-target appears planned but is explicitly conditional and unverified. | Q-001; do not implement. |
| C-002 | `LICENSE` and README “Current open questions” | The repository contains the GPLv3 license text, while the README says the final project/release license is undecided. The file also does not identify the project copyright holder or explicitly state whether “version 3 only” or “version 3 or later” applies. | License intent must be confirmed before release or third-party incorporation. |
| C-003 | README target-frame/timing descriptions and native-information rule | Target casting and target effects are presented as features without documented native equivalence or precision. | Q-002 and Q-003; only the visual slots are preserved. |
| C-004 | README party priorities and open questions | Trust level, party target, distance, and target interaction are prioritized while their data/behavior is unverified. | Q-004 and Q-005; do not implement those fields yet. |
| C-005 | README notification allowance and loot-history wording | Literal native gil events are allowed, but loot history says “no gil values,” leaving history placement ambiguous. | Q-008; no tracking or aggregation under any resolution. |
| C-006 | README installation template and repository state | README says `LICENSE` is TBD even though a GPLv3 file exists. | Same as C-002; installation/release text remains draft. |

## Decision-change procedure

For any decision that changes scope or the native-information boundary, record:

- date and status;
- player need and native equivalent;
- exact information source and timing;
- proposed presentation improvement;
- gameplay-advantage, persistence, precision, automation, and inference risks;
- effect on intentional friction;
- licensing/attribution concerns; and
- verification and acceptance criteria.

Do not delete superseded decisions; mark them superseded and link the replacement.
