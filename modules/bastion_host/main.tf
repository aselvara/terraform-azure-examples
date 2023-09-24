# LOCALS
locals {
    vnet_name = var.vnet_name 
    vnet_rg = var.vnet_rg
    subnet_addr = var.subnet_addr
    location = data.azurerm_virtual_network.bastion_host.location
    resource_group = azurerm_resource_group.bastion_host.name
}

# DATA
data "azurerm_virtual_network" "bastion_host" {
  name                = local.vnet_name
  resource_group_name = local.vnet_rg
}

# RESOURCES
# Resource for Bastion Host
resource "azurerm_resource_group" "bastion_host" {
  name     = "bashtionhostRG-${local.location}"
  location = local.location
}

# Dedicated Subnet for Bastion
resource "azurerm_subnet" "bastion_host" {
  # The name must be AzureBastionSubnet
  name                 = "AzureBastionSubnet"
  resource_group_name  = local.vnet_rg
  virtual_network_name = local.vnet_name
  address_prefixes     = local.subnet_addr
}

# Public IP
resource "azurerm_public_ip" "bastion_host" {
  name                = "bastion-${local.location}"
  resource_group_name = local.resource_group
  location            = local.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Bastion Host
resource "azurerm_bastion_host" "bastion_host" {
  name                = "examplebastion-${local.location}"
  location            = local.location
  resource_group_name = local.resource_group
  sku                 = "Standard"
  scale_units         = 2

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion_host.id
    public_ip_address_id = azurerm_public_ip.bastion_host.id
  }
}

