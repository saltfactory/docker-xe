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
