job "minimal-service" {
    datacenters = [
      %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
    ]

    group "minimal-service-group" {
        network {
            mode = "bridge"
            port "http_envoy_prom" {
              to = "9102"
            }
            dns {
              servers = ["${nameserver_dummy_ip}"]
            }
        }

        update {
          max_parallel     = 2
          min_healthy_time  = "10s"
          healthy_deadline  = "5m"
          progress_deadline = "10m"
          auto_revert = true
        }

        service {
          name = "minimal-service"
          port = 9090
          meta {
            envoy_metrics_port = "$${NOMAD_HOST_PORT_http_envoy_prom}"
          }
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
            expose   = true
            name     = "minimal-service-health"
            type     = "http"
            protocol = "http"
            interval = "10s"
            timeout  = "5s"
            path     = "/health"
          }
        }

        task "minimal-service" {
            driver = "docker"

            config {
                image = "efbar/minimal-service:1.0.1"
            }

            env {
              SERVICE_PORT="9090"
              JAEGER_URL="http://jaeger-collector.service.consul:14268/api/traces"
            }

            resources {
                cpu    = 200
                memory = 250
            }

        }

    }

}
