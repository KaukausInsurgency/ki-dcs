-- create a temporary table to process online time
DROP TEMPORARY TABLE IF EXISTS temp_connect_pairs;
CREATE TEMPORARY TABLE temp_connect_pairs 
(ucid varchar(128), server_id int, session_id int, ci_id int, ci_type varchar(20), ci_time bigint, co_id int, co_type varchar(20), co_time bigint); 

-- mysql limitation - you cannot reference a temporary table more than once in the same query, and we need this in order
-- to remove duplicate rows that might be generated from the insert query
DROP TEMPORARY TABLE IF EXISTS temp_connect_pairs_clone;
CREATE TEMPORARY TABLE temp_connect_pairs_clone LIKE temp_connect_pairs;


INSERT INTO temp_connect_pairs
SELECT
  l1.player_ucid AS ucid,
  l1.server_id AS server_id,
  l1.session_id AS session_id,
  l1.id AS ci_id,
  l1.type AS ci_type,
  l1.real_time AS ci_time,
  l2.id AS co_id,
  l2.type AS co_type,
  l2.real_time AS co_time
FROM
  raw_connection_log l1 
LEFT JOIN raw_connection_log l2 
	ON (l1.server_id = l2.server_id AND 
		l1.session_id = l2.session_id AND 
        l1.player_ucid = l2.player_ucid AND
		l1.id < l2.id AND l2.type != "CONNECTED")
WHERE l1.type = "CONNECTED";

INSERT INTO temp_connect_pairs_clone
SELECT * FROM temp_connect_pairs;

-- DELETE duplicate records that somehow got created (ie. the same connection event linked to multiple disconnect events)
DELETE a.* FROM temp_connect_pairs a 
INNER JOIN temp_connect_pairs_clone b 
	ON a.ci_id = b.ci_id WHERE a.co_id > b.co_id;
    
-- UPDATE records that reference the same disconnect event multiple times to null
UPDATE temp_connect_pairs a
INNER JOIN temp_connect_pairs_clone b 
	ON a.co_id = b.co_id 
SET a.co_id = NULL, a.co_type = NULL, a.co_time = NULL
WHERE a.ci_id < b.ci_id;

-- UPDATE the check out time to be the session end time if there is a session end time (and the check out time is NULL)
-- It's possible that the player crashed and no disconnect was recorded, but we'll just assume it's the end of the session
UPDATE temp_connect_pairs AS tcp
INNER JOIN session s 
	ON s.session_id = tcp.session_id
	SET co_time = s.real_time_end,
		co_type = "PLAYER_CRASH"
WHERE tcp.co_time IS NULL AND s.real_time_end IS NOT NULL;

-- UPDATE the check out time to be the last heartbeat time if there is no session end time (because of a server crash for example)
UPDATE temp_connect_pairs AS tcp
INNER JOIN session s 
	ON s.session_id = tcp.session_id
	SET co_time = TIME_TO_SEC( TIMEDIFF( s.last_heartbeat, COALESCE(s.start, FROM_UNIXTIME(0)) )) + s.real_time_start,
		co_type = "SERVER_CRASH"
WHERE tcp.co_time IS NULL AND s.real_time_end IS NULL AND s.last_heartbeat IS NOT NULL;

-- UPDATE the check out time to be the same as start time if there is no heartbeat or session end time
UPDATE temp_connect_pairs AS tcp
INNER JOIN session s 
	ON s.session_id = tcp.session_id
	SET co_time = tcp.ci_time,
		co_type = "SERVER_FAIL"
WHERE tcp.co_time IS NULL AND s.real_time_end IS NULL AND s.last_heartbeat IS NULL;



-- insert new player records into the stats table
INSERT INTO rpt_overall_stats (ucid)
select distinct t1.player_ucid
from raw_connection_log t1 left join rpt_overall_stats t2
on t1.player_ucid = t2.ucid
where t2.ucid is null;


-- Update the overall player stats
UPDATE rpt_overall_stats rpt 
INNER JOIN 
(
	SELECT ucid, SUM(co_time - ci_time) AS total_time
    FROM temp_connect_pairs
	GROUP BY ucid
) t ON rpt.ucid = t.ucid
	SET rpt.game_time = rpt.game_time + t.total_time;
    
    
-- insert new server_id / player records into the server_traffic table
INSERT INTO rpt_overall_server_traffic (server_id, ucid)
select distinct t1.server_id, t1.ucid
from temp_connect_pairs t1 left join rpt_overall_server_traffic t2
on t1.server_id = t2.server_id AND t1.ucid = t2.ucid
where t2.server_id is null AND t2.ucid IS NULL;



-- update the weighted average online time for each player
-- update the number of connections made by each player
UPDATE rpt_overall_server_traffic s
LEFT JOIN 
  (SELECT server_id, UCID, COUNT(UCID) As GrpCount, 
          SUM(co_time - ci_time) AS SumTimeDiff
   FROM temp_connect_pairs
   GROUP BY server_id, UCID) l
ON s.server_id = l.server_id AND s.UCID = l.UCID
SET s.avg_online_time = (s.avg_online_time * s.num_connects + l.SumTimeDiff) / (s.num_connects + l.GrpCount),
	s.num_connects = s.num_connects + l.GrpCount
WHERE l.UCID IS NOT NULL;

-- Backup the data then purge the raw table

-- backing up all connection events
INSERT INTO backup_connection_log (id, server_id, session_id, type, player_ucid, player_name, player_id, ip_address, game_time, real_time)
SELECT rcl.id, rcl.server_id, rcl.session_id, rcl.type, rcl.player_ucid, rcl.player_name, rcl.player_id, rcl.ip_address, rcl.game_time, rcl.real_time 
FROM raw_connection_log rcl
INNER JOIN temp_connect_pairs tcp
	ON rcl.id = tcp.ci_id;
    
-- backing up all disconnect events
INSERT INTO backup_connection_log (id, server_id, session_id, type, player_ucid, player_name, player_id, ip_address, game_time, real_time)
SELECT rcl.id, rcl.server_id, rcl.session_id, rcl.type, rcl.player_ucid, rcl.player_name, rcl.player_id, rcl.ip_address, rcl.game_time, rcl.real_time 
FROM raw_connection_log rcl
INNER JOIN temp_connect_pairs tcp
	ON rcl.id = tcp.co_id;

-- deleting records from raw table
DELETE rcl.* FROM raw_connection_log rcl
INNER JOIN temp_connect_pairs tcp
	ON rcl.id = tcp.ci_id OR rcl.id = tcp.co_id;
