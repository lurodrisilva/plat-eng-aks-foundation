<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-24 | Updated: 2026-04-24 -->

# .devcontainer

## Purpose
VSCode dev container definition for a reproducible local environment with Terraform, Go, and Azure CLI preinstalled.

## Key Files
| File | Description |
|------|-------------|
| `devcontainer.json` | Uses `mcr.microsoft.com/azterraform:latest`; mounts host home folder and Docker socket; installs `hashicorp.terraform` and `golang.Go` VSCode extensions |

## For AI Agents

### Working In This Directory
- The image is `mcr.microsoft.com/azterraform:latest` — pin to a specific tag if you need reproducibility across machines.
- `--cap-add=SYS_PTRACE` and `seccomp=unconfined` are required for the Go debugger (`dlv`).
- The host home is mounted at `/host-home-folder` for credential reuse (Azure CLI cache, SSH keys).

### Testing Requirements
- Smoke-test by reopening the project in the container and running `terraform version` + `go version`.

### Common Patterns
- Add new VSCode extensions to the `extensions` array; settings to `settings`.

## Dependencies

### External
- `mcr.microsoft.com/azterraform` Docker image.

<!-- MANUAL: -->
