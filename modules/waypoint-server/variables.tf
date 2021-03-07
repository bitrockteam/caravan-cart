variable "dc_names" {
  type        = list(string)
  default     = null
  description = "Name of Nomad datacenter"
}
variable "nameserver_dummy_ip" {
  type    = string
  default = "192.168.0.1"
}
variable "waypoint_server_job_constraints" {
  type = list(map(string))
  default = [{
    attribute = "$${meta.nodeType}"
    operator  = "="
    value     = "worker"
  }]
  description = "List of constraints to be applied to jobs. Escape $ with double $."
}
variable "nomad_endpoint" {
  type        = string
  description = "(required) nomad cluster endpoint"
}
