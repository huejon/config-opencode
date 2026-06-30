---
description: Disabled agent. Use `work` unless the user explicitly re-enables `build`.
mode: subagent
model: openai/gpt-5.5
variant: max
permission:
  "*": deny
  bash:
    "*": deny
---
# Agent: build disabled

Disabled by default. Use primary `work` unless explicitly re-enabled.
