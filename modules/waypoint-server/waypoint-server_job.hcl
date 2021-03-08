job "waypoint-server" {
  datacenters = [
    %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
  ]

  %{ for constraint in waypoint_server_job_constraints ~}
    constraint {
      %{ for key, value in constraint ~}
      "${key}" = "${value}"
      %{ endfor ~}
    }
  %{ endfor ~}

    group "waypoint-server-group" {
        network {
            mode = "bridge"
            port "grpc" {
              to = 9701
            }
            port "ui" {
              static = 9702
              to = 9702
            }
            port "http_envoy_prom" {
                to = "9102"
            }
            dns {
                servers = ["${nameserver_dummy_ip}"]
            }
        }

        service {
          name = "waypoint-server"
          port = "ui"
          tags = []

          connect {
                sidecar_service {
                    port = "ui"
                }
          }

          check {
            port     = "ui"
            type     = "http"
            protocol = "https"
            interval = "25s"
            timeout  = "35s"
            path     = "/"
            tls_skip_verify = "true"
          }
        }
      
        service {
            name = "waypoint-server"
            port = "http_envoy_prom"

            tags = [
                "envoy", "prometheus"
            ]
        }

        task "waypoint-server" {
            driver = "docker"

            config {
                image = "hashicorp/waypoint"
                args = [ "server", "run", 
                  "-vvv",
                  "-advertise-tls=false", 
                  "-url-enabled=false", 
                  "-url-api-insecure=true",
                  "-db=alloc/data.db", 
                  "-listen-grpc=0.0.0.0:$${NOMAD_PORT_grpc}", 
                  "-listen-http=0.0.0.0:$${NOMAD_PORT_ui}"
                ]
            }

            env {
              PORT = "$${NOMAD_PORT_grpc}"
            }

            resources {
                cpu    = 200
                memory = 250
            }

        }

    }

}
