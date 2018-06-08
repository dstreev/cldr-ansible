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
    --hdp_version)
      shift
      export HDP_VERSION=$1
      shift
      ;;
    -h)
      shift
      export HDP_VERSION=$1
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
if [ "${HDP_VERSION}x" == "x" ]; then
  echo "Missing HDP Version"
  exit -1
fi

if [ ! -f ../environment/vars/hdp_${HDP_VERSION}.json ]; then
  echo "Could locate HDP Version Var File"
  exit -1
fi

cd `dirname $0`

# Infra is setup separately now.  Using a single repo and db across all environments to conserve resources.
#ansible-playbook -e env_instance=${ENV_INSTANCE} -e env_state=started ../infrastructure/infra.yaml
ansible-playbook -e env_instance=${ENV_INSTANCE} -e env_state=started ../environment/hdp.yaml

./build-host-yaml.sh -i ${ENV_INSTANCE}

ansible-playbook -i `pwd`/../environment/hosts/${ENV_INSTANCE}.yaml --extra-vars "@../environment/vars/hdp_${HDP_VERSION}.json" -e env_state=started ../hdp/setup/hdp_os_prep.yaml
ansible-playbook -i `pwd`/../environment/hosts/${ENV_INSTANCE}.yaml --extra-vars "@../environment/vars/hdp_${HDP_VERSION}.json" -e env_state=started ../hdp/setup/edge_node_config.yaml

ansible-playbook -i `pwd`/../environment/hosts/${ENV_INSTANCE}.yaml --extra-vars "@../environment/vars/hdp_${HDP_VERSION}.json" -e env_state=started ../hdp/ambari/ambari_install.yaml
