# Docker三剑客
## 一、docker-compose项目：
### 安装：
#### 二进制安装：
$ curl -L https://github.com/docker/compose/releases/download/1.17.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
$ chmod +x /usr/local/bin/docker-compose

### bash命令补全：
$ curl -L https://raw.githubusercontent.com/docker/compose/1.8.0/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose

#### pip安装：
sudo pip install -U docker-compose

### 卸载：
如果是二进制包方式安装的，删除二进制文件即可。
$ sudo rm /usr/local/bin/docker-compose

如果是通过 pip 安装的，则执行如下命令即可删除。
$ sudo pip uninstall docker-compose

## 命令使用说明：
http://docker_practice.gitee.io/compose/commands.html

### Server端：

docker run -ti --rm -v /var/run/docker.sock:/var/run/docker.sock dockercloud/registration

### Client端：


