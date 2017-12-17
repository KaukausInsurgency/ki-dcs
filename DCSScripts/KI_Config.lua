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

-- Controls the rate at which data transmissions are sent to the server mod
KI.Config.DataTransmissionPlayerUpdateRate = 5        -- things like player data
KI.Config.DataTransmissionGameEventsUpdateRate = 10   -- game events
KI.Config.DataTransmissionGeneralUpdateRate = 20      -- things like depot, and capture point data

-- Controls the rate at which mission data is saved to file
KI.Config.SaveMissionRate = 300

-- Controls the rate at which all capture points are updated/managed by KI Engine
KI.Config.CPUpdateRate = 15

-- Controls the rate at which we check if a player is in a zone and display message to them
KI.Config.PlayerInZoneCheckRate = 3

-- controls the rate at which side missions are generated and/or managed from the queue
KI.Config.SideMissionUpdateRate = 1200 

-- adds a randomness increment time to the update rate each run through
KI.Config.SideMissionUpdateRateRandom = 600 

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

-- path to gameevent files
KI.Config.PathGameEvents = lfs.writedir() .. KI.Config.ParentFolder .. "GameEvents"

-- path to slingload event files
KI.Config.PathSlingloadEvents = lfs.writedir() .. KI.Config.ParentFolder .. "SlingloadEvents"

-- IP Address of TCP Server - no function at this time
KI.Config.TCPServerIP = "127.0.0.1"

-- Port Number of TCP Server - no function at this time
KI.Config.TCPServerPort = 9983

-- UDP Port Numbers to communicate with the server side mod
KI.Config.SERVERMOD_RECEIVE_PORT = 6005       -- the port to listen on for server side messages
KI.Config.SERVERMOD_SEND_TO_PORT = 6006       -- the port to send messages to server side
KI.Config.SERVER_SESSION_RECEIVE_PORT = 6007  -- the port to listen for server side session/server info

-- Your server name (Only really used if supporting multi-tenant game servers) -- no function at this time
KI.Config.ServerName = "Kaukasus Insurgency Server"

-- **no function at this time - the current way of doing this is to include Template in objects you wish to have ignored by KI

-- list of template groups / objects that are to be ignored by KI
-- any objects that match these names will be ignored in stuff like Save Game writing/reading
KI.Config.Templates = 
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
}

-- configures capture points in mission
KI.Config.CP =
{
  { name = "Beslan Airport", zone = "Beslan Airport Zone", spawnzone = "Beslan Airport Spawn Zone", type = "AIRPORT" },
  { name = "Nalchik Airport", zone = "Nalchik Airport Zone", spawnzone = "Spawn Zone B", type = "AIRPORT" },
  
  { name = "FARP Skala", zone = "FARP Skala Zone", spawnzone = "Vladikavkaz City Spawn Zone", type = "FARP" },
  { name = "FARP Vetka", zone = "FARP Vetka Zone", spawnzone = "Spawn Zone C", type = "FARP" },
  
  { name = "Zamankul City", zone = "Zamankul Zone", spawnzone = "Zamankul Spawn Zone", type = "CAPTUREPOINT"},
  { name = "Chikola City", zone = "Chikola City Zone", spawnzone = "Chikola City Spawn Zone", type = "CAPTUREPOINT"},
  { name = "Tskhinvali City", zone = "Tskhinvali City Zone", spawnzone = "Tskhinvali City Spawn Zone", type = "CAPTUREPOINT"},
  { name = "Java Village", zone = "Java Zone", spawnzone = "Java Spawn Zone", type = "CAPTUREPOINT"},
  { name = "Mizur Village", zone = "Mizur Zone", spawnzone = "Alagir City Spawn Zone", type = "CAPTUREPOINT"},
  { name = "Buron Village", zone = "Buron Zone", spawnzone = "Alagir City Spawn Zone", type = "CAPTUREPOINT"},
  { name = "Alagir City", zone = "Alagir City Zone", spawnzone = "Alagir City Spawn Zone", type = "CAPTUREPOINT"},
  { name = "Vladikavkaz City", zone = "Vladikavkaz City Zone", spawnzone = "Vladikavkaz City Spawn Zone", type = "CAPTUREPOINT"},
  { name = "Beslan City", zone = "Beslan City Zone", spawnzone = "Beslan City Spawn Zone", type = "CAPTUREPOINT" },
  { name = "Digora City", zone = "Digora City Zone", spawnzone = "Kirovo City Spawn Zone", type = "CAPTUREPOINT" },
  { name = "Kirovo City", zone = "Kirovo City Zone", spawnzone = "Kirovo City Spawn Zone", type = "CAPTUREPOINT" },
  { name = "Kazbegi Village", zone = "Kazbegi Zone", spawnzone = "Spawn Zone A", type = "CAPTUREPOINT" },
  { name = "Garbani Village", zone = "Garbani Zone", spawnzone = "Kirovo City Spawn Zone", type = "CAPTUREPOINT" },
  { name = "Zhemtala Village", zone = "Zhemtala Zone", spawnzone = "Spawn Zone B", type = "CAPTUREPOINT" }
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

