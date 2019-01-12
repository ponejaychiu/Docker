# Docker结合项目如何去使用
本篇主要讲解如下几个知识点：

1、CentOS7与Ubuntu下安装Docker，配置加速器

2、常见Dockerfile命令讲解

3、常见compose命令讲解

4、集群环境下如何使用compose编排

5、根据项目如何使用Docker部署应用

​	5.1、Swarm集群下发布基于LNMP的WordPress应用发布
​	5.2、NodeJS应用发布
​	5.3、Flask应用发布
​	5.4、基于Tomcat定制封装Jenkins镜像



## CentOS7与Ubuntu下安装Docker

### CentOS7

```shell
yum install -y yum-utils device-mapper-persistent-data lvm2 curl
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum -y install docker-ce
```

### Ubuntu

```shell
apt-get remove docker docker-engine docker.io -y

apt-get update

apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y

curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -

apt-key fingerprint 0EBFCD88

add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"

apt-get update

apt-get install docker-ce -y
```

### 配置加速器

​	不想申请加速器的朋友可以使用我的，也可以自己去申请阿里云或者Daocloud的加速器。

```
mkdir -p /etc/docker

cat > /etc/docker/daemon.json << EOF
{
    "registry-mirrors" : [
	    "https://i3jtbyvy.mirror.aliyuncs.com"
	],
	"debug" : true,
	"experimental" : true
}
EOF
```




## 常见Dockerfile命令讲解

​	Dockerfile简单一点就是描述你这个镜像安装了哪些软件包，有哪些操作，创建了什么东西。有些人喜欢用 `docker commit` 命令去打包镜像，这样是不好的，首先commit出来的镜像比你使用Dockerfile构建出来的体积大，而却commit出来的镜像属于黑盒镜像，除了制作者，谁都不知道你在里面干了什么，属于不安全的镜像，很少会有人使用，最后就是不便于你最终的管理和更新。所以推荐使用Dockerfile去管理你的镜像，下面将简单介绍Dockerfile常见的指令和注意事项：

### `FROM`

​	FROM命令是指定你所使用的基础镜像，一般写在文件开头，对于官方没给出Dockerfile的软件想Docker化，那么引用的镜像一般是`debian:jessie`、`alpine`、`ubuntu`，如果官方已经有了，比如nginx、php、mysql这写，那么基本直接引用即可。

指令语法：

```
FROM <image>
FROM <image>:<tag>
FROM <image>:<digest> 

eg:
FROM debian:jessie
FROM alpine:3.6
FROM ubuntu:16.04
FROM mysql:5.7
FROM python:2.7
```



### `MAINTAINER`

​	MAINTAINER命令一般是描述这个Dockerfile的作者信息，

指令语法：

```
MAINTAINER <name>

eg:
MAINTAINER "MoMo" <95112082@qq.com>
```

### `RUN`

​	运行指定的命令，此命令只有在执行`docker build`时才会执行，其他情况下不会执行。这时候有很多初学者会以为在写SHELL，那么在一个Dockerfile里面会出现很多不合理的RUN指令，了解过Docker的朋友应该都知道Docker的镜像是分层结构，说白了就是Dockerfile里面一个指令的操作就是一层。比如下面的操作，一条RUN命令包含了更新源缓存，安装openjdk，清理垃圾，这样的好处是最终这一层会很小，假设你分开写，四个命令四个RUN指令，但是只有第二条命令才是你想要的，那么第一条产生的缓存垃圾就不发删除掉。这也算是优化的一部分。

指令语法：

```
这里只写第一种格式，有兴趣的朋友可以去官网看看其他的方式
RUN <command>

eg:
RUN apt-get update \
    && apt-get install openjdk-8-jdk --no-install-recommends -y \
    && apt-get clean all \
    && rm -rf /var/lib/apt/lists/*

```

### `CMD`

​	设置容器启动时要运行的命令只有在你执行 `docker run` 或者 `docker start` 命令是才会运行，其他情况下不运行。如果一个Dockerfile里面有多条CMD指令，那么只有文件最后一行的 `CMD` 指令才会生效，其他的全部没用，还有一点，还有一点 `CMD` 指令是可以在你执行 `docker run` 的时候覆盖的。

指令语法：

```
CMD ["executable","param1","param2"]

eg:
CMD ["python","flask.py"]
```

### `EXPOSE`

​	设置暴露的容器端口，注意是容器端口。

指令语法：

```
EXPOSE port

eg:
EXPOSE 80
EXPOSE 80 443
```

### `ENV`

​	功能为设置环境变量，此环节变量可以是在构建镜像时使用，也可以在运行中的容器使用。

指令语法：

