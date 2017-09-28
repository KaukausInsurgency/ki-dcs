-- Configuration for Kaukausus Insurgency
if not KI then
  KI = {}
end

KI.Config = {}

-- 1 is red coalition, 2 is blue coalition -- no function at this time
KI.Config.PlayerCoalition = 1 

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
KI.Config.PathMissionData = lfs.writedir() .. KI.Config.ParentFolder .. "KI_Entities.lua"

-- path to saved scores file
KI.Config.PathScores = lfs.writedir() .. KI.Config.ParentFolder .. "KI_Scores.lua"

-- taken from KO - need to understand what these do
KI.Config.PathScoreID = lfs.writedir() .. KI.Config.ParentFolder .. "KI_ScoreID.lua"
KI.Config.PathScores2 = lfs.writedir() .. KI.Config.ParentFolder .. "\\scores\\KI_Scores_"
KI.Config.PathSorties = lfs.writedir() .. KI.Config.ParentFolder .. "KI_Sorties.lua"
KI.Config.PathSortieID = lfs.writedir() .. KI.Config.ParentFolder .. "KI_SortieID.lua"
KI.Config.PlayerListFileName = lfs.writedir() .. KI.Config.ParentFolder .. "KI_PlayersOnline.lua"
KI.Config.PlayerDataFileName = lfs.writedir() .. KI.Config.ParentFolder .. "KI_PlayerData.lua"

-- IP Address of Database Server (mySQL)
KI.Config.DBServerIP = "192.168.1.254"

-- Port Number of Database Server Connection
KI.Config.DBServerPort = 9983

-- Your server name (Only really used if supporting multi-tenant game servers)
KI.Config.ServerName = "My Kaukasus Insurgency Server"

-- configures capture points in mission
KI.Config.CP =
{
  { name = "Beslan City", zone = "BeslanCityZone", spawnzone = "BeslanCitySpawnZone" },
  { name = "Beslan Airport", zone = "BeslanAirportZone", spawnzone = "BeslanAirportSpawnZone" },
  { name = "Kirovo City", zone = "KirovoCityZone", spawnzone = "KirovoCitySpawnZone" },
}

-- configures side missions and their properties
KI.Config.SideMissions =
{
  { 
      -- the name of the side mission - will display in radio item menu as well as on website
      name = "Destroy Insurgent Camp", 
      
      -- the list of zones that this side mission can use (will be randomly picked)
      zones = { "InsCampZone1", "InsCampZone2", "InsCampZone3", "InsCampZone4" },
      
      -- this function tells KI how to create and initialize the mission
      -- spawn and create your necessary objects here using whatever means (MOOSE:Spawn, mist, etc)
      init = function(missionName, chosenZone)
        env.info("DSMT.init called - creating side mission " .. missionName .. " chosen zone : " .. chosenZone.ZoneName)
        local SpawnVeh = SPAWNSTATIC:NewFromStatic("TemplateInsCamp", 2)
        local CampObj = SpawnVeh:SpawnFromPointVec2(chosenZone:GetRandomPointVec2(), math.random(359), KI.GenerateName("Insurgent Camp"))
        local args = {}
        args.CampObject = CampObj
        KI.Toolbox.MessageRedCoalition("ALERT!! NEW MISSION - Destroy the Insurgent Camp that has been uncovered!")
        -- create and initialize the task, init must return struct SideMission Class object
        return DSMTResource:New(nil, nil, { {CampObj, "Fortifications", CampObj:getName()} }, args)
      end,
      
      -- this function tells KI how to destroy/cleanup the side mission
      -- delete and destroy all relevant objects in this function, as well as close any handlers / resources that this side mission may have used
      destroy = function(rsc)
        -- destroys and cleans up task resources, must return true/false to indicate cleanup succeeded
        env.info("DSMT.destroy called - destroying camp object")
        rsc.Arguments.CampObject:destroy()
      end,
      
      -- determines the rate at which the task loop function should run
      rate = 30,
      
      -- this function tells KI how the side mission is to be considered complete - this function is run every so often to check if the criteria has been met - must return true/false to indicate if task is complete
      complete = function(missionName, chosenZone, rsc)
        env.info("DSMT.complete called - checking if CampObject is alive")
        return not rsc.Arguments.CampObject:isExist()
      end,
      
      -- this function tells KI how the side mission is to be considered failed - this function is run every so often to check if the criteria have been met - must return true/false to indicate if task is failed
      -- you can optionally leave this to return false, then once the timeout expires the mission will be considered failed and the ontimeout will be called
      fail = function(missionName, chosenZone, rsc)
        env.info("DSMT.fail called")
        return false
      end,
      
      -- this function tells KI what should happen when the side mission is completed
      -- use this function to display messages to all players
      -- no return required
      oncomplete = function(missionName, chosenZone, rsc)
        env.info("DSMT.oncomplete called")
        KI.Toolbox.MessageRedCoalition("MISSION COMPLETE - " .. missionName .. " - THE CAMP HAS BEEN SUCCESSFULLY DESTROYED!")
      end,
      
      -- this function tells KI what should happen when the side mission is failed
      -- use this function to display messages to all players
      -- no return required
      onfail = function(missionName, chosenZone, rsc)
        env.info("DSMT.onfail called")
      end,
      
      -- this function tells KI what should happen when the side mission time runs out
      -- use this function to display messages to all players
      -- no return required
      ontimeout = function(missionName, chosenZone, rsc)
        env.info("DSMT.ontimeout called")
        KI.Toolbox.MessageRedCoalition("MISSION FAILED - " .. missionName .. " - TIME HAS RUN OUT!")
      end
  }
  
}

