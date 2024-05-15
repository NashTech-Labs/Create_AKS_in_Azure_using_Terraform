resource "azurerm_kubernetes_cluster_node_pool" "win_np" {
  count                 = var.number_of_windows_node_pools
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  name                  = "${local.windows_node_pood_name_prefix}${count.index}"
  node_count            = var.windows_node_pool_config[count.index].node_count
  vm_size               = var.windows_node_pool_config[count.index].vm_size
  enable_auto_scaling   = var.windows_node_pool_config[count.index].enable_auto_scaling
  zones                 = [1, 2, 3]
  mode                  = "User"
  orchestrator_version  = var.kubernetes_version
  os_disk_size_gb       = var.windows_node_pool_config[count.index].os_disk_size_gb
  os_type               = "Windows"
  vnet_subnet_id        = data.azurerm_subnet.akssubnet.id
  priority              = "Regular"                                             # Default is Regular, we can change to Spot with additional settings like eviction_policy, spot_max_price, node_labels and node_taints
  node_labels           = var.windows_node_pool_config[count.index].node_labels # contains(keys(var.windows_node_pool_config), "node_labels") ? var.windows_node_pool_config.node_labels : null
  node_taints           = var.windows_node_pool_config[count.index].node_taints
  tags                  = var.windows_node_pool_config[count.index].tags # contains(keys(var.windows_node_pool_config), "tags") ? var.windows_node_pool_config.tags : null
}

resource "azurerm_kubernetes_cluster_node_pool" "linux_np" {
  count                 = var.number_of_linux_node_pools
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  name                  = "${local.linux_node_pood_name_prefix}${count.index}"
  node_count            = var.linux_node_pool_config[count.index].node_count
  vm_size               = var.linux_node_pool_config[count.index].vm_size
  enable_auto_scaling   = var.linux_node_pool_config[count.index].enable_auto_scaling
  zones                 = [1, 2, 3]
  mode                  = "User"
  orchestrator_version  = var.kubernetes_version
  os_disk_size_gb       = var.linux_node_pool_config[count.index].os_disk_size_gb
  os_type               = "Linux"
  vnet_subnet_id        = data.azurerm_subnet.akssubnet.id
  priority              = "Regular"                                           # Default is Regular, we can change to Spot with additional settings like eviction_policy, spot_max_price, node_labels and node_taints
  node_labels           = var.linux_node_pool_config[count.index].node_labels # contains(keys(var.linux_node_pool_config), "node_labels") ? var.linux_node_pool_config.node_labels : null
  node_taints           = var.linux_node_pool_config[count.index].node_taints
  tags                  = var.linux_node_pool_config[count.index].tags # contains(keys(var.linux_node_pool_config), "tags") ? var.linux_node_pool_config.tags : null
}
