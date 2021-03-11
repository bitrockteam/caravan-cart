locals {
  minimal_jobs = { for f in fileset(path.module, "*_job.hcl") : basename(trimsuffix(f, "_job.hcl")) => f }
}

resource "nomad_job" "minimal-services" {
  for_each = local.minimal_jobs
  jobspec = templatefile(
    "${path.module}/${each.value}",
    {
      dc_names                 = var.dc_names,
      nameserver_dummy_ip      = var.nameserver_dummy_ip,
    }
  )
}
