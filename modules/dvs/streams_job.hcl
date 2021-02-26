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
  %{ endfor ~}

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
          SCHEMAREGISTRY.URL="{{ range service "schema-registry-dvs" }}http://{{ .Address }}:{{ .Port }},{{ end }}"
        EOH

        destination = "file.env"
        env         = true
      }
      env {
        JAVA_OPTS = "-Xms3g -Xmx3g -XX:+UseG1GC -XX:+UseStringDeduplication -XX:+PrintGCDetails"
      }

      resources {
        cpu = 4000
        memory = 4096
      }
    }
  }
}
