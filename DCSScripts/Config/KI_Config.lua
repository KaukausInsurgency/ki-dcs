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

-- If this is not nil and not an empty string, KI will ignore saving this group to file, and the group will not be respawned on restart
KI.Config.IgnoreSaveGroupPrefix = nil

-- Controls the rate at which all capture points are updated/managed by KI Engine
KI.Config.CPUpdateRate = 15

-- Controls the rate at which we check if a player is in a zone and display message to them
KI.Config.PlayerInZoneCheckRate = 3

-- controls the rate at which side missions are generated and/or managed from the queue
KI.Config.SideMissionUpdateRate = 60 -- KI.Toolbox.MinutesToSeconds(30)  

-- adds a randomness increment time to the update rate each run through
KI.Config.SideMissionUpdateRateRandom = 60 -- KI.Toolbox.MinutesToSeconds(15)  

-- controls the maximum amount of active side missions can run at a time
KI.Config.SideMissionsMax = 3

-- controls the maximum amount of time a side mission can remain active
KI.Config.SideMissionMaxTime = KI.Toolbox.HoursToSeconds(1)  

-- controls when the side missions .destroy method is invoked after the mission has already ended
KI.Config.SideMissionsDestroyTime = KI.Toolbox.MinutesToSeconds(15) 

-- parent folder of saved game files
KI.Config.ParentFolder = "Missions\\Kaukasus Insurgency\\"

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

-- Determines whether AI ground units will spawn with the setting 'Dispersion under fire' on or off
-- This is to help get around transport.dll crashes that appear to be linked to this setting
-- If this is ever patched by ED this setting can be turned off
KI.Config.TransportDLLCrashDisableAIDispersionUnderFire = true

KI.Config.Depots =
{
  { name = "Urvan Depot", supplier = true },
  { name = "Troickaya Depot", supplier = true },
}

