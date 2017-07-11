-- Garbage Collector Class
-- Handles cleanup and despawning of inactive resources

GC = {}
GC.Queue = {}
GC.LoopRate = 60 --KI.Toolbox.HoursToSeconds(0.083)  -- check every 5 minutes
GC.OnDespawn = nil  -- external callback function that passes parameter (gcItem.Name) as parameter
--GC.OnLifeExpired = nil -- external callback function that passes parameter (gcItem) prior to garbage collection

-- GCItem Structure
GCItem = 
{
  Name = "",                  -- Friendly display name of item
  Object = nil,               -- The DCS Object/Group
  PredicateIsExist = nil,     -- predicate that instructs GC how to check if the object/entity is alive - passes in object
  PredicateDestroy = nil,     -- predicate that instructs GC how to destroy an object/entity - passes in object
  OnLifeExpired = nil,        -- handler called when life has expired and object was destroyed - passes in gc_item
  PredicateArgs = nil,        -- Any predicate arguments (Closure, byref parameters)
  Predicate = nil,            -- Predicate function that must return a boolean (true if inactive, false if not) - passed in PredicateArgs
  PredicateForceDelete = nil,  -- Predicate Function that if returns true, will force immediate GC of object - passed in PredicateArgs
  ExpiryTime = 0,             -- The time until object expires (expressed in seconds)
  LifeTime = 0                -- the current inactive time of the object
}

function GCItem:New(name, obj, predicateExist, predicateDestroy, onlifeexpired, predicateArgs, predicate, predicateForceDelete, expiryTime)
  local self = KI.Toolbox.DeepCopy(GCItem)

	if self ~= nil then
		setmetatable( self, GCItem )
		self.__index = self	
	end
  
  self.Name = name
  self.Object = obj
  self.PredicateIsExist = predicateExist
  self.PredicateDestroy = predicateDestroy
  self.OnLifeExpired = onlifeexpired or nil
  self.PredicateArgs = predicateArgs or nil
  self.Predicate = predicate or nil
  self.PredicateForceDelete = predicateForceDelete or nil
  self.ExpiryTime = expiryTime or 60
  self.LifeTime = 0
  
  return self
end

function GC.Add(gc_item)
  env.info("GC.Add called for " .. gc_item.Name)
  table.insert(GC.Queue, gc_item)
  GC._Invoke(#GC.Queue)
end

function GC._Monitor(index, time)
  env.info("GC._Monitor called for index " .. tostring(index))
  local _item = GC.Queue[index]
  if _item == nil or _item.Object == nil or not _item.PredicateIsExist(_item.Object) then 
    env.info("GC._Monitor - '_item' is nil - exiting")
    return nil
  --[[elseif _item.Object:isExist and not _item.Object:isExist() then
    env.info("GC._Monitor - '_item' is nil (Object:isExist is false) - exiting")
    return nil
  elseif _item.Object:IsAlive and not _item.Object:IsAlive() then
    env.info("GC._Monitor - '_item' is nil (Object:IsAlive is false) - exiting")
    return nil --]]--
  end
  -- check predicate, if result is true, the object is idle and will be tracked as usual
  -- if the predicate is false, the item has been refreshed and the counter will reset to 0
  local _predResult = true
  if _item.Predicate then
    env.info("GC._Monitor - executing item " .. _item.Name .. " predicate call ")
    _predResult = _item.Predicate(_item.PredicateArgs)
  end
  if _predResult then
    env.info("GC._Monitor - item " .. _item.Name .. " predicate returned true - incrementing LifeTime")
    _item.LifeTime = _item.LifeTime + GC.LoopRate
  else
    env.info("GC._Monitor - item " .. _item.Name .. " predicate returned false - resetting LifeTime")
    _item.LifeTime = 0
  end
  -- check if the objects lifetime has expired, if it has delete it
  if _item.LifeTime >= _item.ExpiryTime or (_item.PredicateForceDelete and _item.PredicateForceDelete(_item.PredicateArgs)) then
    env.info("GC._Monitor - Lifetime for object has been reached - destroying")
    if _item.OnLifeExpired then
      env.info("GC._Monitor - OnLifeExpired handler called for " .. _item.Name)
      _item.OnLifeExpired(_item)
    end
    _item.PredicateDestroy(_item.Object)
    if GC.OnDespawn then
      GC.OnDespawn(_item.Name)
    end
    GC.Queue[index] = nil
    return nil
  else
    env.info("GC._Monitor - Lifetime for object is still good")
    return time + GC.LoopRate
  end
end

function GC._Invoke(index)
  env.info("GC._Invoke called")
  if GC.Queue[index] then
    env.info("GC._Invoke - valid index passed (" .. GC.Queue[index].Name .. ") - monitoring")
    timer.scheduleFunction(GC._Monitor, index, timer.getTime() + GC.LoopRate)
  else
    env.info("GC._Invoke - an invalid index was passed in")
  end
end