resource "nomad_job" "waypoint-server" {
  jobspec = templatefile(
    "${path.module}/waypoint-server_job.hcl",
    {
      dc_names = var.dc_names,
      nameserver_dummy_ip = var.nameserver_dummy_ip,
      job_constraints = var.job_constraints,
    }
  )
}
