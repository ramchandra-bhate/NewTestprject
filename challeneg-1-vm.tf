
resource "azurerm_windows_virtual_machine" "frontend-vms" {
  count = 2
  name                = "frontend-vm-${count.index}"
  resource_group_name = azurerm_resource_group.myrg-1.name
  location            = azurerm_resource_group.myrg-1.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    [element (azurerm_network_interface.azurerm_network_interface.fe-nic[*].id, count.index)]
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_windows_virtual_machine" "backend-vms" {
  count = 2
  name                = "backend-vm-${count.index}"
  resource_group_name = azurerm_resource_group.myrg-1.name
  location            = azurerm_resource_group.myrg-1.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    [element (azurerm_network_interface.azurerm_network_interface.be-nic[*].id, count.index)]
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_windows_virtual_machine" "database-vms" {
  count = 2
  name                = "database-vm-${count.index}"
  resource_group_name = azurerm_resource_group.myrg-1.name
  location            = azurerm_resource_group.myrg-1.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    [element (azurerm_network_interface.azurerm_network_interface.db-nic[*].id, count.index)]
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}