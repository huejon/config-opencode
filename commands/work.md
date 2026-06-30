---
description: Start, continue, check, or hand off work using `.opencode/works/<slug>/` state.
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

Then follow it. Use markdown handoffs, not chat compaction. Keep the user response short.
