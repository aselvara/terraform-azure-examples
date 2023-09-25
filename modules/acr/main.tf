locals {
    resource_group = var.resource_group
    create_rg = var.create_rg
    location = var.location
    subnet_name = var.subnet_name
    vnet_name = var.vnet_name
    vnet_rg = var.vnet_rg
    tags = var.tags
}

resource "azurerm_resource_group" "acr" {
  count = local.create_rg ? 1 : 0
  name     = "${local.resource_group}"
  location = local.location
  tags     = local.tags
}

# Private ACR
resource "azurerm_container_registry" "acr" {
  name                = "myACRexample12312iik"
  resource_group_name = local.resource_group
  location            = local.location
  sku                 = "Premium"
  admin_enabled       = false
  public_network_access_enabled = false
  data_endpoint_enabled = true
  tags = local.tags
}

# Private DNS Zone for ACR azurecr.io
resource "azurerm_private_dns_zone" "acr" {
  name                = "privatelink.azurecr.io"
  resource_group_name = local.resource_group
  tags = local.tags
}

# Adding ACR Private DNS Zone to VNET Link for auto resolution
resource "azurerm_private_dns_zone_virtual_network_link" "acr" {
  name                  = "acr_private_dns_virtual_link"
  resource_group_name   = local.resource_group
  private_dns_zone_name = azurerm_private_dns_zone.acr.name
  virtual_network_id    = data.azurerm_virtual_network.acr.id
  registration_enabled  = false
}

data "azurerm_virtual_network" "acr" {
  name                = local.vnet_name
  resource_group_name = local.vnet_rg
}

data "azurerm_subnet" "acr" {
  name                 = local.subnet_name
  virtual_network_name = local.vnet_name
  resource_group_name  = local.vnet_rg
}

# Private Link for ACR and add to Private DNS Zone
resource "azurerm_private_endpoint" "acr" {
  name                = "private_endpoint_acr"
  location            = local.location
  resource_group_name = local.resource_group
  subnet_id           = data.azurerm_subnet.acr.id
  tags = local.tags

  private_service_connection {
    name                           = "example-acr"
    private_connection_resource_id = azurerm_container_registry.acr.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }

  private_dns_zone_group {
    name                 = azurerm_private_dns_zone.acr.name
    private_dns_zone_ids = [
        azurerm_private_dns_zone.acr.id,

    ]
  }
}
