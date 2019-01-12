#
# MAINTAINER        jaychiu <18698577365@163.com>
# DOCKER-VERSION    17.09.1-ce
#
# Dockerizing jdk: Dockerfile for building jdk images
#
FROM       jaychiu/centos:7.1
MAINTAINER jaychiu <18698577365@163.com>

ENV JAVA_VERSION 1.7.0
ENV JDK_HOME /usr/lib/jvm/java-1.7.0-openjdk

# Install jdk
RUN rpm --rebuilddb && \
    yum -y install java-${JAVA_VERSION}-openjdk java-${JAVA_VERSION}-openjdk-devel && \
    yum clean all
