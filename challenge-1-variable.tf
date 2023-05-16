#buisness unit
variable "buisness_unit" {
  default = "hr"
  description = "buisness Unit"
  type = string
}

#Environment Name
variable "enviornment_name" {
  default = "tst"
  description = "enviornment name"
  type = string
}

#Resource Group Name
variable "resource_group_name" {
  default = "myrg"
  description = "name of resource group"
  type = string
}

#resource group location
variable "resource_group_location" {
  default = "eastus"
  description = "location of resource group"
  type = string
}

#vnet name
variable "virtual_network_name" {
  default = "myvnet-1"
  description = "vnet name"
  type = string
}