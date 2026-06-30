---
name: long-workflow-awareness
description: Use before long tests, daemons, watchers, broad scans, or expensive local workflows; requires notice and run-log state.
compatibility: opencode
---

# Long Workflow Awareness

## Procedure

1. State in Portuguese what will run, why it may take time, stop signal, and progress path.
2. Write command, reason, PID/session when applicable, and stop criteria to run log.
3. Monitor output enough to avoid duplicate/stuck watchers.
4. Summarize final output and what it proves.

## Stop rules

Stop if the workflow stalls without useful output, duplicates existing watchers, crosses an external boundary, or produces enough evidence.

