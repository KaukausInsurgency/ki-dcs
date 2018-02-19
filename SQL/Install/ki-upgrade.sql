DELIMITER $$

DROP TEMPORARY TABLE IF EXISTS ki_upgrade_log $$
CREATE TEMPORARY TABLE ki_upgrade_log
(message VARCHAR(200)) $$

DROP FUNCTION IF EXISTS FNC_TABLE_EXIST $$
CREATE FUNCTION FNC_TABLE_EXIST(Name VARCHAR(1000)) RETURNS BOOLEAN
BEGIN
	IF EXISTS 
		(
			SELECT 1 FROM information_schema.TABLES 
            WHERE table_name = Name AND table_schema = DATABASE() 
            AND table_type = 'BASE TABLE'
		) THEN
        RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;
END $$

DROP PROCEDURE IF EXISTS RENAME_TABLE $$
CREATE PROCEDURE RENAME_TABLE(oldname VARCHAR(1000), newname VARCHAR(1000))
BEGIN
	SET @query = CONCAT('RENAME TABLE ', oldname, ' TO ', newname);
	PREPARE stmt FROM @query;
	EXECUTE stmt;
END $$

DROP FUNCTION IF EXISTS GET_KI_DB_VERSION $$
CREATE FUNCTION GET_KI_DB_VERSION() RETURNS VARCHAR(128)
BEGIN
	DECLARE Version VARCHAR(128);
	IF FNC_TABLE_EXIST('meta') THEN
		SET Version = (SELECT version_guid FROM meta WHERE meta_id = 1);
	ELSE
		IF NOT FNC_TABLE_EXIST('backup_gameevents_log') THEN
			INSERT INTO ki_upgrade_log VALUES ("Detected Database Version is 0.76 or earlier");
			SET Version = "9ff4a3e7-f66c-4894-af05-3a982612e2cc";
        ELSE
			INSERT INTO ki_upgrade_log VALUES ("Detected Database Version is 0.77 or earlier");
			SET Version = "39124186-cc9e-49c0-a23c-d68c8fe9ad81";
        END IF;
    END IF;
    
    IF Version IS NULL THEN
		INSERT INTO ki_upgrade_log VALUES ("Unable To Detect Database Version - Version Is Corrupted!");
		SET Version = "e6726cbe-c673-4724-a456-f5863735cb4d";
    END IF;
    
    RETURN Version;
END $$

DROP PROCEDURE IF EXISTS UPGRADE_KI_DB $$
CREATE PROCEDURE UPGRADE_KI_DB(Version VARCHAR(128))
BEGIN
  INSERT INTO ki_upgrade_log VALUES ("Starting Upgrade");
  
  IF Version = "e6726cbe-c673-4724-a456-f5863735cb4d" THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot Upgrade Database! Corrupted Version Found!';
  END IF;
	
  -- VERSION 0.76 and below
  IF Version = "9ff4a3e7-f66c-4894-af05-3a982612e2cc" THEN
	INSERT INTO ki_upgrade_log VALUES ("Database Version is 0.76 or earlier - Upgrading to 0.77");
    
	CREATE TABLE IF NOT EXISTS backup_gameevents_log LIKE raw_gameevents_log;
    
    INSERT INTO ki_upgrade_log VALUES ("Database Upgraded To Version 0.77");
    SET Version = "39124186-cc9e-49c0-a23c-d68c8fe9ad81";
  END IF;
  
  -- VERSION 0.77
  IF Version = "39124186-cc9e-49c0-a23c-d68c8fe9ad81" THEN
	INSERT INTO ki_upgrade_log VALUES ("Database Version is 0.77 - Upgrading to 0.78");
    
	-- drop table rpt_updated
	DROP TABLE IF EXISTS rpt_updated;
    
    -- create table meta
    CREATE TABLE IF NOT EXISTS meta 
    (
	  meta_id INT NOT NULL,
	  version VARCHAR(45) NOT NULL,
	  version_guid VARCHAR(128) NOT NULL,
	  rpt_last_updated DATETIME NULL,
	  PRIMARY KEY (meta_id)
	);
    
    -- insert data
    INSERT INTO meta (meta_id, version, version_guid, rpt_last_updated)
    VALUES (1, "0.78", "0bc9fc46-ea51-4fc4-9c52-d3793c9a4515", NULL);
    
    INSERT INTO ki_upgrade_log VALUES ("Database Upgraded To Version 0.78");
    SET Version = "0bc9fc46-ea51-4fc4-9c52-d3793c9a4515";
  END IF;
  
  SELECT * FROM ki_upgrade_log;

END $$

-- SELECT "Created Upgrade Code - Preparing To Upgrade Database";

CALL UPGRADE_KI_DB(GET_KI_DB_VERSION()) $$

DROP PROCEDURE IF EXISTS UPGRADE_KI_DB $$
DROP FUNCTION IF EXISTS FNC_TABLE_EXIST $$
DROP PROCEDURE IF EXISTS RENAME_TABLE $$


DROP TEMPORARY TABLE IF EXISTS ki_upgrade_log;
 
DELIMITER ;

