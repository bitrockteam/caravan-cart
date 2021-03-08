
variable "dc_names" {
  type        = list(string)
  default     = null
  description = "Name of Nomad datacenter"
}
variable "openfaas_jobs_constraints" {
  type = list(map(string))
  default = [{
    attribute = "$${meta.nodeType}"
    operator  = "="
    value     = "worker"
  }]
  description = "List of constraints to be applied to jobs. Escape $ with double $."
}
variable "faasd_version" {
  type    = string
  default = "0.11.2"
}
variable "faas_nats_version" {
  type    = string
  default = "0.11.2"
}
variable "faas_auth_plugin_version" {
  type    = string
  default = "0.20.5"
}
variable "faas_gateway_version" {
  type    = string
  default = "0.20.8"
}
variable "faas_queue_worker_version" {
  type    = string
  default = "0.11.2"
}
