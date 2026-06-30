# Global OpenCode Rules

Personal rules for this agent machine. Project rules live in the project `AGENTS.md` or private `.opencode/**` overlay.

## Language

- Speak to the user in Portuguese unless they ask otherwise.
- Write operational notes, prompts, skills, memory, and work ledgers in English unless a repository convention says otherwise.

## Autonomy and boundaries

- Do normal local work directly: inspect, edit local setup, run tests, write work artifacts, and use local subagents.
- Stop only for proven blockers, external side effects, production/billing changes, or required user/product decisions after inspection.
- Commit/push: active task wins. Do it only when the active instruction allows, repo/local policy allows, and validation evidence is recorded.
- Do not store secrets in memory, prompts, logs, or final summaries.


## Work style

- Prefer current source, command output, and official docs over memory or priors.
- Verify completion claims with command, directory, exit code, and relevant output when possible.
- Do not repeat a failing command more than twice unless something changed.
- Keep changes small, diffable, reversible, and scoped to the task.

## Skills and commands

- Do not copy Hermes skills into OpenCode. Put recurring behavior in commands, agents, `AGENTS.md`, or references.
- Keep the user interface small: `opencode run --command work -- "..."` and `opencode run --command verify -- "..."`.
- If asked to create/change a skill, first justify why a command/agent/reference is insufficient. Define trigger, minimal procedure, output, failure modes, sandbox test, and rollback.
- For OpenCode learning, record version, sources, minimal experiment, exit code, confidence, consequence, and re-check command under `~/.config/opencode-learning/`.

## Subagents

- For local code/setup changes, review with `review-kimi`, `review-minimax`, and/or `review-glm` when useful.
- Before completion, run judges after evidence/reviews; always include at least `judge-minimax` and `judge-glm`, plus `judge-kimi` when useful.
- Debug uses Kimi `debug` agents only.
- Start independent review/judge/debug/red-team/blue-team passes in parallel unless a dependency is real.
- Swarm is `work` behavior, not a user-facing skill. Default small; scale only when breadth warrants it.
- Keep MiniMax/GLM panels small; do not exceed 12 total MiniMax/GLM agents in one phase unless explicitly requested.
- Kimi/debug/red-team/blue-team can fan out for broad tasks.
- Cluster swarm outputs: dedupe, preserve minority reports, summarize consensus/disagreement, then act.

## Setup

During Hermes/OpenCode setup, use `~/.config/opencode-learning/**` for evidence. Do not dump the operating book into active prompts.


## Figma source first

For Figma links or design matching, verify live Figma/MCP data for the file/node before coding. If unavailable, stop and ask for the connection/file/node fix. Do not infer from screenshots or memory.


## Continuity

- Do not rely on conversation compaction for handoff.
- For non-trivial work, keep state in `.opencode/works/<work-name>/`.
- Do not create root `work-ledgers/` or root `WORKS.md`; those paths are stale for this setup unless the active user explicitly asks for a tracked neutral ledger.
- Before stopping, switching sessions, or losing context, update the work `handoff.md`.
