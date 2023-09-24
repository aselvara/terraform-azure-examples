locals {
    location = data.azurerm_virtual_network.vm.location 
    resource_group = var.vm_rg
    create_rg = var.create_rg
    subnet_name = var.subnet_name
    vnet_name = var.vnet_name
    vnet_rg = var.vnet_rg
    tags = var.tags
}

data "azurerm_virtual_network" "vm" {
  name                = local.vnet_name
  resource_group_name = local.vnet_rg
}

data "azurerm_subnet" "vm" {
  name                 = local.subnet_name
  virtual_network_name = local.vnet_name
  resource_group_name  = local.vnet_rg
}

resource "azurerm_resource_group" "vm" {
  count = local.create_rg ? 1 : 0
  name     = "${local.resource_group}-${local.location}"
  location = local.location
  tags     = local.tags
}

# Create NIC
resource "azurerm_network_interface" "vm" {
  name                = "nic-${local.location}"
  location            = local.location
  resource_group_name = local.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.vm.id
    private_ip_address_allocation = "Dynamic"
  }
}

## 2. Create VM that links to Bastion Host
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "example-machine-${local.location}"
  resource_group_name = local.resource_group
  location            = local.location
  size                = "Standard_F2"

  network_interface_ids = [
    azurerm_network_interface.vm.id,
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
