<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-24 | Updated: 2026-04-24 -->

# test/unit

## Purpose
Unit tests that exercise the module's `locals.tf` logic without touching Azure. Each test mutates one variable and asserts the resulting `local.*` outputs from `unit-test-fixture/outputs.tf`.

## Key Files
| File | Description |
|------|-------------|
| `unit_test.go` | Test cases for log-analytics workspace resolution, auto-channel-upgrade validation, scaler scan-interval defaults; defines `dummyRequiredVariables()` |

## For AI Agents

### Working In This Directory
- Tests run via `test_helper.RunUnitTest(t, "../../", "unit-test-fixture", ...)` — the second arg is the fixture directory inside the module root.
- Adding a new locals branch in `aks-foundation/locals.tf`? Mirror it with a unit test here and a corresponding output in `unit-test-fixture/outputs.tf`.
- These tests do **not** require Azure credentials — they only run `terraform init/plan` against the fixture.

### Testing Requirements
- Run all: `go test ./... -v` from `aks-foundation/test/`.
- Run one: `go test ./unit/ -v -run TestName`.

### Common Patterns
- Start each test by calling `dummyRequiredVariables()` then setting only the var-of-interest.
- Assert with `output["<name>"].(<type>)` — type assertion + `assert.True(t, ok)` is the convention.

## Dependencies

### Internal
- `../../unit-test-fixture/` — provides outputs the tests assert against.
- `../../locals.tf`, `../../variables.tf` — symlinked into the fixture.

### External
- `terraform-module-test-helper`, `terratest`, `testify`.

<!-- MANUAL: -->
