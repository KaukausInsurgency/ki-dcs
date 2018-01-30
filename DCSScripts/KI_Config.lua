-- Configuration for Kaukausus Insurgency
if not KI then
  KI = {}
end

KI.Config = {}

-- Controls the maximum lifetime of a crate sitting idle at a depot until it is despawned
KI.Config.CrateDespawnTime_Depot = KI.Toolbox.MinutesToSeconds(15)  

-- Controls the maximum lifetime of a crate/troops sitting idle in the wild until it is despawned
KI.Config.CrateDespawnTime_Wild = KI.Toolbox.MinutesToSeconds(30)  

-- Controls the rate at which data transmissions are sent to the server mod
KI.Config.DataTransmissionPlayerUpdateRate = 5        -- things like player data
KI.Config.DataTransmissionGameEventsUpdateRate = 10   -- game events
KI.Config.DataTransmissionGeneralUpdateRate = 20      -- things like depot, and capture point data

-- Controls the time at which groups will be tasked with waypoints when they are respawned via KI.Loader.LoadData() - delay is required!
KI.Config.RespawnTimeBeforeWaypointTasking = 20

-- Controls the rate at which mission data is saved to file
KI.Config.SaveMissionRate = KI.Toolbox.MinutesToSeconds(5)

-- Controls the rate at which all capture points are updated/managed by KI Engine
KI.Config.CPUpdateRate = 15

-- Controls the rate at which we check if a player is in a zone and display message to them
KI.Config.PlayerInZoneCheckRate = 3

-- controls the rate at which side missions are generated and/or managed from the queue
KI.Config.SideMissionUpdateRate = KI.Toolbox.MinutesToSeconds(30)  

-- adds a randomness increment time to the update rate each run through
KI.Config.SideMissionUpdateRateRandom = KI.Toolbox.MinutesToSeconds(15)  

-- controls the maximum amount of active side missions can run at a time
KI.Config.SideMissionsMax = 1

-- controls the maximum amount of time a side mission can remain active
KI.Config.SideMissionMaxTime = KI.Toolbox.HoursToSeconds(1)  

-- controls when the side missions .destroy method is invoked after the mission has already ended
KI.Config.SideMissionsDestroyTime = KI.Toolbox.MinutesToSeconds(15) 

-- parent folder of saved game files
KI.Config.ParentFolder = "Missions\\KIAlpha\\"

-- path to saved game file
KI.Config.PathMissionData = lfs.writedir() .. KI.Config.ParentFolder .. "KI_Entities.lua"

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
KI.Config.DepotMinCapacityToResupply = 0.6

-- The number of units a convoy will resupply to a depot (distributing this amount equally among all items)
KI.Config.ResupplyConvoyAmount = 40

-- Determines the rate at which depots are checked if they need to be resupplied
KI.Config.DepotResupplyCheckRate = KI.Toolbox.MinutesToSeconds(7) 

-- Determines the rate at which active convoys are checked if alive or completed waypoint
KI.Config.ResupplyConvoyCheckRate = KI.Toolbox.MinutesToSeconds(2) 

