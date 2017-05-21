#! /usr/bin/env bash

set -x

(
  sleep $RABBITMQ_SETUP_DELAY

  rabbitmqctl stop_app

  echo "<< Joining cluster with [$RABBITMQ_CLUSTER_NODES] DONE >>"
  rabbitmqctl join_cluster $RABBITMQ_CLUSTER_NODES
  echo "<< Joining cluster with [$RABBITMQ_CLUSTER_NODES] DONE >>"

  rabbitmqctl start_app

  rabbitmqctl set_policy ha-all "^ha\." '{"ha-mode":"all"}'
) & rabbitmq-server "$@"
