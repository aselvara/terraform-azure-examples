locals {
    location = "eastus"
}

module "network" {
  source = "../modules/virtual_network"

  # creates VNet
  network_name = "example"
  location       = local.location
  address_space  = ["10.0.0.0/16"]
  tags           = {
    environment = "Production"
  }
  subnets = {
    "private_subnet_1" = {
      name             = "private-subnet-1"
      address_prefixes = ["10.0.2.0/24"]
    },
    "private_acr" = {
      name             = "private-acr"
      address_prefixes = ["10.0.3.0/24"],
      private_endpoint_network_policies_enabled = false
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
