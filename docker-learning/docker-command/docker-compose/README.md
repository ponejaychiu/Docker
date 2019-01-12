# 现在将使用 Docker Compose 配置并运行一个 Django/PostgreSQL 应用。
# Django目录：
链接：http://docker_practice.gitee.io/compose/django.html
## 一、编辑Dockerfile文件，内容如下：
FROM python:3
ENV PYTHONUNBUFFERED 1
RUN mkdir /code
WORKDIR /code
ADD requirements.txt /code/
RUN pip install -r requirements.txt
ADD . /code/
## 二、编辑requirements.txt文件，内容如下：
### 写明需要安装的具体依赖包名及版本号；
Django>=1.8,<2.0
psycopg2
## 三、编辑docker-compose.yml文件，内容如下：
### 文件将把所有的东西关联起来。它描述了应用的构成（一个 web 服务和一个数据库）、使用的 Docker 镜像、镜像之间的连接、挂载到容器的卷，以及服务开放的端口。
version: "3"
services:

  db:
    image: jaychiu/mysql:5.5
    volumes:
      - /data/mysql/mydata3:/var/lib/mysql
    ports:
      - "3308:3306"
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: jaychiu2017
      MYSQL_DATABASE: django_example
      MYSQL_USER: admin
      MYSQL_PASSWORD: jaychiu2017

  web:
    build: .
    command: python3 manage.py runserver 0.0.0.0:8000
    volumes:
      - ./example:/code
    ports:
      - "8000:8000"
    links:
      - db
## 四、现在我们就可以使用 docker-compose run 命令启动一个 Django 应用了；
$ docker-compose run web django-admin.py startproject django_example .
Compose 会先使用 Dockerfile 为 web 服务创建一个镜像，接着使用这个镜像在容器里运行 django-admin.py startproject composeexample 指令。
这将在当前目录生成一个名为example应用目录:
# ls
docker-compose.yml  Dockerfile  example  requirements.txt

最后docker-compose up -d启动服务；

同步数据库结构这种事，在运行完 docker-compose up 后，在另外一个终端进入文件夹运行以下命令即可：
$ docker-compose run web python manage.py syncdb

# wordpress目录：
链接：http://docker_practice.gitee.io/compose/wordpress.html
## 编辑docker-compose.yml文件，内容如下：
### docker-compose.yml 文件将开启一个 wordpress 服务和一个独立的 MySQL 实例：
version: "3"
services:

   db:
     image: jaychiu/mysql:5.5
     volumes:
       - /data/mysql/mydata2:/var/lib/mysql
     ports:
       - "3307:3306"
     restart: always
     environment:
       MYSQL_ROOT_PASSWORD: jaychiu2017
       MYSQL_DATABASE: wordpress
       MYSQL_USER: admin
       MYSQL_PASSWORD: jaychiu2017

   wordpress:
     depends_on:
       - db
     image: jaychiu/wordpress:4.9.1
     ports:
       - "8000:80"
     restart: always
     environment:
       WORDPRESS_DB_HOST: db:3306
       WORDPRESS_DB_USER: admin
       WORDPRESS_DB_PASSWORD: jaychiu2017
## 执行docker-compose up -d即可运行启动wordpress和MySQL数据库容器。
docker-compose ps查看当前运行的容器；
docker-compose stop停止当前运行的容器；
docker-compose rm删除当前运行的容器；
