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
  echo "Missing Instance setting."
  exit -1
fi

cd `dirname $0`

sed "s/ENV_INSTANCE/${ENV_INSTANCE}/g" ../environment/hosts/host-template.yaml > ../environment/hosts/${ENV_INSTANCE}.yaml
