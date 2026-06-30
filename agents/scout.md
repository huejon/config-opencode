---
description: Disabled agent. Use `work` unless the user explicitly re-enables `scout`.
mode: subagent
model: openai/gpt-5.5
variant: max
permission:
  "*": deny
  bash:
    "*": deny
---
# Agent: scout disabled

Disabled by default. Use primary `work` unless explicitly re-enabled.
