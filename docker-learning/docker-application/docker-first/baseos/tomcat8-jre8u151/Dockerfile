# Base image
FROM jaychiu/jre:8u151
MAINTAINER jaychiu<18698577365@163.com>
LABEL Description="This image is used to run tomcat8 with jre8u151."  Version="1.0"

ENV CATALINA_HOME /var/lib/tomcat8
ENV PATH $CATALINA_HOME/bin:$PATH
WORKDIR $CATALINA_HOME

ADD apache-tomcat-8.5.24.tar.gz  /var/lib/
RUN mv /var/lib/apache-tomcat-8.5.24/* $CATALINA_HOME

EXPOSE 8080
CMD ["catalina.sh", "run"]
