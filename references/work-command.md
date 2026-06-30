# Work command reference

Use when `/work` runs.

## Intent

- New task: create/load `.opencode/works/<slug>/`.
- Resume: read `handoff.md`, `state.md`, and `run-log.md` first.
- Status: report state, last evidence, blocker, next step.
- Handoff: update `handoff.md`; stop with path + next command.

## Work directory

`.opencode/works/<slug>/` contains:

- `work.md` — objective/scope
- `state.md` — current state
- `plan.md` — short plan
- `run-log.md` — commands/results
- `decisions.md` — durable decisions
- `handoff.md` — resume point, not chat compaction
- `memory-candidates.md` — candidates only
- `findings/`, `reviews/`, `proposals/`

## Subagents

Do not ask the user to call subagents. `work` is the interface. `work` chooses subagents and records outputs under `reviews/` or `findings/`.

Required review/debug/judge agents:

- Review: `review-kimi`, `review-qwen`, `review-glm`.
- Debug: `debug`.
- Judges: always include at least `judge-qwen` + `judge-glm`; add `judge-kimi` when useful.
- Risk: `red-team`; triage: `blue-team`.

Flow:

- Normal: implement, verify, run parallel reviews, address/reject findings with evidence, then parallel judges.
- Bug: if root cause is unclear, run parallel `debug`; fix; verify; review; judge.
- Risky/operational: review + red-team, then blue-team triage, then judges.
- Local code/setup change: review and judge before completion. Pure inspection can finish with `verify`-style evidence.

Parallelism: start independent passes together. Serialize only for real dependencies: blue-team after findings; judges after evidence/reviews/triage.

## Swarm

Swarm is `work` behavior, not a user-facing skill. User still calls `opencode run --command work -- "..."`; `work` chooses panel vs swarm.

- Qwen/GLM are panel agents. Use a few; do not exceed 12 total Qwen/GLM in one phase unless asked.
- Kimi/debug/red-team/blue-team are swarm-capable when breadth warrants it.
- Default normal work: 1-2 Kimi reviews, 1 Qwen review, 1 GLM review; then Qwen + GLM judges, optionally Kimi.
- Hard bug: 3-8 `debug` agents first; scale only for broad/ambiguous failures.
- Risky change: 3-12 Kimi review/red-team plus a few Qwen/GLM; then 2-8 blue-team; then judges.
- Explicit swarm request: use more Kimi if useful, while keeping Qwen/GLM below cap.

Cluster swarm output: dedupe, preserve minority reports, save outputs, summarize consensus/disagreement, then act.

## Embedded procedures

Do not ask the user to call skills. Do not copy Hermes skills into OpenCode. Put recurring behavior in commands, agents, `AGENTS.md`, or references.

- Source uncertainty: check current source/config, installed version, docs if needed, and smallest proving experiment.
- Long task: state run, duration risk, stop criteria, and progress path before broad tests/watchers/daemons/scans.
- Non-trivial work: maintain `.opencode/works/<slug>/` and `handoff.md`.
- Figma/design: require live Figma/MCP source data before implementation; stop if unavailable.
- Completion risk: continue until verified, blocked with evidence, external boundary, or safe handoff.
- Skills: if explicitly requested, check existing coverage, trigger, minimal procedure, output, failure modes, sandbox test, rollback.

## Output

Concise Portuguese: path, state, next action, blockers if any.
