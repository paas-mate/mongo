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

RUN if [[ "$TARGETARCH" = "amd64" ]]; \
    then download=$amd_download; \
    else download=$arm_download; \
    fi && \
    wget https://fastdl.mongodb.org/linux/$download.tgz && \
    mkdir -p /opt/mongo && \
    tar -xf $download.tgz -C /opt/mongo --strip-components 1 && \
    rm -rf $download.tgz && \
    ln -s /opt/mongo/bin/mongo /usr/bin/mongo && \
    ln -s /opt/mongo/bin/mongod /usr/bin/mongod && \
    ln -s /opt/mongo/bin/mongos /usr/bin/mongos

WORKDIR /opt/mongo
