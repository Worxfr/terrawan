variable "ipcgw" {
  description = "IP address of the customer gateway"
  type        = string
}

variable "name" {
  description = "Name to be used in the VPN connection tag"
  default = "test"
  type        = string
}

variable "segment" {
  description = "Segment name for the CWAttach tag"
  type        = string
}

# Note: The following variable is inferred from the use of awscc_networkmanager_core_network
# If this resource is defined elsewhere in your Terraform configuration, 
# you may not need to declare this variable.
variable "core_network_id" {
  description = "ID of the core network"
  type        = string
}

variable "core_depends_on" {
  type = any
  default = []
}

