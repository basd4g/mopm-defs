#!/bin/bash

# Check to try install yaml file, and memo succeeded package file and its sha1sum
if [ "$1" = "ubuntu" ]; then
  env_os='ubuntu'
  env_id='amd64@linux#ubuntu'
elif [ "$1" = "darwin" ]; then
  env_os='darwin'
  env_id='amd64@darwin'
else
  echo "Usage: $0 [ubuntu | darwin] PACKAGE_PATH (--without-docker-build)"
  exit 1
fi

installing_package() {
  if ./docker.sh run "$env_os" "$1" 1>&2; then
    echo "true"
  else
    echo "false"
  fi
}

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR

if [ "$3" != "--without-docker-build" ]; then
  echo "docker build"
  ./docker.sh build "$env_os"
fi

passed_path="test-passed/${env_id}"
touch $passed_path

testing_path="$2"
testing_sha1="$(sha1sum $testing_path | awk '{print $1}')"
echo $testing_sha1
testing_pkg="$(echo ${testing_path} | sed -r 's/^definitions\/(.+)\.yaml$/\1/')"

if grep --quiet "${testing_sha1} ${testing_path}" "$passed_path"; then
  echo "MOPM-DEFS_TEST: skip:  $testing_pkg"
  exit 0
fi

sed  --in-place --expression="/definitions\/$testing_pkg\.yaml$/d" "$passed_path"

if [ "$(installing_package $testing_pkg)" = "true" ]; then
  echo "MOPM-DEFS_TEST: success:  $testing_pkg"
  echo "${testing_sha1} ${testing_path}" >> "$passed_path"
else
  echo "MOPM-DEFS_TEST: failed:  $testing_pkg"
fi
