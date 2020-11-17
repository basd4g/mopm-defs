#!/bin/bash
echo -n 'name: ' 1>&2
read NAME
echo -n 'url : https://' 1>&2
read URL
echo -n 'desc: ' 1>&2
read DESCRIPTION
cat << EOS > definitions/${NAME}.yaml
name: ${NAME}
url: https://${URL}
description: ${DESCRIPTION}
environments:
  - architecture: amd64
    platform: darwin
    dependencies:
      - brew
    verification: "which ${NAME}"
    privilege: false
    script: |
      brew install ${NAME}
  - architecture: amd64
    platform: linux/ubuntu
    dependencies:
      - apt
    verification: "which ${NAME}"
    privilege: true
    script: |
      apt install -y ${NAME}
EOS
