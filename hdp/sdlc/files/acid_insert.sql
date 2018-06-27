USE acid_${HIVE_USER};


FROM raw_dataset
INSERT INTO acid_dataset
SELECT *
INSERT INTO append_dataset
SELECT *;

-- Build Merge Statement

MERGE INTO merge_dataset AS T
USING raw_dataset AS S
ON T.event_time = S.event_time
AND T.source_ip = S.source_ip
WHEN NOT MATCHED THEN
INSERT VALUES
  (S.event_time,
    S.source_code,
    S.source_ip,
    S.direction,
    S.target_ip,
    S.offset,
    S.contract,
    S.amount_due,
    S.past_due,
    S.interest);
