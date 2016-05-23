#!/bin/bash

PORT=3000
docker build --tag cc/calico .
docker run --name calico --publish $PORT:$PORT --detach cc/calico
host_ip=$(docker-machine ip)
echo "Can access app as http://$host_ip:$PORT"
