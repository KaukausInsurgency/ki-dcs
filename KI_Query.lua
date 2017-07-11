if not KI then
  KI = {}
end


KI.Query = {}


-- returns nearest depot or nil with MOOSE group as paramter
function KI.Query.FindDepot_Group(transGroup)
  env.info("KI.FindDepot_Group called")
  for i = 1, #KI.Data.Depots do
    if transGroup:IsCompletelyInZone(KI.Data.Depots[i].Zone) then
      env.info("KI.FindDepot_Group - found zone")
      return KI.Data.Depots[i]
    end
  end
  env.info("KI.FindDepot_Group - nothing found")
  return nil
end

-- returns nearest Capture Point or nil with MOOSE group as parameter
function KI.Query.FindCP_Group(transGroup)
  env.info("KI.FindCP_Group called")
  for i = 1, #KI.Data.CapturePoints do
    if transGroup:IsCompletelyInZone(KI.Data.CapturePoints[i].Zone) then
      env.info("KI.FindCP_Group - found zone")
      return KI.Data.CapturePoints[i]
    end
  end
  env.info("KI.FindCP_Group - nothing found")
  return nil
end

-- returns nearest Depot or nil with StaticObject as parameter
function KI.Query.FindDepot_Static(obj)
  env.info("KI.FindDepot_Static called")
  local _opos = obj:getPoint()
  for i = 1, #KI.Data.Depots do
    if KI.Data.Depots[i].Zone:IsVec3InZone(_opos) then
      env.info("KI.FindDepot_Static - found zone")
      return KI.Data.Depots[i]
    end
  end
  env.info("KI.FindDepot_Static - nothing found")
  return nil
end

-- returns nearest Capture Point or nil with StaticObject as parameter
function KI.Query.FindCP_Static(obj)
  env.info("KI.FindCP_Static called")
  local _opos = obj:getPoint()
  for i = 1, #KI.Data.CapturePoints do
    if KI.Data.CapturePoints[i].Zone:IsVec3InZone(_opos) then
      env.info("KI.FindCP_Static - found zone")
      return KI.Data.CapturePoints[i]
    end
  end
  env.info("KI.FindCP_Static - nothing found")
  return nil
end
