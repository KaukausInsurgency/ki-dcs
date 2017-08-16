AICOM = {}

AICOM.Config = {}

AICOM.Config.TurnRate = 600     -- the rate at which the AI Commander can make moves/actions
AICOM.Config.InitMoves = 3      -- the number of moves the AI Commander can make a turn
AICOM.Config.InitResource = 100 -- the number of units/resources the AI Commander has access to per turn

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

AICOM.Enum = {}

AICOM.Enum.Actions =
{
  Attack = 1,
  Reinforce = 2,
  Ambush = 3
}






AICOM.CurrentMoney = AICOM.Config.InitResource
AICOM.MovesRemaining = AICOM.Config.InitMoves

function AICOM.Init()
  env.info("AICOM.Init() Called")
  -- generate and sort the Forces table so that we are working with presorted versions of this data when live
  
  
  local function sortCostAA (a, b )
    if (b.AAEffectiveness < a.AAEffectiveness) then
      return true
    elseif (b.AAEffectiveness > a.AAEffectiveness) then
      return false
    else
      return b.Cost < a.Cost
    end
  end
  
  local function sortCostGND (a, b )
    if (b.GNDEffectiveness < a.GNDEffectiveness) then
      return true
    elseif (b.GNDEffectiveness > a.GNDEffectiveness) then
      return false
    else
      return b.Cost < a.Cost
    end
  end
  
  AICOM.ForcesAACostSorted = KI.Toolbox.DeepCopy(AICOM.Config.Forces)
  AICOM.ForcesGNDCostSorted = KI.Toolbox.DeepCopy(AICOM.Config.Forces)
  table.sort(AICOM.ForcesAACostSorted, sortCostAA)
  table.sort(AICOM.ForcesGNDCostSorted, sortCostGND)
end

function AICOM.Analyze(CapturePoints)
  env.info("AICOM.Analyze Called")
  if CapturePoints then
    env.info("AICOM.Analyze - CapturePoints not null")
  else
    env.info("AICOM.Analyze - WARNING CapturePoints null")
  end
  local _cpAnalysis = {}
  for i = 1, #CapturePoints do
    local _cp = CapturePoints[i]
    local _cost = 0
    local _own = _cp:GetOwnership()
    local _type = 0
    
    -- Assign initial cost values for the ownership of a point
    -- Neutral points are the most valuable to the AI
    -- Contested are second most important
    -- Blue are third, with red being forth
    if _own == "Neutral" then
      _cost = _cost + 1
      _type = AICOM.Enum.Actions.Attack
    elseif _own == "Blue" then
      _cost = _cost + 5
      _type = AICOM.Enum.Actions.Attack
    elseif _own == "Red" then
      _cost = _cost + 7
      _type = AICOM.Enum.Actions.Reinforce
    else
      _cost = _cost + 3
      _type = AICOM.Enum.Actions.Reinforce
    end
    
    -- now include blue units and red units into the cost (with red units being half the cost of a blue unit)
    _cost = _cost + _cp.BlueUnits
    if _cp.RedUnits > 0 then
      _cost = _cost + (_cp.RedUnits / 2)  -- add red units as a cost, but for half the price of blue units
    end
    
    table.insert(_cpAnalysis, { CapturePoint = _cp, Cost = _cost, Action = _type })
  end
  
  env.info("AICOM.Analyze - Dumping results")
  env.info(KI.Toolbox.Dump(_cpAnalysis))
  return _cpAnalysis
end

-- analyzes what the AI is willing to pay for units
-- split into two categories - AA units, and Ground units
function AICOM.AnalyzePay(action)
  env.info("AICOM.AnalyzePay called")
  local _result = { AA = 0, GND = 0 }
  
  -- the amount the AI is willing to pay for AA units - will never pay for anything higher than this
  -- when attacking the AI should get cheaper AA, and buy expensive AA when reinforcing a position
  -- when ambushing the AI ?? need to decide what kind of behaviour needed
  if action == AICOM.Enum.Actions.Attack then
    _result.AA = (AICOM.CurrentMoney / AICOM.MovesRemaining) - math.random(10)
    _result.GND = (AICOM.CurrentMoney / AICOM.MovesRemaining) + math.random(20)
  elseif action == AICOM.Enum.Actions.Reinforce then
    _result.AA = (AICOM.CurrentMoney / AICOM.MovesRemaining) + math.random(20)
    _result.GND = (AICOM.CurrentMoney / AICOM.MovesRemaining) - math.random(5)
  else
    _result.AA = (AICOM.CurrentMoney / AICOM.MovesRemaining) - math.random(20)
    _result.GND = (AICOM.CurrentMoney / AICOM.MovesRemaining) + math.random(5)
  end
  
  env.info("AICOM.AnalyzePay - dumping results")
  env.info(KI.Toolbox.Dump(_result))
  return _result
