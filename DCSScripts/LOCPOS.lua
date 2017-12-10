--[[
LOCPOS Class
Class that encapsulates DCS X and Y, MGRS, and LatLong into a single object

Author: Igneous01
]]--
LOCPOS = 
{
  LatLong = "",
  MGRS = "",
  X = 0,                -- DCS pos.z coordinate
  Y = 0                 -- DCS pos.x coordinate
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
  local vec3 = coordinates:GetVec3()
  self.X = vec3.z
  self.Y = vec3.x
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
  local vec3 = coordinates:GetVec3()
  self.X = vec3.z
  self.Y = vec3.x
  return self
end