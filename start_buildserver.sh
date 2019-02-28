#!/bin/bash

SSH_PORT=${SSH_PORT:-2222}
TAG=${TAG:-latest}
NAME=${NAME:-roborio-docker}

docker run -d --name ${NAME} --hostname ${NAME} \
    -p ${SSH_PORT}:22 \
    -v /root/.ssh/authorized_keys:/home/admin/.ssh/authorized_keys \
    -e LD_PRELOAD=/usr/local/lib/libfakearmv7l.so \
    roborio-build:${TAG} /usr/sbin/sshd -D
