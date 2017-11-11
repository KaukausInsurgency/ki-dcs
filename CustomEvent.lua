--[[
KI Custom Events module

Defines custom game events specific to KI that are passed through to the DCS onEvent handler

Author: Igneous01
]]--

CustomEvent = 
{
  id = "",
  initiator = {},
  place = {},
  time = 0
}


function CustomEvent:New(id, initiator, place)
  env.info("CustomEvent:New called")
  local self = KI.Toolbox.DeepCopy(CustomEvent)

	if self ~= nil then
		setmetatable( self, CustomEvent )
		self.__index = self	
	end
  
  self.id = id
  self.initiator = initiator
  self.place = place
  self.time = timer.getAbsTime()
  return self
end


CustomEventCaster = {}

-- spoofs the object into a dcs airbase like object, by providing the same methods
function CustomEventCaster.CastToAirbase(obj, objFunction)
  env.info("CustomEventCaster.CastToAirbase() called")
  local obj_copy = KI.Toolbox.DeepCopy(obj)
  obj_copy.getCallsign = function(o)
    return objFunction(o)
  end
  obj_copy.getName = function(o)
    return objFunction(o)
  end
  
  return obj_copy
end


