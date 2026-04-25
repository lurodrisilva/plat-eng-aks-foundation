<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-24 | Updated: 2026-04-24 -->

# unit-test-fixture

## Purpose
Minimal Terraform module that re-exports a curated subset of `aks-foundation/locals.tf` outputs, used by the unit-test suite to plan-test pure-locals logic without authenticating to Azure or instantiating any real resources.

## Key Files
| File | Description |
|------|-------------|
| `locals.tf` | **Symlink** → `../locals.tf` — share the module's locals verbatim |
| `variables.tf` | **Symlink** → `../variables.tf` — share the module's variable schema verbatim |
| `alt_locals.tf` | Stand-in values for `azurerm_log_analytics_workspace_*` locals normally produced by the resource (since the resource itself isn't created in the fixture) |
| `outputs.tf` | Exposes `create_analytics_solution`, `create_analytics_workspace`, `log_analytics_workspace`, `automatic_channel_upgrade_check`, `auto_scaler_profile_*` for unit tests to assert against |

## For AI Agents

### Working In This Directory
- **Do not edit `locals.tf` or `variables.tf` here** — they are symlinks to the parent module. Edit the originals in `aks-foundation/`.
- When adding a new local in `aks-foundation/locals.tf` that the unit tests need to assert, add a corresponding `output` block in `outputs.tf` here.
- If a new local depends on a resource that does not exist in the fixture (e.g. `azurerm_log_analytics_workspace.main[0].id`), add a stand-in value in `alt_locals.tf` to avoid `null` propagation breaking the plan.

### Testing Requirements
- Not directly testable; consumed by `test/unit/unit_test.go` via `RunUnitTest(t, "../../", "unit-test-fixture", ...)`.

### Common Patterns
- Keep this fixture tiny and side-effect-free. No `provider` blocks, no `resource` blocks beyond what's strictly required.

## Dependencies

### Internal
- `../locals.tf`, `../variables.tf` (symlinks).
- `../test/unit/` (consumer).

### External
- None.

<!-- MANUAL: -->
