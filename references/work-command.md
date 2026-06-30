# Work command reference

Use when `/work` runs.

## Intent

- New task: create/load `.opencode/works/<slug>/`.
- Resume: read `handoff.md`, `state.md`, and `run-log.md` first.
- Status: report state, last evidence, blocker, next step.
- Handoff: update `handoff.md`; stop with path + next command.
- Board: update `.opencode/WORKS.md` whenever `.opencode/works/<slug>/` is created or materially updated. This board is local-only and must not be tracked by git.
- Path guard: do not create root `work-ledgers/`, root `WORKS.md`, or other tracked ledger folders. If repo docs mention them, treat that as stale unless the active user explicitly asks for a tracked neutral ledger.

## Work directory

`.opencode/works/<slug>/` is local-only by default and contains:

- `work.md` — objective/scope
- `state.md` — current state
- `plan.md` — short plan
- `run-log.md` — commands/results
- `decisions.md` — durable decisions
- `handoff.md` — resume point, not chat compaction
- `memory-candidates.md` — candidates only
- `findings/`, `reviews/`, `proposals/`

## `.opencode/WORKS.md` board

`.opencode/WORKS.md` is a concise local-only board, not a ledger. Keep only:

| Work | Last updated | Status |
|---|---:|---|
| `<slug>` | `YYYY-MM-DD` | `completed|active|blocked|stale` |

Use `completed` only when verified. Use `active` when a safe next continuation exists. Use `blocked` when evidence shows a blocker or required decision. Use `stale` when no current safe continuation is clear. Add a terse reason only when needed.

## Subagents

Do not ask the user to call subagents. `work` is the interface. `work` chooses subagents and records outputs under `reviews/` or `findings/`.

Required review/debug/judge agents:

- Review: `review-kimi`, `review-minimax`, `review-glm`.
- Debug: `debug`.
- Judges: always include at least `judge-minimax` + `judge-glm`; add `judge-kimi` when useful.
- Risk: `red-team`; triage: `blue-team`.

Flow:

- Normal: implement, verify, run parallel reviews, address/reject findings with evidence, then parallel judges.
- Bug: if root cause is unclear, run parallel `debug`; fix; verify; review; judge.
- Risky/operational: review + red-team, then blue-team triage, then judges.
- Local code/setup change: review and judge before completion. Pure inspection can finish with `verify`-style evidence.

Parallelism: start independent passes together. Serialize only for real dependencies: blue-team after findings; judges after evidence/reviews/triage.

## Planning vs execution

Classify the current request before changing files.

Planning mode indicators:

- User asks to plan, design, investigate, compare, propose, review a direction, write requirements, create a PRD/tech spec, or explicitly says not to implement.
- Work is in Discovery/Architecture under D.A.R.T.E. for a new or materially changed prompt/skill/agent.

Planning mode behavior:

- Inspect sources and constraints, then produce the plan/spec/proposal.
- Save useful planning state to `.opencode/works/<slug>/plan.md` or `proposals/`. Use another path only when the active user explicitly requests it.
- Do not edit implementation/config files, run implementation workflows, commit, or push unless the user explicitly switches to execution.

Execution mode indicators:

- User asks to fix, implement, update, configure, refactor, run, verify, continue, or “make it so”.
- Active handoff/state names the next step as apply/evaluate and the requested scope is local and reversible.

Execution mode behavior:

- Execute routine local reversible work without asking permission.
- Ask only for proven blockers, destructive/irreversible changes, external side effects, production/billing/deploy/publish, credentials, or unresolved product decisions after inspection.
- For prompt/skill/agent work, Redaction/Test/Enhance are execution: write the artifact, test it, then improve with evidence.

Ambiguous mode behavior:

- Inspect first. If evidence reveals a safe default, proceed.
- If still ambiguous and the next step materially changes scope, stop with the exact decision needed.

## Swarm

Swarm is `work` behavior, not a user-facing skill. User still calls `opencode run --command work -- "..."`; `work` chooses panel vs swarm.

- MiniMax/GLM are panel agents. Use a few; do not exceed 12 total MiniMax/GLM in one phase unless asked.
- Kimi/debug/red-team/blue-team are swarm-capable when breadth warrants it.
- Default normal work: 1-2 Kimi reviews, 1 MiniMax review, 1 GLM review; then MiniMax + GLM judges, optionally Kimi.
- Hard bug: 3-8 `debug` agents first; scale only for broad/ambiguous failures.
- Risky change: 3-12 Kimi review/red-team plus a few MiniMax/GLM; then 2-8 blue-team; then judges.
- Explicit swarm request: use more Kimi if useful, while keeping MiniMax/GLM below cap.

Cluster swarm output: dedupe, preserve minority reports, save outputs, summarize consensus/disagreement, then act.

## Embedded procedures

Do not ask the user to call skills. Do not copy Hermes skills into OpenCode. Put recurring behavior in commands, agents, `AGENTS.md`, or references.

- Source uncertainty: check current source/config, installed version, docs if needed, and smallest proving experiment.
- Long task: state run, duration risk, stop criteria, and progress path before broad tests/watchers/daemons/scans.
- Non-trivial work: maintain `.opencode/works/<slug>/`, `handoff.md`, and `.opencode/WORKS.md`.
- Figma/design: require live Figma/MCP source data before implementation; stop if unavailable.
- Completion risk: continue until verified, blocked with evidence, external boundary, or safe handoff.
- Skills: if explicitly requested, check existing coverage, trigger, minimal procedure, output, failure modes, sandbox test, rollback.

## Output

Concise Portuguese: path, state, next action, blockers if any.
