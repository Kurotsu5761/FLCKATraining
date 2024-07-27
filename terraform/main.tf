resource "azurerm_resource_group" "rg" {
    location = var.resource_group_location
    name = "FLTraining-rg"
}

module "virtualMachines" {
    source = "./modules/compute"
    resource_group_location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}