end
--


-- attempt to buy AA units with the budget passed in as parameter
function AICOM.TryBuyAA(budget)
  env.info("AICOM.TryBuyAA Called")
  env.info("AICOM.TryBuyAA - Budget: " .. tostring(budget))
  local _cart = {}
  
  for i = 1, #AICOM.ForcesAACostSorted do
    local _aa = AICOM.ForcesAACostSorted[i]
    
    -- does this item fall within our budget?
    if _aa.Cost <= budget then
      -- see if we can afford multiple copies of this AA unit?
      if (_aa.Cost * 2) <= budget then
        env.info("AICOM.TryBuyAA - buying 2 copies of AA unit " .. _aa.Name)
        -- Buy two of this unit
        table.insert(_cart, _aa)
        table.insert(_cart, _aa)
        budget = budget - (_aa.Cost * 2)
      else
        env.info("AICOM.TryBuyAA - buying 1 copy of AA unit " .. _aa.Name)
        -- just buy one copy
        table.insert(_cart, _aa)
        budget = budget - _aa.Cost
      end
    else
      env.info("AICOM.TryBuyAA - could not afford AA unit " .. _aa.Name .. " - skipping")
    end
    
    -- If we have run out of money, break from the loop
    if budget <= 0 then
      env.info("AICOM.TryBuyAA - budget is <= 0 - exiting")
      break
    end
  end
  
  env.info("AICOM.TryBuyAA - dumping results")
  env.info(KI.Toolbox.Dump(_cart))
  return _cart
end
--


-- similar to TryBuyAA, buy some ground units based on budget
function AICOM.TryBuyGND(budget)
  env.info("AICOM.TryBuyGND called")
  env.info("AICOM.TryBuyGND - Budget: " .. tostring(budget))
  local _cart = {}
  
  for i = 1, #AICOM.ForcesGNDCostSorted do
    local _gnd = AICOM.ForcesGNDCostSorted[i]
    
    -- does this item fall within our budget?
    if _gnd.Cost <= budget then
      -- see if we can afford multiple copies of this GND unit?
      if (_gnd.Cost * 3) <= budget then
        env.info("AICOM.TryBuyGND - buying 3 copies of GND unit " .. _gnd.Name)
        -- Buy 3 of this unit
        table.insert(_cart, _gnd)
        table.insert(_cart, _gnd)
        table.insert(_cart, _gnd)
        budget = budget - (_gnd.Cost * 3)
      elseif (_gnd.Cost * 2) <= budget then
        env.info("AICOM.TryBuyGND - buying 2 copies of GND unit " .. _gnd.Name)
        -- Buy 2 of this unit
        table.insert(_cart, _gnd)
        table.insert(_cart, _gnd)
        budget = budget - (_gnd.Cost * 2)
      else
        env.info("AICOM.TryBuyGND - buying 1 copy of GND unit " .. _gnd.Name)
        -- just buy one copy
        table.insert(_cart, _aa)
        budget = budget - _gnd.Cost
      end
    else
      env.info("AICOM.TryBuyGND - could not afford GND unit " .. _gnd.Name .. " - skipping")
    end
    
    -- If we have run out of money, break from the loop
    if budget <= 0 then
      env.info("AICOM.TryBuyGND - budget is <= 0 - exiting")
      break
    end
  end
  
  env.info("AICOM.TryBuyGND - dumping results")
  env.info(KI.Toolbox.Dump(_cart))
  
  return _cart
end
--


