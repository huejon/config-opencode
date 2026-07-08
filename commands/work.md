---
description: Handle work requests by classifying first, loading the full workflow only when needed.
agent: work
---

Request:
$ARGUMENTS

First classify the request as one of:

- conversation
- planning
- execution
- resume
- status
- handoff

If conversation mode is enough, answer directly and concisely without loading
the full work reference.

If planning, execution, resume, status, or handoff is needed, load:

```bash
python - <<'PY'
from pathlib import Path
print(Path('~/.config/opencode/references/work-command.md').expanduser().read_text())
PY
```

Then follow it. Prefer concise human-facing responses. Use markdown handoffs,
not chat compaction.
