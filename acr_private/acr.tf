data "terraform_remote_state" "network" {
  backend = "local"

  config = {
    path = "../network/terraform.tfstate"
  }
}

data "terraform_remote_state" "bastion_host" {
  backend = "local"

  config = {
    path = "../bastion_host/terraform.tfstate"
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

# Providing access to Bastion VM to pull images from ACR
resource "azurerm_role_assignment" "acr_pull_bastion_host" {
  scope                = module.acr.acr_id
  role_definition_name = "AcrPull"
  principal_id         = data.terraform_remote_state.bastion_host.outputs.bastion_vm_identity[0].principal_id
}

# Providing access to Bastion VM to push images to ACR
resource "azurerm_role_assignment" "acr_push_bastion_host" {
  scope                = module.acr.acr_id
  role_definition_name = "AcrPush"
  principal_id         = data.terraform_remote_state.bastion_host.outputs.bastion_vm_identity[0].principal_id
}

