job "faasd_bundle" {
  datacenters = ["${dc_names}"]
  type        = "service"
 
  %{ for constraint in openfaas_jobs_constraints ~}
  constraint {
      %{ for key, value in constraint ~}
      "${key}" = "${value}"
      %{ endfor ~}
  }
  %{ endfor ~}

  group "faasd" {

    restart {
      attempts = 100
      delay    = "5s"
      interval = "10m"
      mode     = "delay"
    }

    network {
      port "faasd_http" {
        static = 8081
        to = 8081
      }
      port "auth_http" {}
      port "nats_tcp" {}
      port "nats_tcp_1" {
        to = 6222
      }
      port "nats_mon" {}
      port "gateway_http" {
        to = 8080
      }
      port "gateway_mon" {
        to = 8082
      }
      dns {
        servers = ["10.0.2.15"]
      }
    }

    service {
        name = "faasd-basic-auth"
        tags = [ "serverless" ]
        port = "auth_http"
          
        check {
            type = "tcp"
            port = "auth_http"
            interval = "5s"
            timeout = "2s"
        }
    }

    service {
        name = "faasd-nats"
        tags = [ "serverless" ]
        port = "nats_tcp"
          
        check {
            type = "tcp"
            port = "nats_tcp"
            interval = "5s"
            timeout = "2s"
        }
    }

    service {
        name = "faasd-gateway"
        tags = [ "serverless" ]
        port = "gateway_http"

        check {
            type = "tcp"
            port = "gateway_http"
            interval = "5s"
            timeout = "2s"
        }
    }

    service {
        name = "faasd-mon"
        tags = [ "serverless" ]
        port = "gateway_mon"

        check {
            type = "http"
            path = "/metrics"
            port = "gateway_mon"
            interval = "30s"
            timeout = "2s"
        }
    }

    service {
        name = "faasd-provider"
        tags = [ "serverless" ]
        port = "faasd_http"
        check {
            type = "tcp"
            port = "faasd_http"
            interval = "5s"
            timeout = "2s"
        }
    }

    task "download-faasd" {
      lifecycle {
        hook = "prestart"
        sidecar = false
      }

      driver = "raw_exec"
      config {
        command = "sh"
        args = ["-c", "wget -q https://github.com/openfaas/faasd/releases/download/${faasd_version}/faasd && mv faasd /usr/local/bin/faasd && chmod +x /usr/local/bin/faasd"]
      }
    }

    task "faasd_provider" {
      driver = "raw_exec"
      config {
        command = "/usr/local/bin/faasd"
        args = ["provider"]
      }
      resources {
        cpu    = 50
        memory = 100
      }
    }

    task "nats" {
      driver = "docker"
      config {
        image = "docker.io/library/nats-streaming:${faas_nats_version}"
        ports = ["nats_tcp", "nats_tcp_1"]
        entrypoint = ["/nats-streaming-server"]
        args = [
          "-p",
          "$${NOMAD_PORT_nats_tcp}",
          "-m",
          "$${NOMAD_PORT_nats_mon}",
          "--store=memory",
          "--cluster_id=faas-cluster",
          "-DV"
        ]
        cap_add = [
          "CAP_NET_RAW",
        ]
      }
      resources {
        cpu    = 50
        memory = 50
      }
    }

    task "basic-auth-plugin" {
      driver = "docker"

      config {
        image = "ghcr.io/openfaas/basic-auth:${faas_auth_plugin_version}"
        ports = ["auth_http"]
        cap_add = [
          "CAP_NET_RAW",
        ]
      }

      template {
        data = "password"
        destination = "secrets/basic-auth-password"
      }

      template {
        data = "admin"
        destination = "secrets/basic-auth-user"
      }

      env {
        port = "$${NOMAD_PORT_auth_http}"
        secret_mount_path = "/secrets/"
        user_filename = "basic-auth-user"
        pass_filename = "basic-auth-password"
      }

      resources {
        cpu    = 20
        memory = 30
      }
    }

    task "gateway" {
      driver = "docker"
      config {
        image = "ghcr.io/openfaas/gateway:${faas_gateway_version}"
        ports = ["gateway_http", "gateway_mon"]
        cap_add = [
          "CAP_NET_RAW",
        ]
      }
      template {
        data = "password"
        destination = "secrets/basic-auth-password"
      }
      template {
        data = "admin"
        destination = "secrets/basic-auth-user"
      }
      env {
        basic_auth="true"
        functions_provider_url="http://faasd-provider.service.consul:$${NOMAD_PORT_faasd_http}/"
        direct_functions="false"
        read_timeout="65s"
        write_timeout="65s"
        upstream_timeout="60s"
        faas_prometheus_host="$${NOMAD_HOST_IP_gateway_http}"
        faas_nats_address="faasd-nats.service.consul"
        faas_nats_port="$${NOMAD_PORT_nats_tcp}"
        auth_proxy_url="http://faasd-basic-auth.service.consul:$${NOMAD_PORT_auth_http}/validate"
        auth_proxy_pass_body="false"
        secret_mount_path="/secrets"
        scale_from_zero="true"
        function_namespace="openfaas-fn"
      }
      resources {
        cpu    = 50
        memory = 50
      }
    }

    task "queue-worker" {
      driver = "docker"
      config {
        image = "docker.io/openfaas/queue-worker:${faas_queue_worker_version}"
        cap_add = [
          "CAP_NET_RAW",
        ]
      }
      template {
        data = "password"
        destination = "secrets/basic-auth-password"
      }

      template {
        data = "admin"
        destination = "secrets/basic-auth-user"
      }
      env {
        faas_nats_address="faasd-nats.service.consul"
        faas_nats_port="$${NOMAD_PORT_nats_tcp}"
        gateway_invoke="true"
        faas_gateway_address="faads-gateway.service.consul:$${NOMAD_PORT_gateway_http}"
        ack_wait="5m5s"
        max_inflight="1"
        write_debug="true"
        basic_auth="true"
        secret_mount_path="/secrets"
      }
      resources {
        cpu    = 50
        memory = 50
      }
    }
  }
}
