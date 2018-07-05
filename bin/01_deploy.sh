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

cd `dirname $0`

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

# Infra is setup separately now.  Using a single repo and db across all environments to conserve resources.
echo "Check to see if the INFRA Stack is running"
INFRA_STACK=`docker -H os01:2375 stack ls | grep ^INFRA`
if [ "${INFRA_STACK}x" == "x" ]; then
  echo "You need to setup the INFRA stack first."
  exit -1
fi

# Check to see if the STACK has been deployed already.  If it has, don't deploy
# it again.
echo "Checking if Stack ${DOCKER_STACK} has already been deployed"
STACK_CHECK=`docker -H os01:2375 stack ls | grep ^hdp12`
if [ "${STACK_CHECK}x" == "x" ]; then
  echo "Deploy Docker Stack ${DOCKER_STACK} with compose file (${ENV_SET})"
  docker -H os01:2375 stack deploy --compose-file ../hdp/setup/stack-compose/${ENV_SET}.yaml ${DOCKER_STACK}


  echo "Build the Host File for instance: ${ENV_INSTANCE}"
  ./build-host-yaml.sh -i ${ENV_INSTANCE} -a ${AMBARI_VERSION} -v ${IMAGE_TAG} -e ${ENV_SET}

  echo "Pause for 15 seconds while the docker services start"
  sleep 15

  # echo "OS Prep"
  # ansible-playbook -i ../environment/hosts/${ENV_INSTANCE}.yaml --extra-vars "@../environment/vars/ambari_${AMBARI_VERSION}.json" -e env_state=started ../hdp/setup/hdp_os_prep.yaml
  echo "Edge Node Config"
  ansible-playbook -i ../environment/hosts/${ENV_INSTANCE}.yaml --extra-vars "@../environment/vars/ambari_${AMBARI_VERSION}.json" -e env_state=started ../hdp/setup/edge_node_config.yaml
  echo "Ambari Install Playbook"
  ansible-playbook -i ../environment/hosts/${ENV_INSTANCE}.yaml --extra-vars "@../environment/vars/ambari_${AMBARI_VERSION}.json" -e env_state=started ../hdp/ambari/ambari_install.yaml

  # Populate Deployment readme.md
  ansible-playbook -e ENV_INSTANCE=${ENV_INSTANCE} -e ENV_SET=${ENV_SET} -e AMBARI_VERSION=${AMBARI_VERSION} -e HDP_STACK_VERSION=${HDP_STACK_VERSION} --tags "add" config-dictionary.yaml

else
  echo "Stack ${DOCKER_STACK} already exists."
fi
#ansible-playbook -i ../environment/hosts/${ENV_INSTANCE}.yaml ../infrastructure/ping.yaml --tags "${ENV_SET}"
