locals {
    resource_group = local.create_rg ? azurerm_resource_group.app_service[0].name : data.azurerm_resource_group.app_service[0].name
    location = local.create_rg ? azurerm_resource_group.app_service[0].location : data.azurerm_resource_group.app_service[0].location
    create_rg = var.create_rg
}

resource "azurerm_resource_group" "app_service" {
  count = local.create_rg ? 1 : 0
  name     = var.resource_group 
  location = var.location
}

data "azurerm_resource_group" "app_service" {
    count = local.create_rg ? 0 : 1
    name = var.resource_group
}

resource "azurerm_service_plan" "app_service" {
  name                = "app_service_plan"
  resource_group_name = local.resource_group
  location            = local.location
  os_type             = "Linux"
  sku_name            = "F1"
}

# resource "azurerm_linux_web_app" "app_service" {
#   name                = "app_service"
#   resource_group_name = azurerm_resource_group.app_service.name
#   location            = azurerm_service_plan.app_service.location
#   service_plan_id     = azurerm_service_plan.app_service.id

#   site_config {}
# }
