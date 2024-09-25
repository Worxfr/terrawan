data "aws_region" "current" {}

variable "ipam_regions" {
  type    = list
  default = ["eu-west-3", "eu-west-1"]
}

variable "region" {
  type    = string
  default = "eu-west-3"
}

variable "ipamcidr" {
  description = "The CIDR block for IPAM Global"
  type        = string
  default     = "100.64.0.0/10"  # You can change this default value
}


locals {
  # ensure current provider region is an operating_regions entry
  all_ipam_regions = distinct(concat([data.aws_region.current.name], var.ipam_regions))
}

variable "name" {
  description = "Name prefix for resources"
  type        = string
  default     = "myworkshop"
}

