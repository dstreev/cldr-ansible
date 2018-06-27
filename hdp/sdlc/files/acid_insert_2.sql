USE acid_${HIVE_USER};


FROM raw_2_dataset
INSERT INTO acid_2_dataset PARTITION (part)
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
       '${PART}'
INSERT INTO append_2_dataset PARTITION (part)
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
       '${PART}';

-- Build Merge Statement

MERGE INTO merge_2_dataset AS T
USING raw_2_dataset AS S ON
T.event_load_time = S.event_load_time
AND T.filename = S.filename
AND T.id = S.id WHEN NOT MATCHED THEN
INSERT
VALUES (S.event_load_time,
        S.filename,
        S.id,
        S.status,
        S.status_comment,
        S.event_real_start,
        S.event_real_stop,
        S.event_planned_start,
        S.event_planned_stop,
        S.total_event_duration,
        S.event_comment,
        S.cell_id,
        S.cell_site,
        S.cell_node,
        S.equipment_name,
        S.cell_terminate,
        S.terminate_start,
        S.terminate_stop,
        S.terminate_duration,
        S.terminate_state,
        S.i01,
        S.i02,
        '${PART}');
