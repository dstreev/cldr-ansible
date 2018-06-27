use acid_${HIVE_USER};

drop table if exists raw_1_dataset;
drop table if exists append_1_dataset;
drop table if exists acid_1_dataset;
drop table if exists merge_1_dataset;

create external table if not exists raw_1_dataset (
  event_time STRING,
  source_code STRING,
  source_ip STRING,
  direction STRING,
  target_ip STRING,
  offset STRING,
  contract STRING,
  amount_due STRING,
  past_due STRING,
  interest STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES
(
  "separatorChar" = ",",
  "quoteChar" = '"'   ,
  "escapeChar" = "\\"
)
STORED AS TEXTFILE
LOCATION "${OUTPUT_DIR}";

create table if not exists append_1_dataset (
  event_time TIMESTAMP,
  source_code BIGINT,
  source_ip STRING,
  direction STRING,
  target_ip STRING,
  offset STRING,
  contract STRING,
  amount_due DOUBLE,
  past_due STRING,
  interest DOUBLE
)
STORED AS ORC;

create table if not exists acid_1_dataset (
  event_time TIMESTAMP,
  source_code BIGINT,
  source_ip STRING,
  direction STRING,
  target_ip STRING,
  offset STRING,
  contract STRING,
  amount_due DOUBLE,
  past_due STRING,
  interest DOUBLE
)
CLUSTERED BY (source_ip) INTO 4 BUCKETS
STORED AS ORC
TBLPROPERTIES("transactional"="true",
"compactorthreshold.hive.compactor.delta.num.threshold"="2",
"compactorthreshold.hive.compactor.delta.pct.threshold"="0.2");

create table if not exists merge_1_dataset (
  event_time TIMESTAMP,
  source_code BIGINT,
  source_ip STRING,
  direction STRING,
  target_ip STRING,
  offset STRING,
  contract STRING,
  amount_due DOUBLE,
  past_due STRING,
  interest DOUBLE
)
CLUSTERED BY (source_ip) INTO 4 BUCKETS
STORED AS ORC
TBLPROPERTIES("transactional"="true",
"compactorthreshold.hive.compactor.delta.num.threshold"="2",
"compactorthreshold.hive.compactor.delta.pct.threshold"="0.2");
