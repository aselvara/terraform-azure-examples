# Variables
locals {
  tags = {
    environment = "Production"
  }
  location = "eastus"
}

# Resource Group for Network
resource "azurerm_resource_group" "defaultnetwork" {
  name     = "example-network-rg-${local.location}"
  location = local.location
  tags     = local.tags
}

# Virtual network
resource "azurerm_virtual_network" "network" {
  name                = "example-virtual-network-${azurerm_resource_group.defaultnetwork.location}"
  location            = azurerm_resource_group.defaultnetwork.location
  resource_group_name = azurerm_resource_group.defaultnetwork.name
  address_space       = ["10.0.0.0/16"]
  tags                = local.tags
}

# PrivateSubnet 1
resource "azurerm_subnet" "example" {
  name                 = "private-subnet-1"
  resource_group_name  = azurerm_resource_group.defaultnetwork.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.0.2.0/24"]
}
