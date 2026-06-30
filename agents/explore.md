---
description: Disabled agent. Use `work` unless the user explicitly re-enables `explore`.
mode: subagent
model: openai/gpt-5.5
permission:
  "*": deny
  bash:
    "*": deny
---
# Agent: explore disabled

Disabled for rafiki. Use primary `work` unless explicitly re-enabled.
