--[[
LOCPOS Class
Class that encapsulates DCS X and Y, MGRS, and LatLong into a single object

Author: Igneous01
]]--
LOCPOS = 
{
  LatLong = "",
  MGRS = "",
  Latitude = 0,                -- DCS pos.z coordinate converted to latitude
  Longitude = 0                 -- DCS pos.x coordinate converted to longitude
}

function LOCPOS:NewFromZone(zone)
  env.info("LOCPOS:NewFromZone called")
  local self = KI.Toolbox.DeepCopy(LOCPOS)

  if self ~= nil then
    setmetatable( self, LOCPOS )
    self.__index = self 
  end
  
  local coordinates = zone:GetCoordinate()
  self.LatLong = coordinates:ToStringLLDDM()
  self.LatLong = string.gsub(coordinates:ToStringLLDDM(), "LL DDM, ", "")
  self.MGRS = coordinates:ToStringMGRS()
  self.MGRS = string.gsub(self.MGRS, "MGRS, ", "")
  local lat, lon = coord.LOtoLL(coordinates:GetVec3())
  self.Latitude = lat
  self.Longitude = lon
  return self
end

function LOCPOS:NewFromVec3(vec3)
  env.info("LOCPOS:NewFromVec3 called")
  local self = KI.Toolbox.DeepCopy(LOCPOS)

  if self ~= nil then
    setmetatable( self, LOCPOS )
    self.__index = self 
  end
  
  local coordinates = COORDINATE:NewFromVec3(vec3)
  self.LatLong = coordinates:ToStringLLDDM()
  self.LatLong = string.gsub(coordinates:ToStringLLDDM(), "LL DDM, ", "")
  self.MGRS = coordinates:ToStringMGRS()
  self.MGRS = string.gsub(self.MGRS, "MGRS, ", "")
  local lat, lon = coord.LOtoLL(coordinates:GetVec3())
  self.Latitude = lat
  self.Longitude = lon
  return self
end