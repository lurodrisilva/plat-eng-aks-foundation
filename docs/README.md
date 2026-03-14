# Documentation Index

Welcome to the AKS Terraform Foundation documentation. This index helps you find the right documentation for your needs.

## 📖 Documentation Structure

```
docs/
├── setup/          # Getting started and installation
├── guides/         # Step-by-step how-to guides
├── architecture/   # Architecture and design decisions
└── reference/      # Reference documentation
```

## 🚀 Getting Started

Start here if you're new to the project:

1. [**Quickstart Guide**](setup/quickstart.md) - Deploy your first AKS cluster in minutes
2. [**Makefile Reference**](reference/makefile.md) - Learn the available commands

## 📚 Documentation by Category

### Setup & Installation

| Document | Description |
|----------|-------------|
| [Quickstart Guide](setup/quickstart.md) | Complete guide to deploy AKS, ArgoCD, and Crossplane |

### How-To Guides

| Document | Description |
|----------|-------------|
| [ArgoCD Public Endpoint](guides/argocd-public-endpoint.md) | Expose ArgoCD through a public endpoint with DNS |
| [Namespace Update](guides/namespace-update.md) | Update and manage Kubernetes namespaces |

### Architecture & Design

| Document | Description |
|----------|-------------|
| [Crossplane Azure Workload Identity](architecture/crossplane-azure-workload-identity.md) | Deep dive into Workload Identity implementation |
| [Crossplane Implementation Summary](architecture/crossplane-implementation-summary.md) | Overview of Crossplane setup and configuration |

### Reference Documentation

| Document | Description |
|----------|-------------|
| [Makefile Reference](reference/makefile.md) | Complete reference for all Make targets |
| [Crossplane README](reference/crossplane-readme.md) | Crossplane configuration and troubleshooting |

## 🎯 Common Tasks

### I want to...

- **Deploy a new cluster** → [Quickstart Guide](setup/quickstart.md)
- **Understand the architecture** → [Architecture docs](architecture/)
- **Use Make commands** → [Makefile Reference](reference/makefile.md)
- **Expose ArgoCD publicly** → [ArgoCD Public Endpoint](guides/argocd-public-endpoint.md)
- **Configure Crossplane** → [Crossplane README](reference/crossplane-readme.md)
- **Deploy Azure Service Operator** → [Crossplane README](reference/crossplane-readme.md)
- **Troubleshoot issues** → Start with [Crossplane README](reference/crossplane-readme.md)

## 🔍 Quick Links

### Essential Commands

```bash
# Deploy infrastructure
make init ENV=dev
make plan
make apply

# Access ArgoCD
http://luciano-argocd.eastus.cloudapp.azure.com

# Get credentials
az aks get-credentials --name aks-test --resource-group aks-test-rg
```

### Key Terraform Files

Located in `../aks-foundation/`:

- `main.tf` - AKS cluster configuration
- `aks_addons_argocd.tf` - ArgoCD installation
- `argocd_public_ingress.tf` - Public endpoint setup
- `aso_argocd.tf` - Azure Service Operator deployment
- `crossplane_*.tf` - Crossplane configuration
- `aks_cluster_namespaces.tf` - Namespace definitions
- `vault.tf` - Vault installation

## 🆘 Getting Help

1. **Check the relevant guide** - Use the index above to find documentation
2. **Review logs** - Check Terraform output and Kubernetes logs
3. **Troubleshooting** - See [Crossplane README](reference/crossplane-readme.md) for common issues
4. **Architecture questions** - Review [Architecture docs](architecture/)

## 📝 Documentation Conventions

- **Code blocks** - Copy-paste ready commands
- **⚠️ Warnings** - Important notes about destructive operations
- **File paths** - Relative to project root unless specified
- **Prerequisites** - Listed at the beginning of each guide

## 🔄 Documentation Updates

This documentation is maintained alongside the code. When updating infrastructure:

1. Update relevant `.tf` files
2. Update documentation if behavior changes
3. Test all commands in documentation
4. Keep examples current

## 🤝 Contributing to Documentation

To improve documentation:

1. Fork the repository
2. Update or create markdown files in `docs/`
3. Update this index if adding new files
4. Submit a pull request

### Documentation Guidelines

- Use clear, concise language
- Include practical examples
- Test all commands before documenting
- Link to related documentation
- Keep formatting consistent

## 📂 Related Resources

- [Main README](../README.md) - Project overview
- [AKS Foundation README](../aks-foundation/README.md) - Terraform module docs
- [Makefile](../makefile) - Infrastructure commands

## 🏷️ Document Status

| Category | Files | Status |
|----------|-------|--------|
| Setup | 1 | ✅ Complete |
| Guides | 2 | ✅ Complete |
| Architecture | 2 | ✅ Complete |
| Reference | 2 | ✅ Complete |

Last updated: 2026-03-14

---

**Navigation**: [Back to Main README](../README.md)
