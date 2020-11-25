#!/bin/bash

env_os="$1"
if [ "$1" != "ubuntu" ] && [ "$1" != "darwin" ]; then
  echo "Usage: $0 [ubuntu |darwin]" 1>&2
  exit 1
fi

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR

echo "docker build"
./docker.sh build "$env_os"

find definitions -type f | while read testing_path
do
 ./test.sh "$env_os" "$testing_path" --without-docker-build
done
