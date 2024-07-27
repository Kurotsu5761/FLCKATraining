#Basic of the VM
resource "azurerm_virtual_network" "default" {
    name = "fltraining-vn"
    address_space = ["10.0.0.0/16"]
    location = var.resource_group_location
    resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "default" {
    name = "fltraining-sn"
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.default.name
    address_prefixes = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "default" {
  name = "fltraining-nic"
  location = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name = "fltraining-ipc"
    subnet_id = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
  }
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
  priority = "Spot"
  eviction_policy = "Deallocate"
  network_interface_ids = [
    azurerm_network_interface.default.id,
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