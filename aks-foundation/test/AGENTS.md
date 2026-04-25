<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-24 | Updated: 2026-04-24 -->

# test

## Purpose
Go-based test suites for the Terraform module. Built on `gruntwork-io/terratest` and `Azure/terraform-module-test-helper`. Three flavors: **unit** (no Azure), **e2e** (real provisioning), **upgrade** (provider/module version-bump compatibility).

## Key Files
| File | Description |
|------|-------------|
| `go.mod` | Module path `github.com/Azure/terraform-azurerm-aks` (inherited from upstream); Go `1.23` toolchain `go1.24.1`; pins `terratest v0.48.2` and `terraform-module-test-helper v0.32.1` |

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `unit/` | Pure-locals unit tests against `unit-test-fixture/` (see `unit/AGENTS.md`) |
| `e2e/` | End-to-end tests against real Azure (see `e2e/AGENTS.md`) |
| `upgrade/` | Provider/module upgrade compatibility tests (see `upgrade/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- The Go module root is here, **not** at the repo root. Run `go test ./unit/ -v` from inside `test/` (or use `go test ./test/unit/ -v` from `aks-foundation/`).
- The module path is inherited from the upstream Azure module (`github.com/Azure/terraform-azurerm-aks`). Do not rename — `terraform-module-test-helper` and `ModuleUpgradeTest` derive paths from it.
- Tests reference `examples/startup` and `examples/without_monitor` — those examples come from upstream and may not exist locally. E2E tests will fail without them; treat e2e as optional/CI-only unless examples are checked in.

### Testing Requirements
- Run a single unit test: `go test ./unit/ -v -run TestDisableLogAnalyticsWorkspaceShouldNotCreateWorkspaceNorSolution`.
- E2E and upgrade need: Azure CLI auth, optional `MSI_ID` env var for managed identity, network access to the upstream module on GitHub.
- Always commit `go.mod` and `go.sum` together if you add a dependency.

### Common Patterns
- Tests use `test_helper.RunUnitTest(t, "../../", "unit-test-fixture", terraform.Options{Vars: ...}, callback)` — first arg is module dir, second is fixture name relative to it.
- Vars are built by a `dummyRequiredVariables()` helper in the unit test file; reuse it when adding tests.
- E2E tests assert against output regex patterns (e.g. `/subscriptions/.+/managedClusters/.+`) rather than exact IDs.

## Dependencies

### Internal
- `../unit-test-fixture/` — fixture root used by unit tests.
- `../*.tf` — module under test (`../../` relative path inside test files).

### External
- `github.com/Azure/terraform-module-test-helper v0.32.1`
- `github.com/gruntwork-io/terratest v0.48.2`
- `github.com/stretchr/testify v1.11.1`

<!-- MANUAL: -->
