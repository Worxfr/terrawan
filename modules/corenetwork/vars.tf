variable "main_region" {
  default = "eu-west-2"
}

variable "list_of_regions"{
  type = list(string)
  default = ["eu-west-1" , "eu-west-3"]
}

variable "name" {
  type = string
  default = "test"
}