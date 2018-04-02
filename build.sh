#!/bin/sh
set -eu
SYNCDIR=/home/vagrant/sync
TAG=atomic-debian
OSTREE=/home/vagrant/ostree
CONF=$SYNCDIR/strap.conf
REF=debian/9/x86_64/minimal

docker build -t $TAG $SYNCDIR
docker run \
    -it \
    --rm \
    --privileged \
    -v $OSTREE:/ostree:z \
    -v $CONF:/conf:ro,z \
    $TAG \
    /conf \
    $REF
