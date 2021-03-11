resource "nomad_job" "filebeat" {
  jobspec = templatefile(
    "${path.module}/filebeat_job.hcl",
    {
      dc_names                  = var.dc_names,
      services_domain           = var.services_domain,
      elastic_service_name      = var.elastic_service_name,
      logstash_jobs_constraints = var.logstash_jobs_constraints
    }
  )
}
