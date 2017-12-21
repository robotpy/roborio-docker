#!/bin/bash -e

ROBORIO_ZIP=$1
if [ "$ROBORIO_ZIP" == "" ]; then
    echo "Usage: $0 roborio_image"
    exit 1
fi

ROBORIO_ZIP_BASE=$(basename $ROBORIO_ZIP)

# Extract the year/version from it
# -> Assuming format of FRC_roboRIO_2018_v16.zip

if [ "${ROBORIO_ZIP_BASE:0:12}" != "FRC_roboRIO_" ]; then
    echo "Error: Expected RIO_IMAGE to begin with 'FRC_roboRIO_'"
    exit 1
fi

VERSION="${ROBORIO_ZIP_BASE:12:-4}"

function rm_unpacked {
    [ ! -d unpacked ] || rm -rf unpacked
}

trap rm_unpacked EXIT

rm_unpacked

# only build the base image if needed
if [[ "$(docker images -q roborio:$VERSION 2> /dev/null)" == "" ]]; then
  # Unpack the roborio image zipfile, ensure we're sane
  mkdir unpacked

  unzip "$ROBORIO_ZIP" -d unpacked
  # there are two files in there, one is a zip file, unzip the zip file
  mkdir unpacked/more
  unzip unpacked/*.zip -d unpacked/more

  # Make sure the file we're looking for is there
  if [ ! -f unpacked/more/systemimage.tar.gz ]; then
    echo "Error: Expected to find systemimage.tar.gz, did not find it!"
    exit 1
  fi

  # Create a docker image from it
  echo "Importing..."
  docker import unpacked/more/systemimage.tar.gz roborio:tmp
  rm_unpacked
  
  docker build -f Dockerfile.base -t roborio:${VERSION} .
  docker rmi roborio:tmp

  docker tag roborio:${VERSION} roborio:latest
fi

# Build the build image too
[ -f libfakearmv7l.so ] || wget https://github.com/robotpy/fakearmv7l/releases/download/v1/libfakearmv7l.so

docker build -f Dockerfile.build . -t roborio-build:${VERSION}
docker tag roborio-build:${VERSION} roborio-build:latest

