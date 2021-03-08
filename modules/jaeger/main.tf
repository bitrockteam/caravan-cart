locals {
  jobs = { for f in fileset(path.module, "*_job.hcl") : basename(trimsuffix(f, "_job.hcl")) => f }
}

resource "nomad_job" "jaeger_jobs" {
  for_each = local.jobs
  jobspec = templatefile(
    "${path.module}/${each.value}",
    {
      dc_names                  = var.dc_names,
      services_domain           = var.services_domain,
      jaeger_jobs_constraints   = var.jaeger_jobs_constraints,
      elastic_service_name      = var.elastic_service_name,
      jeager_agent_service_name = var.jeager_agent_service_name,
      artifacts_source_prefix   = var.artifacts_source_prefix,
    }
  )
}
