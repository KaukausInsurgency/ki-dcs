if not KI then
  KI = {}
end


KI.Query = {}


-- returns nearest depot or nil with MOOSE group as parameter
function KI.Query.FindDepot_Group(transGroup)
  env.info("KI.Query.FindDepot_Group called")
  for i = 1, #KI.Data.Depots do
    if transGroup:IsCompletelyInZone(KI.Data.Depots[i].Zone) then
      env.info("KI.Query.FindDepot_Group - found zone")
      return KI.Data.Depots[i]
    end
  end
  env.info("KI.Query.FindDepot_Group - nothing found")
  return nil
end

-- returns nearest Capture Point or nil with MOOSE group as parameter
function KI.Query.FindCP_Group(transGroup)
  env.info("KI.Query.FindCP_Group called")
  for i = 1, #KI.Data.CapturePoints do
    if transGroup:IsCompletelyInZone(KI.Data.CapturePoints[i].Zone) then
      env.info("KI.Query.FindCP_Group - found zone")
      return KI.Data.CapturePoints[i]
    end
  end
  env.info("KI.Query.FindCP_Group - nothing found")
  return nil
end

-- returns nearest Depot or nil with StaticObject as parameter
function KI.Query.FindDepot_Static(obj)
  env.info("KI.Query.FindDepot_Static called")
  local _opos = obj:getPoint()
  for i = 1, #KI.Data.Depots do
    if KI.Data.Depots[i].Zone:IsVec3InZone(_opos) then
      env.info("KI.Query.FindDepot_Static - found zone")
      return KI.Data.Depots[i]
    end
  end
  env.info("KI.Query.FindDepot_Static - nothing found")
  return nil
end

-- returns nearest Capture Point or nil with StaticObject as parameter
function KI.Query.FindCP_Static(obj)
  env.info("KI.Query.FindCP_Static called")
  local _opos = obj:getPoint()
  for i = 1, #KI.Data.CapturePoints do
    if KI.Data.CapturePoints[i].Zone:IsVec3InZone(_opos) then
      env.info("KI.Query.FindCP_Static - found zone")
      return KI.Data.CapturePoints[i]
    end
  end
  env.info("KI.Query.FindCP_Static - nothing found")
  return nil
end


-- returns Player UCID from player name, or nil with DCS Unit as parameter
function KI.Query.FindUCID_Player(name)
  env.info("KI.Query.FindUCID_Player called (name: " .. name .. ")")
  if not name then return nil end
  
  for pid, op in pairs(KI.Data.OnlinePlayers) do
    env.info("KI.Query.FindUCID_Player - op.Name = '" .. op.Name .. "'")
    if op.Name == name then
      env.info("KI.Query.FindUCID_Player - returned " .. tostring(op.UCID))
      return op.UCID
    end
  end
  
  return nil
end


function KI.Query.FindSortieID_Player(name)
  env.info("KI.Query.FindSortieID_Player called (name: " .. name .. ")")
  if not name then return nil end
  
  for pid, op in pairs(KI.Data.OnlinePlayers) do
    if op.Name == name then
      env.info("KI.Query.FindSortieID_Player - returned " .. tostring(op.SortieID))
      return op.SortieID
    end
  end
  
  return nil
end

function KI.Query.FindNearestPlayer_Static(cargo)
  env.info("KI.Query.FindNearestPlayer_Static called")
  
  if not cargo then 
    env.info("KI.Query.FindNearestPlayer_Static - static is nil - exiting")
    return nil 
  end
  local punit = nil
  local pdistance = nil
  for pid, op in pairs(KI.Data.OnlinePlayers) do
    if op.Unit then
    
      local d = Spatial.Distance(op.Unit:getPoint(), cargo:getPoint()) 
      if pdistance and d < pdistance then
        env.info("KI.Query.FindNearestPlayer_Static - setting new closest distance")
        pdistance = d
        punit = op.Unit
      elseif not pdistance then
        env.info("KI.Query.FindNearestPlayer_Static - setting first distance")
        pdistance = d
        punit = op.Unit
      end
    else
      env.info("KI.Query.FindNearestPlayer_Static - OnlinePlayer object has no Unit - skipping")
    end
  end
  return punit, pdistance
end

function KI.Query.GetDepots(IsSupplier) 
  env.info("KI.Query.GetDepots called")
  if IsSupplier then
    IsSupplier = true
  else
    IsSupplier = false
  end
  local results = {}
  for i = 1, #KI.Data.Depots do
    local _d = KI.Data.Depots[i]
    if _d.IsSupplier == IsSupplier then
      table.insert(results, _d)
    end
  end
  
  return results
end

function KI.Query.GetDepotsResupplyRequired(SupplyCapacity) 
  env.info("KI.Query.GetDepotsResupplyRequired called")
  if not SupplyCapacity then
    SupplyCapacity = 0
  end
  local results = {}
  for i = 1, #KI.Data.Depots do
    local _d = KI.Data.Depots[i]
    if not _d.IsSupplier and not _d.IsSuppliesEnRoute and (_d.CurrentCapacity / _d.Capacity) <= SupplyCapacity then
      table.insert(results, _d)
    end
  end
  
  return results
end

function KI.Query.GetClosestSupplierDepot(Suppliers, Depot)
  env.info("KI.Query.GetClosestSupplierDepot called")
  if not Suppliers or not Depot then
    return nil
  end
  local result = nil
  local _dist
  local _dpos = Depot.Object:getPoint()
  
  for i = 1, #Suppliers do
    local _supplier = Suppliers[i]
    local _spos = _supplier.Object:getPoint()
    local _d = Spatial.Distance(_dpos, _spos)
    
    if _dist == nil or _d < _dist then
      _dist = _d
      result = _supplier
    end 
  end
  
  return result
end

function KI.Query.FindDepotByName(name)
  env.info("KI.Query.FindDepotByName called")
  if not name then
    return nil
  end
  
  for i = 1, #KI.Data.Depots do
    local _d = KI.Data.Depots[i]
    if _d.Name == name then
      return _d
    end
  end
  
  return nil
end
