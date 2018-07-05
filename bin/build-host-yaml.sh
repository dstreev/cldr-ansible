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

sed "s/ENV_INSTANCE/${ENV_INSTANCE}/g" ../environment/hosts/host-template_${ENV_SET}.yaml > ../environment/hosts/${ENV_INSTANCE}.yaml
sed -i.bak "s/AMBARI_VERSION/${AMBARI_VERSION}/g" ../environment/hosts/${ENV_INSTANCE}.yaml
sed -i.bak "s/IMAGE_TAG/${IMAGE_TAG}/g" ../environment/hosts/${ENV_INSTANCE}.yaml
# sed -i.bak "s/HOME_DIR/${HOME_DIR}/g" ../environment/hosts/${ENV_INSTANCE}.yaml

sed -i.bak "s/BLUEPRINT/${BLUEPRINT}/g" ../environment/hosts/${ENV_INSTANCE}.yaml
sed -i.bak "s/AMBARI_ADMIN_USER/${AMBARI_ADMIN_USER}/g" ../environment/hosts/${ENV_INSTANCE}.yaml
sed -i.bak "s/AMBARI_ADMIN_PASSWORD/${AMBARI_ADMIN_PASSWORD}/g" ../environment/hosts/${ENV_INSTANCE}.yaml
sed -i.bak "s/HDP_STACK_VERSION/${HDP_STACK_VERSION}/g" ../environment/hosts/${ENV_INSTANCE}.yaml
sed -i.bak "s/HDP_STACK/${HDP_STACK}/g" ../environment/hosts/${ENV_INSTANCE}.yaml
sed -i.bak "s/HDP_REPO_ID/${HDP_REPO_ID}/g" ../environment/hosts/${ENV_INSTANCE}.yaml
sed -i.bak "s/OS_TYPE/${OS_TYPE}/g" ../environment/hosts/${ENV_INSTANCE}.yaml
sed -i.bak "s/HDP_REPO_URL/${HDP_REPO_URL}/g" ../environment/hosts/${ENV_INSTANCE}.yaml
sed -i.bak "s/HDP_REPO_ID/${HDP_REPO_ID}/g" ../environment/hosts/${ENV_INSTANCE}.yaml
sed -i.bak "s/HDP_UTILS_REPO_URL/${HDP_UTILS_REPO_URL}/g" ../environment/hosts/${ENV_INSTANCE}.yaml
sed -i.bak "s/HDP_UTILS_REPO_ID/${HDP_UTILS_REPO_ID}/g" ../environment/hosts/${ENV_INSTANCE}.yaml
sed -i.bak "s/HDP_GPL_REPO_URL/${HDP_GPL_REPO_URL}/g" ../environment/hosts/${ENV_INSTANCE}.yaml
sed -i.bak "s/HDP_GPL_REPO_ID/${HDP_GPL_REPO_ID}/g" ../environment/hosts/${ENV_INSTANCE}.yaml
