---
name: work-ledger
description: Use for non-trivial local work and `WORKS.md` board upkeep; requires `.opencode/works/<work-name>/` state, run log, findings, decisions, reviews, handoff, and board status.
compatibility: opencode
---

# Work Ledger

## Procedure

1. Create or load `.opencode/works/<work-name>/`.
2. Maintain `work.md`, `state.md`, `context.md`, `plan.md`, `run-log.md`, `decisions.md`, `memory-candidates.md`, and `handoff.md`.
3. Put reviews in `reviews/`, findings in `findings/`, proposals in `proposals/`.
4. Update the repository root `WORKS.md` whenever a work directory is created or materially updated.
5. Keep `WORKS.md` concise: work name, last updated date, and status only. Status is `completed`, `active`, `blocked`, or `stale`; add a terse reason only when needed.
6. Keep memory candidates separate from accepted durable memory.

## Status rules

- `completed`: verified done; do not infer this from old notes.
- `active`: safe next continuation exists.
- `blocked`: evidence shows a blocker or required decision.
- `stale`: no current safe continuation is clear from the ledger.

## Stop rules

Before pausing, write current state, last command/result, blocker if any, next recommended action, and the matching `WORKS.md` status.

## Rollback

If a board update is wrong, revert only the affected `WORKS.md` row and keep the detailed ledger evidence intact.
