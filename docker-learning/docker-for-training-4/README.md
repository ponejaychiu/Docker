# 第四节：Docker实战之网络管理
希云课程链接：http://edu.51cto.com/center/course/lesson/index?id=71320

## 背景知识——了解NameSpace：

namespace将容器的进程、网络、IPC、文件系统、UTS和用户空间隔离开；
组件：
pid、IPC、mount、UTS、user、

PID Namespace隔离进程，Mount Namespace隔离文件系统，Network Namespace隔离网络

<!--注：**本次实验用到的docker版本为：17.09.1-ce**-->

## NAT模式：

创建容器后，容器的网络默认为NAT模式（如果不知道网络模式的话）；

### 一、

docker run -it --name jaychiu-nat1 --rm busybox sh
查看容器的路由：
route -n
宿主机查看iptables可以看到没有任何路由：
iptables -t nat -L -n

### 二、

docker run -it -p 2222:22 --name jaychiu-nat2 --rm busybox sh
宿主机查看iptables可以看到转发的路由：
Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination         
MASQUERADE  all  --  172.17.0.0/16        0.0.0.0/0           
MASQUERADE  tcp  --  172.17.0.3           172.17.0.3           tcp dpt:80
MASQUERADE  tcp  --  172.17.0.4           172.17.0.4           tcp dpt:5000
MASQUERADE  tcp  --  172.17.0.5           172.17.0.5           tcp dpt:22

Chain DOCKER (2 references)
target     prot opt source               destination         
RETURN     all  --  0.0.0.0/0            0.0.0.0/0           
DNAT       tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:1016 to:172.17.0.3:80
DNAT       tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:5001 to:172.17.0.4:5000

DNAT       tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:2222 to:172.17.0.5:22

## HOST模式：

docker run -it -p 2222:22 --name jaychiu-host1 --net host --rm busybox

容器内查看IP和宿主机一模一样；

## Container模式：

需要运行两个容器：
docker run -it --name jaychiu-host1 --net host busybox
docker run -it --name jaychiu-container --net container:jaychiu-host1 busybox
container:{要复制网络的容器名称}

可以看到jaychiu-container容器和jaychiu-host1容器网络一样都是host模式；

## None模式：

docker run -it --name jaychiu-none --net none busybox
容器内查看ip：

ip a

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
## Overlay模式：

需要安装consul命令，这个模式的实验我实在两台ubuntu17.04的系统上做的；