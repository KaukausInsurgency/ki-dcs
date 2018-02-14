DROP VIEW IF EXISTS view_temp_sortie_stats;
CREATE VIEW view_temp_sortie_stats AS
SELECT server_id, session_id, ucid, role, sortie_id, 
		SUM(CASE WHEN event = "SHOT" THEN 1 ELSE 0 END) AS Shots,
        SUM(CASE WHEN event = "SHOOTING_START" THEN 1 ELSE 0 END) AS GunShots,
        SUM(CASE WHEN event = "HIT" THEN 1 ELSE 0 END) AS Hits,
        SUM(CASE WHEN event = "KILL" THEN 1 ELSE 0 END) AS Kills,
		SUM(CASE WHEN event = "TRANSPORT_MOUNT" THEN 1 ELSE 0 END) AS TransportMounts,
        SUM(CASE WHEN event = "TRANSPORT_DISMOUNT" THEN 1 ELSE 0 END) AS TransportDismounts,
        SUM(CASE WHEN event = "CARGO_UNPACKED" THEN 1 ELSE 0 END) AS CargoUnpacked,
        SUM(CASE WHEN event = "DEPOT_RESUPPLY" THEN 1 ELSE 0 END) AS DepotResupplies,
		SUM(CASE WHEN event = "SLING_HOOK" THEN 1 ELSE 0 END) AS SlingHooks,
        SUM(CASE WHEN event = "SLING_UNHOOK" THEN 1 ELSE 0 END) AS SlingUnhooks,
        (
			SELECT model_time
            FROM tmp_gameevents
            WHERE id = 
				(
					SELECT MIN(id)
					FROM tmp_gameevents
					WHERE sortie_id = l.sortie_id AND server_id = l.server_id AND session_id = l.session_id
				)
        ) AS SortieStartTime,
        (
			SELECT model_time
            FROM tmp_gameevents
            WHERE id = 
				(
					SELECT MAX(id)
					FROM tmp_gameevents
					WHERE sortie_id = l.sortie_id AND server_id = l.server_id AND session_id = l.session_id
                )
        ) AS SortieEndTime
FROM tmp_gameevents l
WHERE ucid IS NOT NULL AND sortie_id IS NOT NULL
GROUP BY server_id, session_id, ucid, role, sortie_id;



INSERT INTO rpt_airframe_sortie 
(
	ucid, airframe, sortie_time, shots, 
    gunshots, hits, kills, transport_mount, 
    transport_dismount, cargo_unpacked, depot_resupply, cargo_hooked,
    cargo_unhooked
)
SELECT ucid, role, SortieEndTime - SortieStartTime, Shots, 
	   GunShots, Hits, Kills, TransportMounts, 
       TransportDismounts, CargoUnpacked, DepotResupplies, SlingHooks,
       SlingUnhooks
FROM view_temp_sortie_stats;

DROP VIEW IF EXISTS view_temp_sortie_stats;
