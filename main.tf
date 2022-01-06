/**
 * # kubernetes_cluster
 *
 * This module manages Azure Kubernetes Cluster.
 *
*/
resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
  name                                = var.resource_name
  location                            = var.location
  resource_group_name                 = var.resource_group_name
  dns_prefix                          = local.kubernetes_cluster.dns_prefix
  private_cluster_public_fqdn_enabled = local.kubernetes_cluster.private_cluster_public_fqdn_enabled
  node_resource_group    = local.kubernetes_cluster.node_resource_group

  role_based_access_control {
    enabled = local.kubernetes_cluster_config.role_based_access_control.enabled
  }

  service_principal {
    client_id     = local.kubernetes_cluster_config.service_principal.client_id
    client_secret = local.kubernetes_cluster_config.service_principal.client_secret
  }

  network_profile {
    network_plugin    = local.kubernetes_cluster_config.network_profile.network_plugin
    load_balancer_sku = local.kubernetes_cluster_config.network_profile.load_balancer_sku
  }

  dynamic "default_node_pool" {
    for_each = local.kubernetes_cluster_config.default_node_pool.enable_auto_scaling == true ? [1] : []
    content {
      name                   = local.kubernetes_cluster_config.default_node_pool.name
      vm_size                = local.kubernetes_cluster_config.default_node_pool.vm_size
      availability_zones     = local.kubernetes_cluster_config.default_node_pool.availability_zones
      enable_auto_scaling    = local.kubernetes_cluster_config.default_node_pool.enable_auto_scaling
      enable_host_encryption = local.kubernetes_cluster_config.default_node_pool.enable_host_encryption
      enable_node_public_ip  = local.kubernetes_cluster_config.default_node_pool.enable_node_public_ip
      os_disk_size_gb        = local.kubernetes_cluster_config.default_node_pool.os_disk_size_gb
      type                   = local.kubernetes_cluster_config.default_node_pool.type
      vnet_subnet_id         = local.kubernetes_cluster_config.default_node_pool.vnet_subnet_id
      min_count              = local.kubernetes_cluster_config.default_node_pool.min_count
      max_count              = local.kubernetes_cluster_config.default_node_pool.max_count
      ultra_ssd_enabled      = local.kubernetes_cluster_config.default_node_pool.ultra_ssd_enabled
      tags                   = {
        for tag in keys(local.kubernetes_cluster_config.default_node_pool.tags) :
        tag => local.kubernetes_cluster_config.default_node_pool.tags[tag]
      }
    }
  }
  dynamic "default_node_pool" {
    for_each = local.kubernetes_cluster_config.default_node_pool.enable_auto_scaling == false ? [1] : []
    content {
      name                   = local.kubernetes_cluster_config.default_node_pool.name
      vm_size                = local.kubernetes_cluster_config.default_node_pool.vm_size
      availability_zones     = local.kubernetes_cluster_config.default_node_pool.availability_zones
      enable_auto_scaling    = local.kubernetes_cluster_config.default_node_pool.enable_auto_scaling
      enable_host_encryption = local.kubernetes_cluster_config.default_node_pool.enable_host_encryption
      enable_node_public_ip  = local.kubernetes_cluster_config.default_node_pool.enable_node_public_ip
      os_disk_size_gb        = local.kubernetes_cluster_config.default_node_pool.os_disk_size_gb
      type                   = local.kubernetes_cluster_config.default_node_pool.type
      vnet_subnet_id         = local.kubernetes_cluster_config.default_node_pool.vnet_subnet_id
      node_count             = local.kubernetes_cluster_config.default_node_pool.node_count
      max_count              = local.kubernetes_cluster_config.default_node_pool.max_count
      ultra_ssd_enabled      = local.kubernetes_cluster_config.default_node_pool.ultra_ssd_enabled
      tags                   = {
        for tag in keys(local.kubernetes_cluster_config.default_node_pool.tags) :
        tag => local.kubernetes_cluster_config.default_node_pool.tags[tag]
      }
    }
  }

  // default_node_pool {
  //   name                   = local.kubernetes_cluster_config.default_node_pool.name
  //   vm_size                = local.kubernetes_cluster_config.default_node_pool.vm_size
  //   availability_zones     = local.kubernetes_cluster_config.default_node_pool.availability_zones
  //   enable_auto_scaling    = local.kubernetes_cluster_config.default_node_pool.enable_auto_scaling
  //   enable_host_encryption = local.kubernetes_cluster_config.default_node_pool.enable_host_encryption
  //   enable_node_public_ip  = local.kubernetes_cluster_config.default_node_pool.enable_node_public_ip
  //   os_disk_size_gb        = local.kubernetes_cluster_config.default_node_pool.os_disk_size_gb
  //   type                   = local.kubernetes_cluster_config.default_node_pool.type
  //   vnet_subnet_id         = local.kubernetes_cluster_config.default_node_pool.vnet_subnet_id
  //   node_count             = local.kubernetes_cluster_config.default_node_pool.node_count == "" ? local.kubernetes_cluster_config.default_node_pool.min_count : local.kubernetes_cluster_config.default_node_pool.node_count
  //   min_count              = local.kubernetes_cluster_config.default_node_pool.min_count == "" ? local.kubernetes_cluster_config.default_node_pool.node_count : local.kubernetes_cluster_config.default_node_pool.min_count
  //   max_count              = local.kubernetes_cluster_config.default_node_pool.max_count
  //   ultra_ssd_enabled      = local.kubernetes_cluster_config.default_node_pool.ultra_ssd_enabled
  //   tags                   = {
  //     for tag in keys(local.kubernetes_cluster_config.default_node_pool.tags) :
  //     tag => local.kubernetes_cluster_config.default_node_pool.tags[tag]
  //   }
  // }

  addon_profile {
    aci_connector_linux {
      enabled = local.kubernetes_cluster_config.addon_profile.aci_connector_linux.enabled
    }
    azure_policy {
      enabled = local.kubernetes_cluster_config.addon_profile.azure_policy.enabled
    }
    http_application_routing {
      enabled = local.kubernetes_cluster_config.addon_profile.http_application_routing.enabled
    }
    kube_dashboard {
      enabled = local.kubernetes_cluster_config.addon_profile.kube_dashboard.enabled
    }

    dynamic "oms_agent" {
      for_each = local.kubernetes_cluster_config.addon_profile.oms_agent.enabled == true ? [1] : []
      content {
        enabled                    = local.kubernetes_cluster_config.addon_profile.oms_agent.enabled
        log_analytics_workspace_id = local.kubernetes_cluster_config.addon_profile.oms_agent.log_analytics_workspace_id
      }
    }
  }

  tags = {
    for tag in keys(local.tags) :
    tag => local.tags[tag]
  }
}

/**
 * azurerm_role_assignment
 * the contributor / reader role needs to be assigned to the network managed identity
*/
resource "azurerm_role_assignment" "kubernetes-cluster-role-assignment" {
  scope                = local.kubernetes_cluster_config.role_assignment.vnet_id
  role_definition_name = "Network Contributor"
  principal_id         = local.kubernetes_cluster_config.role_assignment.principal_id
}
