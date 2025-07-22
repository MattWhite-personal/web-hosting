resource "azurerm_resource_group" "webservers" {
  name     = "rg-uks-webservers"
  location = "UK South"
  tags     = local.tags
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_virtual_network" "webservers" {
  name                = "vnet-uks-webservers"
  address_space       = ["10.12.0.0/20"]
  location            = azurerm_resource_group.webservers.location
  resource_group_name = azurerm_resource_group.webservers.name
  tags                = local.tags
}

resource "azurerm_subnet" "mjwsite" {
  #checkov:skip=CKV2_AZURE_31:NSG applied to the network interface
  name                 = "sn-uks-mjwsite"
  resource_group_name  = azurerm_resource_group.webservers.name
  virtual_network_name = azurerm_virtual_network.webservers.name
  address_prefixes     = ["10.12.0.0/24"]

}


resource "azurerm_network_interface" "mjwsite" {
  #checkov:skip=CKV_AZURE_119:Public IP is by design
  name                = "nic-uks-mjwsite"
  location            = azurerm_resource_group.webservers.location
  resource_group_name = azurerm_resource_group.webservers.name
  tags                = local.tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.mjwsite.id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv4"
    public_ip_address_id          = azurerm_public_ip.mjwsite.id
  }
}

resource "azurerm_public_ip" "mjwsite" {
  name                = "pip-uks-mjwsite"
  resource_group_name = azurerm_resource_group.webservers.name
  location            = azurerm_resource_group.webservers.location
  allocation_method   = "Static"
  ip_version          = "IPv4"
  sku                 = "Basic"

  tags = local.tags
}

resource "azurerm_network_security_group" "mjwsite" {
  name                = "nsg-uks-mjwsite"
  resource_group_name = azurerm_resource_group.webservers.name
  location            = azurerm_resource_group.webservers.location
  tags                = local.tags

}

resource "azurerm_network_security_rule" "deny-spam-ips" {
  name                        = "deny-spam-ips"
  priority                    = 100
  direction                   = "Inbound"
  source_address_prefixes     = ["40.83.22.124/32", "40.122.73.60/32", "104.45.192.248/32", "13.82.27.55/32", "163.172.67.65/32", "172.177.11.133/32", "20.193.151.222/32", "95.214.27.159/32", "209.141.49.234/32", "45.81.243.77/32", "40.77.54.153/32", "45.140.17.38/32", "52.176.98.172/32", "40.77.51.39/32", "52.176.98.160/32", "40.78.151.66/32", "40.77.70.130/32", "13.89.186.232/32", "212.237.121.29/32", "45.81.39.127/32", "20.204.167.42/32", "20.198.105.199/32", "193.29.13.230/32", "20.26.229.159/32", "74.235.48.147/32", "20.168.227.215/32", "205.185.124.254/32", "45.227.254.21/32", "35.245.46.255/32", "47.251.60.41/32", "70.37.161.83/32", "47.251.61.246/32", "45.134.26.23/32", "45.134.26.25/32", "45.77.85.38/32", "35.222.216.66/32", "45.134.26.24/32", "51.104.217.185/32", "13.67.221.142/32", "2.173.187.40/32", "13.67.221.182/32", "185.163.125.194/32", "192.155.91.95/32", "163.172.49.3/32", "192.145.126.115/32", "34.87.94.148/32"]
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = "0-65535"
  protocol                    = "*"
  access                      = "Deny"
  resource_group_name         = azurerm_resource_group.webservers.name
  network_security_group_name = azurerm_network_security_group.mjwsite.name


}

resource "azurerm_network_security_rule" "permit-ssh" {
  name                        = "ssh"
  priority                    = 300
  direction                   = "Inbound"
  source_address_prefixes     = ["51.149.250.0/24", "2.221.167.111", "5.64.45.6", "176.25.220.161/32", "5.65.85.70/32", "62.3.75.22/32"]
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  protocol                    = "Tcp"
  access                      = "Allow"
  resource_group_name         = azurerm_resource_group.webservers.name
  network_security_group_name = azurerm_network_security_group.mjwsite.name

}

resource "azurerm_network_security_rule" "permit-http-https-53ar" {
  name                        = "permit-53ar-httphttps"
  priority                    = 350
  direction                   = "Inbound"
  source_address_prefix       = "5.64.45.6"
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_ranges     = ["80", "443"]
  protocol                    = "*"
  access                      = "Allow"
  resource_group_name         = azurerm_resource_group.webservers.name
  network_security_group_name = azurerm_network_security_group.mjwsite.name

}

resource "azurerm_network_security_rule" "permit-http-53ar-v6" {
  name                        = "Permit-53AR-ipv6-HTTP"
  priority                    = 370
  direction                   = "Inbound"
  source_address_prefix       = "2a02:c7c:748e:9300::/64"
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = "80"
  protocol                    = "Tcp"
  access                      = "Allow"
  resource_group_name         = azurerm_resource_group.webservers.name
  network_security_group_name = azurerm_network_security_group.mjwsite.name

}

resource "azurerm_network_security_rule" "permit-https-53ar-v6" {
  name                        = "Permit-53AR-ipv6-HTTPS"
  priority                    = 380
  direction                   = "Inbound"
  source_address_prefix       = "2a02:c7c:748e:9300::/64"
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = "443"
  protocol                    = "Tcp"
  access                      = "Allow"
  resource_group_name         = azurerm_resource_group.webservers.name
  network_security_group_name = azurerm_network_security_group.mjwsite.name

}

resource "azurerm_network_security_rule" "permit-https-any" {
  name                        = "AllowAnyHTTPSInbound"
  priority                    = 390
  direction                   = "Inbound"
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = "443"
  protocol                    = "Tcp"
  access                      = "Allow"
  resource_group_name         = azurerm_resource_group.webservers.name
  network_security_group_name = azurerm_network_security_group.mjwsite.name

}

resource "azurerm_network_interface_security_group_association" "mjwsite" {
  network_interface_id      = azurerm_network_interface.mjwsite.id
  network_security_group_id = azurerm_network_security_group.mjwsite.id
}

resource "azurerm_virtual_machine" "mjwsite" {
  #checkov:skip=CKV2_AZURE_10:Virtual Machine to be decommissioned soon
  #checkov:skip=CKV2_AZURE_12:Virtual Machine to be decommissioned soon
  name                         = "vm-uks-mjwsite"
  location                     = azurerm_resource_group.webservers.location
  resource_group_name          = azurerm_resource_group.webservers.name
  network_interface_ids        = [azurerm_network_interface.mjwsite.id]
  primary_network_interface_id = azurerm_network_interface.mjwsite.id
  vm_size                      = "Standard_B1ms"
  boot_diagnostics {
    enabled     = true
    storage_uri = ""
  }

  storage_os_disk {
    name              = "mjwukwweb01-osdisk-20200801-153009"
    caching           = "ReadWrite"
    create_option     = "Attach"
    managed_disk_type = "StandardSSD_LRS"
    disk_size_gb      = 30
    os_type           = "Linux"
  }

  identity {
    identity_ids = []
    type         = "SystemAssigned"
  }
  tags = local.tags
}
