FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo vim dumb-init && \
    apt-get install -y --no-install-recommends iputils-ping && \
    apt-get install -y wget curl && \
    apt-get install -y --no-install-recommends tcpdump && \
    apt-get install -y --no-install-recommends lsof && \
    apt-get install -y --no-install-recommends iproute2 && \
    apt-get -y --purge autoremove && \
    apt-get autoclean && \
    apt-get clean
RUN echo "alias ll='ls -al'" >> /etc/bash.bashrc && \
    echo "alias ..='cd ..'" >> /etc/bash.bashrc && \
    echo "alias ...='cd ../..'" >> /etc/bash.bashrc && \
    echo "alias tailf='tail -f'" >> /etc/bash.bashrc && \
    echo "set nu" >> /etc/vim/vimrc

ENV MONGO_HOME /opt/mongo

ARG TARGETARCH

ARG amd_download=mongodb-linux-x86_64-ubuntu2004-6.0.4

ARG arm_download=mongodb-linux-aarch64-ubuntu2004-6.0.4

ARG amd_shell_download=mongosh-1.6.2-linux-x64

ARG arm_shell_download=mongosh-1.6.2-linux-arm64

RUN if [ "$TARGETARCH" = "amd64" ]; \
    then download=$amd_download; shell_download=amd_shell_download; \
    else download=$arm_download; shell_download=arm_shell_download; \
    fi && \
    wget -q https://fastdl.mongodb.org/linux/$download.tgz && \
    mkdir -p /opt/mongo && \
    tar -xf $download.tgz -C /opt/mongo --strip-components 1 && \
    rm -rf $download.tgz && \
    wget -q https://downloads.mongodb.com/compass/$shell_download.tgz && \
    mkdir -p /opt/mongo/shell && \
    tar -xf $shell_download.tgz -C /opt/mongo/shell --strip-components 1 && \
    rm -rf $shell_download.tgz && \
    ln -s /opt/mongo/shell/bin/mongosh /usr/bin/mongosh && \
    ln -s /opt/mongo/bin/mongod /usr/bin/mongod && \
    ln -s /opt/mongo/bin/mongos /usr/bin/mongos

WORKDIR /opt/mongo
