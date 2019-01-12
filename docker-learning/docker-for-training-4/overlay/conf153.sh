#!/bin/bash

[-d /data] || mkdir /data
consul agent -server -bootstrap -data-dir /data/consul -bind=0.0.0.0 > /var/log/consul.log 2>&1 &
echo 'DOCKER_OPTS="--kv-store=consul:localhost:8500 --label=com.docker.network.driver.overlay.bind_ineterface=eth0 --deafult-network=overlay:multihost"' > /etc/default/docker

systemctl restart docker
