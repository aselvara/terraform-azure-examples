variable "name" {}

variable "location" {}

variable "resource_group" {}

variable "tags" {
  type = object({})
}

variable "address_space" {
  type = list(string)
}

variable "subnets" {
  type = map(object({
    name             = string
    address_prefixes = list(string)
    })
  )
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