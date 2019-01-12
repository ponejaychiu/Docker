# Base os image
FROM jaychiu/ubuntu:16.04
MAINTAINER jaychiu<18698577365@163.com>
LABEL Description="This image is the base os images from jaychiu/ubuntu 16.04."  Version="1.0"
# reconfig timezone
RUN echo "Asia/Shanghai" > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata
