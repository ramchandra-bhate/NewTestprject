resource "azurerm_resource_group" "myrg-1" {
  #name = var.resource_group_name
name = "${var.buisness_unit}-${var.enviornment_name}-${var.resource_group_name}"
  location = var.resource_group_location
}