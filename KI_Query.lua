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
  env.info("KI.Query.FindUCID_Player called")
  if not name then return nil end
  
  for pid, op in pairs(KI.Data.OnlinePlayers) do
    if op.Name == name then
      return op.UCID
    end
  end
  
  return nil
end