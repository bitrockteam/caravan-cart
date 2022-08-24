variable "dc_names" {
  type        = list(string)
  default     = null
  description = "Name of Nomad datacenter"
}
variable "nameserver_dummy_ip" {
  type    = string
  default = "192.168.0.1"
}
variable "services_domain" {
  type = string
}
variable "elastic_service_name" {
  type = string
}
variable "kibana_jobs_constraints" {
  type = list(map(string))
  default = [{
    attribute = "$${meta.nodeType}"
    operator  = "="
    value     = "monitoring"
  }]
  description = "List of constraints to be applied to jobs. Escape $ with double $."
}

variable "kibana_image_tag" {
  type    = string
  default = "7.17.5"
}
