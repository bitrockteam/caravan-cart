locals {
  jobs = { for f in fileset(path.module, "*_job.hcl") : basename(trimsuffix(f, "_job.hcl")) => f }
}

resource "nomad_job" "jaeger" {
  for_each = local.job
  jobspec = templatefile(
    "${path.module}/job.hcl",
    {
      dc_names                   = var.dc_names,
      services_domain            = var.services_domain,
      monitoring_jobs_constraint = var.monitoring_jobs_constraint,
      elastic_service_name       = var.elastic_service_name,
      jeager_agent_service_name  = var.jeager_agent_service_name,
      artifacts_source_prefix    = var.artifacts_source_prefix,
    }
  )
}
