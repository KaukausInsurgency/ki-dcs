-- Kaukasus Insurgency Init Namespace

if not KI then
  KI = {}
end

KI.Init = {}


function KI.Init.Depots()
  env.info("KI.InitDepots called")
  local objects = coalition.getStaticObjects(1)
  for i = 1, #objects do
    local obj = objects[i]
    local n = obj:getName()
    env.info("KI.InitDepotZones - looping through static objects (" .. n .. ")")
    if string.match(n, "Depot") then
      env.info("KI.InitDepotZones - found Depot object - initializing")
      local _depot = DWM:New(n, n .. " Zone", 7200, 150, false)
      _depot:SetResource("Infantry", 40, 1)
      _depot:SetResource("APC", 8, 2)
      _depot:SetResource("Tank", 8, 3)
      _depot:SetResource("Fuel Truck", 4, 1)
      _depot:SetResource("Command Truck", 4, 1)
      _depot:SetResource("Ammo Truck", 4, 1)
      _depot:SetResource("Power Truck", 4, 1)
      _depot:SetResource("Fuel Tanks", 8, 1)
      _depot:SetResource("Cargo Crates", 8, 1) 
      _depot:SetResource("Watchtower Wood", 4, 2)
      _depot:SetResource("Watchtower Supplies", 4, 1)
      _depot:SetResource("Outpost Pipes", 4, 3)
      _depot:SetResource("Outpost Wood", 4, 2)
      _depot:SetResource("Outpost Supplies", 4, 1)
      table.insert(KI.Data.Depots, _depot)
      env.info("KI.InitDepotZones - DWM Instance created for " .. n)
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
    table.insert(KI.Data.CapturePoints, _cp)
    env.info("KI.Init.CapturePoints - CP Instance created for " .. _cp.Name)
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
