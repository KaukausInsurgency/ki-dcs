-- Kaukasus Insurgency Init Namespace

if not KI then
  KI = {}
end

KI.Init = {}


function KI.Init.Depots()
  env.info("KI.Init.Depots called")
  local objects = coalition.getStaticObjects(KI.Config.AllySide)
  for i = 1, #objects do
    local obj = objects[i]
    local n = obj:getName()
    env.info("KI.Init.Depots - looping through static objects (" .. n .. ")")
    if string.match(n, "Depot") then
      env.info("KI.Init.Depots - found Depot object - initializing")
      
      local IsSupplier = false
      local Capacity = 150
      for k = 1, #KI.Config.Depots do
        local cdepot = KI.Config.Depots[k]
        if cdepot.name == n then
          env.info("KI.Init.Depots - found match in KI.Config.Depots")
          IsSupplier = cdepot.supplier
          if IsSupplier then
            Capacity = -1
          end
        end
      end
      
      -- temporarily change depot size to 400 to test convoy resupply
      local _depot = DWM:New(n, n .. " Zone", 7200, Capacity, IsSupplier)
      
      env.info("KI.Init.Depots - Adding Content")
      for j = 1, #DWM.Config.Contents do
        local _content = DWM.Config.Contents[j]
        _depot:SetResource(_content.Name, _content.InitialStock, _content.StockMultiplier)
        env.info("KI.Init.Depots - Added Resource " .. _content.Name)
      end

      table.insert(KI.Data.Depots, _depot)   
      env.info("KI.Init.Depots - DWM Instance created for " .. n)
      
      if KI.Config.DisplayDepotMarkers then
        env.info("KI.Init.Depots - Creating F10 Map Marker")
        trigger.action.markToAll(KI.IncrementMarkerID(), _depot.Name, _depot.Zone:GetVec3())
      end
    end
  end
end


function KI.Init.CapturePoints()
  env.info("KI.Init.CapturePoints called")
  for i = 1, #KI.Config.CP do
    local ccp = KI.Config.CP[i]
    local _cp = CP:New(ccp.name, ccp.zone, ccp.type, ccp.spawnzone1, ccp.spawnzone2, ccp.text)  
    _cp.Slots = ccp.slots
    _cp.MaxCapacity = ccp.capacity
    _cp.Airbase = ccp.airbase
    _cp.CSCICalled = false
    table.insert(KI.Data.CapturePoints, _cp)   
    env.info("KI.Init.CapturePoints - CP Instance created for " .. _cp.Name)
    
    if KI.Config.DisplayCapturePointMarkers then
      env.info("KI.CapturePoints - Creating F10 Map Marker")
      trigger.action.markToAll(KI.IncrementMarkerID(), _cp.Name, _cp.Zone:GetVec3())
    end    
  end
end


function KI.Init.SideMissions()
  env.info("KI.Init.SideMissions called")
  for i = 1, #KI.Config.SideMissions do
    -- should create a validation function here
    
    local _sm = DSMT:New(KI.Config.SideMissions[i].name, KI.Config.SideMissions[i].desc, KI.Config.SideMissions[i].image)
                        :SetZones(KI.Config.SideMissions[i].zones)
                        :SetCheckRate(KI.Config.SideMissions[i].rate)
                        :SetExpiryTime(KI.Config.SideMissionMaxTime)
                        :SetDestroyTime(KI.Config.SideMissionsDestroyTime)
                        :SetInitFnc(KI.Config.SideMissions[i].init)
                        :SetDestroyFnc(KI.Config.SideMissions[i].destroy)
                        :SetCompleteFnc(KI.Config.SideMissions[i].complete)
                        :SetFailFnc(KI.Config.SideMissions[i].fail)
                        :SetOnCompleteFnc(KI.Config.SideMissions[i].oncomplete)
                        :SetOnFailFnc(KI.Config.SideMissions[i].onfail)
                        :SetOnTimeoutFnc(KI.Config.SideMissions[i].ontimeout)
    table.insert(KI.Data.SideMissions, _sm)
    env.info("KI.Init.SideMissions - Side Mission Instance created for " .. _sm.Name)
  end
end

-- tries to receive UDP message from serverMod for SessionID and ServerID
function KI.Init.GetServerAndSession()
  env.info("KI.Init.GetServerAndSession called")
  local received = KI.UDPReceiveSocketServerSession:receive()
  
  if received then
    local _error = "No Error"
    local Success, Data = xpcall(function() return KI.JSON:decode(received) end, function(err) _error = err end)
    
    env.info("GetServerAndSession - Dump : " .. KI.Toolbox.Dump(Data))
    if Success and Data and Data.ServerID and Data.SessionID then
      KI.Data.ServerID = Data.ServerID
      KI.Data.SessionID = Data.SessionID
      env.info("KI.Init.GetServerAndSession - Successfully received")
      return true
    else
      env.info("KI.Init.GetServerAndSession - FAILURE TO GET ServerID and SessionID - JSON DECODE FAILED! (Error: " .. _error .. ")")
      return false
    end
  else
    env.info("KI.Init.GetServerAndSession - FAILURE TO GET ServerID and SessionID - TIMEOUT REACHED")
    return false
  end
end
