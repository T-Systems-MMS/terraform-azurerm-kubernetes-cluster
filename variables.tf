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
      dns_prefix                          = null
      dns_prefix_private_cluster          = null
      automatic_channel_upgrade           = null
      azure_policy_enabled                = false
      disk_encryption_set_id              = null
      http_application_routing_enabled    = false
      kubernetes_version                  = null
      local_account_disabled              = false
      node_resource_group                 = null
      oidc_issuer_enabled                 = false
      open_service_mesh_enabled           = null
      private_cluster_enabled             = false
      private_dns_zone_id                 = null
      private_cluster_public_fqdn_enabled = false
      public_network_access_enabled       = true
      role_based_access_control_enabled   = true
      sku_tier                            = "Free"
      aci_connector_linux = {
        subnet_name = ""
      }
      default_node_pool = {
        name                         = ""
        enable_auto_scaling          = true
        max_count                    = 10
        min_count                    = 2
        node_count                   = 2
        zones                        = [1, 2, 3]
        enable_host_encryption       = false
        enable_node_public_ip        = false
        fips_enabled                 = false
        kubelet_disk_type            = null
        max_pods                     = null
        node_public_ip_prefix_id     = null
        node_labels                  = null
        only_critical_addons_enabled = null
        orchestrator_version         = null
        os_disk_size_gb              = null
        os_disk_type                 = "Ephemeral"
        os_sku                       = "Ubuntu"
        pod_subnet_id                = null
        type                         = "VirtualMachineScaleSets"
        ultra_ssd_enabled            = false
        vnet_subnet_id               = null
        kubelet_config               = {
          allowed_unsafe_sysctls = null
          container_log_max_line = null
          container_log_max_size_mb = null
          cpu_cfs_quota_enabled = null
          cpu_cfs_quota_period = null
          cpu_manager_policy = null
          image_gc_high_threshold = null
          image_gc_low_threshold = null
          pod_max_pid = null
          topology_manager_policy = null
        }
        linux_os_config              = {
          swap_file_size_mb = null
          transparent_huge_page_defrag = null
          transparent_huge_page_enabled = null
          sysctl_config = {}
        }
        upgrade_settings             = {
          max_surge = ""
        }
        tags                         = {}
      }
      service_principal = {}
      identity = {
        type         = ""
        identity_ids = null
      }
      auto_scaler_profile = {
        balance_similar_node_groups      = false
        expander                         = "random"
        max_graceful_termination_sec     = 600
        max_node_provisioning_time       = "15m"
        max_unready_nodes                = 2
        max_unready_percentage           = 45
        new_pod_scale_up_delay           = "10s"
        scale_down_delay_after_add       = "10m"
        scale_down_delay_after_delete    = "scan_interval"
        scale_down_delay_after_failure   = "2m"
        scan_interval                    = "10s"
        scale_down_unneeded              = "10m"
        scale_down_unready               = "10m"
        scale_down_utilization_threshold = "0.5"
        empty_bulk_delete_max            = 10
        skip_nodes_with_local_storage    = true
        skip_nodes_with_system_pods      = true
      }
      azure_active_directory_role_based_access_control = {
        managed                = null
        tenant_id              = null
        admin_group_object_ids = null
        azure_rbac_enabled     = null
      }
      http_proxy_config = {
        http_proxy  = null
        https_proxy = null
        no_proxy    = null
        trusted_ca  = null
      }
      ingress_application_gateway = {
        effective_gateway_id                 = ""
        ingress_application_gateway_identity = {}
      }
      key_vault_secrets_provider = {
        secret_rotation_enabled  = "false"
        secret_rotation_interval = "2m"
      }
      kubelet_identity = {}
      linux_profile = {
        admin_username = ""
        ssh_key        = {
          key_data = ""
        }
      }
      maintenance_window = {
        allowed     = {}
        not_allowed = {}
      }
      microsoft_defender = {
        log_analytics_workspace_id = ""
      }
      network_profile = {
        network_plugin        = ""
        network_mode          = null
        network_policy        = "azure"
        dns_service_ip        = null
        docker_bridge_cidr    = null
        outbound_type         = "loadBalancer"
        pod_cidr              = null
        service_cidr          = null
        ip_versions           = "IPv4"
        load_balancer_sku     = "standard"
        load_balancer_profile = {
          idle_timeout_in_minutes  = 30
          managed_outbound_ip_count  = 1
          outbound_ip_address_ids = null
          outbound_ip_prefix_ids = null
          outbound_ports_allocated = 0
        }
        nat_gateway_profile   = {
          idle_timeout_in_minutes = 4
          managed_outbound_ip_count = 1
        }
      }
      oms_agent = {
        log_analytics_workspace_id = ""
      }
      windows_profile = {
        admin_username = ""
        license        = "Windows_Server"
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
        for config in [
          "aci_connector_linux",
          "default_node_pool",
          "service_principal",
          "identity",
          "auto_scaler_profile",
          "azure_active_directory_role_based_access_control",
          "http_proxy_config",
          "ingress_application_gateway",
          "key_vault_secrets_provider",
          "kubelet_identity",
          "linux_profile",
          "maintenance_window",
          "microsoft_defender",
          "network_profile",
          "oms_agent",
          "windows_profile"
        ] :
        config => merge(local.default.kubernetes_cluster[config], local.kubernetes_cluster_values[kubernetes_cluster][config])
      }
    )
  }
}
