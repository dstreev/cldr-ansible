#!/usr/bin/env bash

cd `dirname $0`

while [ $# -gt 0 ]; do
  case "$1" in
    --config)
      shift
      export CONFIG=$1
      shift
      ;;
    -cfg)
      shift
      export CONFIG=$1
      shift
      ;;
    --output_dir)
      shift
      export OUTPUT_DIR=$1
      shift
      ;;
    -o)
      shift
      export OUTPUT_DIR=$1
      shift
      ;;
    --mappers)
      shift
      export MAPPERS=$1
      shift
      ;;
    -m)
      shift
      export MAPPERS=$1
      shift
      ;;
    --count)
      shift
      export COUNT=$1
      shift
      ;;
    -c)
      shift
      export COUNT=$1
      shift
      ;;
    --iterations)
      shift
      export ITERATIONS=$1
      shift
      ;;
    -i)
      shift
      export ITERATIONS=$1
      shift
      ;;
    --hive_user)
      shift
      export HIVE_USER=$1
      shift
      ;;
    --hive_user_pw)
      shift
      export HIVE_USER_PW=$1
      shift
      ;;
    --hive_connect_url)
      shift
      export HIVE_URL=$1
      shift
      ;;
    --set)
      shift
      export SET=$1
      shift
      ;;
    -s)
      shift
      export SET=$1
      shift
      ;;
    --part)
      shift
      export PART=$1
      shift
      ;;
    -p)
      shift
      export PART=$1
      shift
      ;;
    *)
      break
      ;;
  esac
done
# Add pause to allow a chance for HS2 to register new hive permissions for user.
sleep 15s

# Delete Gen Output directory.
hdfs dfs -rm -r -f -skipTrash ${OUTPUT_DIR}

hdfs dfs -mkdir -p ${OUTPUT_DIR}/../archive_${SET}
# Create Database.
# /usr/bin/beeline -u "${HIVE_URL}" -n ${HIVE_USER} -p ${HIVE_USER_PW} -e 'CREATE DATABASE IF NOT EXISTS acid_${HIVE_USER}'
/usr/bin/beeline -u "${HIVE_URL}" -n hive -p ${HIVE_USER_PW} --hivevar HIVE_USER=${HIVE_USER} -e 'CREATE DATABASE IF NOT EXISTS acid_${HIVE_USER}'

# Run DDL to gen tables for effort.
/usr/bin/beeline -u "${HIVE_URL}" -n ${HIVE_USER} -p ${HIVE_USER_PW} --hivevar HIVE_USER=${HIVE_USER} --hivevar OUTPUT_DIR=${OUTPUT_DIR} -f acid_${SET}.ddl
