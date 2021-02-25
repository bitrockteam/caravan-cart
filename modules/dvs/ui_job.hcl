job "dvs-ui" {
  datacenters = [
    //%{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
  ]

  type = "service"

  //%{ for constraint in monitoring_jobs_constraint ~}
  constraint {
    //%{ for key, value in constraint ~}
    //"${key}" = "${value}"
    //%{ endfor ~}
  }
  //{ endfor ~}

  group "dvs-ui" {
    network {
      mode = "bridge"
      port "http" {
        to = 3000
      }
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
      connect {
        sidecar_service {
          port = "http"
        }
      }

    }

    service {
      name = "dvs-ui"
      port = "http_envoy_prom"

      tags = [
        "envoy",
        "prometheus"
      ]
    }

    task "dvs-ui" {
      driver = "docker"

      config {
        image = "618624782178.dkr.ecr.eu-west-1.amazonaws.com/kafka-dvs-ui:snapshot"
      }

      env {
        NGINX_PORT = 3000
        DVS_WS_URL = "${DVS_WS_URL}"
        DVS_HTTP_URL = "${DVS_HTTP_URL}"
        DVS_GOOGLE_API_KEY = "${DVS_GOOGLE_API_KEY}"
      }

      resources {
        cpu = 300
        memory = 64
      }
    }
  }
}
