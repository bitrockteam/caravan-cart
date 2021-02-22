resource "nomad_job" "openfaas" {
  jobspec = templatefile(
    "jobs/openfaas/faasd_bundle_job.hcl",
    {
      dc_names = var.dc_names
    }
  )
}
