KI.Data = 
{
  CapturePoints = {},
  Depots = {},
  SideMissions = {},
  ActiveMissions = {},
  Templates = 
  {
    "TemplateInsCamp",
    "InfantrySquadTemplate",
    "ATSquadTemplate",
    "MANPADSSquadTemplate",
    "Spawn FuelTruck Template",
    "Spawn CommandTruck Template",
    "Spawn AmmoTruck Template",
    "Spawn PowerTruck Template",
    "Spawn MechBTR Template",
    "Spawn TankT72 Template",
    "Spawn WatchTower Template",
    "Spawn Outpost Template"
  },
  GameEventQueue = {},                -- data queue of game events
  OnlinePlayers = {},
  Sorties = {},                       -- list of current sorties active in format ["UCID"] = { Role, SortieID }
  SpawnID = 0,
  SortieID = 0,
  SessionID = KI.Null,
  ServerID = KI.Null,
  GameEventFileID = 0,
  Waypoints = {}
}


function KI.IncrementSpawnID()
  env.info("KI.IncrementSpawnID called")
  KI.Data.SpawnID = KI.Data.SpawnID + 1
  env.info("KI.IncrementSpawnID - New ID: " .. tostring(KI.Data.SpawnID))
  return KI.Data.SpawnID
end

function KI.GenerateName(name)
  return name .. tostring(KI.IncrementSpawnID())
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
