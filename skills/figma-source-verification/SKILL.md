---
name: figma-source-verification
description: Use when a task includes a Figma URL, node link, design handoff, or asks to match Figma; requires live Figma/MCP source data before implementation.
compatibility: opencode
---

# Figma Source Verification

## Trigger

Use for Figma links, nodes, handoffs, or design matching.

## Procedure

1. Before coding, verify live Figma/MCP data for the file/node.
2. Prefer metadata, design context, node data, or inspectable tokens.
3. If unavailable/empty/wrong, stop and ask for connection/file/node fix.
4. Do not replace node data with screenshots, memory, or guesses.
5. Record source checked and proof before implementation.

## Boundaries

- This skill does not grant Figma access.
- If no Figma MCP/source tool exists, report that blocker.
- Do not invent measurements or colors.

## Output contract

Return source checked, data status, blocker if any, next action.
