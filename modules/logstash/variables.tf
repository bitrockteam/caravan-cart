variable "dc_names" {
  type        = list(string)
  default     = null
  description = "Name of Nomad datacenter"
}
variable "services_domain" {
  type = string
}
variable "logstash_index_prefix" {
  type    = string
  default = "logs-"
}
variable "elastic_service_name" {
  type = string
}
variable "logstash_jobs_constraints" {
  type = list(map(string))
  default = [{
    attribute = "$${meta.nodeType}"
    operator  = "="
    value     = "monitoring"
  }]
  description = "List of constraints to be applied to jobs. Escape $ with double $."
}

