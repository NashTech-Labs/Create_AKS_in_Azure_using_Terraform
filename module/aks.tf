resource "azurerm_kubernetes_cluster" "aks" {
  name                             = var.name
  location                         = var.location
  kubernetes_version               = var.kubernetes_version
  resource_group_name              = azurerm_resource_group.aks_rg.name
  dns_prefix                       = var.dns_prefix
  private_cluster_enabled          = true
  http_application_routing_enabled = false
  azure_policy_enabled             = true
  private_dns_zone_id              = data.azurerm_private_dns_zone.private_dns_zone.id
  oidc_issuer_enabled              = var.oidc_issuer_enabled
  workload_identity_enabled        = var.workload_identity_enabled
  tags = var.tags


  default_node_pool {
    name                        = local.aks_node_pool_name
    node_count                  = var.system_node_pool_config.node_count
    vm_size                     = var.system_node_pool_config.vm_size
    type                        = "VirtualMachineScaleSets"
    enable_auto_scaling         = var.system_node_pool_config.enable_auto_scaling
    os_disk_size_gb             = var.system_node_pool_config.os_disk_size_gb
    vnet_subnet_id              = data.azurerm_subnet.akssubnet.id
    temporary_name_for_rotation = local.temporary_np_name_for_rotation
    zones                       = [1, 2, 3]
  }


  azure_active_directory_role_based_access_control {
    managed            = true
    azure_rbac_enabled = true
  }


  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }


  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = var.loadbalancer_sku
    network_policy    = var.network_policy
  }
}
