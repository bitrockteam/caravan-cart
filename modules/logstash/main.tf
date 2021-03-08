resource "nomad_job" "logstash" {
  jobspec = templatefile(
    "${path.module}/logstash_job.hcl",
    {
      dc_names                  = var.dc_names,
      logstash_index_prefix     = var.logstash_index_prefix,
      services_domain           = var.services_domain,
      elastic_service_name      = var.elastic_service_name,
      logstash_jobs_constraints = var.logstash_jobs_constraints
    }
  )
}
