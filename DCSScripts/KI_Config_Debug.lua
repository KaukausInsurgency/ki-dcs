-- Configuration for Kaukausus Insurgency
if not KI then
  KI = {}
end

KI.Config = {}

-- The side of the allies (Players) - 1 is RED, 2 is BLUE
KI.Config.AllySide = 1

-- The country ID to use when spawning allied cargo (required by coalition.AddStaticObject)
KI.Config.AllyCountryID = country.id.RUSSIA

-- The country name string to use when spawning allied cargo (required by coalition.AddStaticObject)
KI.Config.AllyCountryName = "Russia"

-- The side of the insurgents (AI) - 1 is RED, 2 IS BLUE
KI.Config.InsurgentSide = 2

-- Controls the maximum lifetime of a crate sitting idle at a depot until it is despawned
KI.Config.CrateDespawnTime_Depot = 120

-- Controls the maximum lifetime of a crate/troops sitting idle in the wild until it is despawned
KI.Config.CrateDespawnTime_Wild = 300

-- Controls the rate at which data transmissions are sent to the server mod
KI.Config.DataTransmissionPlayerUpdateRate = 5        -- things like player data
KI.Config.DataTransmissionGameEventsUpdateRate = 10   -- game events
KI.Config.DataTransmissionGeneralUpdateRate = 20      -- things like depot, and capture point data

-- Controls the time at which groups will be tasked with waypoints when they are respawned via KI.Loader.LoadData() - delay is required!
KI.Config.RespawnTimeBeforeWaypointTasking = 20

-- Controls the rate at which mission data is saved to file
KI.Config.SaveMissionRate = 300

-- Controls the rate at which all capture points are updated/managed by KI Engine
KI.Config.CPUpdateRate = 15

-- Controls the rate at which we check if a player is in a zone and display message to them
KI.Config.PlayerInZoneCheckRate = 10

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
KI.Config.PathMissionData = lfs.writedir() .. KI.Config.ParentFolder .. "KI_Entities_DEBUG.lua"

-- path to gameevent files
KI.Config.PathGameEvents = lfs.writedir() .. KI.Config.ParentFolder .. "GameEvents"

-- path to slingload event files
KI.Config.PathSlingloadEvents = lfs.writedir() .. KI.Config.ParentFolder .. "SlingloadEvents"

-- UDP Port Numbers to communicate with the server side mod
KI.Config.SERVERMOD_RECEIVE_PORT = 6005       -- the port to listen on for server side messages
KI.Config.SERVERMOD_SEND_TO_PORT = 6006       -- the port to send messages to server side
KI.Config.SERVER_SESSION_RECEIVE_PORT = 6007  -- the port to listen for server side session/server info

-- Determines whether the respawned ground group needs to be retasked it's waypoint based on it's current distance to it
KI.Config.RespawnUnitWaypointDistance = 200

-- Determines when a depot will request a convoy resupply - values range from 0 to 1. For 50% capacity use 0.5
KI.Config.DepotMinCapacityToResupply = 0.5

-- The number of units a convoy will resupply to a depot (distributing this amount equally among all items)
KI.Config.ResupplyConvoyAmount = 25

-- Determines the rate at which depots are checked if they need to be resupplied
KI.Config.DepotResupplyCheckRate = 60

-- Determines the rate at which active convoys are checked if alive or completed waypoint
KI.Config.ResupplyConvoyCheckRate = 60

-- Determines when a convoy has reached a depot to resupply it 
-- (this ideally should match KI.Config.RespawnUnitWaypointDistance because on respawn, if this value is less the respawned unit
-- will not be tasked with a move waypoint, causing the convoy to be stuck in a never completed state
KI.Config.ConvoyMinimumDistanceToDepot = KI.Config.RespawnUnitWaypointDistance

KI.Config.Depots =
{
  { name = "Urvan Depot", supplier = true },
  { name = "Troickaya Depot", supplier = true },
}

-- configures capture points in mission
KI.Config.CP =
{
  { name = "Beslan Airport", zone = "BeslanAirportZone", spawnzone = "BeslanAirportSpawnZone", type = "AIRPORT" },  
  { name = "Beslan City", zone = "BeslanCityZone", spawnzone = "BeslanCitySpawnZone", type = "CAPTUREPOINT" },
  { name = "Kirovo City", zone = "KirovoCityZone", spawnzone = "KirovoCitySpawnZone", type = "CAPTUREPOINT" },
}

-- configures side missions and their properties
KI.Config.SideMissions =
{
  { 
      -- the name of the side mission - will display in radio item menu as well as on website
      name = "Destroy Insurgent Camp", 
      
      -- the description of the task - supports HTML and will render on website (use <br/> for new line)
      desc = "Recon has uncovered what appears to be an insurgent camp used for recruitment and training.<br/>Command has tasked that this target be destroyed.",
      
      -- the image the website will use when displaying the task, check docs for preset list of images that can be used
      image = "camp",
      
      -- determines the rate at which the task loop function should run
      rate = 30,
      
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
        KI.AddSideMissionObject(CampObj.StaticName)
        KI.Toolbox.MessageCoalition(KI.Config.AllySide, "ALERT!! NEW MISSION - Destroy the Insurgent Camp that has been uncovered!")
        -- create and initialize the task, init must return arguments
        return args
      end,
      
      -- this function tells KI how to destroy/cleanup the side mission
      -- delete and destroy all relevant objects in this function, as well as close any handlers / resources that this side mission may have used
      destroy = function(args)
        -- destroys and cleans up task resources, must return true/false to indicate cleanup succeeded
        env.info("DSMT.destroy called - destroying camp object")
        xpcall(function() args.CampObject:destroy() end,
               function(err) env.info("DSMT.destroy (Destroy Camp) ERROR : " .. err) end)
        
      end,
        
      -- this function tells KI how the side mission is to be considered complete - this function is run every so often to check if the criteria has been met - must return true/false to indicate if task is complete
      complete = function(missionName, chosenZone, args)
        env.info("DSMT.complete called - checking if CampObject is alive")
        return not args.CampObject:isExist()
      end,
      
      -- this function tells KI how the side mission is to be considered failed - this function is run every so often to check if the criteria have been met - must return true/false to indicate if task is failed
      -- you can optionally leave this to return false, then once the timeout expires the mission will be considered failed and the ontimeout will be called
      fail = function(missionName, chosenZone, args)
        env.info("DSMT.fail called")
        return false
      end,
      
      -- this function tells KI what should happen when the side mission is completed
      -- use this function to display messages to all players
      -- no return required
      oncomplete = function(missionName, chosenZone, args)
        env.info("DSMT.oncomplete called")
        KI.Toolbox.MessageCoalition(KI.Config.AllySide, "MISSION COMPLETE - " .. missionName .. " - THE CAMP HAS BEEN SUCCESSFULLY DESTROYED!")
      end,
      
      -- this function tells KI what should happen when the side mission is failed
      -- use this function to display messages to all players
      -- no return required
      onfail = function(missionName, chosenZone, args)
        env.info("DSMT.onfail called")
      end,
      
      -- this function tells KI what should happen when the side mission time runs out
      -- use this function to display messages to all players
      -- no return required
      ontimeout = function(missionName, chosenZone, args)
        env.info("DSMT.ontimeout called")
        KI.Toolbox.MessageCoalition(KI.Config.AllySide, "MISSION FAILED - " .. missionName .. " - TIME HAS RUN OUT!")
      end
  }
  
}

