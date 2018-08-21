#!/bin/sh
set -eu
IMAGEDIR=/vagrant
TAG=atomic-debian
OSTREE_BUILD=/home/vagrant/ostree-build
OSTREE_PUBLISH=/home/vagrant/ostree-publish

COMPOSE=/vagrant/stretch-minimal/compose.json

COMPOSE_DIR=$(dirname $COMPOSE)
COMPOSE_FILE=$(basename $COMPOSE)

docker build -t $TAG $IMAGEDIR
docker run \
    -it \
    --rm \
    -v $OSTREE_BUILD:/ostree \
    -v $COMPOSE_DIR:/config:ro \
    --privileged \
    $TAG \
    /config/$COMPOSE_FILE \
    /ostree

ostree pull-local --repo=$OSTREE_PUBLISH $OSTREE_BUILD $(jq -r '.ref' < $COMPOSE)
