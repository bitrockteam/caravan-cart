job "keycloak" {
    datacenters = [
    %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
  ]

  %{ for constraint in keycloak_job_constraint ~}
    constraint {
      %{ for key, value in constraint ~}
      "${key}" = "${value}"
      %{ endfor ~}
    }
  %{ endfor ~}

    group "keycloak-group" {
        network {
            mode = "bridge"
            port "http" {}
            port "https" {}
            port "http_envoy_prom" {
                to = "9102"
            }
            dns {
                servers = ["${nameserver_dummy_ip}"]
            }
        }

        service {
          name = "keycloak"
          port = "http"
          tags = []

          connect {
            sidecar_service {
                port = "http"
                proxy {}
            }
          }
          check {
            type     = "http"
            protocol = "http"
            port     = "http"
            interval = "25s"
            timeout  = "35s"
            path     = "/auth"
          }
          check {
            type     = "http"
            protocol = "https"
            port     = "https"
            interval = "25s"
            timeout  = "35s"
            path     = "/auth"
            tls_skip_verify = "true"
          }
        }

        service {
            name = "keycloak"
            port = "http_envoy_prom"

            tags = [
                "envoy", "prometheus"
            ]
        }

        task "keycloak" {
            driver = "docker"

            config {
                image = "jboss/keycloak:12.0.3"
                args = [
                    "-Djboss.bind.address=0.0.0.0", 
                    "-Djboss.http.port=$${NOMAD_PORT_http}", 
                    "-Djboss.https.port=$${NOMAD_PORT_https}"
                ]
            }

            env {
                KEYCLOAK_USER = "admin" 
                KEYCLOAK_PASSWORD = "admin"
                PROXY_ADDRESS_FORWARDING = "true"
            }

            resources {
                cpu    = 500
                memory = 1000
            }

        }

    }
}
