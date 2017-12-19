--[[
Capture Point Class
Class creates a Capture and exposes methods for managing and maintaining the capture point.

Author: Igneous01
]]--
CP = 
{
  Enum = { CAPTUREPOINT = "CAPTUREPOINT", AIRPORT = "AIRPORT", FARP = "FARP"},
  Defenses = {},        -- map based on key["DefenseType"] = [qty, cap]
  Type = "",            -- the type of capture point
  Name = "",            -- name of the capture zone in mission editor
  Zone = nil,           -- Mission Editor Trigger Zone
  BlueUnits = 0,
  RedUnits = 0,
  Owner = "",
  SpawnZone1 = nil,     -- zone where units ai units are spawned for attacking
  SpawnZone2 = nil,
  Position = {},
  Text = nil            -- extra text information that will be displayed on website
}

function CP:New(name, zone, type, spawnzone1, spawnzone2, text)
  env.info("CP:New called")
  local self = KI.Toolbox.DeepCopy(CP)

  if self ~= nil then
    setmetatable( self, CP )
    self.__index = self 
  end
  
  self.Name = name
  self.Zone = ZONE:New(zone)
  self.Type = type or CP.Enum.CAPTUREPOINT
  self.Position = LOCPOS:NewFromZone(self.Zone)
  if spawnzone1 then
    self.SpawnZone1 = ZONE:New(spawnzone1)
  end
  if spawnzone2 then
    self.SpawnZone2 = ZONE:New(spawnzone2)
  end
  if text then
    self.Text = text
  end
  return self
end

-- defines a defense unit with an initial count and limit for the capture zone
-- ie define that a maximum of 30 infantry can be in this cap zone
function CP:SetDefenseUnit(keyDef, maxcap)
  env.info("CP.SetDefenseUnit called")
  if not maxcap then
    maxcap = 1
  end
  self.Defenses[keyDef] = { qty = 0, cap = maxcap }
end

function CP:Fortify(resource, count)
  env.info("CP.Fortify called")
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

  return result, msg
end

function CP:Unfortify(resource, count)
  env.info("CP.Unfortify called")
  if count < 1 then 
    return false
  end
  local msg = ""
  local result = false
  if self.Defenses[resource] then
    local _dqty = self.Defenses[resource].qty
    local _cap = self.Defenses[resource].cap
    -- if the capture point has enough capacity to reinforce, allow it
    _dqty = _dqty - count
    if _dqty < 0 then
      _dqty = 0
    end
    self.Defenses[resource] = { qty = _dqty, cap = _cap } 
    msg = resource .. " was removed from " .. self.Name .. "! (Capacity: " .. tostring(_dqty) .. " / " .. tostring(_cap) .. ")"
    result = true
  else
    msg = "Capture Point cannot be unfortified with this type of unit!"
    result = false
  end
  return result, msg
end
  
function CP:ViewResources()
  local msg = "CP - " .. self.Name .. "\n"
  msg = msg .. string.format("%-25s|%-5s|%-5s", "Defense", "Count", "limit") .. "\n"
  for res, val in pairs(self.Defenses) do
    msg = msg .. string.format("%-25s|%-5d|%-5d", res, val.qty, val.cap) .. "\n"
  end
  return msg
end

function CP:GetResourceEncoded()
  local msg = "Type|Fortified|Limit\n"
  for res, val in pairs(self.Defenses) do
    msg = msg .. res .. "|" .. val.qty .. "|" .. val.cap .. "\n"
  end
  return msg
end

function CP:SetCoalitionCounts(reds, blues)
  env.info("CP.SetCoalitionCounts called")
  self.BlueUnits = blues
  self.RedUnits = reds
  local own = CP.GetOwnership(self)
  if self.Owner ~= own then
    trigger.action.outTextForCoalition(1, "ALERT --- " .. self.Name .. " is now " .. own, 10)
    self.Owner = own
  end
end

function CP:GetOwnership()
  env.info("CP.GetOwnership called")
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
