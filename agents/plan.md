---
description: Disabled agent. Use `work` unless the user explicitly re-enables `plan`.
mode: subagent
model: openai/gpt-5.5
permission:
  "*": deny
  bash:
    "*": deny
---
# Agent: plan disabled

Disabled for rafiki. Use primary `work` unless explicitly re-enabled.
