-- This script is responsible for updating overall game stats for players
-- these are not airframe specific stats, just overall totals

-- TRUNCATE TABLE rpt_overall_stats;


-- insert new player records into the stats table
INSERT INTO rpt_overall_stats (ucid)
select distinct t1.ucid
from tmp_gameevents t1 left join rpt_overall_stats t2
on t1.ucid = t2.ucid
where t2.ucid is null AND t1.ucid IS NOT NULL;


-- update overall player stats
UPDATE rpt_overall_stats rpt
	SET rpt.takeoffs = rpt.takeoffs + 
			(SELECT COUNT(id) FROM tmp_gameevents WHERE ucid = rpt.ucid AND event = "TAKEOFF"),
		rpt.landings = rpt.landings + 
			(SELECT COUNT(id) FROM tmp_gameevents WHERE ucid = rpt.ucid AND event = "LAND"),
        rpt.slingload_hooks = rpt.slingload_hooks + 
			(SELECT COUNT(id) FROM tmp_gameevents WHERE ucid = rpt.ucid AND event = "SLING_HOOK"),
		rpt.slingload_unhooks = rpt.slingload_unhooks + 
			(SELECT COUNT(id) FROM tmp_gameevents WHERE ucid = rpt.ucid AND event = "SLING_UNHOOK"),
		rpt.transport_mounts = rpt.transport_mounts + 
			(SELECT COUNT(id) FROM tmp_gameevents WHERE ucid = rpt.ucid AND event = "TRANSPORT_MOUNT"),
		rpt.transport_dismounts = rpt.transport_dismounts + 
			(SELECT COUNT(id) FROM tmp_gameevents WHERE ucid = rpt.ucid AND event = "TRANSPORT_DISMOUNT"),
		rpt.depot_resupplies = rpt.depot_resupplies + 
			(SELECT COUNT(id) FROM tmp_gameevents WHERE ucid = rpt.ucid AND event = "DEPOT_RESUPPLY"),
		rpt.cargo_unpacked = rpt.cargo_unpacked + 
			(SELECT COUNT(id) FROM tmp_gameevents WHERE ucid = rpt.ucid AND event = "CARGO_UNPACKED"),
		rpt.kills = rpt.kills +
			(SELECT COUNT(id) FROM tmp_gameevents 
				 WHERE (event = "KILL") AND ucid = rpt.ucid),
		rpt.deaths = rpt.deaths +
			(SELECT COUNT(DISTINCT sortie_id) FROM tmp_gameevents 
				 WHERE (event = "DEAD" Or event = "CRASH" Or event = "PILOT_DEAD") AND ucid = rpt.ucid),
		rpt.ejects = rpt.ejects +
			(SELECT COUNT(id) FROM tmp_gameevents WHERE ucid = rpt.ucid AND event = "EJECTION");
                 


















