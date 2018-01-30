--[[
AI Commander Module

This module is responsible for managing the AI Insurgent Commanders behaviour in game.
The AI Commander keeps the mission fun and engaging by 
  - spawning in units
  - deciding where to attack, where to defend
  - when and where to setup an ambush

The Commanders unit pool is user configurable and the logic that drives it is entirely based on the definitions provided in AICOM_Config.lua

Author: Igneous01

]]--

if not AICOM then
  AICOM = {}
end

AICOM.Enum = {}

AICOM.Enum.Actions =
{
  Attack = 1,
  Reinforce = 2,
  Ambush = 3
}

AICOM.CurrentMoney = AICOM.Config.InitResource
AICOM.MovesRemaining = AICOM.Config.InitMoves
AICOM.AmbushZones = {}

function AICOM.Init()
  env.info("AICOM.Init() Called")
  -- generate and sort the Forces table so that we are working with presorted versions of this data when live
  
  
  local function sortCostAA (a, b )
    if (b.AAEffectiveness < a.AAEffectiveness) then
      return true
    elseif (b.AAEffectiveness > a.AAEffectiveness) then
      return false
    else
      return b.Cost > a.Cost
    end
  end
  
  local function sortCostGND (a, b )
    if (b.GNDEffectiveness < a.GNDEffectiveness) then
      return true
    elseif (b.GNDEffectiveness > a.GNDEffectiveness) then
      return false
    else
      return b.Cost > a.Cost
    end
  end
  
  AICOM.ForcesAACostSorted = KI.Toolbox.DeepCopy(AICOM.Config.Forces)
  AICOM.ForcesGNDCostSorted = KI.Toolbox.DeepCopy(AICOM.Config.Forces)
  table.sort(AICOM.ForcesAACostSorted, sortCostAA)
  table.sort(AICOM.ForcesGNDCostSorted, sortCostGND)
  
  env.info("AICOM.Init() - Initializing Ambush Zones")
  for i = 1, #AICOM.Config.AmbushZones do
    table.insert(AICOM.AmbushZones, ZONE:New(AICOM.Config.AmbushZones[i]))
  end
end

function AICOM.CalculatePopulationCap(groups)
  env.info("AICOM.CalculatePopulationCap called")
  if groups == nil then
    return 0
  end
  local _count = 0
  
  for j = 1, #groups do
    local _g = groups[j]
    if _g:isExist() then
      for index, data in pairs(_g:getUnits()) do
        if data:isActive() then
          _count = _count + 1
        else
          env.info("AICOM.CalculatePopulationCap - Inactive group found - ignoring")
          -- it is not possible to partially activate a group, so if any unit in the group 
          -- is not active, assume the entire group is inactive
          break   
        end
      end
    end
  end
  env.info("AICOM.CalculatePopulationCap - returned " .. tostring(_count))
  return _count
end

function AICOM.Analyze(CapturePoints)
  env.info("AICOM.Analyze Called")
  if CapturePoints then
    env.info("AICOM.Analyze - CapturePoints not null")
  else
    env.info("AICOM.Analyze - WARNING CapturePoints null")
    return {}
  end
  local _cpAnalysis = {}
  for i = 1, #CapturePoints do
    local _cp = CapturePoints[i]
    if _cp.SpawnZone1 and _cp.SpawnZone2 then
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
        -- contested
        _cost = _cost + 3
        _type = AICOM.Enum.Actions.Reinforce
      end
      
      -- now include blue units and red units into the cost (with red units being half the cost of a blue unit)
      _cost = _cost + _cp.BlueUnits
      if _cp.RedUnits > 0 then
        _cost = _cost + (_cp.RedUnits / 2)  -- add red units as a cost, but for half the price of blue units
      end
      
      table.insert(_cpAnalysis, { CapturePoint = _cp, Cost = _cost, Action = _type })
    else
      env.info("AICOM.Analyze - Capture Point " .. _cp.Name .. " has no spawn zone - ignoring")
    end
  end
  
  env.info("AICOM.Analyze - Dumping results")
  env.info(KI.Toolbox.Dump(_cpAnalysis))
  return _cpAnalysis
end

-- analyzes what the AI is willing to pay for units
-- split into two categories - AA units, and Ground units
function AICOM.AnalyzePay(action)
  env.info("AICOM.AnalyzePay called (CurrentMoney: " .. tostring(AICOM.CurrentMoney) .. ", MovesRemaining: " .. tostring(AICOM.MovesRemaining) .. ")")
  local _result = { AA = 0, GND = 0 }
  
  -- the amount the AI is willing to pay for AA units - will never pay for anything higher than this
  -- when attacking the AI should get cheaper AA, and buy expensive AA when reinforcing a position
  -- when ambushing the AI ?? need to decide what kind of behaviour needed
  if action == AICOM.Enum.Actions.Attack then
    _result.AA = ((AICOM.CurrentMoney / AICOM.MovesRemaining) / 2) - AICOM.Config.Random(10)
    _result.GND = ((AICOM.CurrentMoney / AICOM.MovesRemaining) / 2) + AICOM.Config.Random(20)
  elseif action == AICOM.Enum.Actions.Reinforce then
    _result.AA = ((AICOM.CurrentMoney / AICOM.MovesRemaining) / 2) + AICOM.Config.Random(20)
    _result.GND = ((AICOM.CurrentMoney / AICOM.MovesRemaining) / 2) - AICOM.Config.Random(5)
  else
    _result.AA = ((AICOM.CurrentMoney / AICOM.MovesRemaining) / 2) - AICOM.Config.Random(20)
    _result.GND = ((AICOM.CurrentMoney / AICOM.MovesRemaining) / 2) + AICOM.Config.Random(5)
  end
  
  env.info("AICOM.AnalyzePay - dumping results")
  env.info(KI.Toolbox.Dump(_result))
  return _result
