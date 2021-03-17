# Caravan Cart

Caravan Cart is a collection of Terraform modules for deploying sample applications on Hashicorp Nomad. These applications have been used for testing the platform deployed by Caravan. The applications are provided _as is_.

## Applications

| Application | Description | Module path |
|---|---|---|
|`DVS`|Bitrock's DVS project, [here](https://github.com/bitrockteam/kafka-dvs-ui) more|`/dvs`|
|`Waypoint`| [Hashicorp's Waypoint](https://www.waypointproject.io) |`/waypoint-server`|
|`Filebeat`|[Elastic's filebeat](https://www.elastic.co/beats/filebeat)|`/filebeat`|
|`Kibana`|[Elastic's Kibana visualizer](https://www.elastic.co/kibana)|`/kibana`|
|`Logstash`|[Elastic's Logstash collector](https://www.elastic.co/logstash)|`/logstash`|
|`Jaeger Tracing`|[Jaeger tracing](https://www.jaegertracing.io)|`/jaeger`|
|`Keycloak`|[JBoss Keycloak](https://www.keycloak.org)|`keycloak`|
|`Openfaas`|[openfaas.com](https://www.openfaas.com/), serverless made simple|`/openfaas`|
|`Minimal Service`|Minimal service for testing purposes, [here](https://github.com/efbar/minimal-service) more |`/minimal-services`|
