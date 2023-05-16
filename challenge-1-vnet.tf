resource "azurerm_virtual_network" "myvnet-1" {
  name = "${var.buisness_unit}-${var.enviornment_name}-${var.virtual_network_name}"
  location = azurerm_resource_group.myrg-1.location
  address_space = [ "192.168.0.0/16" ]
  resource_group_name = azurerm_resource_group.myrg-1.name
}

# Subnet for frontend Application and 2 NIC in the subnet
resource "azurerm_subnet" "subnet-FE" {
    name = "frontEnd"
    virtual_network_name = azurerm_virtual_network.myvnet-1.name
    address_prefixes = [ "192.168.1.0/24" ]
    resource_group_name = azurerm_resource_group.myrg-1.name
}

resource "azurerm_network_interface" "fe-nic" {
  count = 2
  name                = "fe-nic-${count.index}"
  location            = azurerm_resource_group.myrg-1.location
  resource_group_name = azurerm_resource_group.myrg-1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet-FE.id
    private_ip_address_allocation = "Dynamic"
  }
}


# Subnet for backend Application and 2 NICs in the subnet
resource "azurerm_subnet" "subnet-BE" {
    name = "backend"
    virtual_network_name = azurerm_virtual_network.myvnet-1.name
    address_prefixes = [ "192.168.2.0/24" ]
    resource_group_name = azurerm_resource_group.myrg-1.name
}

resource "azurerm_network_interface" "be-nic" {
  count = 2
  name                = "be-nic-${count.index}"
  location            = azurerm_resource_group.myrg-1.location
  resource_group_name = azurerm_resource_group.myrg-1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet-BE.id
    private_ip_address_allocation = "Dynamic"
  }
}


# Subnet for Database Application and 2 NICs in it
resource "azurerm_subnet" "subnet-DB" {
    name = "database"
    virtual_network_name = azurerm_virtual_network.myvnet-1.name
    address_prefixes = [ "192.168.3.0/24" ]
    resource_group_name = azurerm_resource_group.myrg-1.name
}

resource "azurerm_network_interface" "db-nic" {
  count = 2
  name                = "db-nic-${count.index}"
  location            = azurerm_resource_group.myrg-1.location
  resource_group_name = azurerm_resource_group.myrg-1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet-DB.id
    private_ip_address_allocation = "Dynamic"
  }
}
