variable "vm_rg" {}
variable "vm_name" {}
variable "create_rg" {
    type = bool
}
variable "vnet_rg" {}
variable "vnet_name" {}
variable "subnet_name" {}
variable "tags" {
    type = object({})
}