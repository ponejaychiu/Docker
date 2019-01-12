#
# MAINTAINER        jaychiu <18698577365@163.com>
# DOCKER-VERSION    17.09.1-ce
#
# Dockerizing Jenkins: Dockerfile for building Jenkins images
#
FROM       jenkins/jenkins:2.97
MAINTAINER jaychiu <18698577365@163.com>

# Add docker command
USER root
RUN  curl -O https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz && \
     tar zxvf docker-latest.tgz && \
     cp docker/docker /usr/local/bin/ && \
     rm -rf docker docker-latest.tgz
ARG  DOCKER_GID=993
USER jenkins:${DOCKER_GID}
