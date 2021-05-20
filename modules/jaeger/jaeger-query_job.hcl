job "jaeger-query" {
    datacenters = [
        %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
    ]

    type = "service"

    %{ for constraint in jaeger_jobs_constraints ~}
    constraint {
        %{ for key, value in constraint ~}
        "${key}" = "${value}"
        %{ endfor ~}
    }
    %{ endfor ~}

    group "query" {
        network {
            mode = "host"
            port "http" {
                static = 16686
                to = 16686
            }
            port "http_admin" {}
        }
        service {
            name = "jaeger-query"
            tags = [ "monitoring" ]
            port = "http"
            
            check {
                type = "http"
                port = "http_admin"
                path = "/"
                interval = "5s"
                timeout = "2s"
            }

        }

        task "jaeger-query" {
            driver = "exec"

            template {
              data = "nameserver {{env `NOMAD_HOST_IP_http`}}"
              destination = "etc/resolv.conf"
            }

            config {
                command = "/usr/local/bin/jaeger-query"
                args = [
                    "--admin.http.host-port=0.0.0.0:$${NOMAD_PORT_http_admin}",
                    "--query.http-server.host-port=0.0.0.0:$${NOMAD_PORT_http}"
                ]
            }

            env {
                SPAN_STORAGE_TYPE = "elasticsearch"
                ES_SERVER_URLS = "http://${elastic_service_name}.${services_domain}:9200"
                JAEGER_AGENT_HOST = "${jaeger_agent_service_name}.${services_domain}"
                JAEGER_AGENT_PORT = "6831"
            }
        }
    }
}
