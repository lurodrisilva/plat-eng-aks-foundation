# Crossplane Configuration for AKS

This Terraform configuration deploys Crossplane on Azure Kubernetes Service (AKS) with Azure Service Principal authentication.

## Architecture Overview

The implementation consists of:

1. **Azure Infrastructure** (`crossplane_infrastructure.tf`):
   - Azure AD App Registration: `azure-operators-sp`
   - Service Principal: Created from app registration with Contributor role
   - Subscription-level Contributor role assignment

2. **Kubernetes Resources** (`crossplane_argocd.tf`):
   - ArgoCD Application for Crossplane installation
   - Provider installations (provider-family-azure, provider-azure-cache)
   - ClusterProviderConfig for Azure authentication using Secret credentials
   - Kubernetes Secret with JSON credentials

## Resources Created

### Azure Resources

- **App Registration**: `azure-operators-sp`
  - Azure AD application used as the identity for Crossplane and ASO

- **Service Principal**: Created from app registration with Contributor role
  - Permissions: Contributor role at subscription level

### Kubernetes Resources

All resources are deployed in the `resources-system` namespace:

- **ArgoCD Application**: `crossplane`
  - Helm chart from Crossplane stable repository
  - Chart version `2.1.3` (hardcoded in ArgoCD manifest)

- **Providers**:
  - `upbound-provider-family-azure` (version from `var.crossplane_provider_family_azure_version`)
  - `provider-redis-azure` (version from `var.crossplane_provider_azure_cache_version`)

- **ClusterProviderConfig**: `default`
  - Uses Secret source for authentication
  - References `azure-crossplane-credentials` secret

- **Secret**: `azure-crossplane-credentials`
  - Stores JSON credentials: `clientId`, `clientSecret`, `subscriptionId`, `tenantId`

- **ASO controller settings secret**
  - Reuses the same Service Principal credentials for Azure Service Operator

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `crossplane_version` | Version of Crossplane chart (hardcoded at `2.1.3` in ArgoCD manifest) | `2.1.3` |
| `crossplane_provider_family_azure_version` | Version of provider-family-azure | `v2.3.0` |
| `crossplane_provider_azure_cache_version` | Version of provider-azure-cache | `v2.3.0` |

## Outputs

| Output | Description |
|--------|-------------|
| `crossplane_identity_client_id` | The Client ID of the Crossplane app registration |
| `crossplane_identity_principal_id` | The Principal ID of the Crossplane service principal |
| `crossplane_subscription_id` | The Azure Subscription ID used by Crossplane |
| `crossplane_tenant_id` | The Azure Tenant ID used by Crossplane |

## Prerequisites

1. AKS cluster configured

2. ArgoCD installed and configured in `devops-system` namespace

3. Environment variables:
   - `ARM_SUBSCRIPTION_ID`: Azure subscription ID

## Deployment Order

The Terraform configuration ensures proper dependency ordering:

1. Azure infrastructure (App Registration, Service Principal, Role Assignment)
2. AKS cluster and namespaces
3. ArgoCD installation and configuration
4. Crossplane ArgoCD Application (deployed to `control-plane-system` namespace)
5. Provider installations
6. ClusterProviderConfig
7. Credentials secret

## Service Principal Authentication

The implementation uses an Azure AD Service Principal with client secret:

- **App Registration**: `azure-operators-sp` created in Azure AD
- **Service Principal**: Gets Contributor role at subscription level
- **Client Secret**: Stored as Kubernetes Secret `azure-crossplane-credentials`
- **ClusterProviderConfig**: References the secret for authentication

### How It Works

1. Terraform creates an Azure AD App Registration and Service Principal
2. A client secret is generated and stored as a Kubernetes Secret
3. The secret contains JSON with `clientId`, `clientSecret`, `subscriptionId`, and `tenantId`
4. The `ClusterProviderConfig` references this secret using `credentials.source: Secret`
5. Providers authenticate using the client secret credentials
6. Azure Service Operator (ASO v2.17.0) reuses the same Service Principal

## Verifying the Installation

### Check Crossplane Installation

```bash
kubectl get pods -n resources-system
kubectl get providers -n resources-system
```

### Verify Service Principal Authentication

```bash
# Check the credentials secret exists
kubectl get secret azure-crossplane-credentials -n resources-system

# Verify ClusterProviderConfig is healthy
kubectl get clusterproviderconfig default
kubectl describe clusterproviderconfig default
```

### Test with a Managed Resource

```bash
kubectl apply -f - <<EOF
apiVersion: cache.azure.m.upbound.io/v1beta1
kind: ManagedRedis
metadata:
  name: example-redis
  namespace: resources-system
spec:
  forProvider:
    location: East US
    resourceGroupName: aks-control-plane
    skuName: Balanced_B3
  providerConfigRef:
    kind: ClusterProviderConfig
    name: default
EOF

# Check status
kubectl get managedredis example-redis -n resources-system
```

## Troubleshooting

### Provider Not Healthy

```bash
kubectl describe provider upbound-provider-family-azure -n resources-system
kubectl logs -n resources-system -l pkg.crossplane.io/provider=provider-azure
```

### Authentication Issues

1. Verify the credentials secret exists and has correct keys:
   ```bash
   kubectl get secret azure-crossplane-credentials -n resources-system -o yaml
   ```

2. Verify Service Principal has correct permissions:
   ```bash
   az ad sp show --id <client-id>
   az role assignment list --assignee <client-id>
   ```

3. Check ClusterProviderConfig status:
   ```bash
   kubectl get clusterproviderconfig default -o yaml
   kubectl describe clusterproviderconfig default
   ```

### ClusterProviderConfig Not Working

```bash
kubectl get clusterproviderconfig default -o yaml
kubectl describe clusterproviderconfig default
```

## Cleanup

To remove Crossplane and all related resources:

```bash
# Delete managed resources first
kubectl delete managedredis --all -n resources-system

# Terraform will handle the rest
terraform destroy
```

## References

- [Crossplane Documentation](https://docs.crossplane.io/)
- [Upbound Azure Provider](https://marketplace.upbound.io/providers/upbound/provider-family-azure/)
- [Crossplane Azure Workload Identity Guide](../architecture/crossplane-azure-workload-identity.md)