-- Spawns forces into a zone
function AICOM.Spawn(AAGroups, GNDGroups, zone)
  env.info("AICOM.Spawn called")
  local _moneySpent = 0
  
  -- iterate over the AA Force Groups
  for i = 1, #AAGroups do
    local _grp = AAGroups[i]
    _moneySpent = _moneySpent + _grp.Cost
    env.info("AICOM.Spawn - _grp : " .. _grp.Name)
    -- iterate over template groups and spawn them
    for t = 1, #_grp.Templates do
      env.info("AICOM.Spawn - Iterating over grp.Templates")
      local _template = _grp.Templates[t]
      local SpawnObj = SPAWN:NewWithAlias(_template, KI.GenerateName(_template))
      local NewGroup = SpawnObj:SpawnInZone(zone, true)
      if NewGroup ~= nil then
        env.info("AICOM.Spawn - Successfully spawned group " .. _template .. " in zone " .. zone:GetName())
      else
        env.info("AICOM.Spawn - ERROR - Failed to spawn group " .. _template .. " in zone " .. zone:GetName())
      end
    end
  end
  
  -- iterate over ground forces
  for i = 1, #GNDGroups do
    local _grp = GNDGroups[i]
    _moneySpent = _moneySpent + _grp.Cost
    
    -- iterate over all template groups and spawn them
    for t = 1, #_grp.Templates do
      local _template = _grp.Templates[t]
      local SpawnObj = SPAWN:NewWithAlias(_template, KI.GenerateName(_template))
      local NewGroup = SpawnObj:SpawnInZone(zone, true)
      if NewGroup ~= nil then
        env.info("AICOM.Spawn - Successfully spawned group " .. _template .. " in zone " .. zone:GetName())
      else
        env.info("AICOM.Spawn - ERROR - Failed to spawn group " .. _template .. " in zone " .. zone:GetName())
      end
    end
  end
  
  return _moneySpent
end
--



-- NOTE: parameter cost is unused in this function - consider removing
function AICOM.PerformAction(action, cost, capturepoint)
  env.info("AICOM.PerformAction called")
  local _moneySpent = 0
  local _willingToPay = AICOM.AnalyzePay(action)
  local _buyAAUnits = AICOM.TryBuyAA(_willingToPay.AA)
  local _buyGNDUnits = AICOM.TryBuyGND(_willingToPay.GND)
  
  if action == AICOM.Enum.Actions.Ambush then
    
  else
    _moneySpent = AICOM.Spawn(_buyAAUnits, _buyGNDUnits, capturepoint.SpawnZone)
  end
  
  AICOM.MovesRemaining = AICOM.MovesRemaining - 1
  AICOM.CurrentMoney = AICOM.CurrentMoney - _moneySpent
end
--



-- Scheduled function - main function of AICOM
function AICOM.DoTurn(args, time)
  env.info("AICOM.DoTurn called")
  -- reset the CurrentMoney and RemainingMoves
  AICOM.CurrentMoney = AICOM.Config.InitResource
  AICOM.MovesRemaining = AICOM.Config.InitMoves
  
  env.info("AICOM.DoTurn - KI.Data.CapturePoints length: " .. tostring(#KI.Data.CapturePoints))
  -- do some cost analysis on each capture point
  local _cpAnalysis = AICOM.Analyze(KI.Data.CapturePoints)
  
  -- sort the cp analysis table by cost ascending (cheapest to most expensive)
  local _keys = {}
  for k in pairs(_cpAnalysis) do table.insert(_keys, k) end
  table.sort(_keys, function(a, b) return _cpAnalysis[a].Cost < _cpAnalysis[b].Cost end)

  -- this loop actually decides and performs the AI Moves
  for t = 1, AICOM.Config.InitMoves do
    local _action = 0
    local _cost = 0
    local _cp = {}
    
    if t == 1 then
    -- for the first turn, always perform the action that is cheapest from the list
      _action = _cpAnalysis[_keys[1]].Action
      _cost = _cpAnalysis[_keys[1]].Cost
      _cp = _cpAnalysis[_keys[1]].CapturePoint
    
    elseif t == 2 then
    -- for the second turn, pick a random point from the 2nd to 5th cheapest actions in the list
      local _index = math.random(2, 5)
      _action = _cpAnalysis[_keys[_index]].Action
      _cost = _cpAnalysis[_keys[_index]].Cost
      _cp = _cpAnalysis[_keys[_index]].CapturePoint
    elseif t == 3 then
    -- for the third turn, create a 10% chance it will be an ambush action, otherwise pick an item from the bottom of the Capture List
      if math.random(1, 100) < 11 then 
        _cp = AICOM.Config.AmbushPoints[math.random(#AICOM.Config.AmbushPoints)]
        _cost = 10
        _action = AICOM.Enum.Actions.Ambush
      else 
        local _index = math.random(6, 10)
        _action = _cpAnalysis[_keys[_index]].Action
        _cost = _cpAnalysis[_keys[_index]].Cost
        _cp = _cpAnalysis[_keys[_index]].CapturePoint
      end
    end
    
    AICOM.PerformAction(_action, _cost, _cp)
  end
  
  return time + AICOM.Config.TurnRate + math.random(AICOM.Config.TurnRate / 2)
end
