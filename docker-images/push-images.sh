#!/bin/bash

while [ $# -gt 0 ]; do
  case "$1" in
    --tag)
      shift
      export IMAGE_TAG=$1
      shift
      ;;
    -t)
      shift
      export IMAGE_TAG=$1
      shift
      ;;
    *)
      break
      ;;
  esac
done

if [ "${IMAGE_TAG}x" == "x" ]; then
  echo "Missing tag setting."
  exit -1
fi

docker push dstreev/centos7_sshd:${IMAGE_TAG}
