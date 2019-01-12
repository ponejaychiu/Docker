#
# MAINTAINER        jaychiu <18698577365@163.com>
# DOCKER-VERSION    17.09.1-ce
#
# Dockerizing php-fpm: Dockerfile for building php-fpm images
#
FROM       jaychiu/centos:7.1
MAINTAINER jaychiu <18698577365@163.com>

# Set environment variable
ENV	APP_DIR /app

RUN     rpm --rebuilddb && \
        yum -y swap -- remove fakesystemd -- install systemd systemd-libs && \
        yum -y install nginx php-cli php-mysql php-pear php-ldap php-mbstring php-soap php-dom php-gd php-xmlrpc php-fpm php-mcrypt && \ 
        yum clean all

COPY    nginx_nginx.conf /etc/nginx/nginx.conf
COPY	nginx_default.conf /etc/nginx/conf.d/default.conf

COPY	php_www.conf /etc/php-fpm.d/www.conf
RUN	sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php.ini

RUN	mkdir -p /app && echo "<?php phpinfo(); ?>" > ${APP_DIR}/info.php

EXPOSE	80 443

COPY	supervisor_nginx.conf /etc/supervisor.conf.d/nginx.conf
COPY	supervisor_php-fpm.conf /etc/supervisor.conf.d/php-fpm.conf

ONBUILD ADD . /app
ONBUILD RUN chown -R nginx:nginx /app
