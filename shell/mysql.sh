#!/bin/bash

DOCKER_IMAGE="mysql:latest"
DOCKER_CONTAINER_NAME="demo-mysql"
DOCKER_CONTAINER_PORT="3306"
MYSQL_ROOT_PASSWORD="mysql"

function init_container {
  echo "*** [init] Name: $DOCKER_CONTAINER_NAME PORT: $DOCKER_CONTAINER_PORT ***"
  docker run --name $DOCKER_CONTAINER_NAME \
  -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
  -p $DOCKER_CONTAINER_PORT:3306 \
  -d \
  $DOCKER_IMAGE
}

function start_container {
  echo "*** [strarting] Name: $DOCKER_CONTAINER_NAME PORT: $DOCKER_CONTAINER_PORT ***"
  docker start $DOCKER_CONTAINER_NAME
}

function restart_container {
  echo "*** [restarting] Name: $DOCKER_CONTAINER_NAME PORT: $DOCKER_CONTAINER_PORT ***"
  docker restart $DOCKER_CONTAINER_NAME
}

function stop_container {
  echo "*** [stopping] Name: $DOCKER_CONTAINER_NAME PORT: $DOCKER_CONTAINER_PORT ***"
  docker stop $DOCKER_CONTAINER_NAME
}

function remove_container {
  echo "*** [removing] Name: $DOCKER_CONTAINER_NAME PORT: $DOCKER_CONTAINER_PORT ***"
  docker rm $DOCKER_CONTAINER_NAME
}

function init_demo_mysql {
  echo "*** [init] mysql ***"
#   docker exec -it $DOCKER_CONTAINER_NAME bash -c 'mysql -uroot -p"mysql" <<EOF
# create database IF NOT EXISTS demo default character set utf8;
# grant all on demo.* to "demo"@"localhost" identified by "demo";
# grant all on demo.* to "demo"@"%" identified by "demo";
# EOF'
docker run -it \
--link $DOCKER_CONTAINER_NAME:mysql \
--rm mysql sh -c "exec mysql -h\"$(boot2docker ip)\" -P\"$DOCKER_CONTAINER_PORT\" -uroot -p"$MYSQL_ROOT_PASSWORD" <<EOF
create database IF NOT EXISTS demo default character set utf8;
grant all on demo.* to \"demo\"@\"localhost\" identified by \"demo\";
grant all on demo.* to \"demo\"@\"%\" identified by \"demo\";
EOF"

}

function is_running(){
  docker ps -a | grep $DOCKER_CONTAINER_NAME
  # return $(docker ps -a | grep $DOCKER_CONTAINER_NAME)
}


if [ -n "$1" ]; then
  if [ $1 = "init" ]; then
    if [[ -n $(is_running) ]]; then
      stop_container
    fi
    if [[ -n $(is_running) ]]; then
      remove_container
    fi
    init_container
    restart_container
    init_demo_mysql

  elif [ $1 = "start" ]; then
    if [[ -n $(is_running) ]]; then
      restart_container
    else
      start_container
    fi
  fi
fi

echo "*** [Done] ***"