-- Determines when a convoy has reached a depot to resupply it 
-- (this ideally should match KI.Config.RespawnUnitWaypointDistance because on respawn, if this value is less the respawned unit
-- will not be tasked with a move waypoint, causing the convoy to be stuck in a never completed state
KI.Config.ConvoyMinimumDistanceToDepot = KI.Config.RespawnUnitWaypointDistance

-- Determines whether F10 Map Markers will be rendered for all depot positions - true turns this on
KI.Config.DisplayDepotMarkers = false

-- Determines whether F10 Map Markers will be rendered for all capture point positions - true turns this on
KI.Config.DisplayCapturePointMarkers = true 

KI.Config.Depots =
{
  { name = "Urvan Depot", supplier = true },
  { name = "Troickaya Depot", supplier = true },
}

-- configures capture points in mission
KI.Config.CP =
{
  { name = "Beslan Airport", zone = "Beslan Airport Zone", spawnzone1 = "Beslan Vehicle Spawn", spawnzone2 = "Beslan Infantry Spawn", 
    type = "AIRPORT", text = "Tower Frequencies<br/>  - 141.000 MHz<br/>  - 42.400 MHz<br/>  - 270.000 MHz<br/>  - 4.750 MHz",
    capacity = 30,
    slots = 
    {
      "Beslan-Su25T-1",
      "Beslan-Su25T-2",
      "Beslan-AJS37-1",
      "Beslan-AJS37-2",
	  "Beslan-A10C-1",
	  "Beslan-A10C-2",
	  "Beslan-A10A-1",
	  "Beslan-A10A-2",
	  "Beslan-AV8B-1",
	  "Beslan-AV8B-2",
	  "Beslan-F5E3-1",
	  "Beslan-F5E3-2",
    } 
  },
  { name = "Nalchik Airport", zone = "Nalchik Airport Zone", spawnzone1 = nil, spawnzone2 = nil, 
    type = "AIRPORT", text = "Tower Frequencies<br/>  - 136.000 MHz<br/>  - 41.400 MHz<br/>  - 265.000 MHz<br/>  - 4.500 MHz",
    capacity = 30,
    slots =
    {
      "Nalchik-Su25-1",
      "Nalchik-Su25-2",
      "Nalchik-M2000C-1",
      "Nalchik-M2000C-2",
      "Nalchik-Mig21-1",
      "Nalchik-Mig21-2",
	  "Nalchik-A10C-1",
	  "Nalchik-A10C-2",
	  "Nalchik-AJS37-1",
	  "Nalchik-AJS37-2",
	  "Nalchik-Su25T-1",
	  "Nalchik-Su25T-2",
	  "Nalchik-AV8B-1",
	  "Nalchik-AV8B-2",
    } 
  },
  
  { name = "FARP Skala", zone = "FARP Skala Zone", spawnzone1 = "Vehicle Spawn A", spawnzone2 = "FARP Skala Infantry Spawn", 
    type = "FARP", text = "Tower Frequency - 133.500 MHz AM",
    capacity = 30,
    slots = 
    {
      "Skala-Ka50-1",
      "Skala-Ka50-2",
      "Skala-Ka50-3",
      "Skala-Ka50-4",
      "Skala-Mi8-1",
      "Skala-Mi8-2",
      "Skala-Mi8-3",
      "Skala-Mi8-4",
      "Skala-UH1H-1",
      "Skala-UH1H-2",
      "Skala-UH1H-3",
      "Skala-UH1H-4",
	  "Skala-SA342L-1",
	  "Skala-SA342L-2",
	  "Skala-SA342M-1",
	  "Skala-SA342M-2"
    }
  },
  { name = "FARP Vetka", zone = "FARP Vetka Zone", spawnzone1 = "FARP Vetka Vehicle Spawn", spawnzone2 = "FARP Vetka Infantry Spawn",
    type = "FARP", text = "Tower Frequency - 127.500 MHz AM",
    capacity = 30,
    slots = 
    {
      "Vetka-Ka50-1",
      "Vetka-Ka50-2",
      "Vetka-Ka50-3",
      "Vetka-Ka50-4",
      "Vetka-Mi8-1",
      "Vetka-Mi8-2",
      "Vetka-Mi8-3",
      "Vetka-Mi8-4",
      "Vetka-UH1H-1",
      "Vetka-UH1H-2",
      "Vetka-UH1H-3",
      "Vetka-UH1H-4",
	  "Vetka-SA342L-1",
	  "Vetka-SA342L-2",
	  "Vetka-SA342M-1",
	  "Vetka-SA342M-2"
    }
  },
  { name = "FARP Torba", zone = "FARP Torba Zone", spawnzone1 = nil, spawnzone2 = nil,
    type = "FARP", text = "Tower Frequency - 129.000 MHz AM",
    capacity = 30,
    slots = 
    {
      "Torba-Ka50-1",
      "Torba-Ka50-2",
      "Torba-Ka50-3",
      "Torba-Ka50-4",
      "Torba-Mi8-1",
      "Torba-Mi8-2",
      "Torba-Mi8-3",
      "Torba-Mi8-4",
      "Torba-UH1H-1",
      "Torba-UH1H-2",
      "Torba-UH1H-3",
      "Torba-UH1H-4",
	  "Torba-SA342L-1",
	  "Torba-SA342L-2",
	  "Torba-SA342M-1",
	  "Torba-SA342M-2"
    }
  },
  
  { name = "Kazbegi Village", zone = "Kazbegi Zone", capacity = 30, spawnzone1 = "Kazbegi Vehicle Spawn", spawnzone2 = "Kazbegi Infantry Spawn", type = "CAPTUREPOINT"},
  { name = "Garbani Village", zone = "Garbani Zone", capacity = 30, spawnzone1 = "Garbani Vehicle Spawn", spawnzone2 = "Garbani Infantry Spawn", type = "CAPTUREPOINT" },
  { name = "Mizur Village", zone = "Mizur Zone", capacity = 30, spawnzone1 = "Vehicle Spawn B", spawnzone2 = "Infantry Spawn A", type = "CAPTUREPOINT"},
  { name = "Buron Village", zone = "Buron Zone", capacity = 30, spawnzone1 = "Vehicle Spawn B", spawnzone2 = "Infantry Spawn A", type = "CAPTUREPOINT"},
  { name = "Zamankul City", zone = "Zamankul Zone", capacity = 30, spawnzone1 = "Zamankul Vehicle Spawn", spawnzone2 = "Zamankul Infantry Spawn", type = "CAPTUREPOINT"},
  { name = "Vladikavkaz City", zone = "Vladikavkaz City Zone", capacity = 30, spawnzone1 = "Vladikavkaz Vehicle Spawn", spawnzone2 = "Vladikavkaz Infantry Spawn", type = "CAPTUREPOINT"},
  { name = "Chikola City", zone = "Chikola City Zone", capacity = 30, spawnzone1 = "Chikola Vehicle Spawn", spawnzone2 = "Chikola Infantry Spawn", type = "CAPTUREPOINT"},
  { name = "Alagir City", zone = "Alagir City Zone", capacity = 30, spawnzone1 = "Vehicle Spawn A", spawnzone2 = "Alagir Infantry Zone", type = "CAPTUREPOINT"},
  { name = "Digora City", zone = "Digora City Zone", capacity = 30, spawnzone1 = "Vehicle Spawn A", spawnzone2 = "Digora Infantry Spawn", type = "CAPTUREPOINT" },
  { name = "Kirovo City", zone = "Kirovo City Zone", capacity = 30, spawnzone1 = "Vehicle Spawn A", spawnzone2 = "Kirovo Infantry Spawn", type = "CAPTUREPOINT" },
  { name = "Beslan City", zone = "Beslan City Zone", capacity = 30, spawnzone1 = "Beslan Vehicle Spawn", spawnzone2 = "Beslan Infantry Spawn", type = "CAPTUREPOINT" },
  { name = "Zhemtala Village", zone = "Zhemtala Zone", capacity = 30, spawnzone1 = "Zhemtala Vehicle Spawn", spawnzone2 = "Zhemtala Infantry Spawn", type = "CAPTUREPOINT" }
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
        KI.Toolbox.MessageRedCoalition("ALERT!! NEW MISSION - Destroy the Insurgent Camp that has been uncovered!")
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
        KI.Toolbox.MessageRedCoalition("MISSION COMPLETE - " .. missionName .. " - THE CAMP HAS BEEN SUCCESSFULLY DESTROYED!")
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
        KI.Toolbox.MessageRedCoalition("MISSION FAILED - " .. missionName .. " - TIME HAS RUN OUT!")
      end
  }
  
}

