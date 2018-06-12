#!/bin/bash

while [ $# -gt 0 ]; do
  case "$1" in
    --version)
      shift
      export IMAGE_VERSION=$1
      shift
      ;;
    -v)
      shift
      export IMAGE_VERSION=$1
      shift
      ;;
    *)
      break
      ;;
  esac
done

if [ "${IMAGE_VERSION}x" == "x" ]; then
  echo "Missing version setting."
  exit -1
fi

docker push dstreev/centos7_sshd:${IMAGE_VERSION}
