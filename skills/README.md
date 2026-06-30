# OpenCode skills

This directory is intentionally tracked, but currently empty of active global skills.

For this setup, prefer:

1. `commands/` for user-facing workflows.
2. `agents/` for internal roles and subagents.
3. `references/` for shared procedures and operating notes.
4. Project-local `.opencode/skills/` only when a repo truly needs a narrow reusable skill.

Do not bulk-copy Hermes skills or old `.agents` skills here. If a future behavior really belongs as an OpenCode skill, add a minimal, tested skill with a clear trigger, output contract, failure modes, and rollback path.
