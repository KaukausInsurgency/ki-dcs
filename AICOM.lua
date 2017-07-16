AICOM = {}

AICOM.Config = {}

AICOM.Config.TurnRate = 600     -- the rate at which the AI Commander can make moves/actions
AICOM.Config.InitMoves = 3      -- the number of moves the AI Commander can make a turn
AICOM.Config.InitResource = 30  -- the number of units/resources the AI Commander has access to per turn


AICOM.Config.Forces =
{
  [1] = 
  {
    Name = "Infantry Platoon",
    Templates = { "InsInfSqdA", "InsInfSqdB", "InsInfSqdA", "InsInfSqdC" }, -- group templates to use
    Cost = 10,        -- cost to play / use
    Strength = 40,    -- Strength in number of units generated
    Effectiveness = 5 -- AA Effectiveness
  },
  [2] =
  {
    Name = "MANPAD Section",
    Templates = { "InsMANPADSqd", "InsMANPADSqd", "InsInfSqdA" },
    Cost = 8,
    Strength = 20,
    Effectiveness = 15
  },
  [3] =
  {
    Name = "Tank Platoon",
    Templates = { "InsTankPlt1", "InsTankPlt2" },
    Cost = 5,
    Strength = 10,
    Effectiveness = 25
  }
}

AICOM.Enum = {}

AICOM.Enum.Actions =
{
  Attack = 1,
  Reinforce = 2,
  Ambush = 3
}

function AICOM.DoTurn(args, time)
  
  -- do some cost analysis on each capture point
  local _cpAnalysis = {}
  for i = 1, #KI.Data.CapturePoints do
    local _cp = KI.Data.CapturePoints(i)
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
    
    _cost = _cost + _cp.BlueUnits
    if _cp.RedUnits > 0 then
      _cost = _cost + (_cp.RedUnits / 2)  -- add red units as a cost, but for half the price of blue units
    end
    
    table.insert(_cpAnalysis, { CapturePoint = _cp, Cost = _cost, Action = _type })
  end
  
  local _keys = {}
  for k in pairs(_cpAnalysis) do table.insert(_keys, k) end
  table.sort(_keys, function(a, b) return _cpAnalysis[a].Cost < _cpAnalysis[b].Cost end)

  for t = 1, AICOM.Config.InitMoves do
    local _action = 0
    local _cost = 0
    local _cp = {}
    if t == 1 then
      _action = _cpAnalysis[_keys[1]].Action
      _cost = _cpAnalysis[_keys[1]].Cost
      _cp = _cpAnalysis[_keys[1]].CapturePoint
    elseif t == 2 then
      local _index = math.random(2, 5)
      _action = _cpAnalysis[_keys[_index]].Action
      _cost = _cpAnalysis[_keys[_index]].Cost
      _cp = _cpAnalysis[_keys[_index]].CapturePoint
    elseif t == 3 then
      if math.random(1, 100) > 75 then 
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
