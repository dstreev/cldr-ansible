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

DATAGEN_JAR=${HOME}/datagen/mr-data-utility.jar

# Clean up old dataset.
hdfs dfs -rm -r -f -skipTrash ${OUTPUT_DIR}
hdfs dfs -mkdir /user/${USER}/datagen
hdfs dfs -put -f ${CONFIG} /user/${USER}/datagen/${CONFIG}

# Run the Data generator
hadoop jar ${DATAGEN_JAR} com.streever.iot.mapreduce.data.utility.DataGenTool -cfg /user/${USER}/datagen/${CONFIG} -c ${COUNT} -d ${OUTPUT_DIR} -m ${MAPPERS}
