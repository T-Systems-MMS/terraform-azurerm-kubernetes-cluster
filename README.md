This module is deprecated.

We restructured the resources based on the API. The current version can be found here.
https://github.com/telekom-mms/terraform-azurerm-container

<!-- BEGIN_TF_DOCS -->
# kubernetes_cluster

This module manages Azure Kubernetes Cluster.

<-- This file is autogenerated, please do not change. -->

## Requirements

| Name | Version |
|------|---------|
| terraform | ~>1.1 |
| azurerm | >=3.5.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >=3.5.0 |

## Resources

| Name | Type |
|------|------|
| azurerm_kubernetes_cluster.kubernetes_cluster | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| kubernetes_cluster | resource definition, default settings are defined within locals and merged with var settings | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| kubernetes_cluster | azurerm_kubernetes_cluster results |

## Examples

```hcl
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

```
<!-- END_TF_DOCS -->
