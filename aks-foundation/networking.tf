################################################################################
# Virtual Network
################################################################################

resource "azurerm_virtual_network" "aks" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space

  tags = var.tags
}

################################################################################
# Subnets
################################################################################

resource "azurerm_subnet" "aks_nodes" {
  name                 = var.aks_nodes_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = var.aks_nodes_subnet_prefix
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = var.private_endpoints_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = var.private_endpoints_subnet_prefix

  # Required for private endpoint deployment in this subnet
  private_endpoint_network_policies = "Disabled"
}
