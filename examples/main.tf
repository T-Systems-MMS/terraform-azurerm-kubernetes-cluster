module "kubernetes_cluster" {
  source = "registry.terraform.io/T-Systems-MMS/kubernete-cluster/azurerm"
  kubernetes_cluster = {
    env = {
      name                            = "service-env-aks-cluster"
      location                        = "westeurope"
      resource_group_name             = "service-env-rg"
      dns_prefix                      = "service-env-aks-cluster"
      api_server_authorized_ip_ranges = []
      node_resource_group             = "service-env-aks-rg"
      service_principal = {
        client_id     = module.accounts.application["aks_application"].application_id
        client_secret = module.accounts.service_principal_password["aks_application"].value
      }
      default_node_pool = {
        name            = "poolenv"
        node_count      = 2
        os_disk_size_gb = 30
        vm_size         = "Standard_B2ms"
        vnet_subnet_id  = module.network.subnet.aks.id
        tags = {
          service = "service_name"
        }
      }
      oms_agent = {
        log_analytics_workspace_id = "log_analytics_workspace.id"
      }
      tags = {
        service = "service_name"
      }
    }
  }
}

