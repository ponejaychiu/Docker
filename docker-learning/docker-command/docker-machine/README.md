# docker-machine安装：
$curl -L https://github.com/docker/machine/releases/download/v0.13.0/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine
$chmod +x /usr/local/bin/docker-machine
# docker-machine使用：
Virtualbox 驱动

使用 virtualbox 类型的驱动，创建一台 Docker 主机，命名为 test。

$ docker-machine create -d virtualbox test
你也可以在创建时加上如下参数，来配置主机或者主机上的 Docker。

--engine-opt dns=114.114.114.114 配置 Docker 的默认 DNS

--engine-registry-mirror https://registry.docker-cn.com 配置 Docker 的仓库镜像

--virtualbox-memory 2048 配置主机内存

--virtualbox-cpu-count 2 配置主机 CPU

更多参数请使用 docker-machine create --driver virtualbox --help 命令查看。
## 报错：
Error with pre-create check: "This computer doesn't have VT-X/AMD-v enabled. Enabling it in the BIOS is mandatory"
## 机器需要开启虚拟化；
docker-machine create -d virtualbox test1
Running pre-create checks...
(test1) Image cache directory does not exist, creating it at /root/.docker/machine/cache...
(test1) No default Boot2Docker ISO found locally, downloading the latest release...
(test1) Latest release for github.com/boot2docker/boot2docker is v17.09.1-ce
(test1) Downloading /root/.docker/machine/cache/boot2docker.iso from https://github.com/boot2docker/boot2docker/releases/download/v17.09.1-ce/boot2docker.iso...
(test1) 0%....10%....20%....30%....40%....50%....60%....70%....80%....90%....100%
Creating machine...

## 查看虚拟机信息： 
#docker-machine env test1
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.100:2376"
export DOCKER_CERT_PATH="/root/.docker/machine/machines/test1"
export DOCKER_MACHINE_NAME="test1"

## 切换虚拟机环境：
执行以下命令则当前会话窗口进入指定的test1的环境；
# Run this command to configure your shell: 
# eval $(docker-machine env test1)
