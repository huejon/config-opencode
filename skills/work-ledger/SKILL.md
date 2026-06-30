---
name: work-ledger
description: Use for non-trivial local work; requires `.opencode/works/<work-name>/` state, run log, findings, decisions, reviews, and handoff.
compatibility: opencode
---

# Work Ledger

## Procedure

1. Create or load `.opencode/works/<work-name>/`.
2. Maintain `work.md`, `state.md`, `context.md`, `plan.md`, `run-log.md`, `decisions.md`, `memory-candidates.md`, and `handoff.md`.
3. Put review artifacts under `reviews/`, findings under `findings/`, and proposals under `proposals/`.
4. Keep memory candidates separate from accepted durable memory.

## Stop rules

Before pausing, write current state, last command/result, blocker if any, and next recommended action.

