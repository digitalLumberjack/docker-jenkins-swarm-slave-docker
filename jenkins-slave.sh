#!/bin/sh

/usr/local/bin/docker daemon \
                --host=unix:///var/run/docker.sock \
                --host=tcp://0.0.0.0:2375 \
                --storage-driver=vfs &

if [ -n "${RUNNER_DOCKER_PRIVATE_REGISTRY_URL}" ] && [ -n "${RUNNER_DOCKER_PRIVATE_REGISTRY_TOKEN}" ];then
  mkdir ".docker"
  echo "{\"auths\": {\"${RUNNER_DOCKER_PRIVATE_REGISTRY_URL}\": {\"auth\": \"${RUNNER_DOCKER_PRIVATE_REGISTRY_TOKEN}\"}}}" > ".docker/config.json"
fi

# if `docker run` first argument start with `-` the user is passing jenkins swarm launcher arguments
if [ "$1" == "/bin/sh" ];then
  exec "$@"
else
  # jenkins swarm slave
  JAR=`ls -1 /usr/share/jenkins/swarm-client-*.jar | tail -n 1`

  echo Running java $JAVA_OPTS -jar $JAR -fsroot $HOME $PARAMS "$@"
  exec java $JAVA_OPTS -jar $JAR -fsroot $HOME $PARAMS "$@"
fi
