variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "server_name" { type = string }
variable "admin_username" { type = string }
variable "admin_password" { type = string }
variable "sku_name" {
  type    = string
  default = "B_Standard_B1ms"
}
variable "storage_mb" {
  type    = number
  default = 32768
}
