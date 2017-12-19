--[[
AI Commander Configuration

Configuration file for AICOM.lua

Author: Igneous01

]]--

if not AICOM then
  AICOM = {}
end

AICOM.Config = {}
AICOM.Config.OnSpawnGroup = nil  -- callback method when the AI Commander spawns a unit (with arguments: MOOSE:GROUP and DCSVec3)
AICOM.Config.TurnRate = 600     -- the rate at which the AI Commander can make moves/actions
AICOM.Config.InitMoves = 3      -- the number of moves the AI Commander can make a turn
AICOM.Config.InitResource = 125 -- the number of units/resources the AI Commander has access to per turn
AICOM.Config.PopulationCap = 100    -- the amount of enemy units that can be on the map, if this limit is reached AICOM will skip it's turn
AICOM.Config.Random = math.random   -- the random function to use (can supply with mock function for Unit Testing)
AICOM.Config.AmbushProbability = 25 -- the probability of the AI doing an ambush action on it's third turn

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
    Name = "Infantry Platoon",
    Templates = { "InsInfSqdA", "InsInfSqdB" }, -- group templates to use
    Cost = 30,              -- cost to play / use
    Strength = 20,          -- Strength in number of units generated
    AAEffectiveness = 5,    -- Effectiveness against air units
    GNDEffectiveness = 20,  -- Effectiveness against ground units
    SpawnZone = 2,          -- Which spawn zone will be selected (values are either 1 or 2) - these link to CP.SpawnZone1 and CP.SpawnZone2
    Formation = "Off Road", -- When spawned, the waypoint formation to use
    Speed = 10              -- When spawned, the waypoint speed
  },
  {
    Name = "MANPAD Section",
    Templates = { "InsMANPADSqd", "InsMANPADSqd" },
    Cost = 15,
    Strength = 6,
    AAEffectiveness = 75,
    GNDEffectiveness = 5,
    SpawnZone = 2,
    Formation = "Off Road",
    Speed = 10
  },
  {
    Name = "Tank Platoon",
    Templates = { "InsTankPlt1" },
    Cost = 20,
    Strength = 4,
    AAEffectiveness = 15,
    GNDEffectiveness = 45,
    SpawnZone = 1,
    Formation = "On Road",
    Speed = 30
  },
  {
    Name = "BMP Platoon",
    Templates = { "InsMechPlt1", "InsMechPlt2" },
    Cost = 17,
    Strength = 8,
    AAEffectiveness = 25,
    GNDEffectiveness = 25,
    SpawnZone = 1,
    Formation = "On Road",
    Speed = 30
  },
}
