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
FROM tmp_gameevents l
LEFT JOIN rpt_airframe_kd r 
ON l.ucid = r.ucid AND l.role = r.airframe AND l.target_model = r.name
WHERE r.ucid IS NULL AND r.airframe IS NULL AND r.name IS NULL 
      AND l.target_model IS NOT NULL AND l.ucid IS NOT NULL;

-- Insert new models into the table for each unique ucid and airframe using role column
INSERT INTO rpt_airframe_kd (ucid, airframe, name, is_model)
SELECT DISTINCT l.target_player_ucid, l.target_model, l.role, 1
FROM tmp_gameevents l
LEFT JOIN rpt_airframe_kd r 
ON l.ucid = r.ucid AND l.target_model = r.airframe AND l.role = r.name
WHERE r.ucid IS NULL AND r.airframe IS NULL AND r.name IS NULL 
      AND l.target_model IS NOT NULL AND l.target_player_ucid IS NOT NULL;
      
      
 
-- INSERT NEW TYPES
-- Insert new types into the table using target_type
INSERT INTO rpt_airframe_kd (ucid, airframe, name, is_type)
SELECT DISTINCT l.ucid, role, l.target_type, 1
FROM tmp_gameevents l
LEFT JOIN rpt_airframe_kd r 
ON l.ucid = r.ucid AND l.role = r.airframe AND l.target_type = r.name
WHERE r.ucid IS NULL AND r.airframe IS NULL AND r.name IS NULL 
      AND l.target_type IS NOT NULL AND l.ucid IS NOT NULL;
	
-- Insert new types into the table for each unique ucid and airframe using role column
INSERT INTO rpt_airframe_kd (ucid, airframe, name, is_type)
SELECT DISTINCT l.target_player_ucid, l.target_model, t.type, 1
FROM tmp_gameevents l
LEFT JOIN rpt_airframe_kd r 
ON l.ucid = r.ucid AND l.target_model = r.airframe
INNER JOIN target t
ON l.target_model = t.model
WHERE r.ucid IS NULL AND r.airframe IS NULL 
      AND l.target_model IS NOT NULL AND l.target_player_ucid IS NOT NULL;
      



-- INSERT NEW CATEGORIES
-- Insert new categories into the table using target_category
INSERT INTO rpt_airframe_kd (ucid, airframe, name, is_category)
SELECT DISTINCT l.ucid, role, l.target_category, 1
FROM tmp_gameevents l
LEFT JOIN rpt_airframe_kd r 
ON l.ucid = r.ucid AND l.role = r.airframe AND l.target_category = r.name
WHERE r.ucid IS NULL AND r.airframe IS NULL AND r.name IS NULL 
      AND l.target_category IS NOT NULL AND l.ucid IS NOT NULL;
	
-- Insert new types into the table for each unique ucid and airframe using role column
INSERT INTO rpt_airframe_kd (ucid, airframe, name, is_category)
SELECT DISTINCT l.target_player_ucid, l.target_model, t.category, 1
FROM tmp_gameevents l
LEFT JOIN rpt_airframe_kd r 
ON l.ucid = r.ucid AND l.target_model = r.airframe
INNER JOIN target t
ON l.target_model = t.model
WHERE r.ucid IS NULL AND r.airframe IS NULL 
      AND l.target_category IS NOT NULL AND l.target_player_ucid IS NOT NULL;
    

-- update the kill counts for all models
UPDATE rpt_airframe_kd rpt
INNER JOIN
(
	SELECT ucid, role, target_model, 
	   SUM(CASE WHEN event = "KILL" THEN 1 ELSE 0 END) AS killcount
	FROM tmp_gameevents l
	WHERE event = "KILL" AND ucid IS NOT NULL
	GROUP BY ucid, role, target_model
) t
ON rpt.ucid = t.ucid AND rpt.airframe = t.role AND rpt.name = t.target_model AND rpt.is_model = 1
SET kills = kills + t.killcount;

-- update the death counts for all models
UPDATE rpt_airframe_kd rpt
INNER JOIN
(
	SELECT target_player_ucid, target_model, role, 
	   SUM(CASE WHEN event = "KILL" THEN 1 ELSE 0 END) AS deathcount
	FROM tmp_gameevents l
	WHERE event = "KILL" AND target_player_ucid IS NOT NULL
	GROUP BY ucid, target_model, role
) t
ON rpt.ucid = t.target_player_ucid AND rpt.airframe = t.target_model AND rpt.name = t.role AND rpt.is_model = 1
SET deaths = deaths + t.deathcount;


-- TODO - Update kill and death counts for types and categories
