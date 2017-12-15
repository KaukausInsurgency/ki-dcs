KI.Data = 
{
  CapturePoints = {},
  Depots = {},
  SideMissions = {},
  ActiveMissions = {},
  GameEventQueue = {},                -- data queue of game events
  OnlinePlayers = {},
  PlayerInZone = {},                  -- hash of players inside a zone
  SpawnID = 0,
  SortieID = 0,
  SessionID = KI.Null,
  ServerID = KI.Null,
  GameEventFileID = 0,  
  Waypoints = {}                      -- hash of ai ground waypoints
}


function KI.IncrementSpawnID()
  env.info("KI.IncrementSpawnID called")
  KI.Data.SpawnID = KI.Data.SpawnID + 1
  env.info("KI.IncrementSpawnID - New ID: " .. tostring(KI.Data.SpawnID))
  return KI.Data.SpawnID
end

function KI.GenerateName(name)
  return name .. " Spawn" .. tostring(KI.IncrementSpawnID())
end

function KI.IncrementSortieID()
  env.info("KI.IncrementSortieID called")
  KI.Data.SortieID = KI.Data.SortieID + 1
  env.info("KI.IncrementSortieID - New ID: " .. tostring(KI.Data.SortieID))
  return KI.Data.SortieID
end

function KI.IncrementGameEventFileID()
  env.info("KI.IncrementGameEventFileID called")
  KI.Data.GameEventFileID = KI.Data.GameEventFileID + 1
  env.info("KI.IncrementGameEventFileID - New ID: " .. tostring(KI.Data.GameEventFileID))
  return KI.Data.GameEventFileID
end
