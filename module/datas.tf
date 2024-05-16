data "azurerm_subscription" "current" {}

data "azuread_client_config" "current" {}

data "azurerm_virtual_network" "vnet_aks" {
  name                = var.vnet_aks_VV
  resource_group_name = var.vnet_rg_VV
}

data "azurerm_subnet" "akssubnet" {
  name                 = var.subnet_aks_VV
  virtual_network_name = var.vnet_aks_VV
  resource_group_name  = var.vnet_rg_VV
}

data "azurerm_private_dns_zone" "private_dns_zone" {
  name                = var.k8s_dns_zone_VV
  resource_group_name = local.k8s_dns_zone_rg
}
