locals {
  resource_group_name            = "${var.name_VV}-rg"
  key_vault_key_name             = "${var.name_VV}-vaultkey1"
  disk_encryption_set            = "${var.name_VV}-disk-encryption-set"
  log_analytics_workspace_name   = "${var.name_VV}-log-analytics-workspace"
  aks_node_pool_name             = "snp"
  temporary_np_name_for_rotation = "tnp"
  windows_node_pood_name_prefix  = "wnp"
  linux_node_pood_name_prefix    = "lnp"
  acr_user_assigned_identity     = "${var.name_VV}-uai"
  user_assigned_identity         = "${var.name_VV}-aks-uai"
  zone_group                     = "${var.name_VV}-zone-group"
  aks_private_connection         = "${var.name_VV}-private-connection"
  container_insights             = "${var.name_VV}-container_insights"
  disk_crypto_key                = "${var.name_VV}-disk-vaultkey"
  k8s_dns_zone_rg                = "${var.k8s_dns_zone_VV}-rg"
  use_kv                         = var.kv_VV != ""
  use_appgw                      = var.appgw_VV != ""
}

resource "azurerm_resource_group" "aks_rg" {
  name     = local.resource_group_name
  location = var.location_VV
}

resource "azurerm_role_assignment" "dns_contributor" {
  scope                = data.azurerm_private_dns_zone.private_dns_zone.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_role_assignment" "network_contributor" {
  scope                = data.azurerm_virtual_network.vnet_aks.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                             = var.name_VV
  location                         = var.location_VV
  kubernetes_version               = var.kubernetes_version_VV
  resource_group_name              = azurerm_resource_group.aks_rg.name
  dns_prefix                       = var.dns_prefix_VV
  private_cluster_enabled          = true
  http_application_routing_enabled = false
  azure_policy_enabled             = true
  private_dns_zone_id              = data.azurerm_private_dns_zone.private_dns_zone.id
  oidc_issuer_enabled              = var.oidc_issuer_enabled_VV
  workload_identity_enabled        = var.workload_identity_enabled_VV
  tags                             = var.tags_VV


  default_node_pool {
    name                        = local.aks_node_pool_name
    node_count                  = var.system_node_pool_config_VV.node_count
    vm_size                     = var.system_node_pool_config_VV.vm_size
    type                        = "VirtualMachineScaleSets"
    enable_auto_scaling         = var.system_node_pool_config_VV.enable_auto_scaling
    os_disk_size_gb             = var.system_node_pool_config_VV.os_disk_size_gb
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
    load_balancer_sku = var.loadbalancer_sku_VV
    network_policy    = var.network_policy_VV
  }
}

resource "azurerm_user_assigned_identity" "aks" {
  name                = local.user_assigned_identity
  resource_group_name = azurerm_resource_group.aks_rg.name
  location            = var.location_VV
}

resource "azurerm_kubernetes_cluster_node_pool" "win_np" {
  count                 = var.number_of_windows_node_pools_VV
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  name                  = "${local.windows_node_pood_name_prefix}${count.index}"
  node_count            = var.windows_node_pool_config_VV[count.index].node_count
  vm_size               = var.windows_node_pool_config_VV[count.index].vm_size
  enable_auto_scaling   = var.windows_node_pool_config_VV[count.index].enable_auto_scaling
  zones                 = [1, 2, 3]
  mode                  = "User"
  orchestrator_version  = var.kubernetes_version_VV
  os_disk_size_gb       = var.windows_node_pool_config_VV[count.index].os_disk_size_gb
  os_type               = "Windows"
  vnet_subnet_id        = data.azurerm_subnet.akssubnet.id
  priority              = "Regular"                                                # Default is Regular, we can change to Spot with additional settings like eviction_policy, spot_max_price, node_labels and node_taints
  node_labels           = var.windows_node_pool_config_VV[count.index].node_labels # contains(keys(var.windows_node_pool_config), "node_labels") ? var.windows_node_pool_config.node_labels : null
  node_taints           = var.windows_node_pool_config_VV[count.index].node_taints
  tags                  = var.windows_node_pool_config_VV[count.index].tags # contains(keys(var.windows_node_pool_config), "tags") ? var.windows_node_pool_config.tags : null
}

resource "azurerm_kubernetes_cluster_node_pool" "linux_np" {
  count                 = var.number_of_linux_node_pools_VV
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  name                  = "${local.linux_node_pood_name_prefix}${count.index}"
  node_count            = var.linux_node_pool_config_VV[count.index].node_count
  vm_size               = var.linux_node_pool_config_VV[count.index].vm_size
  enable_auto_scaling   = var.linux_node_pool_config_VV[count.index].enable_auto_scaling
  zones                 = [1, 2, 3]
  mode                  = "User"
  orchestrator_version  = var.kubernetes_version_VV
  os_disk_size_gb       = var.linux_node_pool_config_VV[count.index].os_disk_size_gb
  os_type               = "Linux"
  vnet_subnet_id        = data.azurerm_subnet.akssubnet.id
  priority              = "Regular"                                              # Default is Regular, we can change to Spot with additional settings like eviction_policy, spot_max_price, node_labels and node_taints
  node_labels           = var.linux_node_pool_config_VV[count.index].node_labels # contains(keys(var.linux_node_pool_config), "node_labels") ? var.linux_node_pool_config.node_labels : null
  node_taints           = var.linux_node_pool_config_VV[count.index].node_taints
  tags                  = var.linux_node_pool_config_VV[count.index].tags # contains(keys(var.linux_node_pool_config), "tags") ? var.linux_node_pool_config.tags : null
}