-- configures capture points in mission
-- for CP of type "AIRPORT" a property airbase is required - this must be the name of the airbase in DCS to spawn airdrops from
-- see http://flightcontrol-master.github.io/MOOSE/Documentation/Airbase.html##(AIRBASE).Caucasus for list of valid enums to use
KI.Config.CP =
{
  { name = "Beslan Airport", zone = "Beslan Airport Zone", spawnzone1 = "Beslan Vehicle Spawn", spawnzone2 = "Beslan Infantry Spawn", 
    type = "AIRPORT", text = "Tower Frequencies<br/>  - 141.000 MHz<br/>  - 42.400 MHz<br/>  - 270.000 MHz<br/>  - 4.750 MHz",
    capacity = 30,
    airbase = AIRBASE.Caucasus.Beslan,
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
    airbase = AIRBASE.Caucasus.Nalchik,
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
        local GroundForces = {}
        
        -- randomly spawn in between 1 and 2 infantry squads
        for i = 1, math.random(2) do
          local SpawnGrp = SPAWN:NewWithAlias("InsCampSquad", KI.GenerateName("Insurgent Camp Force"))
          local NewGroup = SpawnGrp:SpawnInZone(chosenZone, true)
          
          KI.GameUtils.TryDisableAIDispersion(NewGroup)
          table.insert(GroundForces, NewGroup)
        end
        
        -- randomly spawn in between 1 and 2 manpad squads
        for i = 1, math.random(2) do
          local SpawnGrp = SPAWN:NewWithAlias("InsMANPADSqd", KI.GenerateName("Insurgent Camp Force"))
          local NewGroup = SpawnGrp:SpawnInZone(chosenZone, true)
    
          KI.GameUtils.TryDisableAIDispersion(NewGroup)   
          table.insert(GroundForces, NewGroup)
        end
        
        local VehicleTemplates = { "InsReccePlt", "InsAAAReccePlt" }
        local ChosenVehicleTemplate = VehicleTemplates[math.random(#VehicleTemplates)]
        
        local SpawnGrp = SPAWN:NewWithAlias(ChosenVehicleTemplate, KI.GenerateName("Insurgent Camp Force"))
        local NewGroup = SpawnGrp:SpawnInZone(chosenZone, true)
        KI.GameUtils.TryDisableAIDispersion(NewGroup)   
        table.insert(GroundForces, NewGroup)
        
        -- Preparing arguments to send back
        local args = {}
        args.CampObject = CampObj
        args.GroundForces = GroundForces
        
        -- Register the side mission objects so that they are ignored in saving/writing (Side Mission will be restarted on restart)
        -- KI.AddSideMissionObject(CampObj:getName())
        for _, moosegrp in pairs(GroundForces) do
          KI.AddSideMissionObject(moosegrp.GroupName)
        end
        
        KI.GameUtils.MessageCoalition(KI.Config.AllySide, "ALERT!! NEW MISSION - Destroy the Insurgent Camp that has been uncovered!")
        -- create and initialize the task, init must return arguments
        return args
      end,
      
      -- this function tells KI how to destroy/cleanup the side mission
      -- delete and destroy all relevant objects in this function, as well as close any handlers / resources that this side mission may have used
      destroy = function(args)
        -- destroys and cleans up task resources, must return true/false to indicate cleanup succeeded
        env.info("DSMT.destroy called - destroying camp object")
        xpcall(function() 
        
          -- invoke MOOSEGRP:Destroy() on any groups that are still alive
          for _, moosegrp in pairs(args.GroundForces) do
            if moosegrp:IsAlive() then
              moosegrp:Destroy()
            end
          end
          
          -- invoke DCSStatic:destroy() if static object is still alive
          -- SPAWNSTATIC returns DCS StaticObject type
          if args.CampObject:isExist() then
            args.CampObject:destroy()
          end
        end, function(err) env.info("DSMT.destroy (Destroy Camp) ERROR : " .. err) end)
        
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
        KI.GameUtils.MessageCoalition(KI.Config.AllySide, "MISSION COMPLETE - " .. missionName .. " - THE CAMP HAS BEEN SUCCESSFULLY DESTROYED!")
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
        KI.GameUtils.MessageCoalition(KI.Config.AllySide, "MISSION FAILED - " .. missionName .. " - TIME HAS RUN OUT!")
      end
  },
  { 
      name = "Destroy Convoy Heading to Coban", 
      desc = "Recon has reported sightings of an enemy convoy in Mayramadag, heading towards the village of Coban.<br/>Command has tasked that this convoy be destroyed to minimize the enemies ability to resupply.",
      image = "camp",
      rate = 30,
      zones = { "ConvoyA Zone" },
      init = function(missionName, chosenZone)
        env.info("DSMT.init called - creating side mission " .. missionName)
       
        local SpawnGrp = SPAWN:NewWithAlias("InsConvoyA", KI.GenerateName("Insurgent Convoy"))
        local Convoy = SpawnGrp:SpawnWithIndex(KI.IncrementSpawnID())
        KI.GameUtils.TryDisableAIDispersion(Convoy)   
        
        -- Preparing arguments to send back
        local args = {}
        args.Convoy = Convoy
        args.DestZone = ZONE:New("ConvoyA Zone")
        
        -- Register the side mission objects so that they are ignored in saving/writing (Side Mission will be restarted on restart)
        KI.AddSideMissionObject(Convoy.GroupName)
        
        KI.GameUtils.MessageCoalition(KI.Config.AllySide, "ALERT!! NEW MISSION - Destroy the Insurgent Convoy that has been spotted heading towards Coban!")
        -- create and initialize the task, init must return arguments
        return args
      end,
      
      destroy = function(args)
        env.info("DSMT.destroy called - destroying convoy object")
        xpcall(function() 
          if args.Convoy:IsAlive() then
            args.Convoy:Destroy()
          end
        end, function(err) env.info("DSMT.destroy (Destroy Convoy) ERROR : " .. err) end)
        
      end,
        
      complete = function(missionName, chosenZone, args)
        env.info("DSMT.complete called - checking if Convoy is alive")
        return not args.Convoy:IsAlive()
      end,
      
      fail = function(missionName, chosenZone, args)
        return args.Convoy:IsPartlyInZone(args.DestZone)
      end,
      
      oncomplete = function(missionName, chosenZone, args)
        env.info("DSMT.oncomplete called")
        KI.GameUtils.MessageCoalition(KI.Config.AllySide, "MISSION COMPLETE - " .. missionName .. " - THE CONVOY HAS BEEN SUCCESSFULLY DESTROYED!")
      end,
      
      onfail = function(missionName, chosenZone, args)
        env.info("DSMT.onfail called")
        KI.GameUtils.MessageCoalition(KI.Config.AllySide, "MISSION FAILED - " .. missionName .. " - THE CONVOY SUCCESSFULLY REACHED ITS DESTINATION!")
      end,
      
      ontimeout = function(missionName, chosenZone, args)
        env.info("DSMT.ontimeout called")
        KI.GameUtils.MessageCoalition(KI.Config.AllySide, "MISSION FAILED - " .. missionName .. " - TIME HAS RUN OUT!")
      end
  },
  { 
      name = "Destroy Convoy Heading to Gerpegezh", 
      desc = "Recon has reported sightings of an enemy armored convoy in the mountains north of Verh. Balkanya, heading towards the village of Gerpegezh. Command has tasked that this convoy be destroyed. The convoy is escorted by self-propelled AAA and Vehicle SAM based systems.",
      image = "camp",
      rate = 30,
      zones = { "ConvoyB Zone" },
      init = function(missionName, chosenZone)
        env.info("DSMT.init called - creating side mission " .. missionName)
       
        local SpawnGrp = SPAWN:NewWithAlias("InsConvoyB", KI.GenerateName("Insurgent Convoy"))
        local Convoy = SpawnGrp:SpawnWithIndex(KI.IncrementSpawnID())
        KI.GameUtils.TryDisableAIDispersion(Convoy)   
        
        -- Preparing arguments to send back
        local args = {}
        args.Convoy = Convoy
        args.DestZone = ZONE:New("ConvoyB Zone")
        
        -- Register the side mission objects so that they are ignored in saving/writing (Side Mission will be restarted on restart)
        KI.AddSideMissionObject(Convoy.GroupName)
        
        KI.GameUtils.MessageCoalition(KI.Config.AllySide, "ALERT!! NEW MISSION - Destroy the Insurgent Convoy that has been spotted heading towards Gerpegezh!")
        -- create and initialize the task, init must return arguments
        return args
      end,
      
      destroy = function(args)
        env.info("DSMT.destroy called - destroying convoy object")
        xpcall(function() 
          if args.Convoy:IsAlive() then
            args.Convoy:Destroy()
          end
        end, function(err) env.info("DSMT.destroy (Destroy Convoy) ERROR : " .. err) end)    
      end,
        
      complete = function(missionName, chosenZone, args)
        env.info("DSMT.complete called - checking if Convoy is alive")
        return not args.Convoy:IsAlive()
      end,
      
      fail = function(missionName, chosenZone, args)
        return args.Convoy:IsPartlyInZone(args.DestZone)
      end,
      
      oncomplete = function(missionName, chosenZone, args)
        env.info("DSMT.oncomplete called")
        KI.GameUtils.MessageCoalition(KI.Config.AllySide, "MISSION COMPLETE - " .. missionName .. " - THE CONVOY HAS BEEN SUCCESSFULLY DESTROYED!")
      end,
      
      onfail = function(missionName, chosenZone, args)
        env.info("DSMT.onfail called")
        KI.GameUtils.MessageCoalition(KI.Config.AllySide, "MISSION FAILED - " .. missionName .. " - THE CONVOY SUCCESSFULLY REACHED ITS DESTINATION!")
      end,
      
      ontimeout = function(missionName, chosenZone, args)
        env.info("DSMT.ontimeout called")
        KI.GameUtils.MessageCoalition(KI.Config.AllySide, "MISSION FAILED - " .. missionName .. " - TIME HAS RUN OUT!")
      end
  },
  { 
      name = "Transport Cargo to Kardzhin Depot", 
      desc = "A sensitive package of equipment requires an airlift to Kardzhin Depot",
      image = "camp",
      rate = 30,
      zones = { "SM Cargo A Zone" },
      init = function(missionName, chosenZone)
        env.info("DSMT.init called - creating side mission " .. missionName)
        local obj = coalition.addStaticObject(KI.Config.AllyCountryID, {
          country = "Russia",
          category = "Cargos",
          x = chosenZone:GetVec3(0).x,
          y = chosenZone:GetVec3(0).z,
          type = "fueltank_cargo",
          name = KI.GenerateName("Side Mission Cargo"),
          mass = 3500,
          canCargo = true
        })
        
        local args = {}
        args.Cargo = obj
        args.DestZone = ZONE:New("Kardzhin Depot Zone")
        
        KI.GameUtils.MessageCoalition(KI.Config.AllySide, "ALERT!! NEW MISSION - Cargo airlift required to Kardzhin Depot!")
        -- create and initialize the task, init must return arguments
        return args
      end,
      
      destroy = function(args)
        env.info("DSMT.destroy called - destroying cargo object")
        xpcall(function() 
          if args.Cargo:isExist() then
            args.Cargo:destroy()
          end
        end, function(err) env.info("DSMT.destroy (cargo) ERROR : " .. err) end)    
      end,
        
      complete = function(missionName, chosenZone, args)
        env.info("DSMT.complete called - checking if cargo is in zone")
        
        -- cargo must be alive, NOT in AIR (or it's velocity less than 5cm a second)
        if args.Cargo:isExist() and (not args.Cargo:inAir() or mist.vec.mag(obj:getVelocity()) < 0.05) then
          return args.DestZone:IsVec3InZone(args.Cargo:getPoint())
        else
          return false
        end
      end,
      
      fail = function(missionName, chosenZone, args)
        return not args.Cargo:isExist()
      end,
      
      oncomplete = function(missionName, chosenZone, args)
        env.info("DSMT.oncomplete called")
        KI.GameUtils.MessageCoalition(KI.Config.AllySide, "MISSION COMPLETE - " .. missionName .. " - SUPPLIES SUCCESSFULLY TRANSPORTED TO KARDZHIN DEPOT!")
      end,
      
      onfail = function(missionName, chosenZone, args)
        env.info("DSMT.onfail called")
        KI.GameUtils.MessageCoalition(KI.Config.AllySide, "MISSION FAILED - " .. missionName .. " - THE SUPPLIES HAVE BEEN DESTROYED!")
      end,
      
      ontimeout = function(missionName, chosenZone, args)
        env.info("DSMT.ontimeout called")
        KI.GameUtils.MessageCoalition(KI.Config.AllySide, "MISSION FAILED - " .. missionName .. " - TIME HAS RUN OUT!")
      end
  }
  
}

