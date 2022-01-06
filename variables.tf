variable "resource_name" {
  type    = string
  description = "Azure Kubernetes Cluster"
}
variable "location" {
  type        = string
  description = "location where the resource should be created"
}
variable "resource_group_name" {
  type        = string
  description = "resource_group whitin the resource should be created"
}
variable "tags" {
  type        = any
  default     = {}
  description = "mapping of tags to assign, default settings are defined within locals and merged with var settings"
}
# resource definition
variable "kubernetes_cluster" {
  type    = any
  default = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
# resource configuration
variable "kubernetes_cluster_config" {
  type    = any
  default = {}
  description = "resource configuration, default settings are defined within locals and merged with var settings"
}

locals {
  default = {
    tags = {}
    # resource definition
    kubernetes_cluster = {
      private_cluster_public_fqdn_enabled = false
      node_resource_group    = ""
    }
    # resource configuration
    kubernetes_cluster_config = {
      role_based_access_control = {
        enabled = true
      }
      service_principal = {}
      network_profile = {
        network_plugin    = "azure"
        load_balancer_sku = "standard"
      }
      default_node_pool = {
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
      role_assignment = {}
    }
  }

  # merge custom and default values
  tags               = merge(local.default.tags, var.tags)
  kubernetes_cluster = merge(local.default.kubernetes_cluster, var.kubernetes_cluster)

  # deep merge custom and default values
  kubernetes_cluster_config = {
    # get all config
    for config in keys(local.default.kubernetes_cluster_config) :
    config => merge(local.default.kubernetes_cluster_config[config], var.kubernetes_cluster_config[config])
  }
}



