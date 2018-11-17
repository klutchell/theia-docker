#!/bin/bash

# set timezone with TZ
# eg. TZ=America/Toronto
ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime && echo "${TZ}" > /etc/timezone

# start docker daemon in the background
sudo /usr/bin/dockerd &

# create workspace
[ ! -d "/home/theia/workspace" ] && mkdir "/home/theia/workspace"

# start theia app in the foreground
/usr/local/bin/yarn --cwd "/usr/src/app" theia start "/home/theia/workspace" --hostname=0.0.0.0
