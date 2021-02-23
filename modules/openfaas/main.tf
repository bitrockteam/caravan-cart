resource "nomad_job" "openfaas" {
  jobspec = templatefile(
    "${path.module}/job.hcl",
    {
      dc_names = var.dc_names
    }
  )
}
