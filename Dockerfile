
FROM node:8

LABEL maintainer="kylemharding@gmail.com"

# default timezone
ENV TZ America/Toronto

# avoid prompts during package installation
ENV DEBIAN_FRONTEND noninteractive

# install updates and common utilities
RUN apt-get update && apt-get install -yq --no-install-recommends \
	apt-transport-https \
	aufs-tools \
	bash-completion \
	ca-certificates \
	curl \
	git \
	gnupg2 \
	openssh-server \
	software-properties-common \
	sudo \
	tmux \
	tzdata \
	wget \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install docker
RUN curl -fsSL https://get.docker.com | sh \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# work in app dir
WORKDIR /usr/src/app

# create user account
RUN adduser --disabled-password --gecos '' theia \
	&& adduser theia sudo \
	&& adduser theia docker \
	&& echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
	&& chown theia:theia /usr/src/app

# switch to theia user
USER theia

# export latest theia package list
RUN curl -fsSL https://raw.githubusercontent.com/theia-ide/theia-apps/master/theia-full-docker/latest.package.json -o ./package.json

# install theia with yarn
RUN yarn --cache-folder ./ycache \
	&& rm -rf ./ycache \
	&& yarn theia build

# copy start script
COPY start.sh ./

# expose theia port
EXPOSE 3000

# set default shell to bash
ENV SHELL /bin/bash

# volumes for home dir and docker graph
VOLUME /home/theia /var/lib/docker

# run start script on boot
CMD [ "/bin/bash", "start.sh" ]
