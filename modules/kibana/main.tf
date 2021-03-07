resource "nomad_job" "kibana" {
  jobspec = templatefile(
    "${path.module}/kibana_job.hcl",
    {
      dc_names = var.dc_names,
      nameserver_dummy_ip = var.nameserver_dummy_ip,
      elastic_service_name = var.elastic_service_name,
    }
  )
}
