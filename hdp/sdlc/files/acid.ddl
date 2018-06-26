use acid_${HIVE_USER};

drop table if exists raw_dataset;
drop table if exists append_dataset;
drop table if exists acid_dataset;

create external table if not exists raw_dataset (
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

create table if not exists append_dataset (
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

create table if not exists acid_dataset (
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
TBLPROPERTIES("transactional"="true");
