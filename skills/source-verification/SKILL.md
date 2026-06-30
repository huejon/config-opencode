---
name: source-verification
description: Use when checking whether a tool, API, model, config syntax, permission rule, dependency API, or workflow assumption is current before changing behavior.
compatibility: opencode
---

# Source Verification

## Use when

- Tool/API/model/provider behavior may have changed.
- Changing OpenCode or Hermes config.
- Importing knowledge from Claude Code, old sessions, or another machine.
- Public docs, memory, examples, and installed behavior might diverge.
- Dependency API claims affect implementation details.

## Source priority

1. Current local source/config/files.
2. Installed package type definitions or implementation files.
3. Current command output and local experiments.
4. Current official docs.
5. Versioned repository docs/examples.
6. Imported memory/session/plans.
7. Model prior knowledge.

When public docs and installed package files disagree, treat installed package files/type definitions as authoritative for the current machine and record the divergence.

## Procedure

1. Check installed version or current source.
2. Inspect installed type definitions/implementation when API shape matters.
3. Check official docs when behavior is source-dependent.
4. Run the smallest local experiment that proves or falsifies the assumption.
5. For risky API/config changes, run or request a skeptical review pass against the exact source evidence.
6. Record source, date checked, version, confidence, operational consequence, and re-check path.

## Stop rules

Stop if current docs and installed behavior conflict and the safe choice is not obvious.
Stop if a claim would require guessing from old plans, screenshots, or memory without live/current source.

## Output contract

Return sources checked, facts, caveats, recommendation, and re-check command/URL.
