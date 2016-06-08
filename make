#!/bin/bash

source ../aegis-docker/bin/aegis-config;
export pwd=$(pwd);
export repo_root=$(cd $pwd/../..; pwd);

export container_name=jenkins-dev;
export project_name=docker-jenkins;
export image_name=ubuntu-jenkins;
export ip=$jenkins_ip;
export create_param="-v $HOME/.ssh:/var/jenkins_home/.ssh -v ${pwd}/bashrc:/var/jenkins_home/.bashrc -v ${pwd}/data:/var/jenkins_home -v ${repo_root}:/repositories -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker";
export dev_registry=127.0.0.1:5000;
export registry=registry.yimei180.com;

# 重写mbt!!!!!
mbt_rewrite;
image() {
	./get_jenkins.sh;
	docker build -t $image_name .;
}
local() { echo "ERROR: target not supported" | color red bold; }
debug() { echo "ERROR: target not supported" | color red bold; }

eval $@;

