# 创建集群：
链接：http://docker_practice.gitee.io/swarm_mode/create.html
## 初始化集群：
$ docker swarm init --advertise-addr 192.168.99.100
如果你的 Docker 主机有多个网卡，拥有多个 IP，必须使用 --advertise-addr 指定 IP。
## 增加工作节点：
$ docker-machine create -d virtualbox worker1
$ docker-machine create -d virtualbox worker2
$ docker-machine ssh worker1/worker2
执行以下命令加入集群：
docker swarm join --token SWMTKN-1-46z3864v1cdlwn5jbktlgkqxw91c6avxt6v1sfdg35m5rzac2f-37a1z55mi62hi18z6ztp9tylt 192.168.10.152:2377

任务 （Task）是 Swarm 中的最小的调度单位，目前来说就是一个单一的容器。

服务 （Services） 是指一组任务的集合，服务定义了任务的属性。服务有两种模式：

replicated services 按照一定规则在各个工作节点上运行指定个数的任务。

global services 每个工作节点上运行一个任务

两种模式通过 docker service create 的 --mode 参数指定。

# 部署服务：
链接：http://docker_practice.gitee.io/swarm_mode/deploy.html
## 新建服务：
我们使用 docker service 命令来管理 Swarm 集群中的服务，该命令只能在管理节点运行。
现在我们在上一节创建的 Swarm 集群中运行一个名为 nginx 服务。
$ docker service create --replicas 3 -p 80:80 --name nginx nginx:1.13.7-alpine
i2f57aapnq6rsiw0je056agx1
Since --detach=false was not specified, tasks will be created in the background.
In a future release, --detach=false will become the default.
现在我们使用浏览器，输入任意节点 IP ,即可看到 nginx 默认页面。
# 查看服务：
docker service ls
ID                  NAME                       MODE                REPLICAS            IMAGE                      PORTS
kp4anxxvtdf0        dockercloud-server-proxy   global              1/1                 dockercloud/server-proxy   *:2376->2376/tcp
i2f57aapnq6r        nginx                      replicated          3/3                 nginx:1.13.7-alpine        *:80->80/tcp
# 查看服务详情：
docker service ps nginx
ID                  NAME                IMAGE                 NODE                DESIRED STATE       CURRENT STATE           ERROR               PORTS
b22778220dck        nginx.1             nginx:1.13.7-alpine   worker2             Running             Running 4 minutes ago                       
s1ugcqgkxt0w        nginx.2             nginx:1.13.7-alpine   worker1             Running             Running 4 minutes ago                       
93haltqqrsxb        nginx.3             nginx:1.13.7-alpine   vmware02            Running             Running 5 minutes ago 
# 查看服务日志：
docker service logs nginx
nginx.3.93haltqqrsxb@vmware02    | 10.255.0.2 - - [26/Dec/2017:03:47:56 +0000] "GET / HTTP/1.1" 200 612 "-" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.62 Safari/537.36" "-"
nginx.3.93haltqqrsxb@vmware02    | 2017/12/26 03:47:56 [error] 5#5: *1 open() "/usr/share/nginx/html/favicon.ico" failed (2: No such file or directory), client: 10.255.0.2, server: localhost, request: "GET /favicon.ico HTTP/1.1", host: "192.168.10.152", referrer: "http://192.168.10.152/"
nginx.3.93haltqqrsxb@vmware02    | 10.255.0.2 - - [26/Dec/2017:03:47:56 +0000] "GET /favicon.ico HTTP/1.1" 404 571 "http://192.168.10.152/" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.62 Safari/537.36" "-"
nginx.3.93haltqqrsxb@vmware02    | 10.255.0.2 - - [26/Dec/2017:03:48:44 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.62 Safari/537.36" "-"
# 删除服务：
docker service rm dockercloud-server-proxy
dockercloud-server-proxy

# 集群中使用compose文件：
内容详见docker-compose.yml文件；
# 部署服务：
部署服务使用 docker stack deploy，其中 -c 参数指定 compose 文件名。
$ docker stack deploy -c docker-compose.yml wordpress
现在我们打开浏览器输入 任一节点IP:8080 即可看到各节点运行状态.

# 查看服务：
docker stack ls
NAME                SERVICES
wordpress           3
# 删除服务：
docker stack rm wordpress

