# Curated Knowledge Boundary

OpenCode active artifacts live in `~/.config/opencode`. On this machine, the `ai.md` repository at `/var/home/core/workspace/jonloureiro/ai.md` is the curated knowledge and renewal-harness source.

## When to consult `ai.md`

- Research, methodology, prompt architecture, agent architecture, or harness work needs prior evidence.
- A task asks to update or apply curated knowledge.
- Existing assumptions may be stale and should be checked against `knowledge/INDEX.md`.

## How to use it

1. Read `/var/home/core/workspace/jonloureiro/ai.md/knowledge/INDEX.md` first when available.
2. Prefer Current notes; use Aging or Stale notes only as leads until key claims are re-verified.
3. For new research, follow `/var/home/core/workspace/jonloureiro/ai.md/knowledge/research/good-ai-assisted-research-methodology.md`.
4. Distill operational guidance into OpenCode agents, commands, skills, prompts, or references only when it changes behavior.
5. Do not bulk-copy `ai.md/knowledge` into OpenCode prompts or references.

If the local `ai.md` path is unavailable, irrelevant to the task, or stale for the needed claim, record the exception in the work ledger/run evidence and continue with documented source verification.

## Cron split

- `ai.md` knowledge-curation cron maintains curated research, freshness classification, and harness docs.
- `config-opencode` application cron runs here, reads curated `ai.md` findings, and applies only minimal active OpenCode guidance.
