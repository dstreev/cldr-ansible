#!/usr/bin/env bash

# Start / Initialize Cluster

cd `dirname $0`

while [ $# -gt 0 ]; do
  case "$1" in
    --instance)
      shift
      export ENV_INSTANCE=$1
      shift
      ;;
    -i)
      shift
      export ENV_INSTANCE=$1
      shift
      ;;
    *)
      break
      ;;
  esac
done

if [ "${ENV_INSTANCE}x" == "x" ]; then
  echo "Missing Instance setting (-i 01|02|..)."
  exit -1
fi

# Cycle through the Container on each host looking for an ENV_INSTANCE
# match, then pause the container.

# Paused
# 30575e83d2fd        dstreev/centos7_sshd:105   "/usr/bin/supervisor…"   5 hours ago         Up 5 hours (Paused)   0.0.0.0:22011->22/tcp   hdp11_os15.1.pb2zpx5nl0erk86k176gw33d1
# Loop through docker hosts
for i in 01 02 03 04 05 06 07 10 11 12 13 14 15 16 17 18 19; do
  # Loop through containers the are NOT Pause and are part of the Docker Stack
  echo "Checking Docker host [os${i}] for 'running' containers the are part of Stack 'hdp${ENV_INSTANCE}'"
  for p in `docker -H os${i}:2375 ps | grep hdp${ENV_INSTANCE} | grep -v Paused | awk '{print $1}'`; do
    echo "  ---- Found a running container: ${p}.  'Pausing' container now."
    docker -H os${i}:2375 pause $p
  done
done
