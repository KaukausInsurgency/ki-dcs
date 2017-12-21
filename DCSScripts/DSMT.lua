-- Dynamic Side Mission Tasking class
-- Handles the creation, management and cleanup of side missions



DSMTResource = 
{
  Groups = {},
  Units = {},
  Statics = {}, -- first index is object, second index is category (used in loading/saving to file)
  Arguments = nil
}

function DSMTResource:New(groups, units, statics, args)
  env.info("DSMTResource:New called")
  local self = KI.Toolbox.DeepCopy( DSMTResource )

	if self ~= nil then
		setmetatable( self, DSMTResource )
		self.__index = self	
	end
  
  self.Groups = groups or {}
  self.Units = units or {}
  self.Statics = statics or {}
  self.Arguments = args or nil
  
  return self
end


DSMT = {}

function DSMT:New(taskName, zones, init, destroy, complete, fail, oncomplete, onfail, ontimeout, expiry_time, checkrate, destroytime)
  env.info("DSMT:New called")
  local self = KI.Toolbox.DeepCopy( DSMT )

	if self ~= nil then
		setmetatable( self, DSMT )
		self.__index = self	
	end
  
  self.Name = taskName
  self.Zones = DSMT._initZones(zones)
  self.Init = init
  self.Destroy = destroy
  self.Complete = complete
  self.Fail = fail
  self.OnComplete = oncomplete
  self.OnFail = onfail
  self.OnTimeout = ontimeout
  self.Resource = nil
  self.CurrentZone = nil
  self.CheckRate = checkrate
  self.Expiry = expiry_time or 3600
  self.DestroyTime = destroytime or 300
  self.Life = 0
  self.Done = false
  return self
end


function DSMT._initZones(zonenames)
  env.info("DSMT._initZones called")
  local zones = {}
  for i = 1, #zonenames do
    table.insert(zones, ZONE:New(zonenames[i]))
  end
  return zones
end


function DSMT._selectZone(zones)
  env.info("DSMT._selectZone called")
  return zones[math.random(#zones)]
end


function DSMT:_initMission()
  env.info("DSMT._initMission called")
  self.CurrentZone = DSMT._selectZone(self.Zones)
  self.Resource = self.Init(self.Name, self.CurrentZone)
  return true
end

function DSMT._destroy(self, time)
  env.info("DSMT._destroy called")
  self.Destroy(self.Resource)
  return nil
end

function DSMT._manage(self, time)
  env.info("DSMT._manage called")
  local fncSuccess, result = xpcall(function()
    if self.Complete(self.Name, self.CurrentZone, self.Resource) then
      self.OnComplete(self.Name, self.CurrentZone, self.Resource)
      self.Done = true
      DSMT._invoke(DSMT._destroy, self.DestroyTime, self)
      return nil
    elseif self.Fail(self.Name, self.CurrentZone, self.Resource) then
      self.OnFail(self.Name, self.CurrentZone, self.Resource)
      self.Done = true
      DSMT._invoke(DSMT._destroy, self.DestroyTime, self)
      return nil
    elseif self.Life >= self.Expiry then
      self.OnTimeout(self.Name, self.CurrentZone, self.Resource)
      self.Done = true
      DSMT._invoke(DSMT._destroy, self.DestroyTime, self)
      return nil
    else
      self.Life = self.Life + self.CheckRate
      return time + self.CheckRate
    end
  end, function(err) env.info("DSMT._manage ERROR : " .. err) end)
  
  if fncSuccess then
    return result
  else
    return nil
  end  
end

function DSMT._invoke(fnc, rate, args)
  env.info("DSMT._invoke called")
  timer.scheduleFunction(fnc, args, timer.getTime() + rate)
end


function DSMT:Start()
  env.info("DSMT:Start called")
  if self:_initMission() then
    -- invoke the manager
    DSMT._invoke(DSMT._manage, self.CheckRate, self)
  end
end
