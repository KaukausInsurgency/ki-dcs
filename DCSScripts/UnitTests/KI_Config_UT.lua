-- Configuration for Kaukausus Insurgency
if not KI then
  KI = {}
end

KI.Config = {}

-- Controls the maximum lifetime of a crate sitting idle at a depot until it is despawned
KI.Config.CrateDespawnTime_Depot = 120

-- Controls the maximum lifetime of a crate/troops sitting idle in the wild until it is despawned
KI.Config.CrateDespawnTime_Wild = 300

-- Controls the rate at which data transmissions are sent to the database server
KI.Config.DataTransmissionUpdateRate = 10

-- Controls the rate at which all capture points are updated/managed by KI Engine
KI.Config.CPUpdateRate = 15

-- controls the rate at which side missions are generated and/or managed from the queue
KI.Config.SideMissionUpdateRate = 30 

-- adds a randomness increment time to the update rate each run through
KI.Config.SideMissionUpdateRateRandom = 30 

-- controls the maximum amount of active side missions can run at a time
KI.Config.SideMissionsMax = 3

-- controls the maximum amount of time a side mission can remain active
KI.Config.SideMissionMaxTime =  600 --KI.Toolbox.HoursToSeconds(1)  

-- controls when the side missions .destroy method is invoked after the mission has already ended
KI.Config.SideMissionsDestroyTime = KI.Toolbox.MinutesToSeconds(5) 

-- parent folder of saved game files
KI.Config.ParentFolder = "Missions\\Kaukasus Insurgency\\"

-- path to saved game file
KI.Config.PathMissionData = lfs.writedir() .. KI.Config.ParentFolder .. "KI_UT_Entities.lua"

-- path to saved scores file
KI.Config.PathScores = lfs.writedir() .. KI.Config.ParentFolder .. "KI_Scores.lua"

-- taken from KO - need to understand what these do
KI.Config.PathScoreID = lfs.writedir() .. KI.Config.ParentFolder .. "KI_ScoreID.lua"
KI.Config.PathScores2 = lfs.writedir() .. KI.Config.ParentFolder .. "\\scores\\KI_Scores_"
KI.Config.PathSorties = lfs.writedir() .. KI.Config.ParentFolder .. "KI_Sorties.lua"
KI.Config.PathSortieID = lfs.writedir() .. KI.Config.ParentFolder .. "KI_SortieID.lua"
KI.Config.PlayerListFileName = lfs.writedir() .. KI.Config.ParentFolder .. "KI_PlayersOnline.lua"
KI.Config.PlayerDataFileName = lfs.writedir() .. KI.Config.ParentFolder .. "KI_PlayerData.lua"
KI.Config.SessionID = 1

-- IP Address of Database Server (mySQL)
KI.Config.DBServerIP = "192.168.1.254"

-- Port Number of Database Server Connection
KI.Config.DBServerPort = 9983

KI.Config.Depots = {}

-- configures capture points in mission
KI.Config.CP =
{
  { name = "TestCPKIQuery", zone = "TestCPKIQueryZone", spawnzone1 = "TestCPKIQueryZone", type = "CAPTUREPOINT" }
}

-- configures side missions and their properties
KI.Config.SideMissions =
{
}

-- Minimum distance needed to stop a respawned unit from moving to a waypoint
KI.Config.RespawnUnitWaypointDistance = 100

-- Delay to assign waypoint to unit after being respawned
KI.Config.RespawnTimeBeforeWaypointTasking = 15
