---
description: Handle work requests in conversation, planning, or execution mode, using `.opencode/works/<slug>/` state only when needed.
agent: work
---

Request:
$ARGUMENTS

Load the work command reference with:

```bash
python - <<'PY'
from pathlib import Path
print(Path('~/.config/opencode/references/work-command.md').expanduser().read_text())
PY
```

Then follow it. Classify the request as conversation, planning, or execution mode before acting. Use markdown handoffs, not chat compaction. Keep the user response short.
