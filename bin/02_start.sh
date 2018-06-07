# Start / Initialize Cluster

cd `dirname$@`

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
    # --hdp_version)
    #   shift
    #   export HDP_VERSION=$1
    #   shift
    #   ;;
    # -h)
    #   shift
    #   export HDP_VERSION=$1
    #   shift
    #   ;;
    *)
      break
      ;;
  esac
done

if [ "${ENV_INSTANCE}x" == "x" ]; then
  echo "Missing Instance setting."
  exit -1
fi
# if [ "${HDP_VERSION}x" == "x" ]; then
#   echo "Missing HDP Version"
#   exit -1
# fi

# if [ ! -f vars/hdp_${HDP_VERSION}.json ]; then
#   echo "Could locate HDP Version Var File"
#   exit -1
# fi

cd `dirname $0`
# ansible-playbook ../infrastructure/core-kill.yaml
# ansible-playbook ../infrastructure/core-init.yaml

ansible-playbook -e env_instance=${ENV_INSTANCE} -e env_state=started ../infrastructure/infra.yaml
ansible-playbook -e env_instance=${ENV_INSTANCE} -e env_state=started ../environment/hdp.yaml

ansible-playbook -i `pwd`/hosts/${ENV_INSTANCE}.yaml ../hdp/ambari/ambari_start.yaml
