#
# MAINTAINER        jaychiu <18698577365@163.com>
# DOCKER-VERSION    17.09.1-ce
#
# Dockerizing maven: Dockerfile for building maven images
#
FROM       jaychiu/jdk:1.7.0
MAINTAINER jaychiu <18698577365@163.com>

ENV MAVEN_VERSION 3.5.2
ENV MAVEN_HOME /opt/maven

# Install maven
# ADD http://mirror.cc.columbia.edu/pub/software/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz /opt/

ADD apache-maven-3.5.2-bin.tar.gz /opt/

#RUN  tar -zxvf /opt/apache-maven-3.5.2-bin.tar.gz -C /opt && \
RUN  mv /opt/apache-maven-3.5.2 /opt/maven  && \
     ln -s /opt/maven/bin/mvn /usr/bin/mvn && \
     rm -rf /opt/apache-maven-3.5.2-bin.tar.gz

#COPY settings.xml /opt/maven/conf/settings.xml

ADD hello /hello
RUN cd /hello && \
    mvn clean install -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true
