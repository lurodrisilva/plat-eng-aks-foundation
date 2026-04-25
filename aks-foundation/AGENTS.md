<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-24 | Updated: 2026-04-24 -->

# aks-foundation

## Purpose
Terraform root module. Provisions the AKS cluster, supporting Azure resources (VNet, subnets, private DNS zones, log analytics, role assignments, public IP for ArgoCD), and bootstraps in-cluster platform: ArgoCD, Crossplane (via ArgoCD Application), Vault, and the Azure Service Principal + Kubernetes secrets that Crossplane and ASO consume. The Makefile in the parent directory always invokes Terraform here via `terraform -chdir=./aks-foundation`.

## Key Files

### Cluster & infrastructure
| File | Description |
|------|-------------|
| `main.tf` | `azurerm_kubernetes_cluster.main` resource and SSH key generation (largest file; ~37k) |
| `variables.tf` | Module input variables (~91k — many AKS knobs surfaced) |
| `outputs.tf` | Module outputs (cluster identity client ID, FQDNs, ArgoCD endpoint, etc.) |
| `locals.tf` | Cross-cutting locals: workspace logic, log analytics resolution, subnet flattening, validation regexes |
| `providers.tf` | Provider config: `azurerm`, `azuread` (CLI auth), `kubernetes`/`helm`/`kubectl` wired to the AKS kubeconfig |
| `versions.tf` | Required Terraform `>= 1.3` and pinned provider versions |
| `networking.tf` | VNet + AKS-nodes subnet + private-endpoints subnet (with `private_endpoint_network_policies = "Disabled"`) |
| `private_dns.tf` | One private DNS zone per Azure service from `var.private_dns_zone_names` + VNet links (`registration_enabled = false`) |
| `log_analytics.tf` | Log Analytics Workspace, ContainerInsights solution, Data Collection Rule + association |
| `extra_node_pool.tf` | Additional node pool definitions driven by `var.node_pools` |
| `role_assignments.tf` | Kubelet-identity AcrPull, network-contributor on subnets, App Gateway role wiring |

### Platform bootstrap (in-cluster)
| File | Description |
|------|-------------|
| `aks_cluster_namespaces.tf` | Defines `local.namespaces` map and creates 11 namespaces; `resources-system` is labeled `azure.workload.identity/use=true` |
| `aks_addons_argocd.tf` | Helm-installs ArgoCD `8.1.0`; HA enabled only in `prd` workspace; defines `addons-project` AppProject |
| `argocd_public_ingress.tf` | Static `azurerm_public_ip` + `Service/argocd-server-public` LoadBalancer in `devops-system`. DNS label is suffixed by workspace to dodge Azure's 24h reservation hold |
| `vault.tf` | Helm-installs HashiCorp Vault `0.31.0` with HA + Raft + injector |
| `crossplane_infrastructure.tf` | Creates `azuread_application/service_principal/password` (display name `azure-operators-sp`) and grants subscription-level `Contributor` |
| `crossplane_argocd.tf` | ArgoCD `Application` for Crossplane chart `2.1.3`; creates Kubernetes secret `azure-crossplane-credentials` and the default `ProviderConfig`. Provider CRs are owned by the ArgoCD `providers` app — not duplicated here |
| `aso_argocd.tf` | Creates the `aso-controller-settings` Secret in `resources-system` reusing the Crossplane SP. The ASO ArgoCD Application is currently commented out |
| `crossplane_managed_resources.tf` | Example `ManagedRedis` (commented; reference only) |

### Test / fixtures / utilities
| File | Description |
|------|-------------|
| `tfvmmakefile` | Variant Makefile (likely VM/legacy variant — keep until owner confirms removal) |
| `AppProjectFullSample.yml`, `ApplicationFullSample.yml` | Reference ArgoCD samples — not applied by Terraform |
| `README.md` | Upstream `terraform-azurerm-aks` module README (~120k) — historical reference for module-level inputs |
| `tfplan` | Generated plan binary — should be in `.gitignore`, not committed |
| `.terraform.lock.hcl`, `.terraform/` | Provider lockfile and download cache |

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `test/` | Go + Terratest suites: unit, e2e, upgrade (see `test/AGENTS.md`) |
| `unit-test-fixture/` | Stub fixture used by unit tests to avoid hitting Azure (see `unit-test-fixture/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- **Do not** run `terraform` directly with `cd aks-foundation && terraform plan`. Always go via the parent Makefile: `make plan ENV=dev`. The Makefile manages workspace selection and tfplan lifecycle.
- Provider versions are pinned in `versions.tf`; never bump without a corresponding `make plan` and a check that nothing in the destroy plan looks suspicious.
- The `kubernetes`, `helm`, and `kubectl` providers are wired via `kube_config[0]` of the AKS resource — adding/removing the cluster forces them to re-init. If you change cluster auth (e.g. enable `local_account_disabled`), update `providers.tf` accordingly.
- `terraform.workspace` is consulted in `aks_addons_argocd.tf` and `argocd_public_ingress.tf`. Be aware that the public IP DNS label is `${var.argocd_domain_name_label}-${terraform.workspace}` — this is intentional to survive Azure's 24h DNS-label reservation.
- The Crossplane Service Principal display name is the literal string `azure-operators-sp` (shared with ASO). Do not rename without coordinated cleanup of the App Registration.
- `time_sleep` resources gate ArgoCD/Crossplane sync (`wait_for_crossplane_argocd_sync`, `interval_before_crossplane_installation`, `wait_for_crossplane_provider_crds`). Tune via `var.argocd_app_wait_timeout_seconds` / `var.interval_before_crossplane_installation` rather than removing the gates.
- Crossplane provider CRs are intentionally **not** declared here — they're managed by the ArgoCD `providers` application in `00-baseline-addons/addon_charts/providers`. Adding `kubectl_manifest` Provider resources here will duplicate the package in Crossplane's dependency graph and break every provider in the family. See the comment block in `crossplane_argocd.tf`.

### Testing Requirements
- `cd test && go test ./unit/ -v` for fast unit tests against the fixture (no Azure needed).
- E2E in `test/e2e/` and upgrade in `test/upgrade/` provision real Azure resources — require `MSI_ID` and Azure auth; expect them to be slow and billable.
- Format: `terraform -chdir=. fmt -recursive` (or `terraform fmt -recursive` from this directory).
- Lint: `checkov -d .` from the parent directory.

### Common Patterns
- New cluster-bootstrap component → add a top-level `<component>.tf` here; create namespace via `kubernetes_namespace.namespaces` (or extend `local.namespaces` in `aks_cluster_namespaces.tf`); install via `helm_release` or `kubectl_manifest`; depend on `azurerm_kubernetes_cluster.main`.
- New ArgoCD-managed component → prefer adding a `kubectl_manifest` ArgoCD `Application` rather than another `helm_release`, so GitOps owns the lifecycle.
- New private DNS zone → just append the zone name to `var.private_dns_zone_names`. Resources are `for_each`'d.
- Crossplane managed-resource examples should be commented out (see `crossplane_managed_resources.tf` pattern) — real instances are managed by GitOps.

## Dependencies

### Internal
- Parent Makefile drives all entrypoints.
- `unit-test-fixture/` consumes `locals.tf` and `variables.tf` via symlinks for unit tests.

### External
- Azure: AKS, AzureAD (App Registrations), Public IP, Log Analytics, Container Insights, Private DNS Zones.
- Helm charts: ArgoCD `8.1.0`, Vault `0.31.0`, Crossplane `2.1.3`.
- Pinned providers (see `versions.tf`).

<!-- MANUAL: -->
