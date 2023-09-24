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

module "bastion_host" {
  source = "../modules/bastion_host"

  vnet_name = local.virtual_network.name
  vnet_rg =  local.virtual_network.resource_group
  subnet_addr = ["10.0.1.0/24"]
}

module "bastion_vm" {
  source = "../modules/virtual_machine"

  vnet_name = local.virtual_network.name
  vnet_rg =  local.virtual_network.resource_group
  subnet_name = local.virtual_network.private_subnet
  vm_rg = "bastion-VM"
  create_rg = true
  tags = local.tags
}