variable "resource_group" {}
variable "create_rg" {
    type = bool
    default = true
}
variable "location" {}
variable "subnet_name" {}
variable "vnet_name" {}
variable "vnet_rg" {}
variable "tags" {
    type = object({})
}