# Base image
FROM jaychiu/jre:7u80
MAINTAINER jaychiu<18698577365@163.com>
LABEL Description="This image is used to run tomcat7 with jre7u80."  Version="1.0"

ENV CATALINA_HOME /var/lib/tomcat7
ENV PATH $CATALINA_HOME/bin:$PATH
WORKDIR $CATALINA_HOME

ADD apache-tomcat-7.0.70.tar.gz  /var/lib/
RUN mv /var/lib/apache-tomcat-7.0.70/* $CATALINA_HOME

EXPOSE 8080
CMD ["catalina.sh", "run"]
