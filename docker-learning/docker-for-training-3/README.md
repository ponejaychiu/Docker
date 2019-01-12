# 第三节：Docker实战之监控报警以及日志管理

希云课程链接：http://edu.51cto.com/center/course/lesson/index?id=71319

### 启动wordpress容器和mysql-wordpress容器：

docker run -d -p 80:80 --name wordpress-4.2.1 -e WORDPRESS_DB_HOST=192.168.10.152 -e WORDPRESS_DB_USER=admin -e WORDPRESS_DB_PASSWORD=jaychiu2017 -v /data/logs:/var/log/nginx --rm jaychiu/wordpress:4.2.1

docker run -d -p 3306:3306 -v /data/mysql/mydata/:/var/lib/mysql --name mysql-wordpress jaychiu/mysql:5.5

1. Logstash: logstash server端用来搜集日志；
2. Elasticsearch: 存储各类日志；
3. Kibana: web化接口用作查寻和可视化日志；
4. Logstash Forwarder: logstash client端用来通过lumberjack 网络协议发送日志到logstash server；

## jaychiu-elk目录：

sebp/elk:latest-->jaychiu/elk:1.6.0
从官网下载sebp/elk:latest，镜像很大，需要一点时间；

启动jaychiu/elk:1.6.0镜像：
docker run -d -p 9200:9200 -p 5601:5601 -p 5000:5000 -e ES_MIN_MEM=64M -e ES_MAX_MEM=512M --name elk jaychiu/elk:1.6.0

启动的时候报错：
max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
解决办法：
vi /etc/sysctl.conf
添加一行：vm.max_map_count=262144即可；
查看配置：
sysctl -p

进入elk容器：
docker exec -it elk bash
执行：
/opt/logstash/bin/logstash -e 'input { stdin { }} output { elasticsearch { hosts => ["localhost"] }}'

#### 第一次报错：

Logstash could not be started because there is already another instance using the configured data directory.  If you wish to run multiple instances, you must change the "path.data" setting.

##### 解决报错：

service logstash stop 
再执行上面的命令即可；

#### 第二次报错：

Unknown setting 'host' for elasticsearch

##### 解决报错：

命令中的host替换为hosts即可；
/opt/logstash/bin/logstash -e 'input { stdin { }} output { elasticsearch { hosts => ["localhost"] }}'
然后输入一条测试数据：this is a dummy entry
打开地址：http://<your-host>:9200/_search?pretty查看；
再打开地址：http://<your-host>:5601点击create创建即可；

至此，logstash-server服务创建完毕。

## logstash-forwarder目录：

jaychiu/centos:7.1-->jaychiu/logstash-forwarder:0.4.0

启动jaychiu/logstash-forwarder:0.4.0镜像：
--link {容器名称}:{别名，域名}
docker run -d --name fwd --link elk:log.jaychiu.cn -v /data/logs:/data/logs jaychiu/logstash-forwarder:0.4.0
