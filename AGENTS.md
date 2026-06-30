# Global OpenCode Operating Rules

These are personal/global rules for this dedicated agent machine. Project-specific rules belong in the project's own `AGENTS.md` or private `.opencode/**` overlay.

## Language

- Speak to the user in Portuguese unless they ask otherwise.
- Write operational notes, prompts, skills, memory, and work ledgers in English unless a repository convention says otherwise.

## Autonomy and boundaries

- Do not ask permission for normal local work: inspect files, edit local setup, run tests, create work artifacts, or use local subagents.
- Stop and report only for real blockers, external side effects, production/billing mutations, or decisions that require the user after options are investigated.
- Do not store secrets in memory, prompts, logs, or final summaries.


## Work style

- Prefer current source, command output, and official docs over stale memory or model knowledge.
- Verify every completion claim with a command and exit code when possible.
- Do not repeat the same failing command more than twice unless the hypothesis, code, or environment changed.
- Keep changes small, diffable, reversible, and scoped to the task.

## Skills and commands

- Do not copy Hermes skills into OpenCode. Encode recurring OpenCode behavior in commands, agents, `AGENTS.md`, or references instead.
- The user-facing interface should stay small: prefer `opencode run --command work -- "..."` and `opencode run --command verify -- "..."` over asking the user to name agents or skills.
- If explicitly asked to create or change an OpenCode skill, first justify why a command/agent/reference is not enough; define the exact trigger, minimal procedure, output contract, failure modes, sandbox test, and rollback path.
- When learning OpenCode behavior, record installed version, sources checked, minimal experiment, exit code, confidence, operational consequence, and re-check command under `~/.config/opencode-learning/`.

## Subagent orchestration

- For any local code/setup change, review may use `review-kimi`, `review-qwen`, and `review-glm`; start multiple independent review passes in parallel when useful.
- Before claiming any local code/setup change complete, run multiple independent judges in parallel when useful; always include at least `judge-qwen` and `judge-glm` after evidence/reviews exist, and include `judge-kimi` when useful.
- Debug also uses Kimi `debug` agents only; multiple independent debug passes may run in parallel.
- Independent review, judge, debug, red-team, and blue-team passes should be started in parallel; do not run them one-by-one unless a real dependency exists.
- Swarm is a `work` command behavior, not a separate user-facing skill. Use a small panel by default and scale to a swarm when task breadth warrants it.
- `*-qwen` and `*-glm` agents are high-signal panel agents: use a few of each, and do not exceed 12 total Qwen/GLM agents in one phase unless explicitly requested.
- `*-kimi`, `debug`, `red-team`, and `blue-team` agents are swarm-capable: dozens of parallel Kimi agents are allowed for broad review/debug/red-blue-team work when warranted or requested.
- Swarm outputs must be clustered: dedupe repeated findings, preserve minority reports, and summarize consensus vs disagreement before acting.

## Setup-specific rule

During Hermes/OpenCode setup, use `~/.config/opencode-learning/**` for evidence and do not dump the operating book into active prompts.


## Figma source-first rule

When a task includes a Figma link or asks to match Figma, verify that a live Figma source/MCP connection can return data for the referenced file/node before coding or visual inference. If the source is unavailable or disconnected, stop and ask for the connection to be fixed; do not guess from screenshots or memory.


## Continuity and handoff

- Do not rely on conversation compaction as the handoff mechanism.
- For non-trivial work, keep state in `.opencode/works/<work-name>/`.
- Before stopping, switching sessions, or losing context, update the work `handoff.md`.
