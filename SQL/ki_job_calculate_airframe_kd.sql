INSERT INTO raw_gameevents_log 
SELECT 1353, 4, 300, 14, "a68afce32e6b1f57a6c8d10da24f1516", "KILL", "Player", 1, 300, 294, "Ka-50", NULL, 
"VIKHR-M", "MISSILE", NULL, "T-55", "TANK", "GROUND", 2,
0, NULL, NULL, NULL, NULL;

INSERT INTO raw_gameevents_log 
SELECT 1354, 4, 300, 14, "a68afce32e6b1f57a6c8d10da24f1516", "KILL", "Player", 1, 300, 294, "Ka-50", NULL, 
"VIKHR-M", "MISSILE", NULL, "T-72", "TANK", "GROUND", 2,
0, NULL, NULL, NULL, NULL;

INSERT INTO raw_gameevents_log 
SELECT 1355, 4, 300, 14, "a68afce32e6b1f57a6c8d10da24f1516", "KILL", "Player", 1, 300, 294, "Ka-50", NULL, 
"VIKHR-M", "MISSILE", NULL, "SA-11", "SAM", "GROUND", 1,
0, NULL, NULL, NULL, NULL;

INSERT INTO raw_gameevents_log 
SELECT 1356, 4, 300, 14, "a68afce32e6b1f57a6c8d10da24f1516", "KILL", "Player", 1, 300, 294, "Ka-50", NULL, 
"30 mm HE", "CANNON", NULL, "AK Infantry", "INFANTRY", "GROUND", 2,
0, NULL, NULL, NULL, NULL;

INSERT INTO raw_gameevents_log 
SELECT 1357, 4, 300, 15, "a68afce32e6b1f57a6c8d10da24f1516", "KILL", "Player", 1, 300, 294, "Su-25T", NULL, 
"AA-11 Alamo", "MISSILE", NULL, "F-15", "FIGHTER", "AIR", 2,
0, NULL, NULL, NULL, NULL;

INSERT INTO raw_gameevents_log 
SELECT 1358, 4, 300, 15, "a68afce32e6b1f57a6c8d10da24f1516", "KILL", "Player", 1, 300, 294, "Su-25T", NULL, 
"AA-11 Alamo", "MISSILE", NULL, "Mig-29S", "FIGHTER", "AIR", 1,
0, NULL, NULL, NULL, NULL;

INSERT INTO raw_gameevents_log 
SELECT 1361, 4, 300, 17, "a68afce32e6b1f57a6c8d10da24f1516", "KILL", "Player", 1, 300, 294, "Su-25T", NULL, 
"AA-11 Alamo", "MISSILE", NULL, "Mig-29S", "FIGHTER", "AIR", 1,
0, NULL, NULL, NULL, NULL;

INSERT INTO raw_gameevents_log 
SELECT 1359, 4, 300, 16, "a68afce32e6b1f57a6c8d10da24f1516", "KILL", "Player", 1, 300, 294, "Ka-50", NULL, 
"VIKHR-M", "MISSILE", NULL, "T-55", "TANK", "GROUND", 2,
0, NULL, NULL, NULL, NULL;


INSERT INTO raw_gameevents_log 
SELECT 1362, 4, 300, NULL, NULL, "KILL", "AI", 2, 300, 294, "SA-11", NULL, 
"Mrg 32 Sparrow", "MISSILE", NULL, "Ka-50", "ATTACK_HELO", "AIR", 1,
1, "a68afce32e6b1f57a6c8d10da24f1516", NULL, NULL, NULL;

INSERT INTO raw_gameevents_log 
SELECT 1363, 4, 300, NULL, NULL, "KILL", "AI", 2, 300, 294, "F-16", NULL, 
"AAMRAM", "MISSILE", NULL, "Mig-29", "FIGHTER", "AIR", 1,
1, "a68afce32e6b1f57a6c8d10da24f1516", NULL, NULL, NULL;




-- insert any new target classifications
INSERT INTO target (model, type, category)
SELECT DISTINCT l.target_model, l.target_type, l.target_category
FROM raw_gameevents_log l
LEFT JOIN target r 
ON l.target_model = r.model
WHERE r.model IS NULL AND l.target_model IS NOT NULL AND l.target_category IS NOT NULL;



-- INSERT NEW MODELS
-- Insert new models into the table for each unique ucid and airframe using target_model column
INSERT INTO rpt_airframe_kd (ucid, airframe, name, is_model)
SELECT DISTINCT l.ucid, role, l.target_model, 1
FROM raw_gameevents_log l
LEFT JOIN rpt_airframe_kd r 
ON l.ucid = r.ucid AND l.role = r.airframe AND l.target_model = r.name
WHERE r.ucid IS NULL AND r.airframe IS NULL AND r.name IS NULL 
      AND l.target_model IS NOT NULL AND l.ucid IS NOT NULL;

