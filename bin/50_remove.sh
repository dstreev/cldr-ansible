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

if [ -f "../config/${ENV_INSTANCE}.cfg" ]; then
  . ../config/${ENV_INSTANCE}.cfg
else
  echo "You need to create a config file for ${ENV_INSTANCE}"
  exit -1
fi

export DOCKER_STACK=hdp${ENV_INSTANCE}
export ENV_INSTANCE=${ENV_INSTANCE}
export IMAGE_TAG=${IMAGE_TAG}
echo "Environment: "
echo "     ENV_INSTANCE   : ${ENV_INSTANCE}"
echo "     DOCKER_STACK   : ${DOCKER_STACK}"
echo "     ENV_SET        : ${ENV_SET}"
echo "     AMBARI_VERSION : ${AMBARI_VERSION}"
echo "     IMAGE_TAG      : ${IMAGE_TAG}"
echo "     BLUEPRINT      : ${BLUUEPRINT}"
echo "     AMBARI_VERSION : ${AMBARI_VERSION}"

echo "     BLUEPRINT             : ${BLUEPRINT}"
echo "     AMBARI_ADMIN_USER     : ${AMBARI_ADMIN_USER}"
echo "     AMBARI_ADMIN_PASSWORD : ${AMBARI_ADMIN_PASSWORD}"
echo "     HDP_STACK             : ${HDP_STACK}"
echo "     HDP_STACK_VERSION     : ${HDP_STACK_VERSION}"
echo "     HDP_REPO_ID           : ${HDP_REPO_ID}"
echo "     OS_TYPE               : ${OS_TYPE}"

echo "     HDP_REPO_ID        : ${HDP_REPO_ID}"
echo "     HDP_REPO_URL       : ${HDP_REPO_URL}"
echo "     HDP_UTILS_REPO_ID   : ${HDP_UTILS_REPO_ID}"
echo "     HDP_UTILS_REPO_URL  : ${HDP_UTILS_REPO_URL}"
echo "     HDP_GPL_REPO_ID    : ${HDP_GPL_REPO_ID}"
echo "     HDP_GPL_REPO_URL   : ${HDP_GPL_REPO_URL}"

cd `dirname $0`

echo "Checking if Stack ${DOCKER_STACK} has been deployed"
STACK_CHECK=`docker -H os01:2375 stack ls | grep ^hdp12`
if [ "${STACK_CHECK}x" != "x" ]; then
  echo "Remove Docker Stack ${DOCKER_STACK}"
  docker -H os01:2375 stack rm ${DOCKER_STACK}

  # Remove from config list
  # Populate Deployment readme.md
  ansible-playbook -e ENV_INSTANCE=${ENV_INSTANCE} -e ENV_SET=${ENV_SET} -e AMBARI_VERSION=${AMBARI_VERSION} -e HDP_STACK_VERSION=${HDP_STACK_VERSION} --tags "remove" ../config/config-dictionary.yaml

  # Remove the host yaml for the docker stack.
  rm -r -f ../environment/hosts/${ENV_INSTANCE}.yam*

else
  echo "Stack ${DOCKER_STACK} doesn't exist."
fi
