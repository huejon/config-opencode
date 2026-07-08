# config-opencode

Shared OpenCode configuration: global operating rules, agents, commands, curated skills, references, prompts, and plugins.

## Practical Use

### Using this repo

This repo is the shared OpenCode config. Use the installer from <https://github.com/huejon/config-opencode/blob/main/install.sh> to clone or update it in `~/.config/opencode`, then edit the machine-local `opencode.jsonc`.

```bash
curl -fsSL https://raw.githubusercontent.com/huejon/config-opencode/main/install.sh | sh
```

Then edit `opencode.jsonc` for that host: server bind address, MCP endpoints, absolute paths, and any machine-local permissions.

### Cron sample config

Use `opencode-cron-sample.jsonc` as a safer starting point for scheduled jobs. It is intentionally narrower than the interactive sample and should be copied/adapted into the user's OpenCode config location before use.

It keeps `work` as the default agent and also narrows `agent.work.permission` so agent-level permissions do not re-open broad bash. Keep job-specific permission expansion narrow and justified. Do not enable broad bash, MCPs, external directories, credentials, tokens, or user-specific paths unless a specific job requires them and the risk is understood.

Keep host/account-specific operating rules in ignored local files such as `machine-policy.local.md` or another `*.local.md`, then load them from the host's ignored `opencode.jsonc` via `instructions`.

Commit and push shared prompt, agent, command, or skill changes only after validation. Do not commit local policy, work notes, secrets, sessions, logs, or host-specific config.

When tracked concepts, paths, or boundaries change, update this README in the same change.

### Validation

After edits to commands, agents, references, permissions, or sample config, run the preferred validation entrypoint from anywhere in the repo checkout:

```bash
scripts/validate-opencode-config.sh
```

It runs static repository checks, the subagent permission validator, `git diff --check` when inside a git worktree, obvious committed-secret heuristics, and optional `opencode debug` checks when OpenCode is installed.

### Using commands, skills, and agents

For human work, open OpenCode in the repo first:

```bash
cd <repo>
opencode
```

Then run the command from the TUI:

```text
/work <task>
```

Use `/question <topic>` for extended clarification, brainstorming, tradeoff comparisons, or "grill me" decision pressure before execution. `/work` still answers normal short questions, but `question` is the preferred lane when the task is mostly thinking and should not mutate files. Use `/verify <claim>` when you need an independent check of a concrete claim. Reserve `opencode run --command ...` for headless automation, scripts, or agent-driven runs — not as the default human workflow.

Concept boundaries:

- Commands are the user-facing entry points. They define repeatable workflows such as `work`, `question`, and `verify`.
- Agents are role definitions used by commands or OpenCode sessions. Keep them focused: worker, reviewer, judge, debugger.
- Current required panel: `review-deepseek`/`judge-deepseek` on DeepSeek V4 Pro plus `review-minimax`/`judge-minimax` on MiniMax M3.
- Skills are reusable domain procedures that an agent can load when the task needs specialized steps. Keep them curated; do not bulk-copy external or legacy assistant skills into OpenCode.
- Prompts and references are supporting material. Prompts shape behavior; references hold longer operating docs that should not live inline in every agent.

For non-trivial work, keep notes in `.opencode/works/<slug>/` and update `.opencode/WORKS.md`. Those work ledgers are local-only and should not be committed.

## Install / update on a machine

The GitHub page for the installer is <https://github.com/huejon/config-opencode/blob/main/install.sh>, but runnable commands must use the raw URL because `github.com/.../blob/...` returns HTML.

```bash
curl -fsSL https://raw.githubusercontent.com/huejon/config-opencode/main/install.sh
curl -fsSL https://raw.githubusercontent.com/huejon/config-opencode/main/install.sh | sh
```

Custom arguments:

```bash
curl -fsSL https://raw.githubusercontent.com/huejon/config-opencode/main/install.sh | sh -s -- --repo-url <repo-url> --branch main --dry-run
```

The installer:

- preflights Git, repository access, target state, backup path, and tracked work in an existing target repo before mutating files;
- updates in place with `git pull --ff-only` when `~/.config/opencode` is already this repo and clean;
- moves any other existing `~/.config/opencode` to `~/.config/opencode.backup.<timestamp>` before cloning;
- preserves an old `opencode.jsonc` inside the new repo as `opencode.jsonc.before-config-opencode-<timestamp>`;
- creates `opencode.jsonc` from `opencode-sample.jsonc` only when it is missing;
- supports `--force`, `--branch`, `--repo-url`, `--dry-run`, `--no-color`, and `--help`.

After install, edit `opencode.jsonc` for that host: server bind address, MCP endpoints, absolute paths, and any machine-local permissions.

If you keep host/account-specific operating rules, create `machine-policy.local.md`; `opencode-sample.jsonc` includes it in `instructions` so OpenCode will load it when present.

## Tracked vs local

Tracked:

- `AGENTS.md`
- `agents/`
- `commands/`
- `skills/`
- `references/`
- `prompts/`
- `plugins/`
- `opencode-sample.jsonc`
- `opencode-cron-sample.jsonc`

Notable references:

- `references/work-command.md` — `/work` operating contract.
- `agents/question.md` and `commands/question.md` — primary clarification lane for questions, brainstorming, grill-me flows, and tradeoff-aware recommendations without implementation.
- `references/delivery-gates.md` — PRD/spec/task/review/QA gates distilled from retired project-local prompt artifacts.
- `references/curated-knowledge.md` — boundary, usage rules, and downstream candidate application contract for external curated inputs without bulk-copying them into OpenCode.

## External curated inputs

This config repo can be informed by operator-owned curated research, methodology notes, or renewal-harness outputs that live outside the repository. Those inputs are external context, not repo-to-repo dependencies. Distill only the operational guidance needed for active OpenCode behavior.

Recurring responsibility is split:

- External curation automation: maintains research, freshness/value classification, and harness docs outside this repo.
- `config-opencode` application automation: runs here, may read operator-provided curated findings, and updates only active OpenCode artifacts when needed.

Ignored/local:

- `opencode.jsonc`
- `machine-policy.local.md` and other `*.local.md` files
- `.opencode/WORKS.md` and `.opencode/works/`
- sessions/logs/cache/db files
- credentials/secrets
- package manager artifacts and `node_modules/`

## Machine-local policy

Host/account-specific operating rules do not belong in `AGENTS.md`. Put them in ignored local notes such as `machine-policy.local.md` or another `*.local.md` file, then load those files from the host's ignored `opencode.jsonc` via `instructions`.

Example:

```jsonc
{
  "instructions": [
    "AGENTS.md",
    "machine-policy.local.md",
    "github.local.md"
  ]
}
```

The repo's `.gitignore` ignores `*.local.md`, so each machine can keep local account, path, MCP, or permission notes without syncing them to other hosts.

For locked-down hosts, `machine-policy.local.md` may also say the agent must not mutate remote git state and must not use `gh` CLI commands that mutate GitHub.

## Skills boundary

This repo tracks only the curated OpenCode skills in `skills/`; runtime OpenCode may also discover external skills from its supported external skill directories. Do not bulk-copy external or legacy assistant skills into this repo: put recurring OpenCode behavior in commands, agents, `AGENTS.md`, or references unless a curated skill is justified.
