#
# MAINTAINER        jaychiu <18698577365@163.com>
# DOCKER-VERSION    17.09.1-ce
#
# Dockerizing HelloWorld: Dockerfile for building HelloWorld images
#
FROM       jaychiu/tomcat:7.0.55
MAINTAINER jaychiu <18698577365@163.com>

ADD init /init

ENTRYPOINT ["/init", "/scripts/run"]
