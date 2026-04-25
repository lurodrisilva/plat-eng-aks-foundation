<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-24 | Updated: 2026-04-24 -->

# docs/guides

## Purpose
Task-oriented how-to guides — single-topic walkthroughs that assume the cluster is already running.

## Key Files
| File | Description |
|------|-------------|
| `argocd-public-endpoint.md` | How the public IP + LoadBalancer service expose ArgoCD; the workspace-suffixed DNS label rationale |
| `namespace-update.md` | How to add or modify the namespaces defined in `aks_cluster_namespaces.tf` |

## For AI Agents

### Working In This Directory
- Guides answer "how do I X?". Keep them narrow — one task per file.
- Cross-link to `architecture/` when explaining the **why**, and to `reference/` for command syntax.
- If the procedure changes (e.g. ArgoCD chart bump introduces new values), update the relevant guide alongside the code change.

### Testing Requirements
- Verify steps still work after touching the corresponding Terraform file.

### Common Patterns
- Title is the task in imperative form ("Expose ArgoCD publicly", "Update namespaces").
- Include rollback / undo at the end.

## Dependencies

### Internal
- References `../../aks-foundation/argocd_public_ingress.tf`, `../../aks-foundation/aks_cluster_namespaces.tf`.

### External
- ArgoCD upstream docs.

<!-- MANUAL: -->
