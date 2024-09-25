variable "region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "eu-west-3"  # You can change this default value
}

variable "name" {
  description = "The name prefix for resources"
  type        = string
  default     = "myproject"  # You can change this default value
}


variable "ipcgw" {
  description = "IPSec Customer Gateway IP"
  type        = string
  default     = "1.1.1.1"  # You can change this default value
}

