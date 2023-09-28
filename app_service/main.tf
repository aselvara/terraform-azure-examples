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
  location = data.azurerm_virtual_network.example.location
  resource_group = "RG-AppServices-${local.location}"
}

data "azurerm_virtual_network" "example" {
  name                = local.virtual_network.name
  resource_group_name = local.virtual_network.resource_group
}

module "app_service" {
    source = "../modules/app_service"

    create_rg = true 
    resource_group = local.resource_group
    location = local.location
}