<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-24 | Updated: 2026-04-24 -->

# docs/architecture

## Purpose
Design decisions and architectural rationale — explains **why** the system is built the way it is, not how to use it. Reference these when reviewing PRs that touch identity, Crossplane, or cross-cutting infra.

## Key Files
| File | Description |
|------|-------------|
| `crossplane-azure-workload-identity.md` | Workload-identity design notes for Crossplane (historical — current code uses Service Principal auth, see comments in `crossplane_argocd.tf` and `crossplane_infrastructure.tf`) |
| `crossplane-implementation-summary.md` | Higher-level summary of the Crossplane bootstrap path: Application via ArgoCD → ProviderConfig → managed resources |

## For AI Agents

### Working In This Directory
- Architecture docs explain **trade-offs and rationale**. When you reverse a decision (e.g. SP auth → Workload Identity), update or supersede the doc rather than deleting it; keep history readable.
- The Crossplane workload-identity doc is currently **out of date with the live code** — code uses Service Principal auth (see `crossplane_infrastructure.tf:30-44` for the App Registration + password). Flag this when reviewing.
- Avoid duplicating reference content here; link to `reference/` instead.

### Testing Requirements
- None directly. Cross-check against the code when updating.

### Common Patterns
- Open with context (what was the constraint?), then options considered, then the decision, then known caveats.

## Dependencies

### Internal
- Conceptually anchored in `../../aks-foundation/crossplane_*.tf` and `../../aks-foundation/aso_argocd.tf`.

### External
- Crossplane and Azure Workload Identity upstream documentation.

<!-- MANUAL: -->
