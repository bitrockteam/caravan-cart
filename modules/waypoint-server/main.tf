resource "nomad_job" "waypoint-server" {
  jobspec = templatefile(
    "${path.module}/waypoint-server_job.hcl",
    {
      dc_names                        = var.dc_names,
      nameserver_dummy_ip             = var.nameserver_dummy_ip,
      waypoint_server_job_constraints = var.waypoint_server_job_constraints,
    }
  )
}
