# config-opencode

Shared OpenCode configuration: global operating rules, agents, commands, curated skills, references, prompts, and plugins.

## Practical Use

This repo is shared OpenCode config. Clone or pull it into `~/.config/opencode`, then copy `opencode-sample.jsonc` to local `opencode.jsonc`.

Keep `machine-policy.local.md`, `.opencode/WORKS.md`, and `.opencode/works/` local-only. Use `commands/work` as the main interface. For non-trivial work, keep notes in `.opencode/works/<slug>/` and update `.opencode/WORKS.md`.

Commit and push shared prompt, agent, command, or skill changes only after validation. Do not commit local policy, work notes, secrets, sessions, logs, or host-specific config.

## Install / update on a machine

```bash
git clone git@github.com:huejon/config-opencode.git ~/.config/opencode
cd ~/.config/opencode
cp opencode-sample.jsonc opencode.jsonc
```

Then edit `opencode.jsonc` for that host: server bind address, MCP endpoints, absolute paths, and any machine-local permissions.

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

Ignored/local:

- `opencode.jsonc`
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

## Skills boundary

This repo tracks only the curated OpenCode skills in `skills/`. Do not bulk-copy Hermes skills into OpenCode. Hermes may keep skills about how to operate OpenCode; OpenCode itself should stay small and use only the curated OpenCode skills plus commands/agents/references.
