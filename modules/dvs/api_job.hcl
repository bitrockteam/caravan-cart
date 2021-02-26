job "dvs-api" {
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

  group "dvs-api" {
    network {
      mode = "bridge"
      dns {
        servers = [
          "${nameserver_dummy_ip}"]
      }
    }

    service {
      name = "dvs-api"
      tags = [
        "dvs"]
      port = "1081",
      check {
        expose = true
        name = "dvs-api-health"
        type = "http"
        path = "/health"
        interval = "30s"
        timeout = "10s"
      }
      connect {
        sidecar_service {
        }
      }
    }

    task "dvs-api" {
      driver = "docker"

      config {
        image = "bitrockteam/kafka-dvs-api:snapshot"
      }
      template {
        data = <<EOH
          KAFKA.BOOTSTRAP.SERVERS="{{ range service "kafka-dvs" }}{{ .Address }}:{{ .Port }},{{ end }}"
          SCHEMAREGISTRY.URL="{{ range service "schema-registry-dvs" }}http://{{ .Address }}:{{ .Port }},{{ end }}"
        EOH

        destination = "file.env"
        env = true
      }
      env {
        HOST = "127.0.0.1"
        PORT = "1081"
        JAVA_OPTS = "-Xms2g -Xmx2g -XX:+UseG1GC -XX:+UseStringDeduplication -XX:+PrintGCDetails"
      }

      resources {
        cpu = 1000
        memory = 2512
      }
    }
  }
}
