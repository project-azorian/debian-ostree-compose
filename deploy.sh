#!/bin/sh
set -eu
JSON=/home/vagrant/sync/deploy.json

setenforce 0
deploy-ostree $JSON
setenforce 1
