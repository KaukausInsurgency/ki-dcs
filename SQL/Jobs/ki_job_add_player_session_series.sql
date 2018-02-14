INSERT INTO rpt_player_session_series (ucid, session_id, event, game_time)
SELECT g.ucid, g.session_id, g.event, g.model_time 
FROM tmp_gameevents g
WHERE g.ucid IS NOT NULL AND 
	  g.session_id IS NOT NULL AND 
      g.event IS NOT NULL AND 
      g.model_time IS NOT NULL AND
      g.ucid IS NOT NULL;
      
