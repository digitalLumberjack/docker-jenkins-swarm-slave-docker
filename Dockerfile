FROM openjdk:8u102-jdk

MAINTAINER digitalLumberjack <digitallumberjack@gmail.com>

ARG DOCKER_CLI_VERSION='1.13.0-rc2'
ARG JENKINS_SWARM_VERSION='2.2'

ENV HOME /home/jenkins-slave

# install netstat to allow connection health check with
# netstat -tan | grep ESTABLISHED
RUN apt-get update && apt-get install -y net-tools && rm -rf /var/lib/apt/lists/*

# install docker
RUN wget https://test.docker.com/builds/Linux/x86_64/docker-${DOCKER_CLI_VERSION}.tgz -O docker.tgz \
  && tar xvf docker.tgz \
  && mv docker/docker /usr/local/bin/ \
  && rm -rf docker.tgz docker

RUN useradd -c "Jenkins Slave user" -d $HOME -m jenkins-slave
RUN curl --create-dirs -sSLo /usr/share/jenkins/swarm-client-$JENKINS_SWARM_VERSION-jar-with-dependencies.jar https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/$JENKINS_SWARM_VERSION/swarm-client-$JENKINS_SWARM_VERSION-jar-with-dependencies.jar \
  && chmod 755 /usr/share/jenkins

COPY jenkins-slave.sh /usr/local/bin/jenkins-slave.sh

VOLUME /home/jenkins-slave

ENTRYPOINT ["/usr/local/bin/jenkins-slave.sh"]
