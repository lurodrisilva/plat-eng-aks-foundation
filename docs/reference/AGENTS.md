<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-24 | Updated: 2026-04-24 -->

# docs/reference

## Purpose
Lookup-style reference material — command listings, configuration syntax, and module-level READMEs that are not meant to be read end-to-end.

## Key Files
| File | Description |
|------|-------------|
| `makefile.md` | Reference for every target in the parent `makefile` (`init`, `plan`, `apply`, `destroy`, `upgrade`, `rm-tfplan`) |
| `crossplane-readme.md` | Reference for the Crossplane bootstrap configuration (chart version, namespaces, ProviderConfig keys) |

## For AI Agents

### Working In This Directory
- Reference docs should mirror the code they document. When you change a Make target or bump the Crossplane chart version (`2.1.3` in `crossplane_argocd.tf`), update the matching reference doc.
- Keep tables ordered the same way as the code (alphabetical or by appearance — pick one and stick with it).

### Testing Requirements
- Spot-check every command in `makefile.md` runs.

### Common Patterns
- Tables for command/flag listings; code fences for example invocations.

## Dependencies

### Internal
- Mirrors `../../makefile` and `../../aks-foundation/crossplane_*.tf`.

### External
- None.

<!-- MANUAL: -->
