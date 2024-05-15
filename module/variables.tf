######################
# REQUIRED VARAIBLES #
######################
variable "name" {
  type = string
}

variable "location" {
  type        = string
  description = "Resources location in Azure"
}

variable "vnet_rg" {
  description = "Name of the AKS Vnet resource group."
  type        = string
}

variable "vnet_aks" {
  description = "Name of AKS VNet."
  type        = string
}

variable "subnet_aks" {
  description = "Name of AKS Subnet."
  type        = string
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
}

######################
# OPTIONAL VARAIBLES #
######################
variable "subnet_appgw" {
  description = "Name of AKS Subnet."
  type        = string
  default     = ""
}

variable "appgw" {
  type        = string
  description = "Name of application gateway in front of AKS cluster"
  default     = ""
}

variable "appgw_rg" {
  type        = string
  description = "Name of application gateway resource group"
  default     = ""
}

variable "ems_kv" {
  type        = string
  description = "Name of key vault"
  default     = ""
}

variable "ems_kv_rg" {
  type        = string
  description = "Name of key vault resource group"
  default     = ""
}

# variable "key_size" {
#   type    = string
#   default = "2048"
# }

# variable "key_type" {
#   type    = string
#   default = "RSA"
# }

variable "k8s_dns_zone" {
  type        = string
  description = "private dns zone name"
  default     = "privatelink.eastus.azmk8s.io"
}

variable "metric_annotations_allowlist" {
  type        = string
  description = "Allowlist for metric annotations in the monitoring configuration."
  default     = "null"
}

variable "metric_labels_allowlist" {
  type        = string
  description = "Allowlist for metric labels in the monitoring configuration."
  default     = "null"
}

variable "system_node_pool_config" {
  type = object({
    node_count          = optional(number, 1)
    vm_size             = optional(string, "Standard_DS2_v2")
    enable_auto_scaling = optional(string, "false")
    type                = optional(string, "VirtualMachineScaleSets")
    os_disk_size_gb     = optional(number, 50)
    node_labels         = optional(map(string), {})
    tags                = optional(map(string), {})
  })
  description = "system node pool configuration"
  default = {
    node_count          = 2
    vm_size             = "Standard_DS2_v2"
    enable_auto_scaling = "false"
    type                = "VirtualMachineScaleSets"
    os_disk_size_gb     = 50
  }
}

variable "network_policy" {
  type        = string
  description = "azure network policy "
  default     = "azure"
}

variable "loadbalancer_sku" {
  type        = string
  description = "specified loadbalancer sku type"
  default     = "standard"
}

variable "acr_rg" {
  type        = string
  description = "ACR resource group name"
  default     = "emsimages-rg"
}

variable "aks_publisher" {
  type        = string
  description = "The publisher of the solution.For example Microsoft. Changing this forces a new resource to be created."
  default     = "Microsoft"
}

variable "aks_product" {
  type        = string
  description = "The product name of the solution.For example OMSGallery/Containers. Changing this forces a new resource to be created."
  default     = "aksContainerInsights"
}

variable "acr_registry_id" {
  type        = string
  description = "ACR Container Registry ID"
  default     = "/subscriptions/f8cce0a8-ccaf-4b88-b6f6-d2b8b86b65be/resourceGroups/emsimages-rg/providers/Microsoft.ContainerRegistry/registries/emsimages"
}

# variable "disk_key_opts" {
#   type        = list(string)
#   description = "Key options provided on customer managed key"
#   default     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
# }

variable "dns_prefix" {
  type        = string
  description = "Name for the DNS prefix"
  default     = "ems"
}

variable "number_of_windows_node_pools" {
  type        = number
  description = "number of windows user node pool to add"
  default     = 0
}

variable "windows_node_pool_config" {
  description = "windows node pool configuration"
  type = list(object({
    node_count          = optional(number, 2)
    enable_auto_scaling = optional(bool, false)
    os_disk_size_gb     = optional(number, 50)
    vm_size             = optional(string, "Standard_DS2_v2")
    node_labels         = optional(map(string), {})
    node_taints         = optional(list(string), [])
    tags                = optional(map(string), {})
  }))
  default = [{
    node_count          = 2
    enable_auto_scaling = false
    os_disk_size_gb     = 50
    vm_size             = "Standard_DS2_v2"
  }]
}

variable "number_of_linux_node_pools" {
  type        = number
  description = "number of linux user node pools to add"
  default     = 0
}

variable "linux_node_pool_config" {
  description = "linux node pool configuration"
  type = list(object({
    node_count          = optional(number, 2)
    enable_auto_scaling = optional(bool, false)
    os_disk_size_gb     = optional(number, 50)
    vm_size             = optional(string, "Standard_DS2_v2")
    node_labels         = optional(map(string), {})
    node_taints         = optional(list(string), [])
    tags                = optional(map(string), {})
  }))
  default = [{
    node_count          = 2
    enable_auto_scaling = false
    os_disk_size_gb     = 50
    vm_size             = "Standard_DS2_v2"
  }]
}

variable "workload_identity_enabled" {
  type        = bool
  description = "Defines if workload identity should be enabled on cluster. This requires oidc_issuer_enabled set to true"
  default     = true
}

variable "oidc_issuer_enabled" {
  type        = bool
  description = "Defines if OIDC issuer should be enabled on cluster"
  default     = true
}

variable "nginx_chart_version" {
  type        = string
  default     = "9.9.2"
  description = "Nginx ingress controller chart version"
}

variable "username" {
  type        = string
  description = "The admin username for the new cluster."
  default     = "azureuser"
}

variable "upgrade" {
  type        = string
  description = " The upgrade channel for this Kubernetes Cluster. Possible values are patch, rapid, node-image and stable.If needed not to include automatic channel upgrade then we can pass null as default value "
  default     = null
}

variable "role_definitions" {
  type        = list(string)
  description = "key-vault access RBAC roles"
  default     = ["Key Vault Administrator"]
}

variable "storage_profile" {
  type = object({
    blob_driver_enabled         = optional(bool)
    disk_driver_enabled         = optional(bool)
    disk_driver_version         = optional(string)
    file_driver_enabled         = optional(bool)
    snapshot_controller_enabled = optional(bool)
  })
  default = null
}

variable "tags" {
  type        = map(string)
  description = "mapping of tags key-value pairs"
  default     = {}
}
