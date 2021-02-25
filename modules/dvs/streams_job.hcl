job "dvs-streams" {
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

  group "dvs-streams" {
    network {
      mode = "bridge"
      port "http" {
        to = 3000
      }
      port "http_envoy_prom" {
        to = "9102"
      }
      dns {
        servers = [ "${nameserver_dummy_ip}" ]
      }
    }

    service {
      name = "dvs-streams"
      tags = ["dvs"]
      port = "http"
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
      name = "dvs-streams"
      port = "http_envoy_prom"

      tags = [
        "envoy",
        "prometheus"
      ]
    }

    task "dvs-streams" {
      driver = "docker"

      config {
        image = "618624782178.dkr.ecr.eu-west-1.amazonaws.com/kafka-dvs-streams:snapshot"
      }

      env {
        KAFKA.BOOTSTRAP.SERVERS = "localhost:9092"
        SCHEMAREGISTRY.URL = "http://localhost:8081"
        JAVA_OPTS = "-Xms2g -Xmx2g -XX:+PrintGCDetails"
      }

      resources {
        cpu = 2000
        memory = 4096
      }
    }
  }
}
