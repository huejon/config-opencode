---
description: Create or verify a private `.opencode` overlay for the current repository
---

Create or verify a project `.opencode` overlay in the current repo without editing versioned project files.

Preferred helper path if installed on this machine:

```bash
~/.config/opencode-learning/scripts/create-opencode-local-overlay.sh
```

If that helper script is missing, run the equivalent inline setup:

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

Then verify:

```bash
test -d .opencode
opencode debug config
```

Output contract:

- Report overlay path.
- Report whether `.opencode/` exists and is visible to OpenCode.
- Report whether `opencode debug config` succeeds.
- Do not edit versioned `.gitignore` unless the user explicitly asks.
