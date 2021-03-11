job "minimal-service" {
    datacenters = ["${dc_names}"]

    group "minimal-service-group" {
        network {
            mode = "bridge"
            port "http" {}
            dns {
              servers = ["${nameserver_dummy_ip}"]
            }
        }

        service {
          name = "minimal-service"
          port = "http"

          connect {
              sidecar_service {
                proxy {
                  upstreams {
                      destination_name = "minimal-service-2"
                      local_bind_port = 8080
                  } 
                }
              }
          }

          check {
            type     = "http"
            protocol = "http"
            port     = "http"
            interval = "25s"
            timeout  = "35s"
            path     = "/health"
          }
        }

        task "minimal-service" {
            driver = "docker"

            config {
                image = "efbar/minimal-service:1.0.1"
                ports = ["http"]
            }

            env {
              SERVICE_PORT="$${NOMAD_PORT_http}"
            }

            resources {
                cpu    = 200
                memory = 250
            }

        }

    }

}
