job "dvs-streams" {
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

  group "dvs-streams" {
    network {
      mode = "bridge"
      dns {
        servers = [ "${nameserver_dummy_ip}" ]
      }
    }

    task "dvs-streams" {
      driver = "docker"

      config {
        image = "bitrockteam/kafka-dvs-streams:snapshot"
      }
      template {
        data = <<EOH
          KAFKA.BOOTSTRAP.SERVERS="{{ range service "kafka-dvs" }}{{ .Address }}:{{ .Port }},{{ end }}"
          SCHEMAREGISTRY.URL="{{ range service "schema-registry-dvs" }}{{ .Address }}:{{ .Port }},{{ end }}"
        EOH

        destination = "file.env"
        env         = true
      }
      env {
        JAVA_OPTS = "-Xms2g -Xmx2g -XX:+PrintGCDetails"
      }

      resources {
        cpu = 2000
        memory = 4096
      }
    }
  }
}
