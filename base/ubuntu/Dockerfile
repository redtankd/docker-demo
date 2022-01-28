ARG UBUNTU_VERSION=latest

FROM ubuntu:${UBUNTU_VERSION}

ARG USER_HOME=/root

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-add-repository ppa:fish-shell/release-3
RUN apt-get update
RUN apt-get install -y fish git vim wget curl locales
RUN export DEBIAN_FRONTEND=noninteractive; apt-get install -y tzdata

RUN locale-gen zh_CN.UTF-8
ENV LANG zh_CN.UTF-8

RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

WORKDIR $USER_HOME

COPY config/fish/config.fish .config/fish/config.fish
COPY config/fish/functions/* .config/fish/functions/
COPY gitconfig .gitconfig

