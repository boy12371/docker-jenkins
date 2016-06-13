#!/bin/bash

source ../aegis-docker/bin/aegis-config;
export pwd=$(pwd);
export repo_root=$(cd $pwd/..; pwd);

# node_path=$(which node);
# node_dir=$(cd `dirname $node_path`/..; pwd);
# -v $node_dir:/opt/node-v6.2.0-linux-x64 \

export container_name=jenkins-dev;
export project_name=docker-jenkins;
export image_name=ubuntu-jenkins;
export ip=$jenkins_ip;
export create_param="-v $HOME/.gradle:/var/jenkins_home/.gradle \
-v $HOME/.ssh:/var/jenkins_home/.ssh \
-v $HOME/.gitconfig:/var/jenkins_home/.gitconfig \
-v ${pwd}/data:/var/jenkins_home \
-v ${repo_root}:${repo_root} \
-v /var/run/docker.sock:/var/run/docker.sock \
-v $(which docker):/usr/bin/docker";

# 重写mbt!!!!!
mbt_rewrite;

local() { echo "ERROR: target not supported" | color red bold; }
debug() { echo "ERROR: target not supported" | color red bold; }

eval $@;

