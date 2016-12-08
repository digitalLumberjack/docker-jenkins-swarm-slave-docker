FROM docker:1.12.3-dind

MAINTAINER digitalLumberjack <digitallumberjack@gmail.com>

ARG DOCKER_CLI_VERSION='1.12.2'
ARG JENKINS_SWARM_VERSION='2.2'

ENV HOME /home/jenkins-slave
WORKDIR /home/jenkins-slave

# install netstat to allow connection health check with
# netstat -tan | grep ESTABLISHED
RUN apk add --no-cache net-tools openjdk8-jre


RUN curl --create-dirs -sSLo /usr/share/jenkins/swarm-client-$JENKINS_SWARM_VERSION-jar-with-dependencies.jar https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/$JENKINS_SWARM_VERSION/swarm-client-$JENKINS_SWARM_VERSION-jar-with-dependencies.jar \
  && chmod 755 /usr/share/jenkins

COPY jenkins-slave.sh /usr/local/bin/jenkins-slave.sh

VOLUME /home/jenkins-slave

ENTRYPOINT ["/usr/local/bin/jenkins-slave.sh"]
