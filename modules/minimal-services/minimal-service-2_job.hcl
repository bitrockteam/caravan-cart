job "minimal-service-2" {
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
        count = 2
        update {
          max_parallel      = 1
//          canary            = 1
          min_healthy_time  = "10s"
          healthy_deadline  = "5m"
          progress_deadline = "10m"
          auto_revert   = true
//          auto_promote  = false
        }

        service {
          name = "minimal-service-2"
          port = 9090
          meta {
            envoy_metrics_port = "$${NOMAD_HOST_PORT_http_envoy_prom}"
          }
          connect {
              sidecar_service {}
          }

          check {
            expose   = true
            name     = "minimal-service-2-health"
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
                image = "efbar/minimal-service:${minimal2_version}"
            }

            env {
              SERVICE_PORT="9090"
              TRACING="1"
              JAEGER_URL="http://jaeger-collector.service.consul:14268/api/traces"
            }

            resources {
                cpu    = 200
                memory = 250
            }

        }

    }

}
