---
name: source-verification
description: Use when checking whether a tool, API, model, config syntax, permission rule, dependency API, or workflow assumption is current before changing behavior.
compatibility: opencode
---

# Source Verification

## Trigger

- Tool/API/model/provider behavior may have changed.
- OpenCode/Hermes config changes.
- Imported knowledge may be stale.
- Docs, examples, memory, and installed behavior may diverge.
- Dependency/API shape affects implementation.

## Source order

1. Current local source/config/files.
2. Installed package type definitions or implementation files.
3. Current command output and local experiments.
4. Current official docs.
5. Versioned repository docs/examples.
6. Imported memory/session/plans.
7. Model prior knowledge.

If docs and installed files disagree, trust installed files for this machine and record the divergence.

## Procedure

1. Check installed version/current source.
2. Inspect types/implementation when shape matters.
3. Check official docs when needed.
4. Run the smallest proving experiment.
5. For risky config/API changes, get skeptical review against exact evidence.
6. Record source, date, version, confidence, consequence, and re-check path.

## Stop rules

Stop if docs and installed behavior conflict and the safe choice is unclear.
Stop if only stale plans, screenshots, or memory support the claim.

## Output contract

Return sources, facts, caveats, recommendation, and re-check command/URL.
