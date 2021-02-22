resource "nomad_job" "openfaas" {
  jobspec = templatefile(
    "job.hcl",
    {
      dc_names = var.dc_names
    }
  )
}
