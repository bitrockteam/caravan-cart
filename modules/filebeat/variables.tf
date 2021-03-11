variable "dc_names" {
  type        = list(string)
  default     = null
  description = "Name of Nomad datacenter"
}
variable "domain" {
  type = string
}
variable "services_domain" {
  type = string
}
variable "elastic_service_name" {
  type    = string
  default = "elastic-internal"
}
variable "kibana_service_name" {
  type    = string
  default = "kibana"
}
