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

# Dedicated Subnet for Bastion
resource "azurerm_subnet" "az_bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.1.2.0/24"]
}

# Public IP
resource "azurerm_public_ip" "bastion" {
  name                = "bastion"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Bastion Host
resource "azurerm_bastion_host" "example" {
  name                = "examplebastion"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard"
  scale_units         = 2

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.az_bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}

# Creating VM
## 1. Create NIC
resource "azurerm_network_interface" "bastion" {
  name                = "bastion-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}
## 2. Create VM
resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
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
resource "azurerm_role_assignment" "bastionVMACRPull" {
  principal_id         = azurerm_linux_virtual_machine.example.identity.0.principal_id
  scope                = azurerm_container_registry.example.id
  role_definition_name = "AcrPull"
}

# Role assignment to access ACR 
resource "azurerm_role_assignment" "bastionVMACRPush" {
  principal_id         = azurerm_linux_virtual_machine.example.identity.0.principal_id
  scope                = azurerm_container_registry.example.id
  role_definition_name = "AcrPush"
}
