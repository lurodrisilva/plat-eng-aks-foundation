<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-24 | Updated: 2026-04-24 -->

# docs

## Purpose
Human-readable documentation for the AKS Terraform Foundation, organized by intent: setup (first-time install), guides (how-tos), architecture (design decisions), reference (lookup material).

## Key Files
| File | Description |
|------|-------------|
| `README.md` | Documentation index; routes readers to the right subdirectory |

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `setup/` | First-run installation walkthroughs (see `setup/AGENTS.md`) |
| `guides/` | Task-oriented how-to guides (see `guides/AGENTS.md`) |
| `architecture/` | Design decisions and architecture rationale (see `architecture/AGENTS.md`) |
| `reference/` | Lookup-style reference material (see `reference/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Each subdirectory has a clear intent — when adding a new doc, pick the directory based on **how the reader will consume it** (run-this-once vs. how-do-I-do-X vs. why-was-this-built-this-way vs. lookup).
- Cross-reference from the top-level `README.md` and from `docs/README.md` when adding a new file so it's discoverable.
- Use relative links (e.g. `[Quickstart](setup/quickstart.md)`) so the docs survive being mirrored.

### Testing Requirements
- No tests; verify links manually by clicking through, or via `markdownlint` / `lychee` if added later.

### Common Patterns
- File names are kebab-case (`crossplane-azure-workload-identity.md`).
- Headings use `# Title` for the document title and `##` for top-level sections.

## Dependencies

### Internal
- Cross-linked from `../README.md` (project root).

### External
- None — pure markdown.

<!-- MANUAL: -->
