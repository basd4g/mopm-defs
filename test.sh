#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR

echo "docker build"
docker build -t mopm-defs-ubuntu:latest .

installing_package() {
  if docker run mopm-defs-ubuntu:latest "$1" 1>&2; then
    echo "true"
  else
    echo "false"
  fi
}

env_id="$(mopm environment)"
echo "environment:  ${env_id}"

passed_path="test-passed/${env_id}"
passed_tmp_path="/tmp/passed-file"

rm -f $passed_tmp_path
touch $passed_tmp_path
touch $passed_path

find definitions -type f | xargs sha1sum | while read testing_sha1 testing_path
do
  testing_pkg="$(echo ${testing_path} | sed -r 's/^definitions\/(.+)\.yaml$/\1/')"

  if grep --quiet "${testing_sha1} ${testing_path}" "$passed_path"; then
    echo "skip:  $testing_pkg"
    echo "${testing_sha1} ${testing_path}" >> "$passed_tmp_path"
  elif [ "$(installing_package $testing_pkg)" = "true" ]; then
    echo "success:  $testing_pkg"
    echo "${testing_sha1} ${testing_path}" >> "$passed_tmp_path"
  else
    echo "failed:  $testing_pkg"
  fi
done

rm $passed_path
mv $passed_tmp_path $passed_path
