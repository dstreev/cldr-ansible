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
    *)
      break
      ;;
  esac
done

  # Gen Output Data from Generator.
  ./acid_datagen.sh -cfg ${CONFIG} -m ${MAPPERS} -c ${COUNT} -o ${OUTPUT_DIR}

  # Run Append SQL
  /usr/bin/beeline -u "${HIVE_URL}" -n ${HIVE_USER} -p ${HIVE_USER_PW} --hivevar HIVE_USER=${HIVE_USER} --hivevar PART=${PART} -f acid_scenario_${SET}.sql

  # Sweep Source to Archive directory
  hdfs dfs -mv ${OUTPUT_DIR} ${OUTPUT_DIR}/../archive_${SET}/`date +%Y%m%d_%H%M%S`
