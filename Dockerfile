FROM node:8.4
MAINTAINER lihebin@wosai-inc.com

RUN npm config set registry https://registry.npm.taobao.org
RUN npm install -g gitbook-cli

ADD . /gitbook
WORKDIR /gitbook
RUN gitbook build
ENTRYPOINT gitbook serve