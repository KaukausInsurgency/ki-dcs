--Capture Point Class
--Handles Capture Zone related tasks
CP = 
{
  Defenses = {},        -- map based on key["DefenseType"] = [qty, cap]
  Name = "",            -- name of the capture zone in mission editor
  Zone = nil,           -- Mission Editor Trigger Zone
  BlueUnits = 0,
  RedUnits = 0,
  Owner = ""
}

function CP:New(name, zone)
  local self = KI.Toolbox.DeepCopy(CP)

	if self ~= nil then
		setmetatable( self, CP )
		self.__index = self	
	end
  
  self.Name = name
  self.Zone = ZONE:New(zone)
  
  return self
end

-- defines a defense unit with an initial count and limit for the capture zone
-- ie define that a maximum of 30 infantry can be in this cap zone
function CP:SetDefenseUnit(keyDef, maxcap)
  if not maxcap then
    maxcap = 1
  end
  self.Defenses[keyDef] = { qty = 0, cap = maxcap }
end

function CP:Fortify(resource, count)
  local msg = ""
  local result = false
  if self.Defenses[resource] then
    local _dqty = self.Defenses[resource].qty
    local _cap = self.Defenses[resource].cap
    -- if the capture point has enough capacity to reinforce, allow it
    if (count + _dqty) <= _cap then
      env.info("CP:Fortify - CP has enough capacity to accept this fortification")
      _dqty = _dqty + count
      self.Defenses[resource] = { qty = _dqty, cap = _cap }
      result = true
      msg = self.Name .. " fortified with " .. resource .. "! (Capacity: " .. tostring(_dqty) .. " / " .. tostring(_cap) .. ")"
    else
      msg = "Capture Point has too much of this unit - cannot deploy here! (Capacity: " .. tostring(_dqty) .. " / " .. tostring(_cap) .. ")"
    end
  else
    msg = "Capture Point cannot be fortified with this type of unit!"
  end
  trigger.action.outText(msg, 10)
  return result
end
  
function CP:ViewResources()
  local msg = "CP - " .. self.Name .. "\n"
  msg = msg .. "Defense:\tCount\tLimit\n"
  for res, val in pairs(self.Defenses) do
    msg = msg .. res .. ":\t" .. val.qty .. "\t" .. val.cap .. "\n"
  end
  return msg
end

function CP:SetCoalitionCounts(reds, blues)
  self.BlueUnits = blues
  self.RedUnits = reds
  local own = CP.GetOwnership(self)
  if self.Owner ~= own then
    trigger.action.outTextForCoalition(1, "ALERT --- " .. self.Name .. " is now " .. own, 10)
    self.Owner = own
  end
end

function CP:GetOwnership()
  if self.BlueUnits > 0 and self.RedUnits <= 0 then
    return "Blue"
  elseif self.RedUnits > 0 and self.BlueUnits <= 0 then
    return "Red"
  elseif self.RedUnits <= 0 and self.BlueUnits <= 0 then
    return "Neutral"
  else
    return "Contested"
  end
end
