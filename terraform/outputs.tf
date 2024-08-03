output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "cp_pip" {
  value = module.virtualMachines.cp_pip
}

output "main_pip" {
  value = module.virtualMachines.main_pip
}

output "secondary_pip" {
  value = module.virtualMachines.secondary_pip
}