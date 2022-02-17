module "kubernetes_cluster" {
  source = "registry.terraform.io/T-Systems-MMS/kubernete-cluster/azurerm"
  kubernetes_cluster = {
    env = {
      name                      = "service-env-aks-cluster"
      location                  = "westeurope"
      resource_group_name       = "service-env-rg"
      dns_prefix                = "service-env-aks-cluster"
      node_resource_group       = "service-env-aks-rg"
      role_based_access_control = {}
      service_principal = {
        client_id     = module.accounts.application["aks_application"].application_id
        client_secret = module.accounts.service_principal_password["aks_application"].value
      }
      network_profile = {}
      default_node_pool = {
        name                = "poolenv"
        node_count          = 2
        min_count           = 1
        max_count           = 4
        os_disk_size_gb     = 30
        vm_size             = "Standard_B2ms"
        vnet_subnet_id      = module.network.subnet.aks.id
        enable_auto_scaling = true
        tags = {
          service = "service_name"
        }
      }
      addon_profile = {
        oms_agent = {
          enabled                    = true
          log_analytics_workspace_id = "log_analytics_workspace.id"
        }
      }
      tags = {
        service = "service_name"
      }
    }
  }
}

