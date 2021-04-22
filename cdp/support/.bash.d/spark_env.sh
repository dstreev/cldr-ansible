# export HS2_JDBC_URL="jdbc:hive2://..."
# export HS2_JDBC_URL_PRINCIPAL="hive/_HOST@xxx.LOCAL"

# Expecting to have a standard link for the needed spark libs.
# This is done per CDP deployment since it's not a part of the deployment package
alias spark-shell-hwc-dr='spark-shell --jars /opt/cloudera/parcels/CDH/lib/hive_warehouse_connector/hive-warehouse-connector-assembly.jar \
--conf spark.datasource.hive.warehouse.read.mode=DIRECT_READER_V1 \
--conf spark.sql.extensions="com.hortonworks.spark.sql.rule.Extensions" \
--conf spark.kryo.registrator=com.qubole.spark.hiveacid.util.HiveAcidKyroRegistrator \
--conf spark.datasource.hive.warehouse.load.staging.dir=/tmp/spark-staging \
--conf spark.sql.hive.hiveserver2.jdbc.url.principal=$HS2_JDBC_URL_PRINCIPAL \
--conf spark.sql.hive.hiveserver2.jdbc.url="$HS2_JDBC_URL"'
alias spark-submit-hwc-dr='spark-submit --jars /opt/cloudera/parcels/CDH/lib/hive_warehouse_connector/hive-warehouse-connector-assembly.jar \
--conf spark.datasource.hive.warehouse.read.mode=DIRECT_READER_V1 \
--conf spark.sql.extensions="com.hortonworks.spark.sql.rule.Extensions" \
--conf spark.kryo.registrator=com.qubole.spark.hiveacid.util.HiveAcidKyroRegistrator \
--conf spark.datasource.hive.warehouse.load.staging.dir=/tmp/spark-staging \
--conf spark.sql.hive.hiveserver2.jdbc.url.principal=$HS2_JDBC_URL_PRINCIPAL \
--conf spark.sql.hive.hiveserver2.jdbc.url="$HS2_JDBC_URL"'
alias pyspark-hwc-dr='pyspark --jars /opt/cloudera/parcels/CDH/lib/hive_warehouse_connector/hive-warehouse-connector-assembly.jar \
--conf spark.datasource.hive.warehouse.read.mode=DIRECT_READER_V1 \
--conf spark.sql.extensions="com.hortonworks.spark.sql.rule.Extensions" \
--conf spark.kryo.registrator=com.qubole.spark.hiveacid.util.HiveAcidKyroRegistrator \
--conf spark.datasource.hive.warehouse.load.staging.dir=/tmp/spark-staging \
--conf spark.sql.hive.hiveserver2.jdbc.url.principal=$HS2_JDBC_URL_PRINCIPAL \
--conf spark.sql.hive.hiveserver2.jdbc.url="$HS2_JDBC_URL" \
--py-files /opt/cloudera/parcels/CDH/lib/hive_warehouse_connector/hwc_pyspark.zip'
alias spark-shell-hwc-cluster='spark-shell --jars /opt/cloudera/parcels/CDH/lib/hive_warehouse_connector/hive-warehouse-connector-assembly.jar \
--master yarn \
--conf spark.datasource.hive.warehouse.read.mode=JDBC_CLUSTER \
--conf spark.security.credentials.hiveserver2.enabled=true \
--conf spark.sql.extensions="com.hortonworks.spark.sql.rule.Extensions" \
--conf spark.kryo.registrator=com.qubole.spark.hiveacid.util.HiveAcidKyroRegistrator \
--conf spark.datasource.hive.warehouse.load.staging.dir=/tmp/spark-staging \
--conf spark.sql.hive.hiveserver2.jdbc.url.principal=$HS2_JDBC_URL_PRINCIPAL \
--conf spark.sql.hive.hiveserver2.jdbc.url="$HS2_JDBC_URL"'
alias spark-submit-hwc-cluster='spark-submit --jars /opt/cloudera/parcels/CDH/lib/hive_warehouse_connector/hive-warehouse-connector-assembly.jar \
--master yarn \
--conf spark.datasource.hive.warehouse.read.mode=JDBC_CLUSTER \
--conf spark.security.credentials.hiveserver2.enabled=true \
--conf spark.sql.extensions="com.hortonworks.spark.sql.rule.Extensions" \
--conf spark.kryo.registrator=com.qubole.spark.hiveacid.util.HiveAcidKyroRegistrator \
--conf spark.datasource.hive.warehouse.load.staging.dir=/tmp/spark-staging \
--conf spark.sql.hive.hiveserver2.jdbc.url.principal=$HS2_JDBC_URL_PRINCIPAL \
--conf spark.sql.hive.hiveserver2.jdbc.url="$HS2_JDBC_URL"'
alias pyspark-hwc-cluster='pyspark --jars /opt/cloudera/parcels/CDH/lib/hive_warehouse_connector/hive-warehouse-connector-assembly.jar \
--master yarn \
--conf spark.datasource.hive.warehouse.read.mode=JDBC_CLUSTER \
--conf spark.security.credentials.hiveserver2.enabled=true \
--conf spark.sql.extensions="com.hortonworks.spark.sql.rule.Extensions" \
--conf spark.kryo.registrator=com.qubole.spark.hiveacid.util.HiveAcidKyroRegistrator \
--conf spark.datasource.hive.warehouse.load.staging.dir=/tmp/spark-staging \
--conf spark.sql.hive.hiveserver2.jdbc.url.principal=$HS2_JDBC_URL_PRINCIPAL \
--conf spark.sql.hive.hiveserver2.jdbc.url="$HS2_JDBC_URL" \
--py-files /opt/cloudera/parcels/CDH/lib/hive_warehouse_connector/hwc_pyspark.zip'
alias spark-shell-hwc-client='spark-shell --jars /opt/cloudera/parcels/CDH/lib/hive_warehouse_connector/hive-warehouse-connector-assembly.jar \
--master yarn \
--conf spark.datasource.hive.warehouse.read.mode=JDBC_CLIENT \
--conf spark.security.credentials.hiveserver2.enabled=true \
--conf spark.sql.extensions="com.hortonworks.spark.sql.rule.Extensions" \
--conf spark.kryo.registrator=com.qubole.spark.hiveacid.util.HiveAcidKyroRegistrator \
--conf spark.datasource.hive.warehouse.load.staging.dir=/tmp/spark-staging \
--conf spark.sql.hive.hiveserver2.jdbc.url="$HS2_JDBC_URL;principal=$HS2_JDBC_URL_PRINCIPAL"'
alias spark-submit-hwc-client='spark-submit --jars /opt/cloudera/parcels/CDH/lib/hive_warehouse_connector/hive-warehouse-connector-assembly.jar \
--master yarn \
--conf spark.datasource.hive.warehouse.read.mode=JDBC_CLIENT \
--conf spark.security.credentials.hiveserver2.enabled=false \
--conf spark.sql.extensions="com.hortonworks.spark.sql.rule.Extensions" \
--conf spark.kryo.registrator=com.qubole.spark.hiveacid.util.HiveAcidKyroRegistrator \
--conf spark.datasource.hive.warehouse.load.staging.dir=/tmp/spark-staging \
--conf spark.sql.hive.hiveserver2.jdbc.url.principal=$HS2_JDBC_URL_PRINCIPAL \
--conf spark.sql.hive.hiveserver2.jdbc.url="$HS2_JDBC_URL"'
alias pyspark-hwc-client='pyspark --jars /opt/cloudera/parcels/CDH/lib/hive_warehouse_connector/hive-warehouse-connector-assembly.jar \
--master yarn \
--conf spark.datasource.hive.warehouse.read.mode=JDBC_CLIENT \
--conf spark.security.credentials.hiveserver2.enabled=false \
--conf spark.sql.extensions="com.hortonworks.spark.sql.rule.Extensions" \
--conf spark.kryo.registrator=com.qubole.spark.hiveacid.util.HiveAcidKyroRegistrator \
--conf spark.datasource.hive.warehouse.load.staging.dir=/tmp/spark-staging \
--conf spark.sql.hive.hiveserver2.jdbc.url.principal=$HS2_JDBC_URL_PRINCIPAL \
--conf spark.sql.hive.hiveserver2.jdbc.url="$HS2_JDBC_URL" \
--py-files /opt/cloudera/parcels/CDH/lib/hive_warehouse_connector/hwc_pyspark.zip'
