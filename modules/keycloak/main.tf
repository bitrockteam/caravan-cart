resource "nomad_job" "keycloak" {
  jobspec = templatefile(
    "${path.module}/keycloak_job.hcl",
    {
      dc_names                 = var.dc_names,
      nameserver_dummy_ip      = var.nameserver_dummy_ip,
      keycloak_admin_user      = var.keycloak_admin_user,
      keycloak_admin_password  = var.keycloak_admin_password,
      keycloak_job_constraints = var.keycloak_job_constraints
    }
  )
}
