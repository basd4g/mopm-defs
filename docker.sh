#!/bin/bash

# Example: ./docker.sh build ubuntu
# Example: ./docker.sh build darwin
# Example: ./docker.sh run ubuntu nkf
# Example: ./docker.sh run darwin nkf

method="$1"
os="$2"
package="$3"

if [ "$os" = "ubuntu" ]; then
  env_docker_file='Dockerfile.ubuntu'
  env_docker_image='mopm-defs-ubuntu:latest'
elif [ "$os" = "darwin" ]; then
  env_docker_file='Dockerfile.darwin'
  env_docker_image='mopm-defs-darwin:latest'
else
  echo "Usage: $0 [build | run] [ubuntu | darwin] (PACKAGENAME)" 1>&2
  exit 1
fi

if [ "$method" = "build" ]; then
  docker build -t "$env_docker_image" -f "$env_docker_file" .
elif [ "$method" = "run" ]; then
  docker run "$env_docker_image" "$package"
else
  echo "Usage: $0 [build | run] [ubuntu | darwin] (PACKAGENAME)" 1>&2
  exit 1
fi
