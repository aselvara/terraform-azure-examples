output "vnet_rg" {
    value = azurerm_resource_group.vnet.name
}

output "vnet_name" {
    value = azurerm_virtual_network.vnet.name
}

output "subnet_names" {
    value = values(azurerm_subnet.subnet)[*].name
}
