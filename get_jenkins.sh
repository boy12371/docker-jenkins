#!/bin/bash

if [[ ! -f jenkins.war ]]; then
	curl -fL http://mirrors.jenkins-ci.org/war-stable/$JENKINS_VERSION/jenkins.war -o jenkins.war
else
	echo "jenkins.war already exists";
fi

