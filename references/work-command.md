# Work command reference

Use this reference when `/work` is invoked.

## Intent detection

- New task: create or load `.opencode/works/<slug>/`.
- Continue/resume: read existing `handoff.md`, `state.md`, and `run-log.md` before doing anything.
- Status/check: summarize current state, last evidence, blocker, next step.
- Handoff/pause/stop: update `handoff.md` and stop with path + next command.

## Work directory

`.opencode/works/<slug>/` should be visible to OpenCode and contain:

- `work.md` — objective and scope
- `state.md` — current state
- `plan.md` — short plan
- `run-log.md` — important commands/results
- `decisions.md` — durable decisions
- `handoff.md` — resume point, not chat compaction
- `memory-candidates.md` — candidates only
- `findings/`, `reviews/`, `proposals/`

## Subagent policy

Do not ask the user to call subagents. The `work` command is the user interface; `work` chooses subagents and records their outputs under `.opencode/works/<slug>/reviews/` or `findings/`.

Required review/debug and judges:

- Review can use Kimi, Qwen, and GLM review agents. Run multiple independent review subagents in parallel when useful:
  - `review-kimi` (`opencode-go/kimi-k2.7-code`)
  - `review-qwen` (`opencode-go/qwen3.7-max`)
  - `review-glm` (`opencode-go/glm-5.2`)
- Debug uses `debug` (`opencode-go/kimi-k2.7-code`). Run multiple independent `debug` subagents in parallel when useful.
- Judges can also be multiple in parallel. Always run at least one Qwen judge and one GLM judge before claiming non-trivial work is done; include Kimi judges when useful. Run all independent judges in parallel:
  - `judge-kimi` (`opencode-go/kimi-k2.7-code`)
  - `judge-qwen` (`opencode-go/qwen3.7-max`)
  - `judge-glm` (`opencode-go/glm-5.2`)

Specialists:

- `red-team` (`opencode-go/kimi-k2.7-code`) for adversarial risk review. Can be fanned out into many parallel independent red-team passes.
- `blue-team` (`opencode-go/kimi-k2.7-code`) for triaging review/red-team findings. Can be fanned out into many parallel independent blue-team passes.

Preferred orchestration:

- Normal implementation: `work` implements and runs verification, then starts multiple independent review agents in parallel across Kimi/Qwen/GLM as useful. After review findings are addressed or explicitly rejected with evidence, start multiple judges in parallel with at least `judge-qwen` and `judge-glm`. Do not claim completion until judges return ACCEPT or ACCEPT WITH NOTES, or until any disagreement is resolved with evidence.
- Bug/debug task: start one or more independent Kimi `debug` agents in parallel when the failure is unclear. After the fix and verification, run parallel reviews across useful review models and then parallel judges.
- Risky or operational change: start multiple review and Kimi `red-team` agents in parallel. Then start Kimi `blue-team` triage agents in parallel. Then start parallel judges.
- Any local code/setup change: run parallel reviews and parallel judges before claiming completion, even when the change looks small. If no files/config changed and the task is pure inspection, `verify`-style command evidence is enough.

Parallelism rule: all independent subagent checks must be started in parallel, not one-by-one. Never serialize independent review/debug/red-team/blue-team passes; never serialize independent judges. Serialize only when there is a real dependency: blue-team after findings exist, judges after evidence/reviews/triage exist.

## Swarm / fan-out policy

Swarm is a work-command behavior, not a separate user-facing skill. The user should still call only `opencode run --command work -- "..."`; `work` decides whether to use a small panel or a swarm.

Model-specific fan-out limits:

- `*-qwen` and `*-glm` agents are high-signal panel agents. Use a few of each in parallel when useful; do not exceed 12 total Qwen/GLM agents in one phase unless the user explicitly asks.
- `*-kimi`, `debug`, `red-team`, and `blue-team` agents are swarm-capable. Dozens of parallel Kimi agents are allowed for broad review, debug, red-team, or blue-team work when the task warrants it or the user asks for that scale.

Default phase sizes:

- Normal work: 1-2 `review-kimi`, 1 `review-qwen`, 1 `review-glm`; then 1 `judge-qwen` + 1 `judge-glm`, optionally 1 `judge-kimi`.
- Hard bug/debug: 3-8 `debug` agents in parallel first; scale to dozens only for broad/ambiguous failures.
- Risky change: 3-12 Kimi review/red-team agents in parallel plus a few Qwen/GLM reviewers; then 2-8 blue-team agents; then Qwen/GLM judges.
- Explicit swarm request: use dozens of Kimi agents if useful, while keeping Qwen/GLM panel agents below the cap.

Swarm output rule: cluster duplicate findings, preserve minority reports, record per-agent outputs under `reviews/` or `findings/`, and summarize consensus vs disagreement before deciding next action.

## Embedded procedure policy

Do not ask the user to call skills. Do not keep Hermes skills copied into OpenCode. Put recurring OpenCode behavior into commands, agents, AGENTS.md, or references instead.

Embedded rules that replace former local skills:

- Source uncertainty: check current local source/config, installed version, official docs if needed, and run the smallest proving experiment before changing behavior.
- Long task: state what will run, why it may take time, stop criteria, and where progress is recorded before starting broad tests, watchers, daemons, or expensive scans.
- Non-trivial work: maintain `.opencode/works/<slug>/` state and handoff files.
- Figma link/design handoff: require live Figma/MCP source data before implementation; stop if unavailable instead of guessing from screenshots or memory.
- Completion risk: keep working until complete and verified, blocked with evidence, at an external boundary, or handed off safely.
- Creating/changing an OpenCode skill is discouraged. If explicitly requested, first check existing coverage, exact trigger, minimal procedure, output contract, failure modes, sandbox test, and rollback path.

## Output

User-facing output should be concise Portuguese: path, state, next action, blockers if any.
