FROM ubuntu:bionic

ARG DEBIAN_FRONTEND=noninteractive

RUN \
 apt-get update \
 && apt-get install -y -q curl gnupg \
 && curl -sSL 'http://keyserver.ubuntu.com:80/pks/lookup?op=get&search=0x8AA7AF1F1091A5FD' | apt-key add -  \
 && echo 'deb [arch=amd64] http://repo.sawtooth.me/ubuntu/chime/stable bionic universe' >> /etc/apt/sources.list \
 && apt-get update \
 && apt-get install -y -q --no-install-recommends \
    apt-utils \
 && apt-get install -y -q \
    build-essential \
    apt-transport-https \
    ca-certificates \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y nodejs

WORKDIR /app
ADD server.js package.json ./

RUN npm install express crypto protobufjs sawtooth-sdk secp256k1 text-encoding uuid zeromq node-fetch@2.6.1
RUN npm install
CMD node server.js