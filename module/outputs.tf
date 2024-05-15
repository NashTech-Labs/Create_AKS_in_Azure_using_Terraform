output "id" {
  value = azurerm_kubernetes_cluster.aks.id
}

output "aks_kubelet_identity" {
  value = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "node_resource_group" {
  value = azurerm_kubernetes_cluster.aks.node_resource_group
}

output "cluster_resource_group" {
  value = azurerm_resource_group.aks_rg.name
}

output "ua_managed_identity_id" {
  value = azurerm_user_assigned_identity.aks.principal_id
}
