locals {
  location       = data.azurerm_virtual_network.example.location
  resource_group = azurerm_resource_group.example.name
  virtual_network = {
    name           = "example-virtual-network-eastus"
    resource_group = "example-network-rg-eastus"
    private_subnet = "private-subnet-1"
  }
}

# This was already created in ../network folder. So reusing them.
data "azurerm_virtual_network" "example" {
  name                = local.virtual_network.name
  resource_group_name = local.virtual_network.resource_group
}

# This was already created in ../network folder. So reusing them.
data "azurerm_subnet" "private" {
  name                 = local.virtual_network.private_subnet
  virtual_network_name = local.virtual_network.name
  resource_group_name  = local.virtual_network.resource_group
}

# Dedicated Subnet for Bastion and Hence putting in resource Group of Bastion
resource "azurerm_subnet" "example" {
  name                 = "AzureBastionSubnet" # The name must be AzureBastionSubnet
  resource_group_name  = local.virtual_network.resource_group
  virtual_network_name = local.virtual_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Resource for Bastion Host
resource "azurerm_resource_group" "example" {
  name     = "bashtionhostRG-${local.location}"
  location = local.location
}

# Public IP
resource "azurerm_public_ip" "example" {
  name                = "bastion-${local.location}"
  resource_group_name = local.resource_group
  location            = local.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Bastion Host
resource "azurerm_bastion_host" "example" {
  name                = "examplebastion-${local.location}"
  location            = local.location
  resource_group_name = local.resource_group
  sku                 = "Standard"
  scale_units         = 2

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.example.id
    public_ip_address_id = azurerm_public_ip.example.id
  }
}


# Creating VM
## 1. Create NIC
resource "azurerm_network_interface" "bastion" {
  name                = "bastion-nic-${local.location}"
  location            = local.location
  resource_group_name = local.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.private.id
    private_ip_address_allocation = "Dynamic"
  }
}


## 2. Create VM that links to Bastion Host
resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-machine-${local.location}"
  resource_group_name = local.resource_group
  location            = local.location
  size                = "Standard_F2"

  network_interface_ids = [
    azurerm_network_interface.bastion.id,
  ]

  admin_username                  = "username123"
  admin_password                  = "ComplexPassword!23"
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-minimal-jammy"
    sku       = "minimal-22_04-lts"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }
}


# Optional if you want to access ACR from Bastion Host
# Role assignment to access ACR 
# resource "azurerm_role_assignment" "bastionVMACRPull" {
#   principal_id         = azurerm_linux_virtual_machine.example.identity.0.principal_id
#   scope                = azurerm_container_registry.example.id
#   role_definition_name = "AcrPull"
# }

# # Role assignment to access ACR 
# resource "azurerm_role_assignment" "bastionVMACRPush" {
#   principal_id         = azurerm_linux_virtual_machine.example.identity.0.principal_id
#   scope                = azurerm_container_registry.example.id
#   role_definition_name = "AcrPush"
# }
