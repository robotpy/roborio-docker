#!/bin/bash
#
# This script launches a shell in a docker container that will be
# destroyed when you exit the shell
#

TAG=${TAG:-latest}

docker run --rm -it \
    -e LD_PRELOAD=/usr/local/lib/libfakearmv7l.so \
    roborio-build:${TAG} /bin/bash

