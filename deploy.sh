#!/bin/sh
set -eu
JSON=/home/vagrant/sync/deploy.json

deploy-ostree $JSON