end
--

-- Segments the analysis array into a logical grouping that the DoTurn can understand and work with
-- indexes of { 1, {2, (length-1) / 2}, {((length-1) / 2) + 1, length}}
-- assuming an array of moves of size 11, and a config of 3 moves per turn for the AI
-- the first move the AI does will always be the highest ranking action to take (index 1)
-- the second move the AI makes, should be randomly chosen from the middle range (2-5) for example
-- the third move the AI makes, should be randomly chosen from the high range (6-11) for example
function AICOM.SegmentAnalysis(movelist, segments)
  env.info("AICOM.SegmentAnalysis called")
  if not movelist or not segments then return nil end
  if #movelist == 0 or segments == 0 then return nil end
  local length = #movelist
  
  -- if the length is less than the number of segments, return nil as this is an invalid call
  if length < segments then
    env.info("AICOM.SegmentAnalysis - WARNING - Invalid parameters provided (movelist length is less than segments)")
    return nil
  end
  
  
  local segment_range = math.floor((length - 1) / (segments - 1))
  local remainder = (length - 1) % (segments - 1)
  local MoveSegments = {}
  table.insert(MoveSegments, 1)   -- first item in list will always be first index
  local segment_start_index = 2
  
  -- start our loop at 2, since we already have processed index 1
  for i = 2, segments do
    local maxindex = 0
    if remainder == 0 then
      maxindex = segment_start_index + segment_range - 1
    else
      maxindex = segment_start_index + segment_range
    end
    if maxindex > length then
      maxindex = length
    end
    table.insert(MoveSegments, { Min = segment_start_index, Max = maxindex})
    segment_start_index = maxindex + 1
  end 
  
  return MoveSegments
end

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


-- similar to TryBuyAA, but instead buy some ground units based on budget
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
        table.insert(_cart, _gnd)
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


function AICOM._SpawnGroups(ConfigForces, CPObj)
  env.info("AICOM._SpawnGroups called")
  env.info("AICOM._SpawnGroups Dumping ConfigForces")
  env.info(KI.Toolbox.Dump(ConfigForces))
  
  local _moneySpent = 0
  -- iterate over the AA Force Groups
  for i = 1, #ConfigForces do
    local _grp = ConfigForces[i]
    _moneySpent = _moneySpent + _grp.Cost
    local spawnzone = nil
    
    if _grp.SpawnZone == 1 then
      spawnzone = CPObj.SpawnZone1
    elseif _grp.SpawnZone == 2 then
      spawnzone = CPObj.SpawnZone2
    else
      env.info("AICOM._SpawnGroups - ERROR - Invalid SpawnZone value (must be 1 or 2)")
    end
    
    -- iterate over template groups and spawn them
    for t = 1, #_grp.Templates do
      local _template = _grp.Templates[t]
      local SpawnObj = SPAWN:NewWithAlias(_template, KI.GenerateName(_template))
                          :OnSpawnGroup(function( spawngrp, stype, atkzone, grpconfig ) 
                              if AICOM.Config.OnSpawnGroup then
                                env.info("AICOM._SpawnGroups - callback found")
                                AICOM.Config.OnSpawnGroup(spawngrp, stype, atkzone, grpconfig)
                              end
                          end, "MOVING", CPObj.Zone, _grp)
      SpawnObj.SpawnVisible = false -- hide red units from f10 map and Ka50 ABRIS
      local NewGroup = SpawnObj:SpawnInZone(spawnzone, true)
      if NewGroup ~= nil then
        env.info("AICOM._SpawnGroups - Successfully spawned group " .. _template .. " in zone " .. spawnzone:GetName())
      else
        env.info("AICOM._SpawnGroups - ERROR - Failed to spawn group " .. _template .. " in zone " .. spawnzone:GetName())
      end
    end
  end
  
  return _moneySpent
end