```
ENV <key> <value>

eg:
一种写法
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV CLASSPATH $JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
ENV PATH $PATH:$JAVA_HOME/bin:$JRE_HOME/bin

另一种写法
ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64 \
    CLASSPATH=$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar \
    PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
```

### `ADD`

​	复制命令，把本机的文件复制到镜像中，如果dest是目录则会帮你创建出这个目录，如果src是压缩文件会帮你解压出来。当然ADD指令中的src也可以是URL链接，还有另外一个指令（`COPY `），请注意区别！！！

​	另外，src部分是是你Dockerfile的相对路径，这个请注意！！！

指令语法：

```
ADD <src> <dest>

eg:
ADD nginx.conf /etc/nginx/nginx.conf
ADD app.tar.gz /app/app.tar.gz
```

### `COPY`

​	与ADD指令一样，但是COPY的src部分只能是本地文件。如果dest是目录并且目录不存在，会帮你创建，如果是压缩文件不会帮你解压。

指令语法：

```
COPY <src> <dest>

COPY app.tar.gz /app/
```

### `ENTRYPOINT`

​	启动时的默认命令，此指令设置的命令不可修改。与CMD是有区别的。此命令在Dockerfile只能有一个，若有多个，则以文件最后一个出现的才生效。

指令语法：

```
ENTRYPOINT ["executable", "param1", "param2"]

eg:
ENTRYPOINT ["nginx"]
CMD ["-g","daemon off;"]
```

​	如上，如果执行 `docker run -d --name nginx -P nginx` 则最终容器内执行的命令是`nginx -g daemon off; ` ，如果你执行的命令是 `docker run -d --name nginx -P nginx bash` 则最终容器内执行的命令是`nginx bash` 注意区别，细心体会。

### `VOLUME`

​	设置你的卷，在启动容器的时候Docker会在/var/lib/docker的下一级目录下创建一个卷，以保存你在容器中产生的数据。若没有申明则不会创建。

指令语法：

```
VOLUME ["/path/to/directory"]

eg:
VOLUME ["/data"]
VOLUME ["/data","/app/etc"]
```

### `USER`

​	指定容器运行的用户是谁，前提条件，用户必须**存在**。此指令可以在构建镜像是使用或指定容器中进程的运行用户是谁。

指令语法：

```
USER daemo

eg:
USER nginx
```

### `WORKDIR`

​	指定容器中的工作目录，可以在构建时使用，也可以在启动容器时使用，构建使用就是通过 `WORKDIR` 将当前目录切换到指定的目录中，容器中使用的意思则是在你使用 `docker run` 命令启动容器时，默认进入的目录是 `WORKDIR` 指定的，下面的example中我使用环境变量。

指令语法：

```
WORKDIR /path/to/workdir

eg:
WORKDIR /usr/local/zookeeper-${ZOOKEEPER_VERSION}
```

##  常见compose命令讲解








## 根据项目如何使用Docker部署应用

### Swarm集群下发布基于LRNMP的WordPress应用发布

​	本实例，默认你已经装好系统，装好Docker并创建好Swarm集群。

​	集群约定，对于无状态应用如Nginx，WordPress我们使用NFS去实现Web站点的数据保存以及共享服务以保证所有容器（Nginx、WordPress）数据一致性问题，MySQL数据库我将指定单台主机去实现MySQL数据库功能，数据库目录将存放在所在宿主机上，那么存在一个问题，MySQL高可用如何去实现，这里可以基于MySQL的架构去实现数据库这块的高可用性本篇不讨论如何实现。



应用目录结构：

站点在NFS主目录位置：/nfs/lnmp

站点目录：/nfs/lnmp/www

Nginx配置文件目录：/nfs/lnmp/nginx

WordPress配合文件目录：/nfs/lnmp/php

Redis数据目录（Docker-Swarm-Redis主机下）：/redis/lnmp

MySQL数据目录（Docker-Swarm-MySQL主机下）：/mysql/lnmp



镜像相关文档：

Redi：https://hub.docker.com/_/redis/

Nginx：https://hub.docker.com/_/nginx/

WordPress：https://hub.docker.com/_/wordpress/

MySQL：https://hub.docker.com/_/mysql/



集群节点清单：

| 主机名                   |          节点作用          |           运行的容器 |
| --------------------- | :--------------------: | --------------: |
| Docker-Swarm-MySQL    | MySQL节点，只跑MySQL不跑其他的应用 |           MySQL |
| Docker-Swarm-Redis    | Redis节点，只跑Redis不跑其他的应用 |           Redis |
| Docker-Swarm-NFS      | NFS节点，只用于数据共享，不运行任何应用  |             N/A |
| Docker-Swarm-Master01 |      Swarm集群管理节点       |             N/A |
| Docker-Swarm-Node01   |      Swarm集群工作节点       | Nginx、WordPress |
| Docker-Swarm-Node02   |      Swarm集群工作节点       | Nginx、WordPress |



