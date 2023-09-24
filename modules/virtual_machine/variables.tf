variable "vm_rg" {}
variable "create_rg" {
    type = bool
}
variable "vnet_rg" {}
variable "vnet_name" {}
variable "subnet_name" {}
variable "tags" {
    type = object({})
}