#!/bin/bash

docker run --name roborio-docker --hostname roborio-docker \
    -p 2222:22 -d \
    -v /root/.ssh/authorized_keys:/home/admin/.ssh/authorized_keys \
    -v /usr/bin/qemu-arm-static:/usr/bin/qemu-arm-static \
    -e LD_PRELOAD=/usr/local/lib/libfakearmv7l.so \
    -v ${HOME}/src/frc:/src \
    roborio-build:latest /usr/bin/qemu-arm-static /usr/sbin/sshd -D
