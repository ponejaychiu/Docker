# 第一节：Docker实战之入门以及Dockerfile

希云课程链接：http://edu.51cto.com/center/course/lesson/index?id=71317

##镜像关系

基础镜像——>生成中间件镜像——>应用层镜像

## centos7目录：

build镜像：

centos:7.1.1503-->jaychiu/centos:7.1

运行jaychiu/centos:7.1镜像：
docker run -d -p 2222:22 --name centos7.1 --rm jaychiu/centos:7.1
访问容器：
执行docker exec -it centos7.1 /bin/bash(/bin/sh)进入容器内。

## php-fpm目录：

build镜像：

jaychiu/centos:7.1-->jaychiu/php-fpm:5.4

运行jaychiu/php-fpm:5.4镜像：
docker run -d -p 8080:80 --name website --rm jaychiu/php-fpm:5.4
访问容器：
执行docker exec -it website /bin/bash(/bin/sh)进入容器内。
访问PHP页面：
浏览器输入：http://{HOSTIP}:8080/info.php即可。

## mysql目录：

build镜像：
jaychiu/centos:7.1-->jaychiu/mysql:5.5

运行jaychiu/mysql:5.5镜像：
docker run -d -p 3306:3306 -v /data/mysql/mydata:/var/lib/mysql --name dbserver --rm jaychiu/mysql:5.5
访问容器：
执行docker exec -it dbserver /bin/bash(/bin/sh)进入容器内。

## wordpress目录：

build镜像：
此处build镜像会出发jaychiu/php-fpm:5.4镜像中的ONBUILD命令。
jaychiu/php-fpm:5.4-->jaychiu/wordpress:4.2

运行jaychiu/wordpress:4.2镜像：
docker run -d -p 80:80 --name wordpress -e WORDPRESS_DB_HOST=192.168.10.152 -e WORDPRESS_DB_USER=admin -e WORDPRESS_DB_PASSWORD=jaychiu2017 --rm jaychiu/wordpress:4.2
访问容器：
执行docker exec -it wordpress /bin/bash(/bin/sh)进入容器内。
访问wordpress页面：
浏览器输入：http://{HOSTIP}即可。
注意：要想正常访问wordpress页面需要与启动数据库容器。

## others目录：

分别build一个cmd镜像和entrypoint镜像：
jaychiu/centos:7.1-->jaychiu/cmd:0.1
jaychiu/centos:7.1-->jaychiu/entrypoint:0.1

CMD和ENTRYPOINT的区别：
运行jaychiu/cmd:0.1镜像：
docker run -it jaychiu/cmd:0.1 /bin/bash
其中/bin/bash会覆盖掉cmd中的/bin/echo命令，会进入到容器中去；

运行jaychiu/entrypoint:0.1镜像：
docker run -it jaychiu/entrypoint:0.1 /bin/bash
其中/bin/bash不会覆盖掉entrypoint中的/bin/echo命令，而是作为参数跟在命令后面；

## 常用命令：

### 批量删除所有容器：

docker rm `docker ps -a |awk '{print $1}' |grep [0-9a-z]`
docker rm $(docker ps -a|grep Exited|awk '{print $1}')
docker rm $(docker ps -qa)

### 批量删除已停止的容器：

docker rm `docker ps -a|grep Exited |awk '{print $1}'`
docker rm $(docker ps -a|grep Exited |awk '{print $1}')