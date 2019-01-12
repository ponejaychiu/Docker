# 第二节：Docker实战之Registry以及持续集成

希云课程链接：http://edu.51cto.com/center/course/lesson/index?id=71318

## 自动构建maven

## jre目录：

build镜像：

jaychiu/centos:7.1-->jaychiu/jre:1.7.0

## jdk目录：

jaychiu/centos:7.1-->jaychiu/jdk:1.7.0

## tomcat目录：

jaychiu/jre:1.7.0-->jaychiu/tomcat:7.0.55

## docker-compose.yml文件：

编排tomcat服务和mysql服务：
docker-compose up -d 启动容器服务
docker-compose ps 查看容器服务列表
docker-compose stop 停止容器服务
docker-compose rm 删除停止服务的容器

docker-compose restart 重启容器服务

## jenkins目录：

jenkins/jenkins:2.97-->jaychiu/jenkins:2.97
jenkins版本对应的Java版本：

2.54 (2017-04) and newer: Java 8

1.612 (2015-05) and newer: Java 7

## 过程：

1、直接从官网pull下来最新版本的jenkins/jenkins:2.97；
2、由于官方jenkins容器进入后无法执行docker命令，需要安装docker，重新build镜像；
详见：https://blog.lab99.org/post/docker-2016-07-14-faq.html
3、将apache-maven-3.5.2-bin.tar.gz放到/data/maven-tar目录下；
4、执行重新build后的容器jaychiu/jenkins:2.97：
docker run -d -p 8080:8080 --name jenkins -v /usr/bin/docker:/usr/bin/docker -v /var/run/docker.sock:/var/run/docker.sock -v /data/maven-tar:/root --rm jaychiu/jenkins:2.97
5、进入容器：
docker exec -it jenkins /bin/bash
6、如果需要构建时调整 docker 组 ID，可以使用 --build-arg 来覆盖参数默认值：
docker build -t jaychiu/jenkins:1.609.1 --build-arg DOCKER_GID=1000 .

## jenkins管理：

admin密码存放在/var/jenkins_home/secrets/initialAdminPassword文件，需要登录到容器查看；

## maven目录：

build镜像：
jaychiu/jdk:1.7.0-->jaychiu/maven:3.5.2
如果构建失败，则无需将此目录下的setting.xml文件复制到镜像中；
注释掉Dockerfile中的#COPY settings.xml /opt/maven/conf/settings.xml即可；

创建maven容器：
docker create --name maven jaychiu/maven:3.5.2
拷贝容器内的文件到宿主机：
docker cp maven:/hello/target/hello.war .

## hello目录：

构建jaychiu/hello:1.0镜像：
jaychiu/tomcat:7.0.55-->jaychiu/hello:1.0
docker build -t jaychiu/hello:1.0 .

要想自动构建镜像，需要先运行一个MySQL容器：
docker run -d -p 3306:3306 --name mysql jaychiu/mysql:5.5

接下来就是见证奇迹的时刻了，让maven自动构建一个jaychiu/hello:2.0的镜像
先运行hello容器：
docker run -it -p 80:8080 -e DB_HOST=192.168.10.152 --name hello jaychiu/hello:1.0
因为容器没有固定IP地址，所有需要设置-e环境变量，指定数据库地址，一般为宿主机IP，无需跟端口号，端口号需另外配置；

如果init文件里面指定了ip，则无需设置；

### jenkins任务里Build步骤的执行脚本：

REGISTRY_URL=192.168.10.152:5001
cp /root/apache-maven-3.5.2-bin.tar.gz $WORKSPACE/maven
if docker ps -a |grep -i maven ; then
   docker rm -f maven
fi
docker rmi jaychiu/maven:3.5.2
docker build -t jaychiu/maven:3.5.2 $WORKSPACE/maven
docker create --name maven jaychiu/maven:3.5.2
docker cp maven:/hello/target/hello.war $WORKSPACE/hello
if docker ps -a |grep -i hello ; then
   docker rm -f hello
fi
docker rmi $REGISTRY_URL/jaychiu/hello:1.0
docker build -t $REGISTRY_URL/jaychiu/hello:1.0 $WORKSPACE/hello
docker push $REGISTRY_URL/jaychiu/hello:1.0
docker run -d -p 80:8080 --name hello $REGISTRY_URL/jaychiu/hello:1.0