if not KI then
  KI = {}
end

KI.Scheduled = {}

-- looping function that updates Capture Point unit counts and their status (whether contested, blue, red, neutral, etc)
function KI.Scheduled.UpdateCPStatus(arg, time)
  env.info("KI.Scheduled.UpdateCPStatus called")
  local _rGroups = coalition.getGroups(1, Group.Category.GROUND)
  --local _rGroups = coalition.getGroups(1)
  --env.info("KI.Scheduled.UpdateCPStatus - retrieved red ground units")
  local _bGroups = coalition.getGroups(2, Group.Category.GROUND)
  --local _bGroups = coalition.getGroups(2)
  --env.info("KI.Scheduled.UpdateCPStatus - retrieved blue ground units")
  local _indicesToRemove = {}
  --env.info("KI.Scheduled.UpdateCPStatus - Data.CapturePoints count: " .. tostring(#KI.Data.CapturePoints))
  for i = 1, #KI.Data.CapturePoints do
    --env.info("KI.Scheduled.CaptureStatus looping for CP " .. KI.Data.CapturePoints[i].Name)
    
    local _rcnt = 0
    local _bcnt = 0
    local _z = KI.Data.CapturePoints[i].Zone
    
    -- loop through red groups
    for j = 1, #_rGroups do
      --env.info("KI.Scheduled.CaptureStatus - looping through red groups")
      --env.info("Group: " .. _rGroups[j]:getName())
      local _runits = _rGroups[j]:getUnits()
      local _inZone = false
      for k = 1, #_runits do
        local _rpos = _runits[k]:getPoint()
        if _z:IsVec3InZone(_rpos) then
          --env.info("KI.Scheduled.CaptureStatus - found red unit inside CP " .. KI.Data.CapturePoints[i].Name)
          _rcnt = _rcnt + 1 -- increment counter for red
          _inZone = true
        end
      end
      if _inZone then
        table.insert(_indicesToRemove, j)
      end
    end
    
    -- remove red units that have already been found from future iterations
    for j = 1, #_indicesToRemove do
      --env.info("KI.Scheduled.CaptureStatus - removing found red units from future iterations")
      table.remove(_rGroups, _indicesToRemove[j])
    end

    _indicesToRemove = {}
    
    for j = 1, #_bGroups do
      --env.info("KI.Scheduled.CaptureStatus - looping through blu groups")
      --env.info("Group: " .. _reds[j]:getName())
      local _bunits = _bGroups[j]:getUnits()
      local _inZone = false
      for k = 1, #_bunits do
        local _bpos = _bunits[k]:getPoint()
        if _z:IsVec3InZone(_bpos) then
          env.info("KI.Scheduled.CaptureStatus - found blu unit inside CP " .. KI.Data.CapturePoints[i].Name)
          _bcnt = _bcnt + 1 -- increment counter for red
          _inZone = true
        end
      end
      if _inZone then
        table.insert(_indicesToRemove, j)
      end
    end
    
    for j = 1, #_indicesToRemove do
      --env.info("KI.Scheduled.CaptureStatus - removing found blue units from future iterations")
      table.remove(_bGroups, _indicesToRemove[j])
    end
    
    env.info("KI.Scheduled.UpdateCPStatus - CP Results for " .. KI.Data.CapturePoints[i].Name .. " - Red: " .. tostring(_rcnt) .. " Blue: " .. tostring(_bcnt))
    
    KI.Data.CapturePoints[i]:SetCoalitionCounts(_rcnt, _bcnt)
  end
  
  return time + KI.Config.CPUpdateRate
end


function KI.Scheduled.CheckSideMissions(args, time)
  env.info("KI.Scheduled.CheckSideMissions called")
  
    -- check if there are any done missions and remove them from queue
  for i = #KI.Data.ActiveMissions, 1, -1 do
    if KI.Data.ActiveMissions[i].Done then
      env.info("KI.Scheduled.CheckSideMissions - inactive mission was found - removing from current queue")
      table.remove(KI.Data.ActiveMissions, i)
    end
  end
  env.info("KI.Scheduled.CheckSideMissions - current active: " .. tostring(#KI.Data.ActiveMissions) .. " limit: " .. tostring(KI.Config.SideMissionsMax))
  -- check if we can generate a new side mission
  if #KI.Data.ActiveMissions < KI.Config.SideMissionsMax then
    env.info("KI.Scheduled.CheckSideMissions - num active missions less than maximum - creating mission")
    local sidemission = KI.Toolbox.DeepCopy(KI.Data.SideMissions[math.random(#KI.Data.SideMissions)])
    if sidemission then
      env.info("KI.Scheduled.CheckSideMissions - chosen side mission - starting ...")
      sidemission:Start()
      table.insert(KI.Data.ActiveMissions, sidemission)
    end
  end
  
  return time + KI.Config.SideMissionUpdateRate + math.random(KI.Config.SideMissionUpdateRateRandom)
end


function KI.Scheduled.DataTransmission(args, time)
  env.info("KI.Scheduled.DataTransmission called")
  
  
  -- try to receive UDP data from Server MOD
  -- loop the UDP receive to get the last sent information
  -- this addresses the issue where the mission may send multiples of these udp messages
  -- and we are behind trying to process old ones with old data in them
  local received = nil
  while true do
    local rec = KI.UDPReceiveSocket:receive()
    if not rec then
      break
    else
      received = rec
    end
  end
  if received then
    local _error = ""
    local Success, Data = xpcall(function() return KI.JSON:decode(received) end, function(err) _error = err end)
    
    if Success and Data then
      env.info("KI.Scheduled.DataTransmission - UDP Data received from Server Mod")
      
      env.info("KI.Scheduled.DataTransmission - dumping UDP response - " .. KI.Toolbox.Dump(Data))
      -- Update existing OnlinePlayer records
      -- Insert new ones
      for pid, op in pairs(Data) do
        if KI.Data.OnlinePlayers[pid] then
          -- do a partial update - but do not modify UCID, Lives, or SortieID
          KI.Data.OnlinePlayers[pid].Name = op.Name
          KI.Data.OnlinePlayers[pid].Role = op.Role
          KI.Data.OnlinePlayers[pid].Banned = op.Banned
          
          -- special rule - get the lives from the server MOD only if the value is currently NULL here
          -- it may be that the DB returned the player record so we have the proper life count value
          if KI.Data.OnlinePlayers[pid].Lives == KI.Null then
            KI.Data.OnlinePlayers[pid].Lives = op.Lives
          end
        else
          KI.Data.OnlinePlayers[pid] = op
        end
      end
      env.info("KI.Scheduled.DataTransmission - Updated OnlinePlayers")
      -- remove entries that are no longer on the server
      --[[for pid, op in KI.Data do
        if Data[pid] == nil then
          KI.Data[pid] = nil
        end
      end
      --]]
    else
      env.info("Error decoding UDP JSON Data - " .. _error)
    end
  end
  
  
  env.info("KI.Scheduled.DataTransmission - Preparing CapturePoints Data")
  local CapturePointDBData = {}
  for i = 1, #KI.Data.CapturePoints do
    local data = 
    { 
      ServerID = KI.Data.ServerID, 
      Name = KI.Data.CapturePoints[i].Name,
      Status = KI.Data.CapturePoints[i]:GetOwnership(),
      BlueUnits = KI.Data.CapturePoints[i].BlueUnits,
      RedUnits = KI.Data.CapturePoints[i].RedUnits
    }
    table.insert(CapturePointDBData, data)
  end
  
  
  env.info("KI.Scheduled.DataTransmission - dumping online players : " .. KI.Toolbox.Dump(KI.Data.OnlinePlayers))
  env.info("KI.Scheduled.DataTransmission - dumping game events : " .. KI.Toolbox.Dump(KI.Data.GameEventQueue))
  env.info("KI.Scheduled.DataTransmission - dumping capture points : " .. KI.Toolbox.Dump(CapturePointDBData))
  
  -- send to Server Mod
  -- 1) Online Player list, with the current player life counts, sortieIDs
  -- 2) The current game event queue
  socket.try(
        KI.UDPSendSocket:sendto(
          KI.JSON:encode({ 
                            OnlinePlayers = KI.Data.OnlinePlayers, 
                            GameEventQueue = KI.Data.GameEventQueue,
                            CapturePoints = CapturePointDBData
                          }) 
                          .. KI.SocketDelimiter, 
                          "127.0.0.1", KI.Config.SERVERMOD_SEND_TO_PORT)
      )
  env.info("Sent UDP JSON Data to Server MOD")
      
  KI.Data.GameEventQueue = {} -- flush the game event queue
  
  return time + KI.Config.DataTransmissionUpdateRate
end











-- Old GC function that was integrated into KI (Replaced with GC Class instead)
--[[
-- Unused at this time (replaced with GC)
function KI.Scheduled.DespawnHandler(crate, time)
  env.info("Crate Despawn Timer Function Invoked")
  -- stop the timed function if the object is dead, destroyed, or not part of despawn queue
  if crate == nil then 
    env.info("Crate Despawn Timer - 'crate' is nil - exiting")
    return nil
  elseif not crate:isExist() then 
    env.info("Crate Despawn Timer - 'crate' does not exist - exiting")
    return nil 
  elseif KI.DespawnQueue[actionResult:getName()] == nil then
    env.info("Crate Despawn Timer - 'crate' is not part of GC Queue - exiting")
    return nil
  end
  env.info("Crate Despawn Timer Function called for " .. crate:getName())
  local _dqstruct = KI.DespawnQueue[crate:getName()]
  local _lastPos = _dqstruct.lastPosition
  local _newPos = crate:getPoint()
  
  -- check if in a depot zone
  local _depot = KI.Query.FindDepot_Static(crate)
  if _depot then
    env.info("Crate Despawn Function - " .. crate:getName() .. " is inside depot zone " .. _depot.Name)
    _dqstruct.inDepotZone = true
  else
    env.info("Crate Despawn Function - " .. crate:getName() .. " is not inside a depot zone")
    _dqstruct.inDepotZone = false
  end
  
  -- if the distance is less than 5 metres increment count
  if Spatial.Distance(_newPos, _lastPos) < 5 then
    env.info("Crate Despawn Function - crate position has not changed since last check")
    _dqstruct.timesChecked = _dqstruct.timesChecked + 60
  else
    env.info("Crate Despawn Function - crate position has changed, resetting")
    _dqstruct.timesChecked = 0
    _dqstruct.lastPosition = _newPos
  end
  
  -- if the crate is inside a depot zone and has been sitting there for 2 minutes - despawn it and put contents back into depot
  if _dqstruct.inDepotZone and _dqstruct.timesChecked >= 300 then
    env.info("Crate Despawn Function - crate is in depot and is being despawned")
    trigger.action.outText("Crate " .. crate:getName() .. " has been despawned and contents put back into depot!", 10)
    local n = crate:getName()
    if string.match(n, "SLC FuelTruckCrate") then
      _depot:Give("Fuel Truck", 1)
    elseif string.match(n, "SLC CommandTruckCrate") then
      _depot:Give("Command Truck", 1)
    elseif string.match(n, "SLC AmmoTruckCrate") then
      _depot:Give("Ammo Truck", 1)
    elseif string.match(n, "SLC PowerTruckCrate") then
      _depot:Give("Power Truck", 1)
    elseif string.match(n, "SLC BTRCrate") then
      _depot:Give("APC", 1)
    elseif string.match(n, "SLC TankCrate") then
      _depot:Give("Tank", 1)
    elseif string.match(n, "SLC WTWood") then
      _depot:Give("Watchtower Wood", 1)
    elseif string.match(n, "SLC WTCrate") then
      _depot:Give("Watchtower Supplies", 1)
    elseif string.match(n, "SLC OPPipe") then
      _depot:Give("Outpost Pipes", 1)
    elseif string.match(n, "SLC OPCrate") then
      _depot:Give("Outpost Supplies", 1)
    elseif string.match(n, "SLC OPWood") then
      _depot:Give("Outpost Wood", 1)
    else
      env.info("SLC.Config.PreOnRadioAction - attempt to take an unknown resource from a depot")
    end
    KI.DespawnQueue[crate:getName()] = nil
    crate:destroy()
    return nil
  elseif not _dqstruct.inDepotZone and _dqstruct.timesChecked >= 900 then
    env.info("Crate Despawn Function - crate is in wild and is being despawned")
    trigger.action.outText("Crate " .. crate:getName() .. " has been despawned out in the wild!", 10)
    crate:destroy()
    KI.DespawnQueue[crate:getName()] = nil
    return nil
  else
    env.info("Crate Despawn Function - crate is still being monitored - updating GC information")
    -- update GC information
    KI.DespawnQueue[crate:getName()] = _dqstruct
    return time + 60
  end
end
]]--

