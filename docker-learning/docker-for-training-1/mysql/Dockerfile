#
# MAINTAINER        jaychiu <18698577365@163.com>
# DOCKER-VERSION    17.09.1-ce
#
# Dockerizing Mariadb: Dockerfile for building Mariadb images
#
FROM       jaychiu/centos:7.1
MAINTAINER jaychiu <18698577365@163.com>

ENV DATA_DIR /var/lib/mysql

# Install Mariadb
RUN rpm --rebuilddb && \
    yum install -y mariadb mariadb-server && \
    yum clean all

COPY mysqld_charset.cnf /etc/my.cnf.d/

COPY scripts /scripts
RUN chmod +x /scripts/start

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/scripts/start"]
