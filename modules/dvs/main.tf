locals {
  dvs_jobs = { for f in fileset(path.module, "*_job.hcl") : basename(trimsuffix(f, "_job.hcl")) => f }
}

resource "nomad_job" "dvs" {
  for_each = local.dvs_jobs
  jobspec = templatefile(
    each.value,
    {
      dc_names            = var.dc_names
      nameserver_dummy_ip = var.nameserver_dummy_ip
      jobs_constraint     = var.jobs_constraint
      dvs_ws_url          = var.dvs_ws_url
      dvs_http_url        = var.dvs_http_url
      dvs_google_api_key  = var.dvs_google_api_key
      aviation_edge_key   = var.aviation_edge_key
    }
  )
}

resource "nomad_job" "confluent_platform_dvs" {
  count = var.confluent_platform_dvs_enable ? 1 : 0
  jobspec = templatefile(
    "confluent-platform-dvs_job.hcl",
    {
      dc_names            = var.dc_names
      nameserver_dummy_ip = var.nameserver_dummy_ip
      jobs_constraint     = var.jobs_constraint
    }
  )
}
