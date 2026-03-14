# AKS Terraform Foundation

A production-ready Azure Kubernetes Service (AKS) infrastructure with Crossplane, ArgoCD, and Vault, managed entirely with Terraform.

## 🚀 Quick Start

```bash
# Clone and navigate to the project
cd 03-plat-eng-aks-foundation

# Initialize and deploy
make init ENV=dev
make plan
make apply

# Get AKS credentials
az aks get-credentials --name aks-test --resource-group aks-test-rg
```

For detailed setup instructions, see the [Quickstart Guide](docs/setup/quickstart.md).

## 📋 Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Documentation](#documentation)
- [Project Structure](#project-structure)
- [Quick Reference](#quick-reference)
- [Contributing](#contributing)
- [License](#license)

## ✨ Features

### Infrastructure
- **Azure Kubernetes Service (AKS)**: Production-ready Kubernetes cluster
- **Multi-environment Support**: Separate workspaces for dev and production
- **Infrastructure as Code**: Complete Terraform configuration
- **Azure Integration**: Workload Identity, Azure CNI, managed identities

### Platform Services
- **ArgoCD**: GitOps continuous delivery
  - Public endpoint with Azure Public IP
  - DNS: `luciano-argocd.eastus.cloudapp.azure.com`
- **Crossplane**: Cloud-native control plane
  - Azure AD Service Principal authentication
  - Provider Family Azure and Provider Azure Cache
- **Azure Service Operator (ASO)**: Cloud-native Azure resource management (v2.17.0)
- **Vault**: Secrets management (HashiCorp Vault)

### Operations
- **Makefile Commands**: Simplified infrastructure management
- **Terraform Workspaces**: Environment isolation
- **Namespaced Resources**: Organized by system component
- **Logging & Monitoring**: Azure Log Analytics integration

## 🏗️ Architecture

This project implements a modern cloud-native platform on Azure:

```
┌─────────────────────────────────────────────────────────────────┐
│                         Azure Cloud                             │
│                                                                 │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                    AKS Cluster                             │ │
│  │                                                            │ │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │ │
│  │  │   ArgoCD     │  │ Crossplane+ASO│  │    Vault     │      │ │
│  │  │ devops-system│  │resources-sys │  │ devops-system│      │ │
│  │  └──────────────┘  └──────────────┘  └──────────────┘      │ │
│  │                                                            │ │
│  │  ┌──────────────────────────────────────────────────────┐  │ │
│  │  │              Application Namespaces                  │  │ │
│  │  │ jarvix • gateway • observability • pipeline • security │  │ │
│  │  │            test • storage • ai                       │  │ │
│  │  └──────────────────────────────────────────────────────┘  │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                 │
│  ┌───────────────┐  ┌────────────────-─┐  ┌─────────────────┐   │
│  │   Public IP   │  │ Service Principal│  │  Log Analytics  │   │
│  │   (ArgoCD)    │  │(Crossplane + ASO)│  │   Workspace     │   │
│  └───────────────┘  └─────────────────-┘  └─────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

For detailed architecture documentation, see:
- [Crossplane Azure Workload Identity](docs/architecture/crossplane-azure-workload-identity.md)
- [Crossplane Implementation Summary](docs/architecture/crossplane-implementation-summary.md)

## 📦 Prerequisites

- **Azure CLI**: Authenticated with appropriate subscription
- **Terraform**: >= 1.3
- **kubectl**: For Kubernetes cluster management
- **make**: For using Makefile commands
- **Azure Subscription**: With contributor permissions

### Required Environment Variables

```bash
export ARM_SUBSCRIPTION_ID="your-subscription-id"
```

## 📚 Documentation

### Setup & Getting Started
- [**Quickstart Guide**](docs/setup/quickstart.md) - Get up and running in minutes
- [**Makefile Reference**](docs/reference/makefile.md) - All available Make commands

### Guides
- [**ArgoCD Public Endpoint**](docs/guides/argocd-public-endpoint.md) - Expose ArgoCD publicly
- [**Namespace Update**](docs/guides/namespace-update.md) - Managing Kubernetes namespaces

### Architecture & Design
- [**Crossplane Azure Workload Identity**](docs/architecture/crossplane-azure-workload-identity.md)
- [**Crossplane Implementation Summary**](docs/architecture/crossplane-implementation-summary.md)

### Reference
- [**Crossplane README**](docs/reference/crossplane-readme.md) - Crossplane configuration details
- [**AKS Foundation README**](aks-foundation/README.md) - Terraform module documentation

## 📁 Project Structure

```
03-plat-eng-aks-foundation/
├── README.md                      # This file
├── makefile                       # Infrastructure management commands
├── .devcontainer/                 # Dev container configuration
├── .github/                       # CI/CD workflows
├── .checkov_config.yaml           # Checkov configuration
├── docs/                          # Documentation
│   ├── setup/                     # Setup and installation guides
│   │   └── quickstart.md
│   ├── guides/                    # How-to guides
│   │   ├── argocd-public-endpoint.md
│   │   └── namespace-update.md
│   ├── architecture/              # Architecture documentation
│   │   ├── crossplane-azure-workload-identity.md
│   │   └── crossplane-implementation-summary.md
│   └── reference/                 # Reference documentation
│       ├── makefile.md
│       └── crossplane-readme.md
├── aks-foundation/                # Terraform configuration
│   ├── main.tf                    # Main AKS cluster configuration
│   ├── variables.tf               # Input variables
│   ├── outputs.tf                 # Output values
│   ├── aks_addons_argocd.tf      # ArgoCD Helm installation
│   ├── aks_cluster_namespaces.tf # Kubernetes namespaces
│   ├── argocd_public_ingress.tf  # ArgoCD public endpoint
│   ├── aso_argocd.tf             # Azure Service Operator deployment
│   ├── crossplane_*.tf           # Crossplane configuration
│   ├── crossplane_managed_resources.tf
│   ├── extra_node_pool.tf
│   ├── role_assignments.tf
│   ├── locals.tf
│   ├── providers.tf
│   ├── versions.tf
│   ├── log_analytics.tf
│   ├── vault.tf                   # Vault installation
│   ├── unit-test-fixture/         # Unit test fixtures
│   └── ...                        # Additional configuration files
```

## ⚡ Quick Reference

### Common Commands

```bash
# Initialize for dev environment
make init

# Plan changes
make plan

# Apply changes
make apply

# Full upgrade cycle
make upgrade

# Switch to production
make init ENV=prd

# Destroy infrastructure (⚠️ careful!)
make destroy
```

### Access Services

```bash
# ArgoCD
URL: http://luciano-argocd.eastus.cloudapp.azure.com
Username: admin
Password: kubectl -n devops-system get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d

# Get AKS credentials
az aks get-credentials --name aks-test --resource-group aks-test-rg

# Check cluster status
kubectl get nodes
kubectl get pods -A
```

### Terraform Outputs

```bash
# View all outputs
terraform -chdir=./aks-foundation output

# Specific outputs
terraform -chdir=./aks-foundation output argocd_public_fqdn
terraform -chdir=./aks-foundation output crossplane_identity_client_id # App Registration Client ID
terraform -chdir=./aks-foundation output aks_name
```

## 🔧 Configuration

### Customize Variables

Edit `aks-foundation/terraform.tfvars` or create your own:

```hcl
# Environment
location = "eastus"
resource_group_name = "aks-test-rg"

# AKS Configuration
kubernetes_version = "1.34"
agents_count = 3
agents_size = "Standard_D2s_v3"

# Crossplane
crossplane_version = "2.1.3"
crossplane_provider_family_azure_version = "v2.3.0"

# ArgoCD
# Configured via Helm values in aks_addons_argocd.tf
```

## 🛠️ Development

### Local Development

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd 03-plat-eng-aks-foundation
   ```

2. **Set up Azure authentication**
   ```bash
   az login
   export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
   ```

3. **Initialize Terraform**
   ```bash
   make init ENV=dev
   ```

4. **Make changes and test**
   ```bash
   make plan
   # Review changes
   make apply
   ```

### Testing Changes

```bash
# Validate Terraform configuration
terraform -chdir=./aks-foundation validate

# Format Terraform files
terraform -chdir=./aks-foundation fmt -recursive

# Check for issues with checkov
checkov -d aks-foundation/
```

## 🔐 Security Considerations

- **Service Principal**: Crossplane and ASO use Azure AD Service Principal with client secret stored as Kubernetes Secret
- **RBAC**: Kubernetes RBAC enabled with Azure AD integration
- **Network Policies**: Configure as needed for your security requirements
- **Secrets Management**: Vault for application secrets
- **Public Endpoints**: ArgoCD exposed publicly - consider adding authentication/TLS

For production:
1. Enable TLS for ArgoCD
2. Configure network security groups
3. Implement Azure Firewall or Application Gateway
4. Enable Azure Policy for AKS
5. Configure backup and disaster recovery

## 📖 Additional Resources

- [Azure AKS Documentation](https://docs.microsoft.com/en-us/azure/aks/)
- [Crossplane Documentation](https://docs.crossplane.io/)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Terraform AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Authors

- Luciano Silva

## 🙏 Acknowledgments

- Azure AKS team for excellent Kubernetes service
- Crossplane community for cloud-native infrastructure management
- ArgoCD community for GitOps excellence
- Terraform community for infrastructure as code

---

**Note**: This is a reference implementation. Customize according to your organization's requirements and security policies.
