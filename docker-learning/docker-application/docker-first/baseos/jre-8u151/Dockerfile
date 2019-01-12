# Base jre image
FROM jaychiu/baseos:1.0
MAINTAINER jaychiu<18698577365@163.com>
LABEL Description="This image is used to serve Oracle jre 8u151"  Version="1.0"
# Install and config Oracle jre
ADD jre-8u151-linux-x64.tar.gz  /usr/lib/jvm/
RUN update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jre1.8.0_151/bin/java" 1 \
    && update-alternatives --set java /usr/lib/jvm/jre1.8.0_151/bin/java
ENV JAVA_HOME /usr/lib/jvm/jre1.8.0_151
