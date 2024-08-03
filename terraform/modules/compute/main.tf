#Basic of the VM
resource "azurerm_virtual_network" "default" {
    name = "fltraining-vn"
    address_space = ["192.168.0.0/16"]
    location = var.resource_group_location
    resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "default" {
    name = "fltraining-sn"
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.default.name
    address_prefixes = ["192.168.0.0/24"]
}

resource "azurerm_public_ip" "cp_pip" {
    name = "cp-pip"
    location = var.resource_group_location
    resource_group_name = var.resource_group_name
    allocation_method = "Static"
}

resource "azurerm_network_interface" "cp_nic" {
  name = "cp_nic"
  location = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name = "cp_nic"
    subnet_id = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.cp_pip.id
  }
}

resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "fltraining-nsg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "default" {
  subnet_id                 = azurerm_subnet.default.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

resource "azurerm_network_interface_security_group_association" "default" {
  network_interface_id      = azurerm_network_interface.cp_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

#Control Plane VM
resource "azurerm_linux_virtual_machine" "cp" {
  name = "cp"
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  size = "Standard_B2ls_v2"
  admin_username = "kurox"
  admin_password = "Testing1234"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.cp_nic.id,
  ]

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "canonical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22_04-lts"
    version = "latest"
  }

  admin_ssh_key {
    username = "kurox"
    public_key = var.public_key
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "cpshutdown" {
  virtual_machine_id = azurerm_linux_virtual_machine.cp.id
  location = var.resource_group_location
  enabled = true

  daily_recurrence_time = "2200"
  timezone = "Singapore Standard Time"

  notification_settings {
    enabled = false
  }
}


# Worker Nodes VM
resource "azurerm_public_ip" "main_pip" {
    name = "main-pip"
    location = var.resource_group_location
    resource_group_name = var.resource_group_name
    allocation_method = "Static"
}

resource "azurerm_network_interface" "main_nic" {
  name = "main_nic"
  location = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name = "main_nic"
    subnet_id = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.main_pip.id
  }
}

resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

resource "azurerm_linux_virtual_machine" "main" {
  name = "main"
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  size = "Standard_B2ls_v2"
  admin_username = "kurox"
  admin_password = "Testing1234"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main_nic.id,
  ]

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "canonical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22_04-lts"
    version = "latest"
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "mainshutdown" {
  virtual_machine_id = azurerm_linux_virtual_machine.main.id
  location = var.resource_group_location
  enabled = true

  daily_recurrence_time = "2200"
  timezone = "Singapore Standard Time"

  notification_settings {
    enabled = false
  }
}

# resource "azurerm_public_ip" "secondary_pip" {
#     name = "secondary-pip"
#     location = var.resource_group_location
#     resource_group_name = var.resource_group_name
#     allocation_method = "Static"
# }

# resource "azurerm_network_interface" "secondary_nic" {
#   name = "secondary_nic"
#   location = var.resource_group_location
#   resource_group_name = var.resource_group_name

#   ip_configuration {
#     name = "secondary_nic"
#     subnet_id = azurerm_subnet.default.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id = azurerm_public_ip.secondary_pip.id
#   }
# }

# resource "azurerm_network_interface_security_group_association" "secondary" {
#   network_interface_id      = azurerm_network_interface.secondary_nic.id
#   network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
# }

# resource "azurerm_linux_virtual_machine" "secondary" {
#   name = "secondary"
#   resource_group_name = var.resource_group_name
#   location = var.resource_group_location
#   size = "Standard_B2ls_v2"
#   admin_username = "kurox"
#   admin_password = "Testing1234"
#   disable_password_authentication = false
#   network_interface_ids = [
#     azurerm_network_interface.secondary_nic.id,
#   ]

#   os_disk {
#     caching = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "canonical"
#     offer = "0001-com-ubuntu-server-jammy"
#     sku = "22_04-lts"
#     version = "latest"
#   }
# }

# resource "azurerm_dev_test_global_vm_shutdown_schedule" "secondaryshutdown" {
#   virtual_machine_id = azurerm_linux_virtual_machine.secondary.id
#   location = var.resource_group_location
#   enabled = true

#   daily_recurrence_time = "2200"
#   timezone = "Singapore Standard Time"

#   notification_settings {
#     enabled = false
#   }
# }