
-- Airframe flight times
DROP TEMPORARY TABLE IF EXISTS temp_flight_time;
CREATE TEMPORARY TABLE temp_flight_time 
(
	ucid varchar(128), 
    server_id int, 
    session_id int,
    role varchar(45),
    ci_id int, 
    ci_sortie_id int,
    ci_event varchar(45), 
    ci_time bigint, 
    co_id int, 
    co_sortie_id int,
    co_event varchar(45), 
    co_time bigint
); 

-- Need to create a clone of the temporary table because we need a delete query that joins the temp table to itself to remove duplicates
DROP TEMPORARY TABLE IF EXISTS temp_flight_time_clone;
CREATE TEMPORARY TABLE temp_flight_time_clone LIKE temp_flight_time;

INSERT INTO temp_flight_time
SELECT
  l1.ucid AS ucid,
  l1.server_id AS server_id,
  l1.session_id AS session_id,
  l1.role AS role,
  l1.id AS ci_id,
  l1.sortie_id AS ci_sortie_id,
  l1.event AS ci_event,
  l1.model_time AS ci_time,
  l2.id AS co_id,
  l2.sortie_id AS co_sortie_id,
  l2.event AS co_event,
  l2.model_time AS co_time
FROM
  raw_gameevents_log l1 
LEFT JOIN tmp_gameevents l2 
	ON (l1.server_id = l2.server_id AND 
		l1.session_id = l2.session_id AND 
        l1.ucid = l2.ucid AND
        l1.sortie_id = l2.sortie_id AND
		l1.id < l2.id AND 
        (l2.event = "DEAD" OR l2.event = "PILOT_DEAD" OR 
         l2.event = "CRASH" OR l2.event = "PLAYER_LEAVE_UNIT" OR 
         l2.event = "LAND" OR l2.event = "EJECTION")
        )
WHERE l1.event = "TAKEOFF";

INSERT INTO temp_flight_time_clone
SELECT * FROM temp_flight_time;


