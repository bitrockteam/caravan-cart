resource "nomad_job" "filebeat" {
  jobspec = templatefile(
    "${path.module}/filebeat_job.hcl",
    {
      dc_names             = var.dc_names,
      domain               = var.domain
      services_domain      = var.services_domain,
      elastic_service_name = var.elastic_service_name,
      kibana_service_name  = var.kibana_service_name
    }
  )
}
