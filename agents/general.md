---
description: Disabled agent. Use `work` unless the user explicitly re-enables `general`.
mode: subagent
model: opencode-go/minimax-m3
permission:
  "*": deny
  bash:
    "*": deny
---
# Agent: general disabled

This agent is intentionally disabled for the rafiki setup.

Use the primary `work` agent instead.
