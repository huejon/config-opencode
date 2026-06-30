---
description: Disabled agent. Use `work` unless the user explicitly re-enables `scout`.
mode: subagent
model: opencode-go/minimax-m3
permission:
  "*": deny
  bash:
    "*": deny
---
# Agent: scout disabled

This agent is intentionally disabled for the rafiki setup.

Use the primary `work` agent instead.
