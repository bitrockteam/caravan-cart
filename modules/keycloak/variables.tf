variable "dc_names" {
  type        = list(string)
  default     = null
  description = "Name of Nomad datacenter"
}
variable "nameserver_dummy_ip" {
  type    = string
  default = "192.168.0.1"
}
variable "keycloak_admin_user" {
    type = string
    default = "admin"
}
variable "keycloak_admin_password" {
    type = string
    default = "admin"
}
