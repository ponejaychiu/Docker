# Docker—Learning
## 此目录用来学习docker容器技术

### Server端：

curl -Ssl -o /tmp/csphere-install.sh https://csphere.cn/static/csphere-install-v2.sh
env ROLE=controller CSPHERE_VERSION=0.12.2 /bin/sh /tmp/csphere-install.sh

### Client端：

curl -SsL -o /tmp/csphere-install.sh https://csphere.cn/static/csphere-install-v2.sh
env ROLE=agent CONTROLLER_IP=192.168.10.152 CONTROLLER_PORT=1016 CSPHERE_VERSION=0.12.2 AUTH_KEY=ebafe4fdd4c741d6d7fc0cfc6a1efce2c213afaf4b69d5356acd57e8186e9a6c6a3af4883414a87b /bin/sh /tmp/csphere-install.sh