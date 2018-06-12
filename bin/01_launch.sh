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
    --ambari_version)
      shift
      export AMBARI_VERSION=$1
      shift
      ;;
    -a)
      shift
      export AMBARI_VERSION=$1
      shift
      ;;
    --image_version)
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

if [ "${ENV_INSTANCE}x" == "x" ]; then
  echo "Missing Instance setting."
  exit -1
fi
if [ "${AMBARI_VERSION}x" == "x" ]; then
  echo "Missing AMBARI Version"
  exit -1
fi
if [ "${IMAGE_VERSION}x" == "x" ]; then
  echo "Missing AMBARI Version"
  exit -1
fi

if [ ! -f ../environment/vars/ambari_${AMBARI_VERSION}.json ]; then
  echo "Could locate Ambari Version Var File"
  exit -1
fi

cd `dirname $0`

# Infra is setup separately now.  Using a single repo and db across all environments to conserve resources.
#ansible-playbook -e env_instance=${ENV_INSTANCE} -e env_state=started ../infrastructure/infra.yaml
ansible-playbook -e env_instance=${ENV_INSTANCE} -e image_version=${IMAGE_VERSION} -e env_state=started ../environment/hdp.yaml

./build-host-yaml.sh -i ${ENV_INSTANCE} -a ${AMBARI_VERSION} -v ${IMAGE_VERSION}

ansible-playbook -i `pwd`/../environment/hosts/${ENV_INSTANCE}.yaml --extra-vars "@../environment/vars/ambari_${AMBARI_VERSION}.json" -e env_state=started ../hdp/setup/hdp_os_prep.yaml
ansible-playbook -i `pwd`/../environment/hosts/${ENV_INSTANCE}.yaml --extra-vars "@../environment/vars/ambari_${AMBARI_VERSION}.json" -e env_state=started ../hdp/setup/edge_node_config.yaml

ansible-playbook -i `pwd`/../environment/hosts/${ENV_INSTANCE}.yaml --extra-vars "@../environment/vars/ambari_${AMBARI_VERSION}.json" -e env_state=started ../hdp/ambari/ambari_install.yaml
