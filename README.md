## Description

Here, In this template, we will create an AKS Cluster in the Azure cloud using the terraform scripts.

---

#### Pre-requisite

* AZ Account
* Azure CLI

---

### Steps:-
1. Login into AZ account using `az login` or `az login --tenant <TENANT-ID>`
2. Login into the Azure using the Service Principal the Service Principal like `az service principal -u <client-id> -p <client-password> -t <tenant-ID>`.

---
 
## Configuration

The following table lists the configurable parameters for the module with their default values.

| Parameters                               | Description                                                | Default | Type         | Required |
|------------------------------------------|------------------------------------------------------------|---------|--------------|----------|
| name_VV                                  | Common Name                                                |         | string       | Yes      |  
| location_VV                              | Location of the Resources                                  |         | string       | Yes      |  
| vnet_rg_VV                               | Name of the AKS Vnet resource group                        |         | string       | Yes      |
| vnet_aks_VV                              | Name of AKS VNet                                           |         | string       | Yes      |
| subnet_aks_VV                            | Name of AKS Subnet                                         |         | string       | Yes      |
| kubernetes_version_VV                    | Kubernetes version                                         |         | string       | Yes      |
| k8s_dns_zone_VV                          | private dns zone name                                      |         | string       | Yes      |
| system_node_pool_config_VV               | System node pool configuration                             |         | string       | Yes      |
| network_policy_VV                        | Azure network policy                                       |         | string       | Yes      |
| loadbalancer_sku_VV                      | Specified Load balancer sku type                           |         | string       | Yes      |
| kv_VV                                    | Name of key vault                                          |         | string       | Yes      |
| appgw_VV                                 | Name of application gateway in front of AKS cluster        |         | string       | Yes      |
| dns_prefix_VV                            | Name for the DNS prefix                                    |         | string       | Yes      |
| number_of_windows_node_pools_VV          | Number of windows user node pool to add                    |         | number       | Yes      |
| windows_node_pool_config_VV              | Windows node pool                                          |         | List(object) | Yes      |
| number_of_linux_node_pools_VV            | Number of linux user node pools to                         | 0       | number       | Yes      |
| linux_node_pool_config_VV                | linux node pool configuration                              |         | List(object) | Yes      |
| workload_identity_enabled_VV             | Defines if workload identity should be enabled on cluster. | true    | bool         | Yes      |
| oidc_issuer_enabled_VV                   | Defines if OIDC issuer should be enabled on                | true    | bool         | Yes      |
| tags_VV                                  | Mapping of tags key-value pairs                            |         | map(string)  | Yes      |


---

