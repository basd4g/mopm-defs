#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR

echo "docker build"
docker build -t mopm-defs-ubuntu:latest .

find definitions -type f | while read testing_path
do
 ./test.sh $testing_path --without-docker-build
done
