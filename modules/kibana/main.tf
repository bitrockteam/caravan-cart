resource "nomad_job" "kibana" {
  jobspec = templatefile(
    "${path.module}/kibana_job.hcl",
    {
      dc_names                = var.dc_names,
      nameserver_dummy_ip     = var.nameserver_dummy_ip,
      services_domain         = var.services_domain,
      elastic_service_name    = var.elastic_service_name,
      kibana_jobs_constraints = var.kibana_jobs_constraints,
      kibana_image_tag        = var.kibana_image_tag
    }
  )
}
