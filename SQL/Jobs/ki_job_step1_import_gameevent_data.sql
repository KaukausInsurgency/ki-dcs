-- Clone gameevents table
DROP TABLE IF EXISTS tmp_gameevents;
CREATE TABLE IF NOT EXISTS tmp_gameevents LIKE raw_gameevents_log;

-- gets all event rows for servers that are currently online (but ignoring the current session the servers are playing)
INSERT INTO tmp_gameevents
SELECT r.id, r.server_id, r.session_id, r.sortie_id, r.ucid, r.event, r.player_name, r.player_side, 
	   r.model_time, r.game_time, r.role, r.location, r.weapon, r.weapon_category, r.target_name, 
       r.target_model, r.target_type, r.target_category, r.target_side, r.target_is_player, r.target_player_ucid,
       r.target_player_name, r.transport_unloaded_count, r.cargo FROM raw_gameevents_log r
LEFT JOIN session s 
	ON r.session_id = s.session_id
WHERE r.session_id not in 
	(SELECT MAX(session_id) 
		FROM session s 
        GROUP BY server_id) 
	AND r.server_id in (SELECT server_id FROM server WHERE status = 'Online');
    
-- gets all event rows for servers that are currently offline or restarting
INSERT INTO tmp_gameevents
SELECT r.id, r.server_id, r.session_id, r.sortie_id, r.ucid, r.event, r.player_name, r.player_side, 
	   r.model_time, r.game_time, r.role, r.location, r.weapon, r.weapon_category, r.target_name, 
       r.target_model, r.target_type, r.target_category, r.target_side, r.target_is_player, r.target_player_ucid,
       r.target_player_name, r.transport_unloaded_count, r.cargo FROM raw_gameevents_log r
LEFT JOIN session s 
	ON r.session_id = s.session_id
WHERE r.server_id in (SELECT server_id FROM server WHERE status != 'Online');

