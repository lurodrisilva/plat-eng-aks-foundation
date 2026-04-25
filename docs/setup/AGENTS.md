<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-24 | Updated: 2026-04-24 -->

# docs/setup

## Purpose
First-run installation and bring-up documentation for the AKS Foundation. Read these once when you provision a new cluster.

## Key Files
| File | Description |
|------|-------------|
| `quickstart.md` | End-to-end deploy walkthrough: AKS, ArgoCD, Crossplane bootstrap |

## For AI Agents

### Working In This Directory
- Setup docs should be **chronological** — number steps and assume the reader has nothing installed.
- When you add or rename a Make target in the parent `makefile`, update `quickstart.md`.
- Anything reusable across projects belongs in `guides/`, not here.

### Testing Requirements
- Manually run through `quickstart.md` after structural changes to the Makefile or Terraform code.

### Common Patterns
- Open with prerequisites, then a copy-pasteable command block, then a "what just happened" explanation.

## Dependencies

### Internal
- References `../../makefile` and `../../aks-foundation/`.

### External
- None.

<!-- MANUAL: -->
