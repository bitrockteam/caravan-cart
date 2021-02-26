job "dvs-ui" {
  datacenters = [
    %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
  ]

  type = "service"

  %{ for constraint in jobs_constraint ~}
  constraint {
    %{ for key, value in constraint ~}
    "${key}" = "${value}"
    %{ endfor ~}
  }
  %{ endfor ~}

  group "dvs-ui" {
    network {
      mode = "bridge"
      port "http" {
        to = 3000
      }
      port "http_envoy" {}
      port "http_envoy_prom" {
        to = "9102"
      }
      dns {
        servers = [
          "${nameserver_dummy_ip}"]
      }
    }

    service {
      name = "dvs-ui"
      tags = [ "dvs" ]
      port = "http",
      check {
        type = "http"
        port = "http_envoy"
        path = "/nginx_status"
        interval = "5s"
        timeout = "2s"
      }

      connect {
        sidecar_service {
            port = "http_envoy"
            proxy {
                expose {
                  path {
                    path            = "/nginx_status"
                    protocol        = "http"
                    local_path_port = 3000
                    listener_port   = "http_envoy"
                  }
                }
            }
        }
      }
    }

    service {
      name = "dvs-ui"
      port = "http_envoy_prom"

      tags = [
      "envoy", "prometheus"
      ]
    }

    task "dvs-ui" {
      driver = "docker"

      config {
        image = "bitrockteam/kafka-dvs-ui:snapshot"
      }

      env {
        NGINX_PORT = "127.0.0.1:3000"
        DVS_WS_URL = "https://dvs-api.${domain}"
        DVS_HTTP_URL = "https://dvs.${domain}"
        DVS_GOOGLE_API_KEY = "${dvs_google_api_key}"
      }

      resources {
        cpu = 300
        memory = 64
      }
    }
  }
}