-- DELETE duplicate records (ie. a TAKEOFF event linked to a PILOT_DEAD, CRASH, DEAD events
-- we dont need to know that all 3 events may have happened in a single sortie, we only that one of them did
-- which caused the sortie to end
DELETE a.* FROM temp_flight_time a 
INNER JOIN temp_flight_time_clone b 
	ON a.ci_id = b.ci_id WHERE a.co_id > b.co_id;
    
    
-- Its possible that there will not be a matched LAND or DEAD event to a takeoff
-- (Ie if the players game crashes or if the server crashes)
-- In this case we use the last captured event from the same session id and sortie id
-- This means that when the player or server crashes, some flight time data will be lost
-- This is a good solution for the case where a player Takes off, crashes, reconnects, then takes off again
-- That is a scenario that is really difficult to handle and calculate
UPDATE temp_flight_time a
INNER JOIN tmp_gameevents g 
	ON a.session_id = g.session_id AND a.ci_sortie_id = g.sortie_id
	SET a.co_id = g.id,
		a.co_sortie_id = g.sortie_id,
		a.co_event = "LAST_EVENT", 
		a.co_time = g.model_time
WHERE a.co_time IS NULL AND g.model_time IS NOT NULL 
	  AND g.id = (SELECT MAX(id) FROM tmp_gameevents WHERE session_id = a.session_id AND sortie_id = a.ci_sortie_id);


      
-- Insert new airframe/ucid records into the table
INSERT INTO rpt_airframe_stats (ucid, airframe)
SELECT DISTINCT t1.ucid, role
FROM temp_flight_time t1 LEFT JOIN rpt_airframe_stats t2
ON t1.ucid = t2.ucid AND t1.role = t2.airframe
WHERE t2.ucid IS NULL AND t2.airframe IS NULL;


-- Update the total airframe flight time
UPDATE rpt_airframe_stats rpt 
INNER JOIN 
(
	SELECT ucid, role, SUM(co_time - ci_time) AS total_time
    FROM temp_flight_time
	GROUP BY ucid, role
) t ON rpt.ucid = t.ucid AND rpt.airframe = t.role
	SET rpt.flight_time = rpt.flight_time + t.total_time;

-- Update the average airframe flight time
UPDATE rpt_airframe_stats s
LEFT JOIN 
  (SELECT role, ucid, COUNT(ucid) As GrpCount, 
          SUM(co_time - ci_time) AS SumTimeDiff
   FROM temp_flight_time
   GROUP BY role, ucid) l
ON s.airframe = l.role AND s.ucid = l.ucid
SET s.avg_flight_time = (s.avg_flight_time * s.takeoffs + l.SumTimeDiff) / (s.takeoffs + l.GrpCount)
WHERE l.ucid IS NOT NULL;

-- UPDATE airframe individual stats
-- Need to use seperate update queries whenever we try to reference the temp_flight_time table because of the MySql limitation
-- that you cannot reference temp tables more than once in a single query
UPDATE rpt_airframe_stats rpt
	SET rpt.takeoffs = rpt.takeoffs +
		(
			SELECT COUNT(*) 
            FROM temp_flight_time 
            WHERE ucid = rpt.ucid AND role = rpt.airframe AND ci_event = "TAKEOFF"
		);
        
UPDATE rpt_airframe_stats rpt
	SET rpt.landings = rpt.landings +
        (
			SELECT COUNT(*) 
            FROM temp_flight_time 
            WHERE ucid = rpt.ucid AND role = rpt.airframe AND co_event = "LAND"
		);

-- Update airframe stats
UPDATE rpt_airframe_stats rpt
	SET rpt.slingload_hooks = rpt.slingload_hooks + 
        (
			SELECT COUNT(id) 
            FROM tmp_gameevents 
            WHERE ucid = rpt.ucid AND role = rpt.airframe AND event = "SLING_HOOK"
		),
        rpt.slingload_unhooks = rpt.slingload_unhooks + 
        (
			SELECT COUNT(id) 
            FROM tmp_gameevents 
            WHERE ucid = rpt.ucid AND role = rpt.airframe AND event = "SLING_UNHOOK"
		),
        rpt.deaths = rpt.deaths + 
        (
			SELECT COUNT(DISTINCT sortie_id) 
            FROM tmp_gameevents 
			WHERE (event LIKE "DEAD" Or event LIKE "CRASH" Or event LIKE "PILOT_DEAD") 
				  AND ucid = rpt.ucid AND role = rpt.airframe
		),
        rpt.kills = rpt.kills +
        (
			SELECT COUNT(id) 
            FROM tmp_gameevents 
            WHERE ucid = rpt.ucid AND role = rpt.airframe AND event = "KILL" AND player_side <> target_side
		),
        rpt.kills_player = rpt.kills_player +
        (
			SELECT COUNT(id) 
            FROM tmp_gameevents 
            WHERE ucid = rpt.ucid AND role = rpt.airframe AND event = "KILL" AND player_side <> target_side AND target_is_player = 1
		),
        rpt.kills_friendly = rpt.kills_friendly +
        (
			SELECT COUNT(id) 
            FROM tmp_gameevents 
            WHERE ucid = rpt.ucid AND role = rpt.airframe AND event = "KILL" AND player_side = target_side
		),
        rpt.transport_mounts = rpt.transport_mounts +
        (
			SELECT COUNT(id) 
            FROM tmp_gameevents 
            WHERE ucid = rpt.ucid AND role = rpt.airframe AND event = "TRANSPORT_MOUNT"
		),
        rpt.transport_dismounts = rpt.transport_dismounts + 
        (
			SELECT COUNT(id) 
            FROM tmp_gameevents 
            WHERE ucid = rpt.ucid AND role = rpt.airframe AND event = "TRANSPORT_DISMOUNT"
		),
        rpt.depot_resupplies = rpt.depot_resupplies + 
        (
			SELECT COUNT(id) 
            FROM tmp_gameevents 
            WHERE ucid = rpt.ucid AND role = rpt.airframe AND event = "DEPOT_RESUPPLY"
		),
        rpt.cargo_unpacked = rpt.cargo_unpacked + 
        (
			SELECT COUNT(id) 
            FROM tmp_gameevents 
            WHERE ucid = rpt.ucid AND role = rpt.airframe AND event = "CARGO_UNPACKED"
		),
        rpt.ejects = rpt.ejects +
        (
			SELECT COUNT(id) 
            FROM tmp_gameevents 
            WHERE ucid = rpt.ucid AND role = rpt.airframe AND event = "EJECTION"
		);
