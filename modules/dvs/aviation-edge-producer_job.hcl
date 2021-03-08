job "dvs-aviation-edge-producer" {
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

  group "dvs-aviation-edge-producer" {
    network {
      mode = "bridge"
      port "http" {
        to = 8080
      }
      dns {
        servers = [
          "${nameserver_dummy_ip}"]
      }
    }

    service {
      name = "dvs-aviation-edge-producer"
      tags = [
        "dvs"]
      port = "http",
      check {
        type = "http"
        port = "http"
        path = "/health"
        interval = "30s"
        timeout = "10s"
      }
    }

    task "dvs-kafka-topics" {
      lifecycle {
        hook = "prestart"
        sidecar = true
      }
      driver = "docker"

      config {
        image = "confluentinc/cp-kafka:6.1.0"
        command = "bash"
        args = [
          "-c",
          "chmod +x /local/dvs-kafka-topics.sh && exec /local/dvs-kafka-topics.sh"
        ]
        volumes = [
        "local:/local:ro"
        ]
      }
      template {
        data = <<EOH
                  KAFKA.BOOTSTRAP.SERVERS="{{ range service "kafka-dvs" }}{{ .Address }}:{{ .Port }},{{ end }}"
                EOH

        destination = "file.env"
        env = true
      }
      template {
        data = <<EOH
          ${kafka_topics_script}
        EOH

        destination = "local/dvs-kafka-topics.sh"
      }
      env {
        JAVA_OPTS = "-Xms64m -Xmx64m"
      }

      resources {
        cpu = 100
        memory = 64
      }
    }
    task "dvs-aviation-edge-producer" {
      driver = "docker"

      config {
        image = "bitrockteam/kafka-dvs-aviation-edge-producer:snapshot"
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
        HOST = "0.0.0.0"
        AVIATION_EDGE.BASE_URL = "http://aviation-edge.com"
        AVIATION_EDGE.KEY =  "${aviation_edge_key}"
        OPEN_SKY.BASE_URL = "https://opensky-network.org"
        JAVA_OPTS = "-Xms3g -Xmx3g -XX:+UseG1GC -XX:+UseStringDeduplication -XX:+PrintGCDetails"
      }

      resources {
        cpu = 2000
        memory = 3072
      }
    }
  }
}
