resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.azure_region
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.aks_subnet_nsg_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.aks_vnet_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.aks_vnet_address_space
  dns_servers         = var.aks_vnet_dns_servers
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  name                                           = var.aks_subnet_name
  resource_group_name                            = azurerm_resource_group.rg.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = var.aks_nodepool_subnet_address_prefixes
  service_endpoints                              = var.vnet_service_endpoints
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true

}

resource "azurerm_route_table" "rtb" {
  name                          = "rtb-${var.aks_subnet_name}"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  disable_bgp_route_propagation = false

  tags = var.tags
}

resource "azurerm_public_ip" "natgw" {
  name                = "pip-${var.aks_nat_gateway_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.aks_natgw_public_ip_zone
}


resource "azurerm_nat_gateway" "natgw" {
  name                    = var.aks_nat_gateway_name
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  public_ip_address_ids   = [azurerm_public_ip.natgw.id]
  sku_name                = "Standard"
  idle_timeout_in_minutes = 4
  zones                   = var.aks_natgw_public_ip_zone
}
