local SpawnZone = ZONE:New("SAMPLESPAWNZONE")
local DestZone = ZONE:New("SAMPLEZONE")
local SpawnObj = SPAWN:New("C130")
      :OnSpawnGroup(function( spawngrp, dzone ) 
          xpcall(function() 
                    env.info("OnSpawnGroup CALLBACK")
                    spawngrp:RouteToVec3({ x = dzone:GetVec3().x, y = 2500, z = dzone:GetVec3().z }, 500)
                    --spawngrp:RouteAirTo(dzone:GetCoordinate(), nil, nil, nil, 500, 5)
                    --spawngrp:TaskRouteToZone(dzone, false, 500, FORMATION.Cone)
                 end,
                 function(err) env.info("OnSpawnGroup ERROR - " .. err) end)
      end, DestZone)
      
local NewGroup = SpawnObj:SpawnAtAirbase(AIRBASE:FindByName("Nalchik"), nil, 3000)