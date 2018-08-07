-- Dynamic Side Mission Tasking class
-- Handles the creation, management and cleanup of side missions

DSMT = {}

function DSMT:New(taskName, taskHTMLDesc, taskHTMLImage)
  env.info("DSMT:New called")
  local self = KI.Toolbox.DeepCopy( DSMT )

	if self ~= nil then
		setmetatable( self, DSMT )
		self.__index = self	
	end
  
  self.Name = taskName
  self.Desc = taskHTMLDesc
  self.DescNoHtml = taskHTMLDesc:gsub("<.->", "")
  self.Image = taskHTMLImage
  
  self.Zones = {}
  self.Arguments = nil
  self.CurrentZone = nil
  self.CurrentZoneRadius = nil
  self.CurrentPosition = nil
  self.CheckRate = 30
  self.Expiry = 3600
  self.DestroyTime = 300
  self.Life = 0
  self.Done = false
  self.Status = ""
  self.TimeStarted = 0
  self.TimeEnded = 0
  return self
end

-- builder extension functions

function DSMT:SetZones(zones)
  self.Zones = DSMT._initZones(zones)
  return self
end

function DSMT:SetCheckRate(t)
  self.CheckRate = t
  return self
end

function DSMT:SetExpiryTime(t)
  self.Expiry = t
  return self
end

function DSMT:SetDestroyTime(t)
  self.DestroyTime = t
  return self
end

function DSMT:SetInitFnc(fnc)
  self.Init = fnc
  return self
end

function DSMT:SetDestroyFnc(fnc)
  self.Destroy = fnc
  return self
end

function DSMT:SetCompleteFnc(fnc)
  self.Complete = fnc
  return self
end

function DSMT:SetFailFnc(fnc)
  self.Fail = fnc
  return self
end

function DSMT:SetOnCompleteFnc(fnc)
  self.OnComplete = fnc
  return self
end

function DSMT:SetOnFailFnc(fnc)
  self.OnFail = fnc
  return self
end

function DSMT:SetOnTimeoutFnc(fnc)
  self.OnTimeout = fnc
  return self
end

-- end builder extension functions



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


function DSMT:_initMission(chosenzone)
  env.info("DSMT._initMission called")
  if not chosenzone then
    self.CurrentZone = DSMT._selectZone(self.Zones)
  else
    self.CurrentZone = chosenzone
  end
  self.CurrentPosition = LOCPOS:NewFromZone(self.CurrentZone)
  self.CurrentZoneRadius = self.CurrentZone:GetRadius()
  self.Arguments = self.Init(self.Name, self.CurrentZone)
  return true
end

function DSMT._destroy(self, time)
  env.info("DSMT._destroy called")
  self.Destroy(self.Arguments)
  return nil
end

function DSMT._manage(self, time)
  env.info("DSMT._manage called")
  local fncSuccess, result = xpcall(function()
    self.Life = self.Life + self.CheckRate
    
    if self.Complete(self.Name, self.CurrentZone, self.Arguments) then
      self.OnComplete(self.Name, self.CurrentZone, self.Arguments)
      self:_setDone("Complete")
      return nil
    elseif self.Fail(self.Name, self.CurrentZone, self.Arguments) then
      self.OnFail(self.Name, self.CurrentZone, self.Arguments)
      self:_setDone("Failed")
      return nil
    elseif self.Life >= self.Expiry then
      self.OnTimeout(self.Name, self.CurrentZone, self.Arguments)
      self:_setDone("Timeout")
      return nil
    else 
      self.Status = "Active"
      return time + self.CheckRate
    end
  end, function(err) env.info("DSMT._manage ERROR : " .. err) end)
  
  if fncSuccess then
    return result
  else
    return nil
  end  
end

function DSMT:_setDone(status)
  self.Done = true
  self.Status = status
  self.TimeEnded = timer.getAbsTime()
  DSMT._invoke(DSMT._destroy, self.DestroyTime, self)
end

function DSMT._invoke(fnc, rate, args)
  env.info("DSMT._invoke called")
  timer.scheduleFunction(fnc, args, timer.getTime() + rate)
end


function DSMT:Start(chosenzone)
  env.info("DSMT:Start called")
  if self:_initMission(chosenzone) then
    -- invoke the manager
    self.Status = "Active"
    self.TimeStarted = timer.getAbsTime()
    DSMT._invoke(DSMT._manage, self.CheckRate, self)
  end
end
