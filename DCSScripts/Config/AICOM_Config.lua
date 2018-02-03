--[[
AI Commander Configuration

Configuration file for AICOM.lua

Author: Igneous01

]]--

if not AICOM then
  AICOM = {}
end

AICOM.Config = {}
AICOM.Config.OnSpawnGroup = nil  							-- callback method when the AI Commander spawns a unit (with arguments: MOOSE:GROUP and DCSVec3)
AICOM.Config.TurnRate = KI.Toolbox.MinutesToSeconds(45)     -- the rate at which the AI Commander can make moves/actions
AICOM.Config.InitMoves = 3      							-- the number of moves the AI Commander can make a turn
AICOM.Config.InitResource = 150 							-- the number of units/resources the AI Commander has access to per turn
AICOM.Config.PopulationCap = 240    						-- the amount of enemy units that can be on the map, if this limit is reached AICOM will skip it's turn
AICOM.Config.Random = math.random   						-- the random function to use (can supply with mock function for Unit Testing)
AICOM.Config.AmbushProbability = 15 						-- the probability of the AI doing an ambush action on it's third turn

-- collection of zones the AI will randomly select for an ambush
AICOM.Config.AmbushZones = 
{
  "AmbushZone1", 
  "AmbushZone2", 
  "AmbushZone3", 
  "AmbushZone4", 
  "AmbushZone5", 
  "AmbushZone6", 
  "AmbushZone7",
  "AmbushZone8",
  "AmbushZone9"
}       
AICOM.Config.AmbushCost = 30        -- max cost the AI will spend on an ambush action
AICOM.Config.AmbushTime = KI.Toolbox.MinutesToSeconds(30) -- the amount of time the units will wait in the ambush zone before being despawned

AICOM.Config.Forces =
{
  {
    Name = "Infantry Section",
    Templates = { "InsInfSqdA", "InsInfSqdB" }, -- group templates to use
    Cost = 4,              -- cost to play / use
    Strength = 10,          -- Strength in number of units generated
    AAEffectiveness = 5,    -- Effectiveness against air units
    GNDEffectiveness = 10,  -- Effectiveness against ground units
    SpawnZone = 2,          -- Which spawn zone will be selected (values are either 1 or 2) - these link to CP.SpawnZone1 and CP.SpawnZone2
    Formation = "Off Road", -- When spawned, the waypoint formation to use
    Speed = 10              -- When spawned, the waypoint speed
  },
  {
    Name = "MANPAD Section",
    Templates = { "InsMANPADSqd", "InsMANPADSqd" },
    Cost = 21,
    Strength = 6,
    AAEffectiveness = 75,
    GNDEffectiveness = 1,
    SpawnZone = 2,
    Formation = "Off Road",
    Speed = 10
  },
  {
    Name = "T-55 Platoon",
    Templates = { "InsT55Plt" },
    Cost = 25,
    Strength = 4,
    AAEffectiveness = 15,
    GNDEffectiveness = 50,
    SpawnZone = 1,
    Formation = "On Road",
    Speed = 30
  },
  {
    Name = "T-72B Platoon",
    Templates = { "InsT72BPlt" },
    Cost = 35,
    Strength = 4,
    AAEffectiveness = 16,
    GNDEffectiveness = 70,
    SpawnZone = 1,
    Formation = "On Road",
    Speed = 30
  },
  
  {
    Name = "BMP1 Platoon",
    Templates = { "InsBMP1Plt" },
    Cost = 18,
    Strength = 8,
    AAEffectiveness = 18,
    GNDEffectiveness = 41,
    SpawnZone = 1,
    Formation = "On Road",
    Speed = 30
  },
  {
    Name = "BMP2 Platoon",
    Templates = { "InsBMP2Plt" },
    Cost = 22,
    Strength = 8,
    AAEffectiveness = 25,
    GNDEffectiveness = 45,
    SpawnZone = 1,
    Formation = "On Road",
    Speed = 30
  },
  {
    Name = "BUK Platoon",
    Templates = { "InsBukPlt" },
    Cost = 40,
    Strength = 5,
    AAEffectiveness = 100,
    GNDEffectiveness = 0,
    SpawnZone = 1,
    Formation = "On Road",
    Speed = 30
  },
  {
    Name = "ZSU Platoon",
    Templates = { "InsAAAPlt" },
    Cost = 17,
    Strength = 4,
    AAEffectiveness = 60,
    GNDEffectiveness = 40,
    SpawnZone = 1,
    Formation = "On Road",
    Speed = 30
  },
  {
    Name = "SA-8 / SA-9 Platoon",
    Templates = { "InsSAMPlt" },
    Cost = 32,
    Strength = 4,
    AAEffectiveness = 80,
    GNDEffectiveness = 0,
    SpawnZone = 1,
    Formation = "On Road",
    Speed = 30
  }, 
  {
    Name = "Motorized Recce Platoon",
    Templates = { "InsReccePlt" },
    Cost = 8,
    Strength = 4,
    AAEffectiveness = 11,
    GNDEffectiveness = 30,
    SpawnZone = 1,
    Formation = "On Road",
    Speed = 30
  },
  {
    Name = "Motorized AAA Platoon",
    Templates = { "InsAAAReccePlt" },
    Cost = 15,
    Strength = 4,
    AAEffectiveness = 45,
    GNDEffectiveness = 24,
    SpawnZone = 1,
    Formation = "On Road",
    Speed = 30
  },
}
