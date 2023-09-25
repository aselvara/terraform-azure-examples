variable "network_name" {}

variable "location" {}

variable "tags" {
  type = object({})
  default = {}
}

variable "address_space" {
  type = list(string)
}


variable "subnets" {
  type = map(object({
    name = string
    address_prefixes = list(string)
    private_endpoint_network_policies_enabled = optional(bool, true)
  }))
  default = {}
}

/* example 
subnets = {
    "subnet1" = {
        name = "abc"
        address_prefixes = ["10.1.1.0/16"]
    }
} 
*/