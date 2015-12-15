#!/bin/bash

NAME=checkbot
IMAGE=dreg.meedan.net/checkdesk/${NAME}
VERSION=local

# Stop any running container
docker stop $NAME
docker rm $NAME

dir=$(pwd)
cd $(dirname "${BASH_SOURCE[0]}")

# Run
docker run -d -h ${HOSTNAME}-${NAME} --name ${NAME} --link redis:redis ${IMAGE}:${VERSION}

echo '-----------------------------------------------------------'
echo "${IMAGE} is now running "
echo '-----------------------------------------------------------'