function AICOM.SpawnAmbush(ConfigForces, zone)
  env.info("AICOM.SpawnAmbush called")
  env.info("AICOM.SpawnAmbush Dumping ConfigForces")
  env.info(KI.Toolbox.Dump(ConfigForces))
  
  local _moneySpent = 0
  -- iterate over the AA Force Groups
  for i = 1, #ConfigForces do
    local _grp = ConfigForces[i]
    _moneySpent = _moneySpent + _grp.Cost
    
    -- iterate over template groups and spawn them
    for t = 1, #_grp.Templates do
      local _template = _grp.Templates[t]
      local SpawnObj = SPAWN:NewWithAlias(_template, KI.GenerateName(_template))
                          :OnSpawnGroup(function( spawngrp, stype, atkzone, grpconfig ) 
                              if AICOM.Config.OnSpawnGroup then
                                env.info("AICOM.SpawnAmbush - callback found")
                                AICOM.Config.OnSpawnGroup(spawngrp, stype, atkzone, grpconfig)
                              end
                          end, "AMBUSH", nil, nil)
                          
      local NewGroup = SpawnObj:SpawnInZone(zone, true)
      if NewGroup ~= nil then
        env.info("AICOM.SpawnAmbush - Successfully spawned group " .. _template .. " in zone " .. zone:GetName())
      else
        env.info("AICOM.SpawnAmbush - ERROR - Failed to spawn group " .. _template .. " in zone " .. zone:GetName())
      end
    end
  end
  
  return _moneySpent
end


-- Spawns forces into a zone
function AICOM.Spawn(AAGroups, GNDGroups, CPObj)
  env.info("AICOM.Spawn called")
  local _moneySpent = AICOM._SpawnGroups(AAGroups, CPObj) + AICOM._SpawnGroups(GNDGroups, CPObj)
  env.info("AICOM.Spawn - Total Money Spent : " .. tostring(_moneySpent))
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
  local _spawntype = ""
  if action == AICOM.Enum.Actions.Ambush then
    env.info("AICOM.PerformAction - AI is setting up ambush")
    _spawntype = "AMBUSH"
    _moneySpent = AICOM.SpawnAmbush(_buyAAUnits, capturepoint) + AICOM.SpawnAmbush(_buyGNDUnits, capturepoint)
  else
    _spawntype = "MOVING"
    _moneySpent = AICOM.Spawn(_buyAAUnits, _buyGNDUnits, capturepoint)
  end
  
  AICOM.MovesRemaining = AICOM.MovesRemaining - 1
  AICOM.CurrentMoney = AICOM.CurrentMoney - _moneySpent
end
--



-- Scheduled function - main function of AICOM
function AICOM.DoTurn(args, time)
  env.info("AICOM.DoTurn called")
  
  local fncSuccess, result = xpcall(function()
    -- check the pop cap and see if we've hit the limit
    local _cap = AICOM.CalculatePopulationCap(coalition.getGroups(2, Group.Category.GROUND))
    if _cap >= AICOM.Config.PopulationCap then
      env.info("AICOM.DoTurn - pop cap has been reached (" .. tostring(_cap) .. "/" .. tostring(AICOM.Config.PopulationCap) .. ") - Doing nothing")
      KI.UTDATA.AICOM_POPCAP_REACHED = true
      return time + AICOM.Config.TurnRate + AICOM.Config.Random(AICOM.Config.TurnRate / 2)
    end
    
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
    local _moves = AICOM.SegmentAnalysis(_keys, AICOM.Config.InitMoves)
    
    if _moves == nil then
      env.info("AICOM.DoTurn - ERROR - SegmentAnalysis returned nil, cannot process moves for AI - check parameters!")
      return time + AICOM.Config.TurnRate + AICOM.Config.Random(AICOM.Config.TurnRate / 2)
    end
    
    -- this loop actually decides and performs the AI Moves
    for t = 1, #_moves do
      local _action = 0
      local _cost = 0
      local _cp = {}
      local _keyIndex = _moves[t]
      local _ambushWasDone = false
      
      if t == 1 then
      -- for the first turn, always perform the action that is cheapest from the list
        _action = _cpAnalysis[_keys[_keyIndex]].Action
        _cost = _cpAnalysis[_keys[_keyIndex]].Cost
        _cp = _cpAnalysis[_keys[_keyIndex]].CapturePoint
      else
        if not _ambushWasDone and (AICOM.Config.Random(1, 100) <= AICOM.Config.AmbushProbability) then 
          _cp = AICOM.AmbushZones[AICOM.Config.Random(#AICOM.AmbushZones)]
          _cost = AICOM.Config.AmbushCost
          _action = AICOM.Enum.Actions.Ambush
          _ambushWasDone = true
        else 
          local _index = AICOM.Config.Random(_keyIndex.Min, _keyIndex.Max)
          _action = _cpAnalysis[_keys[_index]].Action
          _cost = _cpAnalysis[_keys[_index]].Cost
          _cp = _cpAnalysis[_keys[_index]].CapturePoint
        end
      end
      
      AICOM.PerformAction(_action, _cost, _cp)
    end
    
    return time + AICOM.Config.TurnRate + AICOM.Config.Random(AICOM.Config.TurnRate / 2)
  end, function(err) env.info("AICOM.DoTurn ERROR : " .. err) end)
  
  if fncSuccess then
    return result
  else
    return nil
  end  
end
