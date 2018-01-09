INSERT INTO ki.rpt_player_session_series (ucid, session_id, event, game_time)
SELECT g.ucid, g.session_id, g.event, g.game_time 
FROM raw_gameevents_log g
WHERE g.ucid IS NOT NULL AND g.session_id IS NOT NULL AND g.event IS NOT NULL AND g.game_time IS NOT NULL;