-- Insert new models into the table for each unique ucid and airframe using role column
INSERT INTO rpt_airframe_kd (ucid, airframe, name, is_model)
SELECT DISTINCT l.target_player_ucid, l.target_model, l.role, 1
FROM raw_gameevents_log l
LEFT JOIN rpt_airframe_kd r 
ON l.ucid = r.ucid AND l.target_model = r.airframe AND l.role = r.name
WHERE r.ucid IS NULL AND r.airframe IS NULL AND r.name IS NULL 
      AND l.target_model IS NOT NULL AND l.target_player_ucid IS NOT NULL;
      
      
 
-- INSERT NEW TYPES
-- Insert new types into the table using target_type
INSERT INTO rpt_airframe_kd (ucid, airframe, name, is_type)
SELECT DISTINCT l.ucid, role, l.target_type, 1
FROM raw_gameevents_log l
LEFT JOIN rpt_airframe_kd r 
ON l.ucid = r.ucid AND l.role = r.airframe AND l.target_type = r.name
WHERE r.ucid IS NULL AND r.airframe IS NULL AND r.name IS NULL 
      AND l.target_type IS NOT NULL AND l.ucid IS NOT NULL;
	
-- Insert new types into the table for each unique ucid and airframe using role column
INSERT INTO rpt_airframe_kd (ucid, airframe, name, is_type)
SELECT DISTINCT l.target_player_ucid, l.target_model, t.type, 1
FROM raw_gameevents_log l
LEFT JOIN rpt_airframe_kd r 
ON l.ucid = r.ucid AND l.target_model = r.airframe
INNER JOIN ki.target t
ON l.target_model = t.model
WHERE r.ucid IS NULL AND r.airframe IS NULL 
      AND l.target_model IS NOT NULL AND l.target_player_ucid IS NOT NULL;
      



-- INSERT NEW CATEGORIES
-- Insert new categories into the table using target_category
INSERT INTO rpt_airframe_kd (ucid, airframe, name, is_category)
SELECT DISTINCT l.ucid, role, l.target_category, 1
FROM raw_gameevents_log l
LEFT JOIN rpt_airframe_kd r 
ON l.ucid = r.ucid AND l.role = r.airframe AND l.target_category = r.name
WHERE r.ucid IS NULL AND r.airframe IS NULL AND r.name IS NULL 
      AND l.target_category IS NOT NULL AND l.ucid IS NOT NULL;
	
-- Insert new types into the table for each unique ucid and airframe using role column
INSERT INTO rpt_airframe_kd (ucid, airframe, name, is_category)
SELECT DISTINCT l.target_player_ucid, l.target_model, t.category, 1
FROM raw_gameevents_log l
LEFT JOIN rpt_airframe_kd r 
ON l.ucid = r.ucid AND l.target_model = r.airframe
INNER JOIN ki.target t
ON l.target_model = t.model
WHERE r.ucid IS NULL AND r.airframe IS NULL 
      AND l.target_category IS NOT NULL AND l.target_player_ucid IS NOT NULL;
    

-- update the kill counts for all models
UPDATE ki.rpt_airframe_kd rpt
INNER JOIN
(
	SELECT ucid, role, target_model, 
	   SUM(CASE WHEN event = "KILL" THEN 1 ELSE 0 END) AS killcount
	FROM raw_gameevents_log l
	WHERE event = "KILL" AND ucid IS NOT NULL
	GROUP BY ucid, role, target_model
) t
ON rpt.ucid = t.ucid AND rpt.airframe = t.role AND rpt.name = t.target_model AND rpt.is_model = 1
SET kills = kills + t.killcount;

-- update the death counts for all models
UPDATE ki.rpt_airframe_kd rpt
INNER JOIN
(
	SELECT target_player_ucid, target_model, role, 
	   SUM(CASE WHEN event = "KILL" THEN 1 ELSE 0 END) AS deathcount
	FROM raw_gameevents_log l
	WHERE event = "KILL" AND target_player_ucid IS NOT NULL
	GROUP BY ucid, target_model, role
) t
ON rpt.ucid = t.target_player_ucid AND rpt.airframe = t.target_model AND rpt.name = t.role AND rpt.is_model = 1
SET deaths = deaths + t.deathcount;


-- TODO - Update kill and death counts for types and categories