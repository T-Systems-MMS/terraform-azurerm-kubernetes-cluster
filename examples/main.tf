module "kubernetes-cluster" {
  source              = "../modules/azure/terraform-kubernetes-cluster"
  location            = "westeurope"
  resource_group_name = "service-env-rg"
  resource_name       = "service-aks-cluster"
  kubernetes_cluster  = {
    dns_prefix = "service-aks-cluster"
    node_resource_group = "service-env-aks-rg"
  }
  kubernetes_cluster_config = {
    role_based_access_control = {}
    service_principal = {
      client_id = module.accounts.application["service-env-aks-cluster-app"].application_id
      client_secret = module.accounts.service_principal_password["service-env-aks-cluster-app"].value
    }
    network_profile   = {}
    default_node_pool = {
      name                = "poolserviceenv"
      node_count          = 2
      min_count           = 1
      max_count           = 4
      os_disk_size_gb     = 30
      vm_size             = "Standard_B2ms"
      vnet_subnet_id      = module.network.subnet.aks.id
      enable_auto_scaling = true
    }
    addon_profile = {
      oms_agent = {
        enabled                    = true
        log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
      }
    }
    role_assignment = {
      vnet_id      = module.network.virtual_network.id
      principal_id = module.accounts.service_principal["service-env-aks-cluster-app"].object_id
    }
  }
  tags = {
    service = "service_name"
  }
}
