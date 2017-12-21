#!/bin/bash

docker run -d --name roborio-docker --hostname roborio-docker \
    -p 2222:22 \
    -v /root/.ssh/authorized_keys:/home/admin/.ssh/authorized_keys \
    -e LD_PRELOAD=/usr/local/lib/libfakearmv7l.so \
    roborio-build:latest /usr/sbin/sshd -D