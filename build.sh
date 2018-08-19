#!/bin/sh
set -eu
SYNCDIR=/home/vagrant/sync
TAG=atomic-debian
OSTREE_BUILD=/home/vagrant/ostree
OSTREE_PUBLISH=/home/vagrant/ostree-publish
CONF=$SYNCDIR/strap.conf
REF=debian/9/x86_64/minimal

docker build -t $TAG $SYNCDIR
docker run \
    -it \
    --rm \
    -v $OSTREE_BUILD:/ostree:z \
    -v $CONF:/conf:ro,z \
    --privileged \
    $TAG \
    /conf \
    $REF

ostree pull-local --repo=$OSTREE_PUBLISH $OSTREE_BUILD $REF
