---
description: Run local OpenCode readiness checks for this machine.
---

Run local OpenCode readiness checks. Prefer helper; otherwise run inline checks.

Procedure:

1. If `~/.config/opencode-learning/scripts/opencode-local-readiness.sh` exists and is executable, run it:

```bash
~/.config/opencode-learning/scripts/opencode-local-readiness.sh
```

2. If missing, create `~/.config/opencode-learning/audits/` and run equivalent checks:

```bash
command -v opencode
opencode --version
opencode auth list
opencode debug config
opencode debug paths
opencode debug agent work
opencode agent list
opencode debug skill
opencode models openai --refresh
opencode models opencode-go --refresh
TS="$(tailscale ip -4 2>/dev/null | head -1 || true)"
test -n "$TS"
opencode run --attach "http://$TS:4096" --dir "$(pwd)" --agent work --model openai/gpt-5.5 'Respond with exactly: OPENCODE_LOCAL_READINESS_OK'
```

3. Validate local copy artifact if present:

```bash
python - <<'PY'
import os, tarfile
p=os.path.expanduser('~/.config/opencode-learning/exports/local-copy-artifacts.tar.gz')
print('artifact_exists', os.path.exists(p))
if os.path.exists(p):
    with tarfile.open(p,'r:gz') as t:
        names=t.getnames()
    bad=[n for n in names if any(x in n for x in ['node_modules','auth.json','opencode.db','/raw/','plugins/cache','package-lock','package.json','.jsonl'])]
    print('entries', len(names))
    print('bad_entries', len(bad))
    print('has_opencode', any('/.opencode/' in n for n in names))
    print('has_opencode_local', any('/.opencode/' in n for n in names))
PY
```

Return:

- Commands and exit codes.
- Audit file path if helper was used.
- Treat optional missing integrations as notes unless they block the current setup goal.
- If any required check fails, diagnose briefly and update the setup progress ledger.
