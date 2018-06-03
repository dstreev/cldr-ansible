# Start / Initialize Cluster

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
  echo "Missing Instance setting."
  exit -1
fi

cd `dirname $0`

ansible-playbook -e env_instance=${ENV_INSTANCE} -e env_state=stopped ../infrastructure/infra.yaml
ansible-playbook -e env_instance=${ENV_INSTANCE} -e env_state=stopped hdp.yaml
