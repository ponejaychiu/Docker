FROM jaychiu/php-fpm:5.4

ADD init.sh /init.sh

ENTRYPOINT ["/init.sh", "/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
