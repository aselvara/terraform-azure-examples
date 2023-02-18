# Azure Container Regristry
resource "azurerm_resource_group" "example" {
  name     = "myResourceGroup1"
  location = "eastus"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.1.0.0/16"]

  tags = {
    environment = "Production"
  }
}

resource "azurerm_subnet" "example" {
  name                 = "private-subnet-1"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.1.1.0/24"]
}

# Private ACR
resource "azurerm_container_registry" "example" {
  name                = "myACRexample12312iik"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "Premium"
  admin_enabled       = false
  public_network_access_enabled = false
}

# Private DNS Zone
resource "azurerm_private_dns_zone" "example" {
  name                = "privatelink.azurecr.com"
  resource_group_name = azurerm_resource_group.example.name
}

# Private Link for ACR and add to Private DNS Zone
resource "azurerm_private_endpoint" "acr" {
  name                = "private_endpoint_acr"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  subnet_id           = azurerm_subnet.example.id

  private_service_connection {
    name                           = "example-acr"
    private_connection_resource_id = azurerm_container_registry.example.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }

  private_dns_zone_group {
    name                 = azurerm_private_dns_zone.example.name
    private_dns_zone_ids = [
        azurerm_private_dns_zone.example.id
    ]
  }
}