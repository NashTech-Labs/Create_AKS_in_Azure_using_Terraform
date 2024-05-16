######################
# REQUIRED VARAIBLES #
######################
variable "name_VV" {
  description = "Common Name"
  type = string
}

variable "location_VV" {
  type        = string
  description = "Location of the Resources"
}

variable "vnet_rg_VV" {
  description = "Name of the AKS Vnet resource group."
  type        = string
}

variable "vnet_aks_VV" {
  description = "Name of AKS VNet."
  type        = string
}

variable "subnet_aks_VV" {
  description = "Name of AKS Subnet."
  type        = string
}

variable "kubernetes_version_VV" {
  type        = string
  description = "Kubernetes version"
}

######################
# OPTIONAL VARAIBLES #
######################
variable "k8s_dns_zone_VV" {
  type        = string
  description = "private dns zone name"
}
variable "system_node_pool_config_VV" {
  type = object({
    node_count          = optional(number, 1)
    vm_size             = optional(string, "Standard_DS2_v2")
    enable_auto_scaling = optional(string, "false")
    type                = optional(string, "VirtualMachineScaleSets")
    os_disk_size_gb     = optional(number, 50)
    node_labels         = optional(map(string), {})
    tags                = optional(map(string), {})
  })
  description = "System node pool configuration"
  default = {
    node_count          = 2
    vm_size             = "Standard_DS2_v2"
    enable_auto_scaling = "false"
    type                = "VirtualMachineScaleSets"
    os_disk_size_gb     = 50
  }
}

variable "network_policy_VV" {
  type        = string
  description = "Azure network policy "
  default     = "azure"
}

variable "loadbalancer_sku_VV" {
  type        = string
  description = "Specified Load balancer sku type"
  default     = "standard"
}

variable "kv_VV" {
  type        = string
  description = "Name of key vault"
  default     = ""
}


variable "appgw_VV" {
  type        = string
  description = "Name of application gateway in front of AKS cluster"
  default     = ""
}

variable "dns_prefix_VV" {
  type        = string
  description = "Name for the DNS prefix"
  default     = "Prefix-Name"
}

variable "number_of_windows_node_pools_VV" {
  type        = number
  description = "Number of windows user node pool to add"
  default     = 0
}

variable "windows_node_pool_config_VV" {
  description = "Windows node pool configuration"
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

variable "number_of_linux_node_pools_VV" {
  type        = number
  description = "Number of linux user node pools to add"
  default     = 0
}

variable "linux_node_pool_config_VV" {
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

variable "workload_identity_enabled_VV" {
  type        = bool
  description = "Defines if workload identity should be enabled on cluster. This requires oidc_issuer_enabled set to true"
  default     = true
}

variable "oidc_issuer_enabled_VV" {
  type        = bool
  description = "Defines if OIDC issuer should be enabled on cluster"
  default     = true
}

variable "tags_VV" {
  type        = map(string)
  description = "Mapping of tags key-value pairs"
  default     = {}
}
