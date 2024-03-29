job "jaeger-deps" {
    datacenters = [
        %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
    ]

    type = "batch"

    periodic {
        cron             = "@daily"
        prohibit_overlap = true
    }

    %{ for constraint in jaeger_jobs_constraints ~}
    constraint {
        %{ for key, value in constraint ~}
        "${key}" = "${value}"
        %{ endfor ~}
    }
    %{ endfor ~}

    group "batch" {

        task "jaeger-deps" {
            driver = "exec"

            template {
              data = "nameserver {{env `attr.unique.network.ip-address`}}"
              destination = "etc/resolv.conf"
            }

            config {
                command = "/bin/java"
                args =  [
                  "-Xmx2048m",
                  "-Xms256m",
                  "-jar", "local/jaeger-spark-dependencies-0.0.1-SNAPSHOT.jar"
                ] 
            }

            env {
                STORAGE = "elasticsearch"
                ES_NODES = "http://${elastic_service_name}.${services_domain}:9200"
            }

            artifact {
                source = "${artifact_source_jaeger_spark_dependecies}",
                destination = "local/"
            }

            resources {
                cpu    = 200
                memory = 2048
            }
        }
    }
}
