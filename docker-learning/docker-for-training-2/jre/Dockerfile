#
# MAINTAINER        jaychiu <18698577365@163.com>
# DOCKER-VERSION    17.09.1-ce
#
# Dockerizing jre: Dockerfile for building jre images
#
FROM       jaychiu/centos:7.1
MAINTAINER jaychiu <18698577365@163.com>

ENV JAVA_VERSION 1.7.0
ENV JRE_HOME /usr/lib/jvm/jre

# Install jre
RUN rpm --rebuilddb && \
    yum -y install java-${JAVA_VERSION}-openjdk mysql && \
    yum clean all
