---
name: figma-source-verification
description: Use when a task includes a Figma URL, node link, design handoff, or asks to match Figma; requires live Figma/MCP source data before implementation.
compatibility: opencode
---

# Figma Source Verification

## Trigger

Use this skill whenever the user provides a Figma link, Figma node, design handoff, or asks to match Figma.

## Procedure

1. Before coding or visual inference, verify that the current Figma source connection can return real data for the referenced file/node.
2. Prefer a live Figma MCP/source call that returns metadata, design context, node data, or inspectable tokens.
3. If the Figma source is unavailable, empty, disconnected, or points to the wrong node, stop and ask the user to fix the connection/open/select the file or node.
4. Do not substitute screenshots, memory, or guesswork for unavailable Figma node data.
5. Once source data is available, record what source was checked and what it proves before implementing.

## Boundaries

- This skill does not grant access to Figma by itself.
- If no Figma MCP/source tool is configured in the current environment, report that as the blocker.
- Do not invent measurements or colors.

## Output contract

Return:

- Figma source checked;
- whether it returned node/design data;
- blocker if unavailable;
- next action.
