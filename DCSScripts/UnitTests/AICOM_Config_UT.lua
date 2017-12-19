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
AICOM.Config.AmbushProbability = 10 -- the probability of the AI doing an ambush action on it's third turn
-- collection of zones the AI will randomly select for an ambush
AICOM.Config.AmbushZones = {}       
AICOM.Config.AmbushCost = 30        -- max cost the AI will spend on an ambush action
AICOM.Config.AmbushTime = KI.Toolbox.MinutesToSeconds(30) -- the amount of time the units will wait in the ambush zone before being despawned

AICOM.Config.Forces = {}
