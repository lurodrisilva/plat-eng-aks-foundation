<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-24 | Updated: 2026-04-24 -->

# test/e2e

## Purpose
End-to-end tests that provision real Azure infrastructure via the upstream `examples/startup` and `examples/without_monitor` example modules, then assert outputs and reachability. Slow and billable — gate behind CI credentials.

## Key Files
| File | Description |
|------|-------------|
| `terraform_aks_test.go` | `TestExamplesStartup` and `TestExamplesWithoutMonitor`; uses `retryablehttp` to probe endpoints; reads `MSI_ID` env for managed-identity testing |

## For AI Agents

### Working In This Directory
- `t.Parallel()` is used; tests can race for Azure quotas if you add more.
- `MSI_ID` env var, when present, is passed as `managed_identity_principal_id` — used for the BYO-identity flow.
- `client_id` / `client_secret` are explicitly set to empty strings so the module falls back to managed identity in CI.
- Examples paths (`examples/startup`, `examples/without_monitor`) reference upstream Azure module examples; if those aren't present locally the test will fail at `terraform init`.

### Testing Requirements
- Requires: Azure CLI logged in, `ARM_SUBSCRIPTION_ID`, sufficient quota for AKS clusters.
- Run: `go test ./e2e/ -v -timeout 90m` from `aks-foundation/test/`.
- Expect ~30–60 minutes per test for cluster provisioning + teardown.

### Common Patterns
- Output regex assertion: `assert.Regexp(t, regexp.MustCompile("/subscriptions/.+/managedClusters/.+"), aksId)`.
- HTTP probes use `retryablehttp` — keep retries reasonable to avoid masking failures.

## Dependencies

### Internal
- `../../examples/*` (upstream module examples; may not exist locally).

### External
- `terratest`, `terraform-module-test-helper`, `go-retryablehttp`, `testify`.
- Live Azure subscription with cluster-creation permissions.

<!-- MANUAL: -->
