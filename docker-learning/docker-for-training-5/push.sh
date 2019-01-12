#!/bin/bash

set -e
#IP=`ifconfig eno16777736 |grep inet |awk '{print $2}' |tr -d "addr:"`
#IP=`ifconfig eno16777736 |grep inet |awk '{print $2}'`
IP=192.168.10.152

docker tag hello:1.0 $IP/hello:1.0
docker tag hello:2.0 $IP/hello:2.0
echo "---> docker images tag Rename is completed!"

echo "---> Start uploading images to the $IP registry server"

docker push $IP/hello:1.0
docker push $IP/hello:2.0

echo "---> Images upload to completed!"
