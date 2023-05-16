resource "azurerm_public_ip" "pip-lb" {
  name                = "PublicIPForLB"
  location            = azurerm_resource_group.myrg-1.location
  resource_group_name = azurerm_resource_group.myrg-1.name
  allocation_method   = "Static"
  sku = "Standard"
}

resource "azurerm_lb" "lb-frontend" {
  name                = "fe-LoadBalancer"
  location            = azurerm_resource_group.myrg-1.location
  resource_group_name = azurerm_resource_group.myrg-1.name
  sku = "Standard"
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.pip-lb.id
  }
}

resource "azurerm_lb_backend_address_pool" "fe-pool" {
  loadbalancer_id = azurerm_lb.lb-frontend.id
  name            = "fe-BackEndAddressPool"
  
}

resource "azurerm_lb_backend_address_pool_address" "fe-backend-pool" {
  name                                = "address1"
  backend_address_pool_id             = azurerm_lb_backend_address_pool.fe-pool.id
  virtual_network_id = azurerm_virtual_network.myvnet-1.id
  ip_address = azurerm_network_interface.fe-nic[*].id
}

# Resource-4: Create LB Probe
resource "azurerm_lb_probe" "fe_lb_probe" {
  name                = "tcp-probe"
  protocol            = "Tcp"
  port                = 443
  loadbalancer_id     = azurerm_lb.lb-frontend.id
  resource_group_name = azurerm_resource_group.myrg-1.name

}

# Resource-5: Create LB Rule
resource "azurerm_lb_rule" "fe_lb_rule_app1" {
  name                           = "fe-app1-rule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = azurerm_lb.lb-frontend.frontend_ip_configuration.name
  #frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
  backend_address_pool_id        = azurerm_lb_backend_address_pool.fe-pool.id 
  probe_id                       = azurerm_lb_probe.fe_lb_probe.id
  loadbalancer_id                = azurerm_lb.lb-frontend.id
  resource_group_name            = azurerm_resource_group.myrg-1.name
}

#================== internal load balancer to balance load getting from FrontEnd and distributing it in Backend servers

resource "azurerm_lb" "lb-backend" {
  name                = "be-LoadBalancer"
  location            = azurerm_resource_group.myrg-1.location
  resource_group_name = azurerm_resource_group.myrg-1.name
  sku = "Standard"
  frontend_ip_configuration {
    name                 = "be-privateIPAddress"
    subnet_id = azurerm_subnet.subnet-BE.id
    private_ip_address = "192.168.2.10"
  }
}

resource "azurerm_lb_backend_address_pool" "be-pool" {
  loadbalancer_id = azurerm_lb.lb-backend.id
  name            = "be-BackEndAddressPool"
  
}

resource "azurerm_lb_backend_address_pool_address" "be-backend-pool" {
  name                                = "address1"
  backend_address_pool_id             = azurerm_lb_backend_address_pool.be-pool.id
  virtual_network_id = azurerm_virtual_network.myvnet-1.id
  ip_address = azurerm_network_interface.be-nic[*].id
}

# Resource-4: Create LB Probe
resource "azurerm_lb_probe" "be_lb_probe" {
  name                = "tcp-probe"
  protocol            = "Tcp"
  port                = 443
  loadbalancer_id     = azurerm_lb.lb-backend.id
  resource_group_name = azurerm_resource_group.myrg-1.name

}

# Resource-5: Create LB Rule
resource "azurerm_lb_rule" "be_lb_rule_app1" {
  name                           = "be-app1-rule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = azurerm_lb.lb-backend.frontend_ip_configuration.name
  #frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
  backend_address_pool_id        = azurerm_lb_backend_address_pool.be-pool.id 
  probe_id                       = azurerm_lb_probe.be_lb_probe.id
  loadbalancer_id                = azurerm_lb.lb-backend.id
  resource_group_name            = azurerm_resource_group.myrg-1.name
}

#===================== internal load balancer to manage load between backend servers and database servers

resource "azurerm_lb" "lb-database" {
  name                = "db-LoadBalancer"
  location            = azurerm_resource_group.myrg-1.location
  resource_group_name = azurerm_resource_group.myrg-1.name
  sku = "Standard"
  frontend_ip_configuration {
    name                 = "db-privateIPAddress"
    subnet_id = azurerm_subnet.subnet-DB
    private_ip_address = "192.168.3.10"
  }
}

resource "azurerm_lb_backend_address_pool" "db-pool" {
  loadbalancer_id = azurerm_lb.lb-database.id
  name            = "be-BackEndAddressPool"
  
}

resource "azurerm_lb_backend_address_pool_address" "db-backend-pool" {
  name                                = "address1"
  backend_address_pool_id             = azurerm_lb_backend_address_pool.db-pool.id
  virtual_network_id = azurerm_virtual_network.myvnet-1.id
  ip_address = azurerm_network_interface.db-nic[*].id
}

# Resource-4: Create LB Probe
resource "azurerm_lb_probe" "db_lb_probe" {
  name                = "tcp-probe"
  protocol            = "Tcp"
  port                = 443
  loadbalancer_id     = azurerm_lb.lb-database.id
  resource_group_name = azurerm_resource_group.myrg-1.name

}

# Resource-5: Create LB Rule
resource "azurerm_lb_rule" "be_lb_rule_app1" {
  name                           = "be-app1-rule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = azurerm_lb.lb-database.frontend_ip_configuration.name
  #frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
  backend_address_pool_id        = azurerm_lb_backend_address_pool.db-pool.id 
  probe_id                       = azurerm_lb_probe.db_lb_probe.id
  loadbalancer_id                = azurerm_lb.lb-database.id
  resource_group_name            = azurerm_resource_group.myrg-1.name
}