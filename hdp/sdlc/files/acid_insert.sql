use acid_${HIVE_USER};

FROM raw_dataset
INSERT INTO acid_dataset
SELECT *
INSERT INTO append_dataset
SELECT *;
