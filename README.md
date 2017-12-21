roborio-docker
==============

This repository contains scripts that are useful for transforming a RoboRIO
firmware image into a docker image that can be ran on an ARM computer (it
will not work on a normal PC).

This process has been tested on an ODROID-C2.

Build image from firmware image
-------------------------------

First, grab the image zipfile from your driver station, and copy it to the
machine that you're running docker on. Then, run:

    ./build_images.sh FRC_roboRIO_x_x.zip

This should create a docker image called 'roborio:x_x', and it will also tag
the image as roborio:latest.

Additionally, it will build an image 'roborio-build:latest' which will be a
roborio image that contains various essential build tools if you need to build
various pieces of software.

Running an SSH build server
---------------------------

The 'start_buildserver.sh' script can be used to start a docker image that can
be used in conjunction with the build scripts in roborio-packages. It spawns
an SSH server that listens on port 2222. Some magic is done to:

* Switch the processor into 32-bit mode via `setarch`
* Use LD_PRELOAD to install a uname hook that reports the host being 'armv7l'

To ssh into this docker image, you'll want to add something like this to your
~/.ssh/config 

    Host roborio-docker
      User root
      Hostname xx.xx.xx.xx
      Port 2222

Why does this exist?
--------------------

For historical reasons, the roborio-packages repository primarily relies on
compiling packages on the RoboRIO. For awhile I was using the roborio-vm to
build packages, but it takes a very long time to build complex packages such
as NumPy or SciPy. Building on real ARM hardware is a lot faster.