准备编排文件，内容如下（docker-compose.yaml）：

```yaml
version: '3.4'
services:
    nginx:
        image: nginx:1.13.6-alpine
        hostname: nginx
        ports:
            - 3000:80/tcp
        networks:
            xbclub:
                aliases:
                    - nginx
        volumes:
            - /nfs/lnmp/nginx/nginx.conf:/etc/nginx/nginx.conf:ro
            - /nfs/lnmp/www:/var/www/html:rw
            - /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime:ro
        deploy:
            mode: replicated
            replicas: 3
            placement:
                constraints:
                    - node.role == worker
                    - node.hostname != Docker-Swarm-MySQL
                    - node.hostname != Docker-Swarm-Redis
                    - node.hostname != Docker-Swarm-NFS
    wordpress:
        image: wordpress:4.9.1-php7.1-fpm-alpine
        hostname: php
        networks:
            xbclub:
                aliases:
                    - wordpress
        environment:
            - WORDPRESS_DB_HOST=mysql
            - WORDPRESS_DB_USER=root
            - WORDPRESS_DB_PASSWORD=root
            - WORDPRESS_DB_NAME=xbclub
            - WORDPRESS_TABLE_PREFIX=wp_
        volumes:
            - /nfs/lnmp/www:/var/www/html:rw
            - /nfs/lnmp/php/uploads.ini:/usr/local/etc/php/conf.d/uploads.ini:ro
            - /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime:ro
        deploy:
            mode: replicated
            replicas: 3
            placement:
                constraints:
                    - node.role == worker
                    - node.hostname != Docker-Swarm-MySQL
                    - node.hostname != Docker-Swarm-Redis
                    - node.hostname != Docker-Swarm-NFS
    mysql:
        image: mysql:5.7.20
        hostname: mysql
        networks:
            xbclub:
                aliases:
                    - mysql
        environment:
            - MYSQL_ROOT_PASSWORD=root
        volumes:
            - /mysql/lnmp:/var/lib/mysql
            - /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime:ro
        deploy:
            mode: replicated
            replicas: 1
            placement:
                constraints:
                    - node.hostname == Docker-Swarm-MySQL
        logging:
            driver: json-file
            options:
                max-file: '3'
                max-size: 100m
    redis:
        image: redis:4.0.6
        hostname: redis
        networks:
            xbclub:
                aliases:
                    - redis
        volumes:
            - /redis/lnmp:/data:rw
            - /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime:ro
        deploy:
            mode: replicated
            replicas: 1
            placement:
                constraints:
                    - node.hostname == Docker-Swarm-Redis
networks:
    xbclub:
        external: true
```

Nginx配置文件（nginx.conf）：

```
user  nginx nginx;
worker_processes auto;
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;
worker_rlimit_nofile 51200;

events {
    use epoll;
    worker_connections 51200;
    multi_accept on;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    log_format  main  '{"remote_addr":"$remote_addr",'
                      '"http_x_forwarded_for":"$http_x_forwarded_for",'
                      '"remote_user":"$remote_user",'
                      '"time_local":"$time_local",'
                      '"request":"$request",'
                      '"status":"$status",'
                      '"request_time":"$request_time",'
                      '"body_bytes_sent":"$body_bytes_sent",'
                      '"http_referer":"$http_referer",'
                      '"http_user_agent":"$http_user_agent"}';

    server_names_hash_bucket_size 128;
    client_header_buffer_size 32k;
    large_client_header_buffers 4 32k;
    client_max_body_size 50m;

    sendfile   on;
    tcp_nopush on;

    keepalive_timeout 60;

    tcp_nodelay on;

    fastcgi_connect_timeout 300;
    fastcgi_send_timeout 300;
    fastcgi_read_timeout 300;
    fastcgi_buffer_size 64k;
    fastcgi_buffers 4 64k;
    fastcgi_busy_buffers_size 128k;
    fastcgi_temp_file_write_size 256k;

    gzip on;
    gzip_min_length  1k;
    gzip_buffers     4 16k;
    gzip_http_version 1.1;
    gzip_comp_level 2;
    gzip_types     text/plain application/javascript application/x-javascript text/javascript text/css application/xml application/xml+rss;
    gzip_vary on;
    gzip_proxied   expired no-cache no-store private auth;
    gzip_disable   "MSIE [1-6]\.";

    server_tokens off;

    server {
        listen 80;
        server_name _;
        index index.html index.htm index.php;
        location / {
            deny all;
        }
    }

    server{
        listen 80;
        server_name www.example.com ;
        server_name _;
        index index.html index.htm index.php default.html default.htm default.php;
        root  /var/www/html;

        location / {
            try_files $uri $uri/ /index.php?$args;
        }

        # Add trailing slash to */wp-admin requests.
        rewrite /wp-admin$ $scheme://$host$uri/ permanent;

        # Deny access to PHP files in specific directory
        #location ~ /(wp-content|uploads|wp-includes|images)/.*\.php$ { deny all; }

        location ~ [^/]\.php(/|$) {
          try_files $uri =404;
          fastcgi_pass  wordpress:9000;
          fastcgi_index index.php;
          include fastcgi.conf;
        }

        location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$ {
            expires      30d;
        }

        location ~ .*\.(js|css)?$ {
            expires      12h;
        }

        location ~ /.well-known {
            allow all;
        }

        location ~ /\. {
            deny all;
        }
    }
}
```

