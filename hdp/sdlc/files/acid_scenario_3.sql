USE acid_${HIVE_USER};


FROM raw_3_dataset
INSERT INTO acid_3_ymd_dataset PARTITION (YEAR,
                                          MONTH,
                                          DAY)
SELECT event_load_time,
       filename,
       id,
       status,
       status_comment,
       event_real_start,
       event_real_stop,
       event_planned_start,
       event_planned_stop,
       total_event_duration,
       event_comment,
       cell_id,
       cell_site,
       cell_node,
       equipment_name,
       cell_terminate,
       terminate_start,
       terminate_stop,
       terminate_duration,
       terminate_state,
       i01,
       i02,
       year(event_load_time),
       month(event_load_time),
       day(event_load_time);

-- Collapse the 'over partition' dataset into another table.
-- From Y-M-D to Y-M (30:1 reduction)

FROM acid_3_ymd_dataset
INSERT INTO acid_3_ym_dataset PARTITION (YEAR,
                                          MONTH)
SELECT event_load_time,
       filename,
       id,
       status,
       status_comment,
       event_real_start,
       event_real_stop,
       event_planned_start,
       event_planned_stop,
       total_event_duration,
       event_comment,
       cell_id,
       cell_site,
       cell_node,
       equipment_name,
       cell_terminate,
       terminate_start,
       terminate_stop,
       terminate_duration,
       terminate_state,
       i01,
       i02,
       `year`,
       `month`;
