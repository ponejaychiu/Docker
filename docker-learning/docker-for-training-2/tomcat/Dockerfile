#
# MAINTAINER        jaychiu <18698577365@163.com>
# DOCKER-VERSION    17.09.1-ce
#
# Dockerizing TOMCAT: Dockerfile for building TOMCAT images
#
FROM       jaychiu/jre:1.7.0
MAINTAINER jaychiu <18698577365@163.com>

ENV TOMCAT_MAJOR_VERSION 7
ENV TOMCAT_MINOR_VERSION 7.0.55
ENV CATALINA_HOME /tomcat
ENV APP_DIR ${CATALINA_HOME}/webapps/

# Install tomcat
# RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz

COPY apache-tomcat-7.0.55.tar.gz apache-tomcat-7.0.55.tar.gz

RUN tar zxf apache-tomcat-*.tar.gz && \
    rm apache-tomcat-*.tar.gz && \
    mv apache-tomcat* tomcat

ADD scripts /scripts

EXPOSE 8080 8443

ENTRYPOINT ["/scripts/run"]

ONBUILD ADD . ${APP_DIR}