WordPress配置文件（uploads.ini）：

```
file_uploads = On
memory_limit = 64M
upload_max_filesize = 64M
post_max_size = 64M
max_execution_time = 600
```

本实例项目地址：https://github.com/buxiaomo/docker-compose/tree/master/wordpress

总结：

本实例我们直接使用的是官方的镜像，没有做定制操作，原因如下：

1、不要重复造轮子，官方有镜像尽量使用官方的镜像不要自己构建

2、官方镜像有人维护，不需要自己维护，较少成本

3、官方镜像基本可以满足大部分应用需求，所以基本不需要进行定制化，如果需要定制化可以直接使用FROM BASEIMAGE去做定制化，而不是从头再来。



### NodeJS应用发布

​	针对自己写Dockerfile构将APP镜像，首先需要有一点，你的APP必须可以前台运行！！！

​	由于官方有镜像，我们就直接引用即可，不需要自己去构建NodeJS的镜像，这里我一一个NodeJS的WebUI去实现镜像封装以及运行。对于NodeJS应用，大概分为两部分，下载依赖包，运行分为，这里可以更具实际情况决定Dockerfile如何编写，理论上依赖包只需要下载一次就行了，不需要每次运行分为都去下载镜像包，那么针对这种情况可以在构建的时候把依赖包一起打包到镜像中，当然，将依赖包打包到镜像中构建出来的镜像会有点大，但是好处就是启动服务的时候不需要下载依赖包，启动时间会很快，适合离线环境；一种是在启动的时候去下载依赖包，这样的话镜像会小一点，但是启动时会去下载依赖包，启动时间会比较长，具体方式可以自己选。下面简要说一下步骤：

编写Dockerfile内容如下：

```
FROM node:9.3.0

ADD app /app/

WORKDIR /app

RUN npm i

EXPOST 7001

CMD ["npm","run","dev"]
```

进入Dockerfile所在目录执行`docker build -t=nodejs .`构建镜像



### Flask应用发布

项目代码：https://github.com/buxiaomo/dockerfile/tree/master/ssserverweb

​	应用简介：应用通过Docker Engine API对基于Docker Swarm提供的SS服务管理用户添加删除和添加节点的小demo项目，本应用通过Swarm实现。Docker化应用类似于NodeJS。通过阿里云的域名API配置主机IP与域名的关系，本篇只针对应用如何使用Docker部署，代码实现不在本篇讨论范围这里不详细说明。

申明：代码可能存在逻辑问题，不要纠结这个，本篇只讨论如何容器化应用。

可以直接看GitHub的代码查看详情。准备Dockerfile，内容如下：

```
FROM python:2.7.14

ADD . /app

WORKDIR /app

RUN pip install -r requirements.txt

ENV ALIYUN_ID NULL
ENV ALIYUN_Secret NULL
ENV ALIYUN_RegionId cn-hangzhou

ENV Domain NULL
ENV ManagerIP NULL

EXPOSE 8000

CMD ["python","ssserver.py"]
```

进入Dockerfile所在目录执行`docker build -t=ssserverweb .`构建镜像

启动容器：

```
docker run -d --name ssserverweb 
-p 8080:8000 \
-v /var/run/docker.sock:/var/run/docker.sock:ro \
-e ALIYUN_ID=*** \
-e ManagerIP=*** \
-e ALIYUN_Secret=**** \
-e DomainName=www.example.com \
ssserverweb:latest
```

查看服务，访问链接：http://IP:8080 即可访问到访问页面


### 基于Tomcat封装Jenkins镜像





若有错误欢迎指出修正：95112082@qq.com