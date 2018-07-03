use acid_dstreev;

select count(*) from acid_dataset;
select count(1) from append_dataset;

select * from acid_dataset limit 100;

ANALYZE TABLE acid_dataset COMPUTE STATISTICS FOR COLUMNS;

SHOW COMPACTIONS;
SHOW LOCKS acid_dataset;
SHOW LOCKS append_dataset;

ALTER TABLE acid_dataset COMPACT 'minor';
