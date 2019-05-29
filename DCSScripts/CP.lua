--[[
Capture Point Class
Class creates a Capture and exposes methods for managing and maintaining the capture point.

Author: Igneous01
]]--
CP = 
{
  Enum = { CAPTUREPOINT = "CAPTUREPOINT", AIRPORT = "AIRPORT", FARP = "FARP"},
  Type = "",            -- the type of capture point
  Name = "",            -- name of the capture zone in mission editor
  Zone = nil,           -- Mission Editor Trigger Zone
  BlueUnits = 0,
  RedUnits = 0,
  MaxCapacity = 0,      -- maximum number of friendly units that can exist in zone
  Owner = "",
  SpawnZone1 = nil,     -- zone where units ai units are spawned for attacking
  SpawnZone2 = nil,
  Position = {},
  Text = nil,           -- extra text information that will be displayed on website
  Slots = {}            -- list of group name player slots - used in slot blocking
}

CP._ID = 0

function CP._incrementID()
  CP._ID = CP._ID + 1
  return CP._ID
end

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
  self.MaxCapacity = 0
  self.ID = CP._incrementID()
  return self
end

function CP:Fortify(resource, val)
  env.info("CP.Fortify called")
  val = val or 1
  local msg = ""
  local result = false
  local AlliedUnits
  
  if KI.Config.AllySide == 1 then
    AlliedUnits = self.RedUnits
  else
    AlliedUnits = self.BlueUnits
  end
  
  local newtotal = AlliedUnits + val
  if newtotal <= self.MaxCapacity then
    env.info("CP:Fortify - CP has enough capacity to accept this fortification")
    result = true
    msg = self.Name .. " fortified with " .. resource .. "! (Capacity: " .. tostring(newtotal) .. " / " .. tostring(self.MaxCapacity) .. ")"
  else
    msg = "Capture Point cannot be fortified any further! (Capacity: " .. tostring(AlliedUnits) .. " / " .. tostring(self.MaxCapacity) .. ")"
  end

  return result, msg
end
  
function CP:ViewResources()
  local msg = "CP - " .. self.Name .. "\n"
  msg = msg .. "Status: " .. self:GetOwnership() .. " Red: " 
        .. tostring(self.RedUnits) .. " Blue: " .. self.BlueUnits .. "\n"
  --msg = msg .. string.format("%-25s|%-5s|%-5s", "Defense", "Count", "limit") .. "\n"
  --for res, val in pairs(self.Defenses) do
  --  msg = msg .. string.format("%-25s|%-5d|%-5d", res, val.qty, val.cap) .. "\n"
  --end
  return msg
end

function CP:SetCoalitionCounts(reds, blues)
  env.info("CP.SetCoalitionCounts called")
  self.BlueUnits = blues
  self.RedUnits = reds
  local own = CP.GetOwnership(self)
  if self.Owner ~= own then
    KI.Toolbox.MessageCoalition(KI.Config.AllySide, "ALERT --- " .. self.Name .. " is now " .. own, 10)
    KI.Toolbox.MessageCoalition(KI.Config.InsurgentSide, "ALERT --- " .. self.Name .. " is now " .. own, 10)
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
