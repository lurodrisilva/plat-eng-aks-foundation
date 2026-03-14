# Crossplane on AKS - Quick Start Guide

## Prerequisites

- Azure CLI installed and authenticated
- kubectl installed
- Terraform >= 1.3
- Environment variable: `ARM_SUBSCRIPTION_ID`

## Deploy Everything

```bash
# Navigate to the project
cd aks-foundation

# Set required environment variable
export ARM_SUBSCRIPTION_ID="<your-subscription-id>"

# Initialize Terraform
terraform init

# Review what will be created
terraform plan

# Deploy (this creates AKS, ArgoCD, and Crossplane)
terraform apply -auto-approve
```

## Get AKS Credentials

```bash
az aks get-credentials --name aks-test --resource-group aks-test-rg
```

## Verify Installation

```bash
# Check all pods are running
kubectl get pods -n resources-system
kubectl get pods -n devops-system

# Check Crossplane installation
kubectl get providers -n resources-system

# Should show:
# - upbound-provider-family-azure (HEALTHY: True, INSTALLED: True)
# - provider-redis-azure (HEALTHY: True, INSTALLED: True)
```

## Get Credentials

```bash
# View Crossplane Service Principal credentials
terraform output crossplane_identity_client_id
terraform output crossplane_subscription_id
terraform output crossplane_tenant_id

# Get from Kubernetes secret (stores JSON with clientId, clientSecret, subscriptionId, tenantId)
kubectl get secret azure-crossplane-credentials -n resources-system -o yaml
```

## Test Crossplane

Create a test Redis instance:

```bash
kubectl apply -f - <<EOF
apiVersion: cache.azure.m.upbound.io/v1beta1
kind: ManagedRedis
metadata:
  name: test-redis
  namespace: resources-system
spec:
  forProvider:
    location: eastus
    resourceGroupName: aks-control-plane
    skuName: Balanced_B3
  providerConfigRef:
    kind: ClusterProviderConfig
    name: default
EOF
```

Monitor provisioning:

```bash
# Watch status
kubectl get managedredis test-redis -n resources-system -w

# Check detailed status
kubectl describe managedredis test-redis -n resources-system
```

## Troubleshooting

### Check Provider Logs

```bash
kubectl logs -n resources-system -l pkg.crossplane.io/provider=provider-azure-cache
```

### Verify Service Principal Authentication

```bash
# Check the credentials secret exists and has correct data
kubectl get secret azure-crossplane-credentials -n resources-system

# Verify secret contains expected keys (clientId, clientSecret, subscriptionId, tenantId)
kubectl get secret azure-crossplane-credentials -n resources-system \
  -o jsonpath='{.data}' | python3 -c "import sys,json,base64; d=json.load(sys.stdin); [print(k) for k in d]"
```

## Cleanup Test Resources

```bash
# Delete the test Redis instance
kubectl delete managedredis test-redis -n resources-system

# Wait for it to be deleted from Azure
kubectl get managedredis -n resources-system -w
```

## Teardown

```bash
# Delete all managed resources first
kubectl delete managedredis --all -n resources-system

# Destroy infrastructure
terraform destroy
```

## What Gets Created

### Azure Resources
- Azure AD App Registration: `azure-operators-sp`
- Service Principal with Contributor role at subscription level
- AKS Cluster: `aks-test`
- Resource Group: `aks-test-rg`

### Kubernetes Resources
- Namespace: `resources-system`
- Namespace: `devops-system`
- ArgoCD: Full installation
- Crossplane: Core installation (chart `2.1.3`)
- Azure Service Operator (ASO v2.17.0) deployment
- Providers: provider-family-azure, provider-azure-cache
- ClusterProviderConfig: Azure authentication using Secret credentials
- Secret: `azure-crossplane-credentials` with JSON credentials
- ASO controller settings secret

## Configuration Variables

Customize in `terraform.tfvars`:

```hcl
# Crossplane versions
crossplane_version                       = "2.1.3"  # chart version (hardcoded in ArgoCD manifest)
crossplane_provider_family_azure_version = "v2.3.0"
crossplane_provider_azure_cache_version  = "v2.3.0"

# AKS configuration
location         = "eastus"
kubernetes_version = "1.34"

# Other settings...
```

## Next Steps

1. Review the full documentation: [Crossplane Implementation Summary](../architecture/crossplane-implementation-summary.md)
2. Read troubleshooting guide: [Crossplane README](../reference/crossplane-readme.md)
3. Learn about Crossplane: [Crossplane Azure Workload Identity](../architecture/crossplane-azure-workload-identity.md)
4. Create your first Composition
5. Explore more Azure providers

## Support

For issues:
1. Check provider logs
2. Verify Service Principal credentials secret exists
3. Review Azure Service Principal permissions
4. Consult the troubleshooting guides

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                         Azure AD                             │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  App Registration: azure-operators-sp                │   │
│  │  Service Principal with Contributor role             │   │
│  │  (Subscription level)                                │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
                           ↕ Client Secret Authentication
┌─────────────────────────────────────────────────────────────┐
│                    AKS Cluster (aks-test)                    │
│                                                              │
│  ┌────────────────────────┐  ┌───────────────────────────┐ │
│  │  devops-system         │  │  resources-system         │ │
│  │                        │  │                           │ │
│  │  - ArgoCD              │  │  - Crossplane             │ │
│  │  - ArgoCD Projects     │  │  - Azure Providers        │ │
│  │  - ArgoCD Apps         │  │  - ClusterProviderConfig  │ │
│  └────────────────────────┘  │  - Credentials Secret     │ │
│                               │  - Managed Resources      │ │
│                               └───────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```
