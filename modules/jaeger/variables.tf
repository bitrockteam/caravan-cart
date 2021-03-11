variable "dc_names" {
  type        = list(string)
  default     = null
  description = "Name of Nomad datacenter"
}
variable "services_domain" {
  type = string
}
variable "jaeger_jobs_constraints" {
  type = list(map(string))
  default = [{
    attribute = "$${meta.nodeType}"
    operator  = "="
    value     = "monitoring"
  }]
  description = "List of constraints to be applied to jobs. Escape $ with double $."
}
variable "elastic_service_name" {
  type = string
}
variable "jaeger_agent_service_name" {
  type    = string
  default = "jaeger-agent"
}
variable "artifacts_source_prefix" {
  type = string
}

