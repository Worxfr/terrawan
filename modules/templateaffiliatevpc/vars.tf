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

variable "exchcidr" {
  description = "The CIDR block for the office VPC"
  type        = string
  default     = "100.64.0.0/24"  # You can change this default value
}

variable "affcidr" {
  description = "The CIDR block for the affiliate VPC"
  type        = string
  default     = "10.1.0.0/16"  # You can change this default value
}

variable "core_network_id" {
  description = "The ID of the AWS Cloud WAN Core Network"
  type        = string
  default     = ""  # You should provide this value when applying the configuration
}

variable "core_network_arn" {
  description = "The arn of the AWS Cloud WAN Core Network"
  type        = string
  default     = ""  # You should provide this value when applying the configuration
}

# This data source is used in the main configuration but not directly as a variable
# Including it here for completeness
data "aws_availability_zones" "available" {
  state = "available"
}

variable "segment" {
    description = "The CIDR block for the affiliate VPC"
    type        = string
    default = "value"
}

variable "core_depends_on" {
  type = any
  default = []
}
  
variable "pool_map"{
  type = map
  default = {}
}


