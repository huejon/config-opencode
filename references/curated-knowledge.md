# Curated Knowledge Boundary

OpenCode active artifacts live in `~/.config/opencode`. Curated research, methodology notes, and renewal-harness outputs may be supplied by operator-owned automation outside this repo. Treat those inputs as external context, not as repo-to-repo dependencies.

## When to consult external curated inputs

- Research, methodology, prompt architecture, agent architecture, or harness work needs prior evidence.
- A task asks to update or apply curated knowledge.
- Existing assumptions may be stale and should be checked against current operator-provided sources when available.

## How to use it

1. Use current operator-provided curated inputs when available and relevant.
2. Prefer notes marked current; use aging or stale notes only as leads until key claims are re-verified.
3. For new research, follow the current operator-provided research methodology when available; otherwise use documented source verification.
4. Distill operational guidance into OpenCode agents, commands, skills, prompts, or references only when it changes behavior.
5. Do not bulk-copy external knowledge stores into OpenCode prompts or references.

If curated inputs are unavailable, irrelevant to the task, or stale for the needed claim, record the exception in the work ledger/run evidence and continue with documented source verification.

## Cron split

- External curation automation maintains curated research, freshness classification, and harness docs outside this repo.
- `config-opencode` application automation runs here, may read operator-provided curated findings, and applies only minimal active OpenCode guidance.
