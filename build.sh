#!/bin/sh
set -eu
IMAGEDIR=/vagrant
TAG=atomic-debian
OSTREE=/home/vagrant/ostree-publish

COMPOSE=$1

COMPOSE_DIR=$(dirname $COMPOSE)
COMPOSE_FILE=$(basename $COMPOSE)

docker build -t $TAG $IMAGEDIR
docker run \
    -it \
    --rm \
    -v $OSTREE:/ostree \
    -v $COMPOSE_DIR:/config:ro \
    --privileged \
    $TAG \
    /config/$COMPOSE_FILE \
    /ostree
