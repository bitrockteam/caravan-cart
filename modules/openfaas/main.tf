resource "nomad_job" "openfaas" {
  jobspec = templatefile(
    "${path.module}/job.hcl",
    {
      dc_names                  = var.dc_names,
      openfaas_jobs_constraints = var.openfaas_jobs_constraints
    }
  )
}
