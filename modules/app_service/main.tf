locals {
    resource_group = var.resource_group 
    location = var.location

}

resource "azurerm_resource_group" "app_service" {
  name     = local.resource_group 
  location = local.location
}

resource "azurerm_service_plan" "app_service" {
  name                = "app_service_plan"
  resource_group_name = azurerm_resource_group.app_service.name
  location            = azurerm_resource_group.app_service.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "app_service" {
  name                = "app_service"
  resource_group_name = azurerm_resource_group.app_service.name
  location            = azurerm_service_plan.app_service.location
  service_plan_id     = azurerm_service_plan.app_service.id

  site_config {}
}
