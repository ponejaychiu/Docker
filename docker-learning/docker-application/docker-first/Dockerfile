FROM openjdk
MAINTAINER Jaychiu

WORKDIR /home/docker
ADD http://apache.osuosl.org/zookeeper/stable/zookeeper-3.4.10.tar.gz /home/docker
RUN tar -xzf zookeeper-3.4.10.tar.gz
RUN mv zookeeper-3.4.10 /opt/zookeeper
WORKDIR /opt/zookeeper
RUN echo "tickTime=2000" >> conf/zoo.cfg
RUN echo "dataDir=/var/lib/zookeeper" >> conf/zoo.cfg
RUN echo "clientPort=2181" >> conf/zoo.cfg
EXPOSE 2181
CMD ["/opt/zookeeper/bin/zkServer.sh", "start-foreground"]
