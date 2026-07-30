# Vana'diel HD UI — Codex Instructions

This repository is in the design-transfer and gameplay-audit phase. Do not begin
implementation unless Xpie explicitly asks for it.

## Required reading

Before any project work, read these files completely:

1. `docs/DECISIONS.md`
2. `docs/DESIGN-SPEC.md`
3. `docs/PROJECT-STATUS.md`
4. `README.md`
5. `docs/REFERENCES.md` whenever outside projects, third-party assets, licensing,
   attribution, FFXI policy, or Ashita behavior are involved

If the documents conflict, use the order above. Do not silently reconcile a
conflict: add it to the contradiction register in `docs/DECISIONS.md` and ask
Xpie before a material design or implementation choice depends on it.

## Privacy and naming

- Refer to the project owner only as **Xpie** in documentation, source comments,
  release materials, metadata, issue text, responses, and all other
  project-related references.
- Do not reproduce, infer, or publish another personal name for the project
  owner.
- Treat this naming rule as binding for all future project work.

## Binding project boundaries

- Modernize the presentation of information FFXI already communicates; do not
  create new knowledge.
- Never add automation, action selection, command execution, predictive or
  inferred combat information, hidden or normally unavailable information,
  enemy lists, inventory tracking, storage summaries, free-space indicators,
  proactive inventory warnings, gil tracking, market/vendor values, or equipment
  displays in the core addon.
- A native inventory-full or item/gil acquisition message may be displayed as a
  temporary native event. It must not become a gauge, forecast, persistent
  capacity display, or analytical inventory tool.
- Packet availability does not by itself make information acceptable. For every
  proposed field, identify where the unmodified game communicates it, when it
  communicates it, and whether the proposed display changes the player's
  knowledge or timing.
- Contextual, aggregated, inferred, packet-derived, target-of-target,
  target-casting, target-status, trust-level, distance, and party-target data
  require the documented boundary/technical review before implementation.
- When in doubt, omit the information and record the question.

## Preserved component decisions

Treat the approved decisions in `docs/DECISIONS.md` as binding, including the
compact player frame, mirrored target frame, conditional target-of-target,
integrated casting presentation, unified status/recast tray, party-first combat
layout, restrained notification feed, inventory exclusions, and
native-information boundary.

Names alone do not authorize unresolved behavior. In particular, do not
implement target-of-target, target casting, target effects, trust-level
comparison, click-to-target behavior, or distance until their open reviews are
resolved.

## Implementation and reuse rules

- The eventual overlay is one Ashita v4 addon with independently configurable
  modules. Native DAT/texture replacements and external-addon themes remain
  separate optional installation layers.
- Write original event handling, state management, rendering, configuration, and
  assets.
- Study XIUI and other projects only for behavior and interface patterns unless
  their license and the intended form of reuse have been reviewed and recorded.
- Do not copy source, textures, icons, fonts, screenshots, or other assets merely
  because they are publicly accessible.
- Preserve license notices and attribution for any incorporated third-party
  work. Update `docs/REFERENCES.md` and create a release-ready third-party notice
  before distribution.

## Documentation discipline

- Record approved, rejected, deferred, and superseded decisions in
  `docs/DECISIONS.md`.
- Keep component behavior and constraints in `docs/DESIGN-SPEC.md`.
- Keep current phase, completed work, blockers, and next steps in
  `docs/PROJECT-STATUS.md`.
- Keep source provenance, licensing status, and inspiration-only references in
  `docs/REFERENCES.md`.
- After material design decisions or implementation progress, update the
  appropriate documents before finishing the task.
- Do not convert a proposal, example, possible display mode, or technical
  capability into an approved requirement.
