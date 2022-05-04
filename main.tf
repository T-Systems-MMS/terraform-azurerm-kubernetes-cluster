/**
 * # kubernetes_cluster
 *
 * This module manages Azure Kubernetes Cluster.
 *
*/
resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
  for_each = var.kubernetes_cluster

  name                                = local.kubernetes_cluster[each.key].name == "" ? each.key : local.kubernetes_cluster[each.key].name
  location                            = local.kubernetes_cluster[each.key].location
  resource_group_name                 = local.kubernetes_cluster[each.key].resource_group_name
  dns_prefix                          = local.kubernetes_cluster[each.key].dns_prefix
  dns_prefix_private_cluster          = local.kubernetes_cluster[each.key].dns_prefix_private_cluster
  automatic_channel_upgrade           = local.kubernetes_cluster[each.key].automatic_channel_upgrade
  api_server_authorized_ip_ranges     = local.kubernetes_cluster[each.key].api_server_authorized_ip_ranges
  azure_policy_enabled                = local.kubernetes_cluster[each.key].azure_policy_enabled
  disk_encryption_set_id              = local.kubernetes_cluster[each.key].disk_encryption_set_id
  http_application_routing_enabled    = local.kubernetes_cluster[each.key].http_application_routing_enabled
  kubernetes_version                  = local.kubernetes_cluster[each.key].kubernetes_version == null ? data.azurerm_kubernetes_service_versions.kubernetes_service_versions[each.key].latest_version : local.kubernetes_cluster[each.key].kubernetes_version
  local_account_disabled              = local.kubernetes_cluster[each.key].local_account_disabled
  node_resource_group                 = local.kubernetes_cluster[each.key].node_resource_group
  oidc_issuer_enabled                 = local.kubernetes_cluster[each.key].oidc_issuer_enabled
  open_service_mesh_enabled           = local.kubernetes_cluster[each.key].open_service_mesh_enabled
  private_cluster_enabled             = local.kubernetes_cluster[each.key].private_cluster_enabled
  private_dns_zone_id                 = local.kubernetes_cluster[each.key].private_dns_zone_id
  private_cluster_public_fqdn_enabled = local.kubernetes_cluster[each.key].private_cluster_public_fqdn_enabled
  public_network_access_enabled       = local.kubernetes_cluster[each.key].public_network_access_enabled
  role_based_access_control_enabled   = local.kubernetes_cluster[each.key].role_based_access_control_enabled
  sku_tier                            = local.kubernetes_cluster[each.key].sku_tier

  dynamic "aci_connector_linux" {
    for_each = local.kubernetes_cluster[each.key].aci_connector_linux.subnet_name != "" ? [1] : []

    content {
      subnet_name = local.kubernetes_cluster[each.key].aci_connector_linux.subnet_name
    }
  }

  default_node_pool {
    name                         = local.kubernetes_cluster[each.key].default_node_pool.name == "" ? each.key : local.kubernetes_cluster[each.key].default_node_pool.name
    vm_size                      = local.kubernetes_cluster[each.key].default_node_pool.vm_size
    enable_auto_scaling          = local.kubernetes_cluster[each.key].default_node_pool.enable_auto_scaling
    max_count                    = local.kubernetes_cluster[each.key].default_node_pool.enable_auto_scaling == true ? local.kubernetes_cluster[each.key].default_node_pool.max_count : null
    min_count                    = local.kubernetes_cluster[each.key].default_node_pool.enable_auto_scaling == true ? local.kubernetes_cluster[each.key].default_node_pool.min_count : null
    node_count                   = local.kubernetes_cluster[each.key].default_node_pool.node_count
    enable_host_encryption       = local.kubernetes_cluster[each.key].default_node_pool.enable_host_encryption
    enable_node_public_ip        = local.kubernetes_cluster[each.key].default_node_pool.enable_node_public_ip
    fips_enabled                 = local.kubernetes_cluster[each.key].default_node_pool.fips_enabled
    kubelet_disk_type            = local.kubernetes_cluster[each.key].default_node_pool.kubelet_disk_type
    max_pods                     = local.kubernetes_cluster[each.key].default_node_pool.max_pods
    node_public_ip_prefix_id     = local.kubernetes_cluster[each.key].default_node_pool.node_public_ip_prefix_id
    node_labels                  = local.kubernetes_cluster[each.key].default_node_pool.node_labels
    only_critical_addons_enabled = local.kubernetes_cluster[each.key].default_node_pool.only_critical_addons_enabled
    orchestrator_version         = local.kubernetes_cluster[each.key].default_node_pool.orchestrator_version == null ? data.azurerm_kubernetes_service_versions.kubernetes_service_versions[each.key].latest_version : local.kubernetes_cluster[each.key].default_node_pool.orchestrator_version
    os_disk_size_gb              = local.kubernetes_cluster[each.key].default_node_pool.os_disk_size_gb
    os_disk_type                 = local.kubernetes_cluster[each.key].default_node_pool.os_disk_type
    os_sku                       = local.kubernetes_cluster[each.key].default_node_pool.os_sku
    pod_subnet_id                = local.kubernetes_cluster[each.key].default_node_pool.pod_subnet_id
    type                         = local.kubernetes_cluster[each.key].default_node_pool.type
    ultra_ssd_enabled            = local.kubernetes_cluster[each.key].default_node_pool.ultra_ssd_enabled
    vnet_subnet_id               = local.kubernetes_cluster[each.key].default_node_pool.vnet_subnet_id
    zones                        = local.kubernetes_cluster[each.key].default_node_pool.enable_auto_scaling == true ? null : local.kubernetes_cluster[each.key].default_node_pool.zones

    dynamic "kubelet_config" {
      for_each = local.kubernetes_cluster[each.key].default_node_pool.kubelet_config != {} ? [1] : []

      content {
        allowed_unsafe_sysctls    = local.kubernetes_cluster[each.key].default_node_pool.kubelet_config.allowed_unsafe_sysctls
        container_log_max_line    = local.kubernetes_cluster[each.key].default_node_pool.kubelet_config.container_log_max_line
        container_log_max_size_mb = local.kubernetes_cluster[each.key].default_node_pool.kubelet_config.container_log_max_size_mb
        cpu_cfs_quota_enabled     = local.kubernetes_cluster[each.key].default_node_pool.kubelet_config.cpu_cfs_quota_enabled
        cpu_cfs_quota_period      = local.kubernetes_cluster[each.key].default_node_pool.kubelet_config.cpu_cfs_quota_period
        cpu_manager_policy        = local.kubernetes_cluster[each.key].default_node_pool.kubelet_config.cpu_manager_policy
        image_gc_high_threshold   = local.kubernetes_cluster[each.key].default_node_pool.kubelet_config.image_gc_high_threshold
        image_gc_low_threshold    = local.kubernetes_cluster[each.key].default_node_pool.kubelet_config.image_gc_low_threshold
        pod_max_pid               = local.kubernetes_cluster[each.key].default_node_pool.kubelet_config.pod_max_pid
        topology_manager_policy   = local.kubernetes_cluster[each.key].default_node_pool.kubelet_config.topology_manager_policy
      }
    }

    dynamic "linux_os_config" {
      for_each = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config != {} ? [1] : []

      content {
        swap_file_size_mb             = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.swap_file_size_mb
        transparent_huge_page_defrag  = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.transparent_huge_page_defrag
        transparent_huge_page_enabled = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.transparent_huge_page_enabled
      }
    }

    dynamic "upgrade_settings" {
      for_each = local.kubernetes_cluster[each.key].default_node_pool.upgrade_settings.max_surge != "" ? [1] : []

      content {
        max_surge = local.kubernetes_cluster[each.key].default_node_pool.upgrade_settings.max_surge
      }
    }

    tags = local.kubernetes_cluster[each.key].default_node_pool.tags
  }

  dynamic "service_principal" {
    for_each = local.kubernetes_cluster[each.key].service_principal != {} ? [1] : []

    content {
      client_id     = local.kubernetes_cluster[each.key].service_principal.client_id
      client_secret = local.kubernetes_cluster[each.key].service_principal.client_secret
    }
  }

  dynamic "identity" {
    for_each = local.kubernetes_cluster[each.key].identity.type != "" ? [1] : []

    content {
      type         = local.kubernetes_cluster[each.key].identity.type
      identity_ids = local.kubernetes_cluster[each.key].identity.identity_ids
    }
  }

  dynamic "auto_scaler_profile" {
    for_each = local.kubernetes_cluster[each.key].default_node_pool.enable_auto_scaling == true ? [1] : []
    content {
      balance_similar_node_groups      = local.kubernetes_cluster[each.key].auto_scaler_profile.balance_similar_node_groups
      expander                         = local.kubernetes_cluster[each.key].auto_scaler_profile.expander
      max_graceful_termination_sec     = local.kubernetes_cluster[each.key].auto_scaler_profile.max_graceful_termination_sec
      max_node_provisioning_time       = local.kubernetes_cluster[each.key].auto_scaler_profile.max_node_provisioning_time
      max_unready_nodes                = local.kubernetes_cluster[each.key].auto_scaler_profile.max_unready_nodes
      max_unready_percentage           = local.kubernetes_cluster[each.key].auto_scaler_profile.max_unready_percentage
      new_pod_scale_up_delay           = local.kubernetes_cluster[each.key].auto_scaler_profile.new_pod_scale_up_delay
      scale_down_delay_after_add       = local.kubernetes_cluster[each.key].auto_scaler_profile.scale_down_delay_after_add
      scale_down_delay_after_delete    = local.kubernetes_cluster[each.key].auto_scaler_profile.scale_down_delay_after_delete
      scale_down_delay_after_failure   = local.kubernetes_cluster[each.key].auto_scaler_profile.scale_down_delay_after_failure
      scan_interval                    = local.kubernetes_cluster[each.key].auto_scaler_profile.scan_interval
      scale_down_unneeded              = local.kubernetes_cluster[each.key].auto_scaler_profile.scale_down_unneeded
      scale_down_unready               = local.kubernetes_cluster[each.key].auto_scaler_profile.scale_down_unready
      scale_down_utilization_threshold = local.kubernetes_cluster[each.key].auto_scaler_profile.scale_down_utilization_threshold
      empty_bulk_delete_max            = local.kubernetes_cluster[each.key].auto_scaler_profile.empty_bulk_delete_max
      skip_nodes_with_local_storage    = local.kubernetes_cluster[each.key].auto_scaler_profile.skip_nodes_with_local_storage
      skip_nodes_with_system_pods      = local.kubernetes_cluster[each.key].auto_scaler_profile.skip_nodes_with_system_pods
    }
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = local.kubernetes_cluster[each.key].azure_active_directory_role_based_access_control.managed != null ? [1] : []

    content {
      managed                = local.kubernetes_cluster[each.key].azure_active_directory_role_based_access_control.managed
      tenant_id              = local.kubernetes_cluster[each.key].azure_active_directory_role_based_access_control.tenant_id
      admin_group_object_ids = local.kubernetes_cluster[each.key].azure_active_directory_role_based_access_control.admin_group_object_ids
      azure_rbac_enabled     = local.kubernetes_cluster[each.key].azure_active_directory_role_based_access_control.azure_rbac_enabled
    }
  }

  dynamic "http_proxy_config" {
    for_each = local.kubernetes_cluster[each.key].http_proxy_config.http_proxy != null || local.kubernetes_cluster[each.key].http_proxy_config.https_proxy != null ? [1] : []

    content {
      http_proxy  = local.kubernetes_cluster[each.key].http_proxy_config.http_proxy
      https_proxy = local.kubernetes_cluster[each.key].http_proxy_config.https_proxy
      no_proxy    = local.kubernetes_cluster[each.key].http_proxy_config.no_proxy
      trusted_ca  = local.kubernetes_cluster[each.key].http_proxy_config.trusted_ca
    }
  }

  dynamic "ingress_application_gateway" {
    for_each = local.kubernetes_cluster[each.key].ingress_application_gateway.effective_gateway_id != "" ? [1] : []

    content {
      effective_gateway_id = local.kubernetes_cluster[each.key].ingress_application_gateway.effective_gateway_id

      ingress_application_gateway_identity {
        client_id                 = local.kubernetes_cluster[each.key].ingress_application_gateway.effective_gateway_id.ingress_application_gateway_identity.client_id
        object_id                 = local.kubernetes_cluster[each.key].ingress_application_gateway.effective_gateway_id.ingress_application_gateway_identity.object_id
        user_assigned_identity_id = local.kubernetes_cluster[each.key].ingress_application_gateway.effective_gateway_id.ingress_application_gateway_identity.user_assigned_identity_id
      }
    }
  }

  dynamic "key_vault_secrets_provider" {
    for_each = local.kubernetes_cluster[each.key].key_vault_secrets_provider.secret_rotation_enabled != "false" ? [1] : []

    content {
      secret_rotation_enabled  = local.kubernetes_cluster[each.key].key_vault_secrets_provider.secret_rotation_enabled
      secret_rotation_interval = local.kubernetes_cluster[each.key].key_vault_secrets_provider.secret_rotation_interval
    }
  }

  dynamic "kubelet_identity" {
    for_each = local.kubernetes_cluster[each.key].kubelet_identity != {} ? [1] : []

    content {
      client_id                 = local.kubernetes_cluster[each.key].kubelet_identity.client_id
      object_id                 = local.kubernetes_cluster[each.key].kubelet_identity.object_id
      user_assigned_identity_id = local.kubernetes_cluster[each.key].kubelet_identity.user_assigned_identity_id
    }
  }

  dynamic "linux_profile" {
    for_each = local.kubernetes_cluster[each.key].linux_profile.admin_username != "" ? [1] : []

    content {
      admin_username = local.kubernetes_cluster[each.key].linux_profile.admin_username

      ssh_key {
          key_data = local.kubernetes_cluster[each.key].linux_profile.ssh_key.key_data
      }
    }
  }

  dynamic "maintenance_window" {
    for_each = local.kubernetes_cluster[each.key].maintenance_window.allowed != {} || local.kubernetes_cluster[each.key].maintenance_window.not_allowed != {} ? [1] : []

    content {
      dynamic "allowed" {
        for_each = local.kubernetes_cluster[each.key].maintenance_window.allowed != {} ? [1] : []

        content {
          day = local.kubernetes_cluster[each.key].maintenance_window.allowed[allowed.key].day
          hours = local.kubernetes_cluster[each.key].maintenance_window.allowed[allowed.key].hours
        }
      }
      dynamic "not_allowed" {
        for_each = local.kubernetes_cluster[each.key].maintenance_window.not_allowed != {} ? [1] : []

        content {
          end = local.kubernetes_cluster[each.key].maintenance_window.not_allowed[not_allowed.key].end
          start = local.kubernetes_cluster[each.key].maintenance_window.not_allowed[not_allowed.key].start
        }
      }
    }
  }

  dynamic "microsoft_defender" {
    for_each = local.kubernetes_cluster[each.key].microsoft_defender.log_analytics_workspace_id != "" ? [1] : []

    content {
      log_analytics_workspace_id = local.kubernetes_cluster[each.key].microsoft_defender.log_analytics_workspace_id
    }
  }

  dynamic "network_profile" {
    for_each = local.kubernetes_cluster[each.key].network_profile.network_plugin != "" ? [1] : []

    content {
      network_plugin     = local.kubernetes_cluster[each.key].network_profile.network_plugin
      network_mode       = local.kubernetes_cluster[each.key].network_profile.network_mode
      network_policy     = local.kubernetes_cluster[each.key].network_profile.network_policy
      dns_service_ip     = local.kubernetes_cluster[each.key].network_profile.dns_service_ip
      docker_bridge_cidr = local.kubernetes_cluster[each.key].network_profile.docker_bridge_cidr
      outbound_type      = local.kubernetes_cluster[each.key].network_profile.outbound_type
      pod_cidr           = local.kubernetes_cluster[each.key].network_profile.pod_cidr
      service_cidr       = local.kubernetes_cluster[each.key].network_profile.service_cidr
      ip_versions        = local.kubernetes_cluster[each.key].network_profile.ip_versions
      load_balancer_sku  = local.kubernetes_cluster[each.key].network_profile.load_balancer_sku

      load_balancer_profile {
        idle_timeout_in_minutes   = local.kubernetes_cluster[each.key].network_profile.load_balancer_profile.idle_timeout_in_minutes
        managed_outbound_ip_count = local.kubernetes_cluster[each.key].network_profile.load_balancer_profile.managed_outbound_ip_count
        outbound_ip_address_ids   = local.kubernetes_cluster[each.key].network_profile.load_balancer_profile.outbound_ip_address_ids
        outbound_ip_prefix_ids    = local.kubernetes_cluster[each.key].network_profile.load_balancer_profile.outbound_ip_prefix_ids
        outbound_ports_allocated  = local.kubernetes_cluster[each.key].network_profile.load_balancer_profile.outbound_ports_allocated
      }

      dynamic "nat_gateway_profile" {
        for_each = local.kubernetes_cluster[each.key].network_profile.nat_gateway_profile != {} ? [1] : []

        content {
          idle_timeout_in_minutes   = local.kubernetes_cluster[each.key].network_profile.nat_gateway_profile.idle_timeout_in_minutes
          managed_outbound_ip_count = local.kubernetes_cluster[each.key].network_profile.nat_gateway_profile.managed_outbound_ip_count
        }
      }
    }
  }

  dynamic "oms_agent" {
    for_each = local.kubernetes_cluster[each.key].oms_agent.log_analytics_workspace_id != "" ? [1] : []

    content {
      log_analytics_workspace_id = local.kubernetes_cluster[each.key].oms_agent.log_analytics_workspace_id
    }
  }

  dynamic "windows_profile" {
    for_each = local.kubernetes_cluster[each.key].windows_profile.admin_username != "" ? [1] : []

    content {
      admin_username = local.kubernetes_cluster[each.key].windows_profile.admin_username
      admin_password = local.kubernetes_cluster[each.key].windows_profile.admin_password
      license        = local.kubernetes_cluster[each.key].windows_profile.license
    }
  }

  tags = local.kubernetes_cluster[each.key].tags
}
