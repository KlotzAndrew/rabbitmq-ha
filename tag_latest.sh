#! /usr/bin/env bash

set -ex

docker-compose build

# nginx img
docker tag rabbitmqha_rabbit-1 klotzandrew/rabbitmqha_rabbit-1
docker push klotzandrew/rabbitmqha_rabbit-1

# # nginx img
# docker tag rabbitmqha_rabbit-2 klotzandrew/rabbitmqha_rabbit-2
# docker push klotzandrew/rabbitmqha_rabbit-2

# nginx img
docker tag rabbitmqha_haproxy klotzandrew/rabbitmqha_haproxy
docker push klotzandrew/rabbitmqha_haproxy
