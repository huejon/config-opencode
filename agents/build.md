---
description: Disabled agent. Use `work` unless the user explicitly re-enables `build`.
mode: subagent
model: opencode-go/minimax-m3
permission:
  "*": deny
  bash:
    "*": deny
---
# Agent: build disabled

This agent is intentionally disabled for the rafiki setup.

Use the primary `work` agent instead.
