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
  node_resource_group                 = local.kubernetes_cluster[each.key].node_resource_group
  api_server_authorized_ip_ranges    = local.kubernetes_cluster[each.key].api_server_authorized_ip_ranges
  local_account_disabled = local.kubernetes_cluster[each.key].local_account_disabled
  private_cluster_enabled = local.kubernetes_cluster[each.key].private_cluster_enabled
  private_cluster_public_fqdn_enabled = local.kubernetes_cluster[each.key].private_cluster_public_fqdn_enabled
  sku_tier = local.kubernetes_cluster[each.key].sku_tier

  role_based_access_control {
    enabled = local.kubernetes_cluster[each.key].role_based_access_control.enabled
  }

  dynamic "service_principal" {
    for_each = local.kubernetes_cluster[each.key].service_principal.client_id != "" ? [1] : []
    content {
      client_id     = local.kubernetes_cluster[each.key].service_principal.client_id
      client_secret = local.kubernetes_cluster[each.key].service_principal.client_secret
    }
  }

  dynamic "identity" {
    for_each = local.kubernetes_cluster[each.key].identity.type == "SystemAssigned" ? [1] : []
    content {
      type     = local.kubernetes_cluster[each.key].identity.type
    }
  }

  dynamic "identity" {
    for_each = local.kubernetes_cluster[each.key].identity.type == "UserAssigned" ? [1] : []
    content {
      type     = local.kubernetes_cluster[each.key].identity.type
      user_assigned_identity_id = local.kubernetes_cluster[each.key].identity.user_assigned_identity_id
    }
  }

  dynamic "kubelet_identity" {
    for_each = local.kubernetes_cluster[each.key].kubelet_identity.client_id != "" ? [1] : []
    content {
      client_id     = local.kubernetes_cluster[each.key].kubelet_identity.client_id
      object_id = local.kubernetes_cluster[each.key].kubelet_identity.object_id
      user_assigned_identity_id = local.kubernetes_cluster[each.key].kubelet_identity.user_assigned_identity_id
    }
  }

  network_profile {
    network_plugin    = local.kubernetes_cluster[each.key].network_profile.network_plugin
    load_balancer_sku = local.kubernetes_cluster[each.key].network_profile.load_balancer_sku
  }

  dynamic "default_node_pool" {
    for_each = local.kubernetes_cluster[each.key].default_node_pool.enable_auto_scaling == true ? [1] : []
    content {
      name                   = local.kubernetes_cluster[each.key].default_node_pool.name == "" ? default_node_pool.key : local.kubernetes_cluster[each.key].default_node_pool.name
      vm_size                = local.kubernetes_cluster[each.key].default_node_pool.vm_size
      availability_zones     = local.kubernetes_cluster[each.key].default_node_pool.availability_zones
      enable_auto_scaling    = local.kubernetes_cluster[each.key].default_node_pool.enable_auto_scaling
      enable_host_encryption = local.kubernetes_cluster[each.key].default_node_pool.enable_host_encryption
      enable_node_public_ip  = local.kubernetes_cluster[each.key].default_node_pool.enable_node_public_ip
      os_disk_size_gb        = local.kubernetes_cluster[each.key].default_node_pool.os_disk_size_gb
      type                   = local.kubernetes_cluster[each.key].default_node_pool.type
      vnet_subnet_id         = local.kubernetes_cluster[each.key].default_node_pool.vnet_subnet_id
      min_count              = local.kubernetes_cluster[each.key].default_node_pool.min_count
      max_count              = local.kubernetes_cluster[each.key].default_node_pool.max_count
      ultra_ssd_enabled      = local.kubernetes_cluster[each.key].default_node_pool.ultra_ssd_enabled
      tags                   = local.kubernetes_cluster[each.key].default_node_pool.tags
    }
  }
  dynamic "default_node_pool" {
    for_each = local.kubernetes_cluster[each.key].default_node_pool.enable_auto_scaling == false ? [1] : []
    content {
      name                   = local.kubernetes_cluster[each.key].default_node_pool.name == "" ? default_node_pool.key : local.kubernetes_cluster[each.key].default_node_pool.name
      vm_size                = local.kubernetes_cluster[each.key].default_node_pool.vm_size
      availability_zones     = local.kubernetes_cluster[each.key].default_node_pool.availability_zones
      enable_auto_scaling    = local.kubernetes_cluster[each.key].default_node_pool.enable_auto_scaling
      enable_host_encryption = local.kubernetes_cluster[each.key].default_node_pool.enable_host_encryption
      enable_node_public_ip  = local.kubernetes_cluster[each.key].default_node_pool.enable_node_public_ip
      os_disk_size_gb        = local.kubernetes_cluster[each.key].default_node_pool.os_disk_size_gb
      type                   = local.kubernetes_cluster[each.key].default_node_pool.type
      vnet_subnet_id         = local.kubernetes_cluster[each.key].default_node_pool.vnet_subnet_id
      node_count             = local.kubernetes_cluster[each.key].default_node_pool.node_count
      max_count              = local.kubernetes_cluster[each.key].default_node_pool.max_count
      ultra_ssd_enabled      = local.kubernetes_cluster[each.key].default_node_pool.ultra_ssd_enabled
      tags                   = local.kubernetes_cluster[each.key].default_node_pool.tags
    }
  }

  addon_profile {
    aci_connector_linux {
      enabled = local.kubernetes_cluster[each.key].addon_profile.aci_connector_linux.enabled
    }
    azure_policy {
      enabled = local.kubernetes_cluster[each.key].addon_profile.azure_policy.enabled
    }
    http_application_routing {
      enabled = local.kubernetes_cluster[each.key].addon_profile.http_application_routing.enabled
    }
    kube_dashboard {
      enabled = local.kubernetes_cluster[each.key].addon_profile.kube_dashboard.enabled
    }

    dynamic "oms_agent" {
      for_each = local.kubernetes_cluster[each.key].addon_profile.oms_agent.enabled == true ? [1] : []
      content {
        enabled                    = local.kubernetes_cluster[each.key].addon_profile.oms_agent.enabled
        log_analytics_workspace_id = local.kubernetes_cluster[each.key].addon_profile.oms_agent.log_analytics_workspace_id
      }
    }
  }

  dynamic "linux_profile" {
    for_each = local.kubernetes_cluster[each.key].linux_profile.admin_username != "" ? [1] : []
    content {
      admin_username     = local.kubernetes_cluster[each.key].linux_profile.admin_username

      dynamic "ssh_key" {
        for_each = local.kubernetes_cluster[each.key].linux_profile.ssh_key
        content {
          key_data = local.kubernetes_cluster[each.key].linux_profile.ssh_key[ssh_key.key].key_data
        }
      }
    }
  }

  tags = local.kubernetes_cluster[each.key].tags
}
