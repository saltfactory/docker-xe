#!/bin/bash

############################################################
## docker project name
PROJECT_NAME="docker-xe"
############################################################
## docker configurations
DOCKER_USER="saltfactory"
DOCKER_VERSION="1.8.3"
DOCKER_NAME="xe"
DOCKER_IMAGE="$DOCKER_USER/$DOCKER_NAME:$DOCKER_VERSION"
############################################################
## container configurations
DOCKER_CONTAINER_NAME="demo-xe"
DOCKER_CONTAINER_PORT="7000"
############################################################
## container volumes
XE_HOME="/Users/saltfactory/shared/xe-core"
XE_FILES="/Users/saltfactory/shared/xe-core/files"
XE_LOGS="/Users/saltfactory/shared/logs"
############################################################

function is_running {
  docker ps | grep $DOCKER_CONTAINER_NAME
}

function is_exists {
  docker ps -a  | grep $DOCKER_CONTAINER_NAME
}

function build_image {
  if [ "$1" = "src" ]; then
    echo "*** [Building] \"$DOCKER_IMAGE\" via sources package ***"
    if [ ! -d $XE_HOME ]; then
      git clone https://github.com/xpressengine/xe-core.git $XE_HOME
    else
      echo "*** $XE_HOME is exist"
    fi
  else
    echo "*** [Building] \"$DOCKER_IMAGE\" via full package ***"
  fi

  docker build -t $DOCKER_IMAGE .

}

function init_container {
  remove_containers

  echo "*** [init] Name: \"$DOCKER_CONTAINER_NAME\" PORT: $DOCKER_CONTAINER_PORT ***"
  docker run \
  --name $DOCKER_CONTAINER_NAME \
  -p $DOCKER_CONTAINER_PORT:80 \
  -v $XE_HOME:/var/www/sources \
  -v $XE_LOGS:/var/logs/apache2 \
  -e BEFORE_SCRIPT=before.sh \
  -d \
  $DOCKER_IMAGE

  # docker run \
  # --name $DOCKER_CONTAINER_NAME \
  # -p $DOCKER_CONTAINER_PORT:80 \
  # -v $XE_FILES:/var/www/files \
  # -v $XE_LOGS:/var/logs/apache2 \
  # -e BEFORE_SCRIPT=before.sh \
  # -d \
  # $DOCKER_IMAGE

  docker ps
}

function start_container {
  if [[ -n $(is_running) ]]; then
    echo "*** \"$DOCKER_CONTAINER_NAME\" is running! ***"
  else
    if [[ -n $(is_exists) ]]; then
      echo "*** [init] Name: \"$DOCKER_CONTAINER_NAME\" PORT: $DOCKER_CONTAINER_PORT ***"
      docker start $DOCKER_CONTAINER_NAME
    else
      init_container
    fi
  fi
}

function stop_container {
  if [[ -n $(is_running) ]]; then
    echo "*** [stop] Name: \"$DOCKER_CONTAINER_NAME\" PORT: $DOCKER_CONTAINER_PORT ***"
    docker stop $DOCKER_CONTAINER_NAME
  else
    echo "*** \"$DOCKER_CONTAINER_NAME\" is not running! ***"
  fi
}

function remove_containers {
  stop_container

  if [ -n "$(docker ps -a  | grep $DOCKER_CONTAINER_NAME)" ]; then
    echo "*** [removing] Name: \"$DOCKER_CONTAINER_NAME\" PORT: $DOCKER_CONTAINER_PORT ***"
    docker rm $(docker ps -a  | grep $DOCKER_CONTAINER_NAME | awk '{print $1}')
  else
    echo "*** \"$DOCKER_CONTAINER_NAME\" is not exist! ***"
  fi
}

function log_containers {
  docker logs $DOCKER_CONTAINER_NAME
}

function exec_container {
  docker exec -it $DOCKER_CONTAINER_NAME bash
}


echo "*** [Run] *** "
if [ -n "$1" ]; then
  case "$1" in
  build)
    build_image $2
  ;;
  init)
    init_container
  ;;
  start)
    start_container
  ;;
  stop)
    stop_container
  ;;
  remove|rm)
    remove_containers
  ;;
  log|logs)
    log_containers
  ;;
  exec)
    exec_container
  ;;
  *)
    echo "option is not valid!"
  ;;
  esac
fi

echo "*** [Done] *** "
