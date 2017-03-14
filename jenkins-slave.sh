#!/bin/bash

# if `docker run` first argument start with `-` the user is passing jenkins swarm launcher arguments
if [[ $# -lt 1 ]] || [[ "$1" == "-"* ]]; then

  # jenkins swarm slave
  JAR=`ls -1 /usr/share/jenkins/swarm-client-*.jar | tail -n 1`

  # if -master is not provided and using --link jenkins:jenkins
  if [[ "$@" != *"-master "* ]] && [ ! -z "$JENKINS_PORT_8080_TCP_ADDR" ]; then
    PARAMS="-master http://$JENKINS_PORT_8080_TCP_ADDR:$JENKINS_PORT_8080_TCP_PORT"
  fi
  if [ -n "${RUNNER_DOCKER_PRIVATE_REGISTRY_URL}" ] && [ -n "${RUNNER_DOCKER_PRIVATE_REGISTRY_TOKEN}" ];then
    mkdir -p "/home/jenkins-slave/.docker"
    echo "{\"auths\": {\"${RUNNER_DOCKER_PRIVATE_REGISTRY_URL}\": {\"auth\": \"${RUNNER_DOCKER_PRIVATE_REGISTRY_TOKEN}\"}}}" > "/home/jenkins-slave/.docker/config.json"
  fi

  echo Running java $JAVA_OPTS -jar $JAR -fsroot $HOME $PARAMS "$@"
  exec java -Xmx2048m $JAVA_OPTS -jar $JAR -fsroot $HOME $PARAMS "$@"
fi

# As argument is not jenkins, assume user want to run his own process, for sample a `bash` shell to explore this image
exec "$@"
