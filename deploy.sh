#!/bin/sh
set -eu
OSTREE=/home/vagrant/ostree
REF=debian/9/x86_64/minimal
OS=debian

ostree pull-local $OSTREE $REF
ostree admin deploy --os=$OS --karg=root=/dev/mapper/fedora-root $REF
