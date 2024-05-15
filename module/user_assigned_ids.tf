resource "azurerm_user_assigned_identity" "aks" {
  name                = local.user_assigned_identity
  resource_group_name = azurerm_resource_group.aks_rg.name
  location            = var.location
}
