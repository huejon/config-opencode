# config-opencode

Shared OpenCode configuration: global operating rules, agents, commands, references, prompts, and plugins.

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

Host/account-specific operating rules do not belong in `AGENTS.md`. Put them in an ignored local note such as `machine-policy.local.md`, then adapt the active machine config/process as needed.
