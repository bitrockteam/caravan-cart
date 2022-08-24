job "kibana" {
  datacenters = [
    %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
  ]

  type = "service"

  %{ for constraint in kibana_jobs_constraints ~}
  constraint {
    %{ for key, value in constraint ~}
    "${key}" = "${value}"
    %{ endfor ~}
  }
  %{ endfor ~}

  group "kibana-group" {
    network {
      mode = "bridge"
      port "http_envoy_prom" {
        to = "9102"
      }
      dns {
        servers = ["${nameserver_dummy_ip}"]
      }
    }

    service {
      name = "kibana"
      tags = ["monitoring"]
      port = 5601,
      meta {
        envoy_metrics_port = "$${NOMAD_HOST_PORT_http_envoy_prom}"
      }
      check {
        expose = true
        name = "kibana-health"
        type = "http"
        path = "/api/status"
        interval = "5s"
        timeout = "2s"
      }
      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "${elastic_service_name}"
              local_bind_port = 9200
            }
          }
        }
      }

    }

    task "kibana" {
      driver = "docker"

      config {
        image = "docker.elastic.co/kibana/kibana:${kibana_image_tag}"
      }

      env {
        SERVER_NAME = "kibana.${services_domain}"
        ELASTICSEARCH_HOSTS = "http://localhost:9200"
        TELEMETRY_ENABLED = "false"
        MONITORING_UI_CONTAINER_ELASTICSEARCH_ENABLED = "false"
        STATUS_ALLOWANONYMOUS = "true"
        XPACK_SECURITY_ENABLED = "false"
      }

      resources {
        cpu = 300
        memory = 1000
      }

    }
  }
}
