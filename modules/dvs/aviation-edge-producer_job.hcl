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
  { endfor ~}

  group "dvs-aviation-edge-producer" {
    network {
      mode = "bridge"
      port "http" {
        to = 1081
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

    task "dvs-aviation-edge-producer" {
      driver = "docker"

      config {
        image = "bitrockteam/kafka-dvs-aviation-edge-producer:snapshot"
      }
      template {
        data = <<EOH
          KAFKA.BOOTSTRAP.SERVERS="{{ range service "kafka-dvs" }}{{ .Address }}:{{ .Port }},{{ end }}"
          SCHEMAREGISTRY.URL="{{ range service "schema-registry-dvs" }}{{ .Address }}:{{ .Port }},{{ end }}"
        EOH

        destination = "file.env"
        env = true
      }
      env {
        AVIATION_EDGE.BASE_URL = "http://aviation-edge.com"
        AVIATION_EDGE.KEY =  "${aviation_edge_key}"
        OPEN_SKY.BASE_URL = "https://opensky-network.org"
        JAVA_OPTS = "-Xms2g -Xmx2g -XX:+PrintGCDetails"
      }

      resources {
        cpu = 1000
        memory = 2512
      }
    }
  }
}
