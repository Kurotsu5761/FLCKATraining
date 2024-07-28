resource "azurerm_resource_group" "rg" {
    location = var.resource_group_location
    name = "FLTraining-rg"
}

module "virtualMachines" {
    source = "./modules/compute"
    resource_group_location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    public_key = azapi_resource_action.ssh_public_key_gen.output.publicKey
}