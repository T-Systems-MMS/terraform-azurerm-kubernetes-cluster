output "kubernetes_cluster" {
  description = "azurerm_kubernetes_cluster results"
  value = {
    id                  = azurerm_kubernetes_cluster.kubernetes_cluster.id
    name                = azurerm_kubernetes_cluster.kubernetes_cluster.name
    kube_config         = azurerm_kubernetes_cluster.kubernetes_cluster.kube_config
    network_profile     = azurerm_kubernetes_cluster.kubernetes_cluster.network_profile
    node_resource_group = azurerm_kubernetes_cluster.kubernetes_cluster.node_resource_group
  }
}
