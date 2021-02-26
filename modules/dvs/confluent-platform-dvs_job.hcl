job "confluent-platform-dvs" {
  datacenters = [
    "aws-dc"
  ]

  type = "service"


  group "confluent-platform" {
    network {
      mode = "bridge"
      port "http_zook" {
        to = 2181
      }
      port "http_broker" {
        to = 9092
      }
      port "http_schema" {
        to = 8081
      }
      dns {
        servers = [
          "192.168.0.1" ]
      }
    }

    service {
      name = "zookeeper-dvs"
      tags = [
        "dvs"]
      port = "http_zook"
    }

    service {
      name = "kafka-dvs"
      tags = [
        "dvs"]
      port = "http_broker"
    }

    service {
      name = "schema-registry-dvs"
      tags = [
        "dvs"]
      port = "http_schema"
    }

    task "zookeeper" {
      driver = "docker"

      config {
        image = "confluentinc/cp-zookeeper:5.4.3"
      }

      env {
        ZOOKEEPER_CLIENT_PORT = 2181
        ZOOKEEPER_TICK_TIME = 2000
      }

      resources {
        cpu = 300
        memory = 512
      }
    }
    task "broker" {
      driver = "docker"

      config {
        image = "confluentinc/cp-enterprise-kafka:5.4.3"
      }

      env {
        KAFKA_BROKER_ID = 1
        KAFKA_ZOOKEEPER_CONNECT = "${NOMAD_HOST_ADDR_http_zook}"
        KAFKA_LISTENER_SECURITY_PROTOCOL_MAP = "PLAINTEXT:PLAINTEXT"
        KAFKA_ADVERTISED_LISTENERS = "PLAINTEXT://kafka-dvs.service.consul:${NOMAD_HOST_PORT_http_broker}"
        KAFKA_METRIC_REPORTERS = "io.confluent.metrics.reporter.ConfluentMetricsReporter"
        KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR = 1
        KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS = 0
        KAFKA_MESSAGE_MAX_BYTES = 8388608
        CONFLUENT_METRICS_REPORTER_BOOTSTRAP_SERVERS = "${NOMAD_HOST_ADDR_http_broker}"
        CONFLUENT_METRICS_REPORTER_ZOOKEEPER_CONNECT = "${NOMAD_HOST_ADDR_http_zook}"
        CONFLUENT_METRICS_REPORTER_TOPIC_REPLICAS = 1
        CONFLUENT_METRICS_ENABLE = "true"
        CONFLUENT_SUPPORT_CUSTOMER_ID = "anonymous"
      }

      resources {
        cpu = 2000
        memory = 2048
      }
    }
    task "schema-registry" {
      driver = "docker"

      config {
        image = "confluentinc/cp-schema-registry:5.4.3"
      }

      env {
        SCHEMA_REGISTRY_HOST_NAME = "schema-registry"
        SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS = "${NOMAD_HOST_ADDR_http_broker}"
      }

      resources {
        cpu = 300
        memory = 512
      }
    }
  }
}
