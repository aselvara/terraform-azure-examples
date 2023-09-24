locals {
    resource_group = var.resource_group
    location = var.location
    name = var.name
    address_space = var.address_space
    tags = var.tags
    subnets = var.subnets
}

# Resource Group for Network
resource "azurerm_resource_group" "vnet" {
  name     = "${local.resource_group}-${local.location}"
  location = local.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${local.name}-${local.location}"
  location            = local.location
  address_space       = local.address_space
  tags                = local.tags
  resource_group_name = azurerm_resource_group.vnet.name
}

resource "azurerm_subnet" "subnet" {
  for_each             = local.subnets
  name                 = each.value.name
  address_prefixes     = each.value.address_prefixes
  resource_group_name  = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
}
