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

cd `dirname $0`

sed "s/ENV_INSTANCE/${ENV_INSTANCE}/g" ../environment/hosts/host-template.yaml > ../environment/hosts/${ENV_INSTANCE}.yaml
sed -i.bak "s/AMBARI_VERSION/${AMBARI_VERSION}/g" ../environment/hosts/${ENV_INSTANCE}.yaml
sed -i.bak "s/IMAGE_VERSION/${IMAGE_VERSION}/g" ../environment/hosts/${ENV_INSTANCE}.yaml
