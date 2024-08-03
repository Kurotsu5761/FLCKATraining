output "cp_pip" {
    value = azurerm_linux_virtual_machine.cp.public_ip_address
}

output "main_pip" {
    value = azurerm_linux_virtual_machine.main.public_ip_address
}

output "secondary_pip" {
    value = azurerm_linux_virtual_machine.secondary.public_ip_address
}