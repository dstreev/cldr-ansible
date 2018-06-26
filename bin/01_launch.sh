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

echo "Environment: "
echo "     ENV_INSTANCE   : ${ENV_INSTANCE}"
echo "     ENV_SET        : ${ENV_SET}"
echo "     AMBARI_VERSION : ${AMBARI_VERSION}"
echo "     IMAGE_TAG      : ${IMAGE_TAG}"
echo "     BLUEPRINT      : ${BLUUEPRINT}"

# Infra is setup separately now.  Using a single repo and db across all environments to conserve resources.
#ansible-playbook -e env_instance=${ENV_INSTANCE} -e env_state=started ../infrastructure/infra.yaml
ansible-playbook -e env_instance=${ENV_INSTANCE} -e env_set=${ENV_SET} -e image_tag=${IMAGE_TAG} -e env_state=started ../environment/hdp.yaml

./build-host-yaml.sh -i ${ENV_INSTANCE} -a ${AMBARI_VERSION} -v ${IMAGE_TAG} -e ${ENV_SET}

ansible-playbook -i ../environment/hosts/${ENV_INSTANCE}.yaml --extra-vars "@../environment/vars/ambari_${AMBARI_VERSION}.json" -e env_state=started ../hdp/setup/hdp_os_prep.yaml
ansible-playbook -i ../environment/hosts/${ENV_INSTANCE}.yaml --extra-vars "@../environment/vars/ambari_${AMBARI_VERSION}.json" -e env_state=started ../hdp/setup/edge_node_config.yaml

ansible-playbook -i ../environment/hosts/${ENV_INSTANCE}.yaml --extra-vars "@../environment/vars/ambari_${AMBARI_VERSION}.json" -e env_state=started ../hdp/ambari/ambari_install.yaml

ansible-playbook -i ../environment/hosts/${ENV_INSTANCE}.yaml ../infrastructure/ping.yaml --tags "${ENV_SET}"
