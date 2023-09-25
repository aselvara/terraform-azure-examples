data "terraform_remote_state" "network" {
  backend = "local"

  config = {
    path = "../network/terraform.tfstate"
  }
}

locals {
  virtual_network = {
    name           = data.terraform_remote_state.network.outputs.vnet_name
    resource_group = data.terraform_remote_state.network.outputs.vnet_rg
    private_subnet = data.terraform_remote_state.network.outputs.subnet_names[0]
  }
  tags = {
    environment = "Production"
  }
}

data "azurerm_virtual_network" "example" {
  name                = local.virtual_network.name
  resource_group_name = local.virtual_network.resource_group
}

module "acr" {
  source = "../modules/acr"

  resource_group = "acr"
  create_rg = true
  location = data.azurerm_virtual_network.example.location
  subnet_name = local.virtual_network.private_subnet
  vnet_name = local.virtual_network.name
  vnet_rg = local.virtual_network.resource_group
  tags  = local.tags
}