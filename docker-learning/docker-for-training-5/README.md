# 第五节：Docker实战之持续部署
课程链接：http://edu.51cto.com/center/course/lesson/index?id=73706

## docker-compose命令的使用：

### 启动编排服务：

docker-compose up -d
Starting my-web-container ... 
Starting my-web-container ... done

### 查看服务：

docker-compose ps

      Name              Command         State                   Ports                 
--------------------------------------------------------------------------------------
my-db-container    /scripts/start       Up      22/tcp, 0.0.0.0:3306->3306/tcp        
my-web-container   /init /scripts/run   Up      22/tcp, 0.0.0.0:80->8080/tcp, 8443/tcp

### 停止服务：

docker-compose stop
Stopping my-db-container  ... done
Stopping my-web-container ... done

### 启动服务：

docker-compose start
Starting my-db-container  ... done
Starting my-web-container ... done

### 删除服务（删除服务之前需要先停止服务）：

docker-compose rm
Going to remove my-db-container, my-web-container
Are you sure? [yN] y
Removing my-db-container  ... done
Removing my-web-container ... done

### 更新服务：

程序文件更新并生成新的镜像后，更改docker-compose.yml配置文件里镜像后直接执行启动即可；
docker-compose up -d
Recreating my-web-container ... 

Recreating my-web-container ... done

## docker swarm命令的使用：

### 创建swarm集群：

#### 一、创建集群token（discovery server）

vi /etc/systemd/system/multi-user.target.wants/docker.service

增加以下内容到文件中去：
ExecStart=/usr/bin/dockerd --registry-mirror=https://registry.docker-cn.com --insecure-registry 192.168.10.152:5000 --insecure-registry 192.168.10.152:5001 --label label_name=docker1
systemctl daemon-reload
systemctl restart docker

然后查看docker服务：
ps -elf |grep docker

4 S root      23570      1  1  80   0 - 191646 do_wai 17:29 ?       00:00:01 /usr/bin/dockerd --registry-mirror=https://registry.docker-cn.com --insecure-registry 192.168.10.152:5000 --insecure-registry 192.168.10.152:5001 --label label_name=docker1

#### 二、创建swarm master节点

docker run -d -p 2376:2375 swarm manage token://<cluster-id>

以MySQL为例创建集群：
docker create jaychiu/mysql:5.5
token值：3c0d1145f74c754823c0501046eedc4ecb9684d39235f2235f1a05884adbaf7f

docker run -d -p 2376:2375 --name mysql-swarm-server swarm manage token://3c0d1145f74c754823c0501046eedc4ecb9684d39235f2235f1a05884adbaf7f

5a9b2076ab22c0b215daaa0744c5807cbe30a814053aebe5723b2c6669caf152

#### 三、加入swarm集群（swarm node）

docker run -d -p swarm join --add=<node_ip>:<port> token://<cluster-id>

登陆第二台服务器：
token值与上面的一致

docker run -d --name mysql-swarm-node swarm join --add=192.168.10.152:2375 token://3c0d1145f74c754823c0501046eedc4ecb9684d39235f2235f1a05884adbaf7f

### 17.09.1-ce版本的docker内置swarm命令：

#### docker swarm init即可成为swarm manager；

Swarm initialized: current node (7jjr0vkbc4ve6za3fk2ae1g0l) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-46z3864v1cdlwn5jbktlgkqxw91c6avxt6v1sfdg35m5rzac2f-37a1z55mi62hi18z6ztp9tylt 192.168.10.152:2377
To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

### manager上查看节点信息：

docker node ls

ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS
7jjr0vkbc4ve6za3fk2ae1g0l *   vmware02            Ready               Active              Leader
jcixfcouujpztxfr9ge59n9sg     vmware03            Ready               Active              
qfjgsdwtwopp1kbw8mfoui93e     vmware04            Ready               Active 