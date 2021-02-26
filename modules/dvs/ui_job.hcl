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
      dns {
        servers = [
          "${nameserver_dummy_ip}"]
      }
    }

    service {
      name = "dvs-ui"
      tags = [
        "dvs"]
      port = "http",
      check {
        type = "http"
        port = "http"
        path = "/nginx_status"
        interval = "5s"
        timeout = "2s"
      }
    }

    task "dvs-ui" {
      driver = "docker"

      config {
        image = "bitrockteam/kafka-dvs-ui:snapshot"
      }

      env {
        NGINX_PORT = 3000
        DVS_WS_URL = "${dvs_ws_url}"
        DVS_HTTP_URL = "${dvs_http_url}"
        DVS_GOOGLE_API_KEY = "${dvs_google_api_key}"
      }

      resources {
        cpu = 300
        memory = 64
      }
    }
  }
}
