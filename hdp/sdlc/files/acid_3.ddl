use acid_${HIVE_USER};

drop table if exists raw_3_dataset;
drop table if exists acid_3_ymd_dataset;
drop table if exists acid_3_ym_dataset;

create external table if not exists raw_3_dataset (
  event_load_time STRING,
  filename STRING,
  id STRING,
  status STRING,
  status_comment STRING,
  event_real_start STRING,
  event_real_stop STRING,
  event_planned_start STRING,
  event_planned_stop STRING,
  total_event_duration STRING,
  event_comment STRING,
  cell_id STRING,
  cell_site STRING,
  cell_node STRING,
  equipment_name STRING,
  cell_terminate STRING,
  terminate_start STRING,
  terminate_stop STRING,
  terminate_duration STRING,
  terminate_state STRING,
  i01 STRING,
  i02 STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES
(
  "separatorChar" = ",",
  "quoteChar" = '"'   ,
  "escapeChar" = "\\"
)
STORED AS TEXTFILE
LOCATION '${OUTPUT_DIR}';

create table if not exists acid_3_ymd_dataset (
  event_load_time TIMESTAMP,
  filename STRING,
  id BIGINT,
  status STRING,
  status_comment STRING,
  event_real_start TIMESTAMP,
  event_real_stop TIMESTAMP,
  event_planned_start TIMESTAMP,
  event_planned_stop TIMESTAMP,
  total_event_duration BIGINT,
  event_comment STRING,
  cell_id BIGINT,
  cell_site STRING,
  cell_node STRING,
  equipment_name STRING,
  cell_terminate STRING,
  terminate_start DATE,
  terminate_stop DATE,
  terminate_duration BIGINT,
  terminate_state STRING,
  i01 STRING,
  i02 STRING
)
PARTITIONED BY (year int,month int, day int)
CLUSTERED BY (cell_id) INTO 2 BUCKETS
STORED AS ORC
TBLPROPERTIES("transactional"="true",
"compactorthreshold.hive.compactor.delta.num.threshold"="2",
"compactorthreshold.hive.compactor.delta.pct.threshold"="0.2");

create table if not exists acid_3_ym_dataset (
  event_load_time TIMESTAMP,
  filename STRING,
  id BIGINT,
  status STRING,
  status_comment STRING,
  event_real_start TIMESTAMP,
  event_real_stop TIMESTAMP,
  event_planned_start TIMESTAMP,
  event_planned_stop TIMESTAMP,
  total_event_duration BIGINT,
  event_comment STRING,
  cell_id BIGINT,
  cell_site STRING,
  cell_node STRING,
  equipment_name STRING,
  cell_terminate STRING,
  terminate_start DATE,
  terminate_stop DATE,
  terminate_duration BIGINT,
  terminate_state STRING,
  i01 STRING,
  i02 STRING
)
PARTITIONED BY (year int, month int)
CLUSTERED BY (cell_id) INTO 2 BUCKETS
STORED AS ORC
TBLPROPERTIES("transactional"="true",
"compactorthreshold.hive.compactor.delta.num.threshold"="2",
"compactorthreshold.hive.compactor.delta.pct.threshold"="0.2");
