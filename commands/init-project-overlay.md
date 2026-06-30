---
description: Create or verify a private `.opencode` overlay for the current repo.
---

Create/verify a private project `.opencode` overlay without editing versioned project files.

Prefer helper if installed:

```bash
~/.config/opencode-learning/scripts/create-opencode-local-overlay.sh
```

If missing, run inline setup:

```bash
root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$root"
mkdir -p .opencode/{memory,works,skills,commands,agents,prompts}
# Do not add `.opencode/` to `.git/info/exclude` by default.
[ -f .opencode/opencode.jsonc ] || cat > .opencode/opencode.jsonc <<'JSON'
{
  "$schema": "https://opencode.ai/config.json",
  "share": "disabled",
  "permission": {
    "question": "deny",
    "doom_loop": "allow",
    "external_directory": "deny"
  }
}
JSON
```

Verify:

```bash
test -d .opencode
opencode debug config
```

Return:

- Overlay path.
- Whether `.opencode/` exists and is visible to OpenCode.
- Whether `opencode debug config` succeeds.
- Do not edit versioned `.gitignore` unless the user explicitly asks.
