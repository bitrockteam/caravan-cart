#! /bin/bash

#set -x

SOURCE_TOPICS='flight_raw airport_raw airline_raw city_raw airplane_raw flight_received enhanced_flight_raw airport_info'
OUTPUT_TOPICS='top_arrival_airport top_departure_airport top_speed top_airline total_flight total_airline flight_received_list flight_parked_list flight_en_route_list'
MONITORING_TOPICS='parser_error monitoring_streams_flight_received_list monitoring_streams_flight_received_list_delay monitoring_aviation_edge_producer_flight'
ERRORS_TOPICS='parser_error flight_raw_invalid'

TOPICS="$SOURCE_TOPICS $OUTPUT_TOPICS $MONITORING_TOPICS $ERRORS_TOPICS"
LOW_RETENTION_TOPICS="flight_interpolated_list"
MULTI_PARTITION_TOPICS='flight_received_partitioner'
COMPACTED_TOPIC='flight_opensky_raw'

for t in $TOPICS
do
IS_TOPIC=$(kafka-topics --bootstrap-server "${KAFKA.BOOTSTRAP.SERVER}" --list | grep -c $t)
if [ $IS_TOPIC -eq 0 ]; then
  kafka-topics --bootstrap-server "${KAFKA.BOOTSTRAP.SERVER}" --create --topic $t --replication-factor 1 --partitions 1
fi
done

for t in $LOW_RETENTION_TOPICS
do
IS_TOPIC=$(kafka-topics --bootstrap-server "${KAFKA.BOOTSTRAP.SERVER}" --list | grep -c $t)
if [ $IS_TOPIC -eq 0 ]; then
  kafka-topics --bootstrap-server "${KAFKA.BOOTSTRAP.SERVER}" --create --topic $t --replication-factor 1 --partitions 1  --config retention.ms=86400000
fi
done

for t in $MULTI_PARTITION_TOPICS
do
IS_TOPIC=$(kafka-topics --bootstrap-server "${KAFKA.BOOTSTRAP.SERVER}" --list | grep -c $t)
if [ $IS_TOPIC -eq 0 ]; then
  kafka-topics --bootstrap-server "${KAFKA.BOOTSTRAP.SERVER}" --create --topic $t --replication-factor 1 --partitions 15
fi
done

for t in $COMPACTED_TOPIC
do
IS_TOPIC=$(kafka-topics --bootstrap-server "${KAFKA.BOOTSTRAP.SERVER}" --list | grep -c $t)
if [ $IS_TOPIC -eq 0 ]; then
  kafka-topics --bootstrap-server "${KAFKA.BOOTSTRAP.SERVER}" --create --topic $t --replication-factor 1 --partitions 1 --config cleanup.policy=compact,delete
fi
done
