#!/bin/sh
set -eu
OSTREE=/home/vagrant/ostree
CHECKOUT=/home/vagrant/ostree-debian
REF=debian/9/x86_64/minimal

rm -rf $CHECKOUT
ostree checkout --repo=$OSTREE $REF $CHECKOUT
