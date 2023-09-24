module "network" {
  source = "../modules/virtual_network"

  # creates VNet
  name           = "example"
  location       = "eastus"
  resource_group = "example"
  address_space  = ["10.0.0.0/16"]
  tags           = {
    environment = "Production"
  }
  subnets = {
    "private_subnet_1" = {
      name             = "private-subnet-1"
      address_prefixes = ["10.0.2.0/24"]
    }
  }
}

output "vnet_name" {
    value = module.network.vnet_name
}
output "vnet_rg" {
    value = module.network.vnet_rg
}
output "subnet_names" {
    value = module.network.subnet_names
}