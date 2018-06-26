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
    *)
      break
      ;;
  esac
done

DATAGEN_JAR=${HOME}/hdp_support/mr-data-utility.jar

# Clean up old dataset.
hdfs dfs -rm -rf -skipTrash ${OUTPUT_DIR}

# Run the Data generator
hadoop jar ${DATAGEN_JAR} com.streever.iot.mapreduce.data.utility.DataGenTool -cfg ${CONFIG} -c ${COUNT} -d ${OUTPUT_DIR} -m ${MAPPERS}
