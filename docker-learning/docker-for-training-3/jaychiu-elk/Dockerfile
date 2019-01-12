#
# MAINTAINER        jaychiu <18698577365@163.com>
# DOCKER-VERSION    17.09.1-ce
#
# Dockerizing logstash-forwarder: Dockerfile for building logstash-forwarder images
#
FROM       sebp/elk:latest 
MAINTAINER jaychiu <18698577365@163.com>

COPY logstash-forwarder.key /etc/pki/tls/private/logstash-forwarder.key
COPY logstash-forwarder.crt /etc/pki/tls/certs/logstash-forwarder.crt
