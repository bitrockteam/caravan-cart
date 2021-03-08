resource "nomad_job" "openfaas" {
  jobspec = templatefile(
    "${path.module}/openfaas_job.hcl",
    {
      dc_names                  = var.dc_names,
      openfaas_jobs_constraints = var.openfaas_jobs_constraints,
      faasd_version             = var.faasd_version,
      faas_nats_version         = var.faas_nats_version,
      faas_auth_plugin_version  = var.faas_auth_plugin_version,
      faas_gateway_version      = var.faas_gateway_version,
      faas_queue_worker_version = var.faas_queue_worker_version,
    }
  )
}
