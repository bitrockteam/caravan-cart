variable "dc_names" {
  type        = list(string)
  default     = null
  description = "Name of Nomad datacenter"
}
variable "nameserver_dummy_ip" {
  type    = string
  default = "192.168.0.1"
}
