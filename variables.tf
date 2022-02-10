variable "kubernetes_cluster" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}

locals {
  default = {
    # resource definition
    kubernetes_cluster = {
      name                                = ""
      dns_prefix                          = ""
      node_resource_group                 = ""
      api_server_authorized_ip_ranges     = []
      local_account_disabled = false
      private_cluster_enabled = false
      private_cluster_public_fqdn_enabled = false
      sku_tier = "Free"
      role_based_access_control = {
        enabled = true
      }
      service_principal = {
        client_id = ""
      }
      identity = {
        type = ""
      }
      kubelet_identity = {
        client_id = ""
      }
      network_profile = {
        network_plugin    = "azure"
        load_balancer_sku = "standard"
      }
      default_node_pool = {
        name                   = ""
        availability_zones     = [1, 2, 3]
        enable_auto_scaling    = true
        enable_host_encryption = false
        enable_node_public_ip  = false
        type                   = "VirtualMachineScaleSets"
        node_count             = ""
        min_count              = ""
        max_count              = ""
        ultra_ssd_enabled      = false
        tags                   = {}
      }
      addon_profile = {
        aci_connector_linux = {
          enabled = false
        }
        azure_policy = {
          enabled = false
        }
        http_application_routing = {
          enabled = false
        }
        kube_dashboard = {
          enabled = false
        }
        oms_agent = {
          enabled = false
        }
      }
      linux_profile = {
        admin_username = ""
        ssh_key = {}
      }
    }
  }

  # compare and merge custom and default values
  kubernetes_cluster_values = {
    for kubernetes_cluster in keys(var.kubernetes_cluster) :
    kubernetes_cluster => merge(local.default.kubernetes_cluster, var.kubernetes_cluster[kubernetes_cluster])
  }
  # merge all custom and default values
  kubernetes_cluster = {
    for kubernetes_cluster in keys(var.kubernetes_cluster) :
    kubernetes_cluster => merge(
      local.kubernetes_cluster_values[kubernetes_cluster],
      {
        for config in ["role_based_access_control", "service_principal", "network_profile", "default_node_pool", "addon_profile"] :
        config => merge(local.default.kubernetes_cluster[config], local.kubernetes_cluster_values[kubernetes_cluster][config])
      }
    )
  }
}



