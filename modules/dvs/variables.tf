variable "dc_names" {
  type = list(string)
}

variable "jobs_constraint" {
  type = list(map(string))
  default = [{
    attribute = "$${meta.nodeType}"
    operator  = "="
    value     = "worker"
  }]
  description = "List of constraints to be applied to jobs running. Escape $ with double $."
}

variable "cp_jobs_constraint" {
  type = list(map(string))
  default = [{
    attribute = "$${meta.nodeType}"
    operator  = "="
    value     = "worker"
  }]
  description = "List of constraints to be applied to CP jobs running. Escape $ with double $."
}

variable "nameserver_dummy_ip" {
  type    = string
  default = "192.168.0.1"
}

variable "confluent_platform_dvs_enable" {
  type        = bool
  default     = false
  description = "Enable Confluent Platform Single Node Job"
}

variable "dvs_ws_url" {
  type    = string
  default = "https://dvs.$domain"
}

variable "dvs_http_url" {
  type    = string
  default = "https://dvs.$domain"
}

variable "dvs_google_api_key" {
  type    = string
  default = ""
}

variable "aviation_edge_key" {
  type    = string
  default = ""
}
