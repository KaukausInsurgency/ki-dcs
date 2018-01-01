KI.Data = 
{
  CapturePoints = {},
  Depots = {},
  SideMissions = {},                  -- list of side missions the mission will generate
  ActiveMissions = {},                -- list of currently active missions
  InactiveMissionsQueue = {},         -- data queue of missions that were completed/expired/no longer active
  GameEventQueue = {},                -- data queue of game events
  OnlinePlayers = {},                 -- hash of current online players
  PlayerInZone = {},                  -- hash of players inside a zone
  SpawnID = 0,
  SortieID = 0,
  SessionID = KI.Null,
  ServerID = KI.Null,
  GameEventFileID = 0,                -- unique file ID enumerator for game events
  TaskID = 0,                         -- unique ID for active side missions
  Waypoints = {},                     -- hash of ai ground waypoints
  UnitIDs = {},                       -- hash of unit IDs in format [tostring(unit.id_)] = DCS Unit Obj - used for slingload events scanning
  SideMissionGroundObjects = {}       -- list of group, static object names
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

function KI.IncrementTaskID()
  env.info("KI.IncrementTaskID called")
  KI.Data.TaskID = KI.Data.TaskID + 1
  env.info("KI.IncrementTaskID - New ID: " .. tostring(KI.Data.TaskID))
  return KI.Data.TaskID
end

function KI.AddSideMissionObject(obj)
  env.info("KI.AddSideMissionObject called")
  table.insert(KI.Data.SideMissionGroundObjects, obj)
end