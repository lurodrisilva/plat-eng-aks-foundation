<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-24 | Updated: 2026-04-24 -->

# test/upgrade

## Purpose
Module-upgrade tests that exercise the provider/module version bump path: deploy with the previous major version, then re-apply with the current code, and assert the diff is non-destructive. Uses `test_helper.ModuleUpgradeTest`.

## Key Files
| File | Description |
|------|-------------|
| `upgrade_test.go` | `TestExampleUpgrade_startup`, `TestExampleUpgrade_without_monitor`; reads previous major version via `GetCurrentMajorVersionFromEnv` |

## For AI Agents

### Working In This Directory
- `test_helper.ModuleUpgradeTest(t, "Azure", "terraform-azurerm-aks", "examples/<name>", currentRoot, opts, currentMajorVersion)` checks out the previous major from GitHub and runs `apply` on it before applying the local code.
- Requires the env var that `GetCurrentMajorVersionFromEnv()` reads (typically `CURRENT_MAJOR_VERSION`); CI sets this from the latest published tag.
- Like e2e, this is slow and billable — ~60 minutes per test.

### Testing Requirements
- Live Azure subscription, `ARM_SUBSCRIPTION_ID`, optional `MSI_ID`.
- Run: `CURRENT_MAJOR_VERSION=v9 go test ./upgrade/ -v -timeout 120m` from `aks-foundation/test/`.

### Common Patterns
- Always pass `Upgrade: true` in `terraform.Options` so providers re-init cleanly between the previous and current apply.

## Dependencies

### Internal
- `../../examples/*` (upstream).

### External
- `terraform-module-test-helper`, `terratest`, `testify`.

<!-- MANUAL: -->
