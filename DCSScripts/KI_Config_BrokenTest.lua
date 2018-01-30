-- Configuration for Kaukausus Insurgency

-- This configuration file is purposely made broken with invalid values and missing items to test ConfigChecker
if not KI then
  KI = {}
end

KI.Config = {}

-- Controls the maximum lifetime of a crate sitting idle at a depot until it is despawned
KI.Config.CrateDespawnTime_Depot = -20

-- Controls the rate at which data transmissions are sent to the server mod
KI.Config.DataTransmissionPlayerUpdateRate = 1        -- things like player data
KI.Config.DataTransmissionGameEventsUpdateRate = 2   -- game events
KI.Config.DataTransmissionGeneralUpdateRate = 300      -- things like depot, and capture point data

-- Controls the rate at which mission data is saved to file
KI.Config.SaveMissionRate = 25

-- Controls the rate at which all capture points are updated/managed by KI Engine
KI.Config.CPUpdateRate = 1

-- Controls the rate at which we check if a player is in a zone and display message to them
KI.Config.PlayerInZoneCheckRate = 43

-- adds a randomness increment time to the update rate each run through
KI.Config.SideMissionUpdateRateRandom = 0


-- controls the maximum amount of time a side mission can remain active
KI.Config.SideMissionMaxTime =  120

-- parent folder of saved game files
KI.Config.ParentFolder = "Missions\\Random\\"

-- path to saved game file
KI.Config.PathMissionData = lfs.writedir() .. KI.Config.ParentFolder .. "KI_Entities.lua"

-- path to gameevent files
KI.Config.PathGameEvents = lfs.writedir() .. KI.Config.ParentFolder .. "GameEventsRR"

-- path to slingload event files
KI.Config.PathSlingloadEvents = lfs.writedir() .. KI.Config.ParentFolder .. "SlingloadEventsWEQ"

-- UDP Port Numbers to communicate with the server side mod
KI.Config.SERVERMOD_RECEIVE_PORT = 80       -- the port to listen on for server side messages
KI.Config.SERVERMOD_SEND_TO_PORT = 81       -- the port to send messages to server side

-- Determines whether the respawned ground group needs to be retasked it's waypoint based on it's current distance to it
KI.Config.RespawnUnitWaypointDistance = 25

-- Determines when a depot will request a convoy resupply - values range from 0 to 1. For 50% capacity use 0.5
KI.Config.DepotMinCapacityToResupply = 0.95


-- Determines whether F10 Map Markers will be rendered for all capture point positions - true turns this on
KI.Config.DisplayCapturePointMarkers = 3187 

KI.Config.Depots =
{
  { name = "Urvan Depot 3443", supplier = true },
  { name = "Troickaya Depot", supplier = true },
}

-- configures capture points in mission
KI.Config.CP =
{
  { name = "Beslan Airport", zone = "Beslan Airport Zone", spawnzone1 = nil, spawnzone2 = "Beslan Infantry Spawn", 
    type = "AIRPORT", text = "Tower Frequencies<br/>  - 141.000 MHz<br/>  - 42.400 MHz<br/>  - 270.000 MHz<br/>  - 4.750 MHz",
    capacity = 30,
    slots = 
    {
      "Beslan-Su25T-1",
      "Beslan-Su25T-2",
      "Beslan-Su27-1",
      "Beslan-Su27-8",
    } 
  },
  { name = "Nalchik Airport", zone = "Nalchik Airport Zone", spawnzone1 = nil, spawnzone2 = nil, 
    type = "AIRPORT", text = "Tower Frequencies<br/>  - 136.000 MHz<br/>  - 41.400 MHz<br/>  - 265.000 MHz<br/>  - 4.500 MHz",
    capacity = 30,
    slots =
    {
      "Nalchik-Mig29-1",
      "Nalchik-Mig29-2",
      "Nalchik-M2000C-1",
      "Nalchik-M234000C-2",
      "Nalchik-Mig21-1",
      "Nalchik-Mig21-2"
    } 
  },
  
  { name = "FARP Skala", zone = "FARP Skala", spawnzone1 = "Vehicle Spawn A", spawnzone2 = "FARP Skala Infantry Spawn", 
    type = "FARP", text = "Tower Frequency - 127.500 MHz AM",
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
      "Skala-UH1H-4"
    }
  },
  { name = "FARP Vetka", zone = "FARP Vetka Zone", spawnzone1 = "FARP Vetka Vehicle Spawn", spawnzone2 = "FARP Vetka Infantry Spawn",
    type = "FARP", text = "Tower Frequency - 133.500 MHz AM",
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
      "Vetka-UH2461H-4"
    }
  },
  
  
  
  { name = "Tskhinvali City", zone = "Tskhinvali City Zone", capacity = 30, spawnzone1 = "Tskhinvali City Spawn Zone", spawnzone2 = "Tskhinvali City Spawn Zone", type = "CAPTUREPOINT"},
  { name = "Java Village", zone = "Java Zone", capacity = 30, spawnzone1 = "Java Spawn Zone", spawnzone2 = "Java Spawn Zone", type = "geag"},
  
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
        
      desc = "",
      
      -- the image the website will use when displaying the task, check docs for preset list of images that can be used
      image = "camp",
      
      -- determines the rate at which the task loop function should run
      rate = 30,
      
      -- the list of zones that this side mission can use (will be randomly picked)
      zones = { "InsCampZone1", "InsC341ampZone2", "InsCampZone3", "InsCampZone4" },
      
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
        
      -- this function tells KI how the side mission is to be considered complete - this function is run every so often to check if the criteria has been met - must return true/false to indicate if task is complete
      complete = 25,
      
      -- this function tells KI what should happen when the side mission is completed
      -- use this function to display messages to all players
      -- no return required
      oncomplete = false,
      
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

