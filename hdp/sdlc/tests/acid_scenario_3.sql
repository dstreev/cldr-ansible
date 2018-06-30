USE acid_${HIVE_USER};


SELECT COUNT(1),
       MIN(S.terminate_start),
       MAX(S.terminate_start)
FROM acid_3_ym_dataset S
WHERE YEAR = 2018
  AND MONTH = 5
  AND terminate_start >= '2018-10-23'
  AND terminate_start <= '2018-10-25';


ALTER TABLE acid_3_ym_dataset PARTITION (YEAR=2018,
                                              MONTH=6) COMPACT 'major';
-- wait for compaction to complete.
SELECT COUNT(1),
       MIN(S.terminate_start),
       MAX(S.terminate_start)
FROM acid_3_ym_dataset S
WHERE YEAR = 2018
  AND MONTH = 6
  AND terminate_start >= '2018-10-23'
  AND terminate_start <= '2018-10-25';

SELECT COUNT(1),
       MIN(S.terminate_start),
       MAX(S.terminate_start)
FROM acid_3_ym_dataset S
WHERE YEAR = 2018
  AND terminate_start >= '2018-10-23'
  AND terminate_start <= '2018-10-25';
