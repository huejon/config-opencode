---
name: work-ledger
description: Use for non-trivial local work; requires `.opencode/works/<work-name>/` state, run log, findings, decisions, reviews, and handoff.
compatibility: opencode
---

# Work Ledger

## Procedure

1. Create or load `.opencode/works/<work-name>/`.
2. Maintain `work.md`, `state.md`, `context.md`, `plan.md`, `run-log.md`, `decisions.md`, `memory-candidates.md`, and `handoff.md`.
3. Put reviews in `reviews/`, findings in `findings/`, proposals in `proposals/`.
4. Keep memory candidates separate from accepted durable memory.

## Stop rules

Before pausing, write current state, last command/result, blocker if any, and next recommended action.
