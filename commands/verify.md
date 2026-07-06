---
description: Verify a specific claim with matching command evidence.
agent: work
---

Claim:
$ARGUMENTS

Run the smallest command/inspection that proves or falsifies the claim.

For OpenCode config, agent, or command behavior, prove installed/local truth
first with the relevant local checks (`opencode --version`, `opencode debug
config`, `opencode debug paths` for path/scope claims, and `opencode debug
agent <name>` for agent claims). Use current docs, changelog, or schema only
when the claim depends on newly documented fields or behavior not proven
locally.

Return: Claim, Command, Directory, Exit code, Relevant output, Proof, Unknowns, Next check if needed.
