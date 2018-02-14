-- Inserts the processed data into backup table
-- Deletes data from raw table 
-- Drops the temp staging table
INSERT INTO backup_gameevents_log
SELECT * FROM tmp_gameevents;

DELETE rcl.* FROM raw_gameevents_log rcl
INNER JOIN tmp_gameevents tcp
	ON rcl.id = tcp.id;

DROP TABLE IF EXISTS tmp_gameevents;

UPDATE rpt_updated
SET last_updated = NOW();