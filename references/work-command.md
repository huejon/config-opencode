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

Subagents must not ask for permission. Their permissions should resolve to explicit `allow` or `deny`, not `ask`.

Each dispatch must name objective, input scope, output format, source/tool guidance, effort budget, and stopping condition; request distilled findings or artifact references, not raw transcripts.

OpenCode mechanics guard, distilled from external operator research `research-notes/knowledge/research/platform-agent-mechanics.md` lines 40-49 and 72-82:

- Before relying on a newly documented config field or agent/command behavior, re-check local truth with `opencode --version`, `opencode debug config`, `opencode debug paths`, `opencode debug agent <name>` when relevant, and current docs/changelog/schema when needed.
- Prefer current OpenCode mechanics: plural runtime directories where relevant (`agents/`, `commands/`, `skills/`, `tools/`, `themes/`) while treating singular names as backward-compatible; control tools through `permission`, not deprecated `tools` fields.
- If a command selects an agent for subtask-style execution, follow the dispatch contract above and treat the call as an isolated work packet.

Required review/debug/judge agents:

- Review: `review-deepseek`, `review-minimax`; add `review-kimi`/`review-glm` when useful.
- Debug: `debug`.
- Judges: always include at least `judge-minimax` + `judge-deepseek`; add `judge-glm`/`judge-kimi` when useful.
- Risk: `red-team`; triage: `blue-team`.

Flow:

- Normal: implement, verify, run parallel reviews, address/reject findings with evidence, then parallel judges.
- Bug: if root cause is unclear, run parallel `debug`; fix; verify; review; judge.
- Risky/operational: review + red-team, then blue-team triage, then judges.
- Local code/setup change: review and judge before completion. Pure inspection can finish with `verify`-style evidence.

Judge verdict handling:

- `ACCEPT`: completion proven.
- `ACCEPT WITH NOTES`: completion is acceptable, but the notes are real follow-up signal.
- In implementation/execution work, address each note or reject it with evidence, then rerun only the needed review/risk/judge passes.
- In review/reporting work, stop on `ACCEPT WITH NOTES` and include the notes in the final report.
- `NEEDS FIXES`/`REJECT`: fix or stop with a blocker, then rerun the required passes.

Parallelism: start independent passes together. Serialize only for real dependencies: blue-team after findings; judges after evidence/reviews/triage.

## Request modes

Classify the current request before changing files.

Conversation mode indicators:

- User asks for pure chat, explanation, advice, status, or a short answer.
- No plan artifact, code/config edit, command run, subagent pass, or local execution is needed to satisfy the request.

Conversation mode behavior:

- Reply directly in Portuguese using a pragmatic, direct, concise style with no wall of text, no praise padding, and no AI-sounding prose.
- `/work` must still answer normal questions directly. For extended clarification, brainstorming, "grill me"/"me grille", or multi-approach tradeoff exploration, prefer the primary `question` lane or suggest `/question` when the user has not asked for execution.
- Do not create/update `.opencode/works/` artifacts, edit files, run commands, or invoke subagents unless needed to answer accurately.
- The primary `work` agent may ask concise clarifying questions in conversation mode when that is the answer.
- If the answer depends on current local state and cannot be answered safely from context, switch only to the minimum inspection needed; if inspection becomes planning or execution, reclassify before proceeding.

Planning mode indicators:

- User asks to plan, design, investigate, compare, propose, review a direction, write requirements, create a PRD/tech spec, or explicitly says not to implement.
- Work is in Discovery/Architecture under D.A.R.T.E. for a new or materially changed prompt/skill/agent.

Planning mode behavior:

- Inspect sources and constraints, then produce the plan/spec/proposal.
- Save useful planning state to `.opencode/works/<slug>/plan.md` or `proposals/`. Use another path only when the active user explicitly requests it.
- Do not edit implementation/config files, run implementation workflows, commit, or push unless the user explicitly switches to execution.
- The primary `work` agent may ask for missing product/scope decisions after inspection when the plan would materially change.

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

- DeepSeek/MiniMax/GLM are panel agents. Use a few; do not exceed 12 total DeepSeek/MiniMax/GLM in one phase unless asked.
- Kimi/debug/red-team/blue-team are swarm-capable when breadth warrants it.
- Default normal work: 1 DeepSeek review, 1 MiniMax review, optionally Kimi/GLM reviews; then MiniMax + DeepSeek judges, optionally GLM/Kimi.
- Hard bug: 3-8 `debug` agents first; scale only for broad/ambiguous failures.
- Risky change: 3-12 Kimi review/red-team plus a few DeepSeek/MiniMax/GLM; then 2-8 blue-team; then judges.
- Explicit swarm request: use more Kimi if useful, while keeping DeepSeek/MiniMax/GLM below cap.

Cluster swarm output: dedupe, preserve minority reports, save outputs, summarize consensus/disagreement, then act.

## Embedded procedures

Do not ask the user to call skills. Do not bulk-copy external or legacy assistant skills into OpenCode. Put recurring behavior in commands, agents, `AGENTS.md`, or references.

- Evidence before edits: inspect current source/config/files, relevant symbols, schemas, command output, or official docs before changing files.
- Anti-invention rule: do not invent files, symbols, APIs, imports, config keys, config shapes, commands, endpoints, or behavior. If it is not observed in current source/config/docs/output, treat it as unknown.
- Assumption stop: if missing evidence or ambiguity materially changes scope, risk, portability, security, data integrity, rollback, or external side effects, stop and ask for the specific decision/source instead of editing from assumptions.
- User-work preservation: inspect diffs/status before editing when user work may exist; preserve observed user work unless intentionally changing it for the task.
- Hard scope guard: inspect broadly when needed for evidence, but edit only files with direct relevance to the current objective, bug, artifact, or validation path. Do not do opportunistic or drive-by cleanup, formatting, rename, documentation, or refactor work outside the active scope. If you discover a related issue outside scope, record or report it as a follow-up instead of editing it.

- Delivery gates: for feature work larger than a small local edit, use `references/delivery-gates.md`; keep PRD/spec/task/review/QA gates proportional to risk.
- Curated knowledge: for research, methodology, prompt architecture, agent architecture, or harness work, consult current operator-provided curated inputs when available and relevant; follow the current operator-provided methodology note for new research when available; if unavailable or not relevant, record the exception and continue with source verification; apply only distilled guidance to OpenCode, never bulk copies.
- Source uncertainty: check current source/config, installed version, docs if needed, and smallest proving experiment.
- Long task: state run, duration risk, stop criteria, and progress path before broad tests/watchers/daemons/scans.
- Non-trivial work: maintain `.opencode/works/<slug>/`, `handoff.md`, and `.opencode/WORKS.md`.
- Figma/design: require live Figma/MCP source data before implementation; stop if unavailable.
- Completion risk: continue until verified, blocked with evidence, external boundary, or safe handoff.
- Skills: if explicitly requested, check existing coverage, trigger, minimal procedure, output, failure modes, sandbox test, rollback.

## Output

Concise Portuguese: path, state, next action, blockers if any.
