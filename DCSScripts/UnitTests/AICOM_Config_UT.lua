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
AICOM.Config.TurnRate = 120     -- the rate at which the AI Commander can make moves/actions
AICOM.Config.InitMoves = 3      -- the number of moves the AI Commander can make a turn
AICOM.Config.InitResource = 100 -- the number of units/resources the AI Commander has access to per turn
AICOM.Config.AmbushProbability = 10 -- the probability of the AI doing an ambush action on it's third turn
AICOM.Config.PopulationCap = 20     -- the amount of enemy units that can be on the map, if this limit is reached AICOM will skip it's turn
AICOM.Config.Random = math.random   -- the random function to use (can supply with mock function for Unit Testing)
AICOM.Config.AmbushPoints = {}

AICOM.Config.Forces =
{
  {
    Name = "Infantry Platoon",
    Templates = { "InsInfSqdA", "InsInfSqdB", "InsInfSqdA", "InsInfSqdA" }, -- group templates to use
    Cost = 30,            -- cost to play / use
    Strength = 40,        -- Strength in number of units generated
    AAEffectiveness = 5,  -- Effectiveness against air units
    GNDEffectiveness = 20 -- Effectiveness against ground units
  },
  {
    Name = "MANPAD Section",
    Templates = { "InsMANPADSqd", "InsMANPADSqd", "InsInfSqdA" },
    Cost = 15,
    Strength = 16,
    AAEffectiveness = 75,
    GNDEffectiveness = 5
  },
  {
    Name = "Tank Platoon",
    Templates = { "InsTankPlt1", "InsTankPlt1" },
    Cost = 20,
    Strength = 8,
    AAEffectiveness = 15,
    GNDEffectiveness = 45
  },
  {
    Name = "BMP Platoon",
    Templates = { "InsMechPlt1", "InsMechPlt2" },
    Cost = 20,
    Strength = 8,
    AAEffectiveness = 25,
    GNDEffectiveness = 25
  },
}
