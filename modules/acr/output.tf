output "acr_rg_id" {
    value = azurerm_resource_group.acr[0].id
}

output "acr_id" {
    value = azurerm_container_registry.acr.id
}