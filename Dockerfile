FROM ubuntu-1404

# 需要在docker内使用docker, 所以安装libsystemd-journal0
RUN apt-get update \
  && apt-get install -y wget git curl zip libsystemd-journal0 \
  && rm -rf /var/lib/apt/lists/*

ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT 50000
ENV JAVA_OPTS  -Duser.timezone=Asia/Shanghai 

RUN echo "Asia/Shanghai" > /etc/timezone \
  &&  dpkg-reconfigure -f noninteractive tzdata

# Jenkins is run with user `jenkins`, uid = 1000
# If you bind mount a volume from the host or a data container, 
# ensure you use the same uid
RUN groupadd -g 999 docker \
  && useradd -d "$JENKINS_HOME" -u 1000 -G 999 -m -s /bin/bash jenkins

# Jenkins home directory is a volume, so configuration and build history 
# can be persisted and survive image upgrades
VOLUME /var/jenkins_home

# `/usr/share/jenkins/ref/` contains all reference configuration we want 
# to set on a fresh new installation. Use it to bundle additional plugins 
# or config file with your custom jenkins Docker image.
RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d

ENV TINI_SHA 6d6a317ba7d5a50f0e9dc7f5e0b5f10356fcfd0a

# Use tini as subreaper in Docker container to adopt zombie processes 
# RUN curl -fL https://github.com/krallin/tini/releases/download/v0.8.3/tini-static -o /bin/tini && chmod +x /bin/tini \
#  && echo "$TINI_SHA /bin/tini" | sha1sum -c -

COPY tini-static  /bin/tini 
RUN  chmod +x /bin/tini
COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy

ENV JENKINS_VERSION 1.625.1
ENV JENKINS_SHA c96d44d4914a154c562f21cd20abdd675ac7f5f3

# could use ADD but this one does not check Last-Modified header 
# see https://github.com/docker/docker/issues/8331
# RUN curl -fL http://mirrors.jenkins-ci.org/war-stable/$JENKINS_VERSION/jenkins.war -o /usr/share/jenkins/jenkins.war
# 下不了 jenkins.war
ADD jenkins.war /usr/share/jenkins/
RUN echo "$JENKINS_SHA /usr/share/jenkins/jenkins.war" | sha1sum -c -

ENV JENKINS_UC https://updates.jenkins-ci.org
RUN chown -R jenkins "$JENKINS_HOME" /usr/share/jenkins/ref

# for main web interface:
EXPOSE 8080

# will be used by attached slave agents:
EXPOSE 50000

ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log

RUN echo "export PATH=/repositories/aegis-docker/bin:$PATH" >> /etc/profile

COPY jenkins.sh /usr/local/bin/jenkins.sh
ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]

# from a derived Dockerfile, can use `RUN plugins.sh active.txt` to setup /usr/share/jenkins/ref/plugins from a support bundle
COPY plugins.sh /usr/local/bin/plugins.sh

WORKDIR /repositories

USER jenkins



