if not KI then
  KI = {}
end

KI.Scheduled = {}


function KI.Scheduled.ScanForSlingloadEvents(args, time)
  env.info("KI.Scheduled.ScanForSlingloadEvents called")
  
  local FilesToDelete = {}
  local RawEvents = {}
  for file in lfs.dir(KI.Config.PathSlingloadEvents) do
    env.info("KI.Scheduled.ScanForSlingloadEvents - file : " .. file)
    if string.match(file, ".lua") then 
      env.info("KI.Scheduled.ScanForSlingloadEvents - unprocessed file found (File: " .. file .. ")")
      local filePath = KI.Config.PathSlingloadEvents .. "\\" .. file
      env.info("KI.Scheduled.ScanForSlingloadEvents - full file path : " .. filePath)
      local _data, _err = loadfile(filePath)

      if _data then
        table.insert(RawEvents, _data())
      else
        env.info("KI.Scheduled.ScanForSlingloadEvents ERROR opening file (" .. filePath .. ") error: " .. _err)
      end -- end data read
      
      table.insert(FilesToDelete, filePath)
    end -- end string match .lua
  end -- end for file iteration
  
  env.info("KI.Scheduled.ScanForSlingloadEvents - deleting files")
  for i = 1, #FilesToDelete do
    -- delete the file
    os.remove(FilesToDelete[i])
  end
  
  env.info("KI.Scheduled.ScanForSlingloadEvents - searching for player match")
  for i = 1, #RawEvents do
    
    for uid, obj in pairs(KI.Data.UnitIDs) do
    
      local re = RawEvents[i]
      env.info("KI.Scheduled.ScanForSlingloadEvents (op.id_: " .. uid .. ", HeliID: " .. re["HeliID"] .. ")")
      if uid == re["HeliID"] then
        
        for c = 1, #SLC.CargoInstances do
          env.info("KI.Scheduled.ScanForSlingloadEvents - matched heliID (" .. re["HeliID"] .. ")")
          local cargo = SLC.CargoInstances[c]
          if cargo.Object and cargo.Object.id_ then
            env.info("KI.Scheduled.ScanForSlingloadEvents (cargo.Object.id_: " .. tostring(cargo.Object.id_) .. ", CargoID: " .. re["CargoID"] .. ")")
            if tostring(cargo.Object.id_) == re["CargoID"] then
              env.info("KI.Scheduled.ScanForSlingloadEvents - matched cargoID (" .. re["CargoID"] .. ")")
              local e = {}
              if re["Event"] == "HOOK" then
                e.id = KI.Defines.Event.KI_EVENT_SLING_HOOK
              elseif re["Event"] == "UNHOOK" then
                e.id = KI.Defines.Event.KI_EVENT_SLING_UNHOOK
              elseif re["Event"] == "UNHOOK_CRASH" then
                e.id = KI.Defines.Event.KI_EVENT_SLING_UNHOOK_DESTROYED
              end
              
              if e.id then
                local cargo_name = "Cargo"
                if cargo.Object:isExist() then         
                  cargo_name = cargo.Object:getName()
                end
                e.initiator = obj
                e.cargo = cargo_name
                e.time = re["Time"]
                env.info("KI.Scheduled.ScanForSlingloadEvents - raising slingload event")
                KI.Hooks.GameEventHandler:onEvent(e)  -- raise the event
              end
              break
            end
          else
            env.info("KI.Scheduled.ScanForSlingloadEvents - cargo.Object is nil, or cargo.Object.id_ is nil")
          end
          
        end -- end for
        
        break
      end -- end if heliID not nil
      
    end  -- end for
    
  end -- end for
  
end



-- this function checks if players are inside any zones, and sends a message to them so that they know they are inside a zone
function KI.Scheduled.IsPlayerInZone(side, time)
  env.info("KI.Scheduled.IsPlayerInZone called (side: " .. tostring(side) .. ", time: " .. tostring(time) .. ")")
  local _groups = coalition.getGroups(side, Group.Category.HELICOPTER)
  local moosegrp = GROUP  -- localizing the global variable as it improves performance storing a local reference
  
  -- loop through groups
  for j = 1, #_groups do
    local _unit = _groups[j]:getUnit(1)
    local _pname = _unit:getPlayerName()
    if _pname then
      env.info("KI.Scheduled.IsPlayerInZone - player name found : " .. _pname)
      local _grp = moosegrp:Find(_groups[j])

      local _grpID = _groups[j]:getID()
      local _inzone = false
      local _name = ""
      
      for i = 1, #KI.Data.CapturePoints do
        local _cp = KI.Data.CapturePoints[i]
        if _grp:IsCompletelyInZone(_cp.Zone) then      
          _name = _cp.Name
          _inzone = true
          env.info("KI.Scheduled.IsPlayerInZone - Player " .. _pname .. " is inside capture point " .. _name)
          break      
        end   
      end
      
      if not _inzone then
        for i = 1, #KI.Data.Depots do
          local _depot = KI.Data.Depots[i]
          if _grp:IsCompletelyInZone(_depot.Zone) then
            _name = _depot.Name
            _inzone = true
            env.info("KI.Scheduled.IsPlayerInZone - Player " .. _pname .. " is inside depot " .. _name)
            break      
          end   
        end
      end
      
      if _inzone and KI.Data.PlayerInZone[_pname] == nil then
        trigger.action.outTextForGroup(_grpID, "You are now entering " .. _name, 30, false)
        KI.Data.PlayerInZone[_pname] = true
      elseif not _inzone then
        env.info("KI.Scheduled.IsPlayerInZone - player " .. _pname .. " is not inside any zones, removing from hash")
        KI.Data.PlayerInZone[_pname] = nil
      end
    end -- end player name
  end -- end looping through red helicopters
  
  return time + KI.Config.PlayerInZoneCheckRate
end



-- looping function that updates Capture Point unit counts and their status (whether contested, blue, red, neutral, etc)
function KI.Scheduled.UpdateCPStatus(arg, time)
  env.info("KI.Scheduled.UpdateCPStatus called")
  
  local _AllyOwner 
  if KI.Config.AllySide == 1 then
    _AllyOwner = "Red"
  else
    _AllyOwner = "Blue"
  end
  
  local _rGroups = coalition.getGroups(1, Group.Category.GROUND)
  local _bGroups = coalition.getGroups(2, Group.Category.GROUND)
  
  -- get ship groups and join them to the red and blue group lists
  if true then
    local _rShips = coalition.getGroups(1, Group.Category.SHIP)
    local _bShips = coalition.getGroups(2, Group.Category.SHIP)
    for i = 1, #_rShips do
        _rGroups[#_rGroups + 1] = _rShips[i]
    end
    for i = 1, #_bShips do
        _bGroups[#_bGroups + 1] = _bShips[i]
    end
  end
  
  for i = 1, #KI.Data.CapturePoints do
    local _indicesToRemove = {}
    
    local _cp = KI.Data.CapturePoints[i]
    local _rcnt = 0
    local _bcnt = 0
    local _z = _cp.Zone
    local _slotsdisabled = false
    
    
    -- arg is boolean indicating if this is a first time run of this function
    -- on the very first call to UpdateCPStatus - any capture points not owned by allied forces will have _slotsdisabled set to false
    -- this is because we have not disabled any slots yet on our first run of this code
    -- then let the function correct itself and open up / disable slots after counting all the units
    -- on subsidiary calls to this function, we will set the _slotsdisabled to true to identify that these slots were disabled
    -- in a previous call
    -- this is done to remove redundant/duplicate calls to flag setting and dostring_in calls 
    if (_cp:GetOwnership() ~= _AllyOwner) and not arg then
      _slotsdisabled = true
    end
    
    
    -- loop through red groups
    for j = 1, #_rGroups do
      if _rGroups[j]:isExist() then
        local _runits = _rGroups[j]:getUnits()
        local _inZone = false
        for k = 1, #_runits do
          if _runits[k]:isActive() then
            local _rpos = _runits[k]:getPoint()
            if _z:IsVec3InZone(_rpos) then
              _rcnt = _rcnt + 1 -- increment counter for red
              _inZone = true
            end
          end
        end
        if _inZone then
          table.insert(_indicesToRemove, j) -- remove groups already found in zones from being iterated over next time around
        end
      else
        table.insert(_indicesToRemove, j) -- remove inactive / dead groups from being iterated over next time around
      end
    end
    
    -- remove red units that have already been found from future iterations
    -- this helps reduce the number of inner for loop iterations and optimizes the function
    -- needs to be reverse for loop because each time you remove an item all the indexes are shifted down
    -- so iterating from end to beginning makes the most sense here
    for j = #_indicesToRemove, 1, -1 do
      table.remove(_rGroups, _indicesToRemove[j])
    end

    -- empty out the array
    _indicesToRemove = {}
    
    for j = 1, #_bGroups do
      if _bGroups[j]:isExist() then
        local _bunits = _bGroups[j]:getUnits()
        local _inZone = false
        for k = 1, #_bunits do
          if _bunits[k]:isActive() then
            local _bpos = _bunits[k]:getPoint()
            if _z:IsVec3InZone(_bpos) then
              _bcnt = _bcnt + 1 -- increment counter for red
              _inZone = true
            end
          end
        end
        if _inZone then
          table.insert(_indicesToRemove, j) -- remove groups already found in zones from being iterated over next time around
        end
      else
        table.insert(_indicesToRemove, j) -- remove inactive / dead groups from being iterated over next time around
      end
    end
    
    -- remove blue units that have already been found from future iterations
    -- this helps reduce the number of inner for loop iterations and optimizes the function
    -- needs to be reverse for loop because each time you remove an item all the indexes are shifted down
    -- so iterating from end to beginning makes the most sense here
    for j = #_indicesToRemove, 1, -1 do
      table.remove(_bGroups, _indicesToRemove[j])
    end
    
    env.info("KI.Scheduled.UpdateCPStatus - CP Results for " .. _cp.Name .. " - Red: " .. tostring(_rcnt) .. " Blue: " .. tostring(_bcnt))
    
    _cp:SetCoalitionCounts(_rcnt, _bcnt)
    
    if _cp.Slots and #_cp.Slots > 0 then
      env.info("KI.Scheduled.UpdateCPStatus - CP has slots")
      -- enable slots
      if _cp:GetOwnership() == _AllyOwner and _slotsdisabled then
        env.info("KI.Scheduled.UpdateCPStatus - Enabling slots for " .. _cp.Name)
        for s = 1, #_cp.Slots do
          trigger.action.setUserFlag(_cp.Slots[s],0)  
        end   
      elseif _cp:GetOwnership() ~= _AllyOwner and not _slotsdisabled then -- disable slots
        env.info("KI.Scheduled.UpdateCPStatus - Disabling slots for " .. _cp.Name)
        for s = 1, #_cp.Slots do
          trigger.action.setUserFlag(_cp.Slots[s],100)  
        end 
      end
    end
  end -- end for capture points
  
  return time + KI.Config.CPUpdateRate
end


function KI.Scheduled.CheckSideMissions(args, time)
  env.info("KI.Scheduled.CheckSideMissions called")
  
    -- check if there are any done missions and remove them from queue
  for i = #KI.Data.ActiveMissions, 1, -1 do
    if KI.Data.ActiveMissions[i].Done then
      env.info("KI.Scheduled.CheckSideMissions - inactive mission was found - removing from current queue")
      table.insert(KI.Data.InactiveMissionsQueue, KI.Data.ActiveMissions[i])
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
      sidemission.TaskID = KI.IncrementTaskID()
      sidemission.InsertNewDBRecord = true
      sidemission:Start()
      table.insert(KI.Data.ActiveMissions, sidemission)
    end
  end
  
  return time + KI.Config.SideMissionUpdateRate + math.random(KI.Config.SideMissionUpdateRateRandom)
end


function KI.Scheduled.CheckDepotSupplyLevels(args, time)
  env.info("KI.Scheduled.CheckDepotSupplyLevels called")
  local suppliers = KI.Query.GetDepots(true)
  local depots = KI.Query.GetDepotsResupplyRequired(KI.Config.DepotMinCapacityToResupply)
  
  for i = 1, #depots do
    local _d = depots[i]
    local _stock = (_d.CurrentCapacity / _d.Capacity)
    
    env.info("KI.Scheduled.CheckDepotSupplyLevels - Depot " .. _d.Name 
    .. " is requesting a resupply (Stock: " .. tostring(_stock) .. ", Config: " 
    .. tostring(KI.Config.DepotMinCapacityToResupply) .. ")")
    
    local nearestSupplier = KI.Query.GetClosestSupplierDepot(suppliers, _d)
    if nearestSupplier then    
      env.info("KI.Scheduled.CheckDepotSupplyLevels - Found supplier " 
      .. nearestSupplier.Name .. " for depot " .. _d.Name)
      
      if _d:SpawnConvoy(nearestSupplier) then    
        env.info("KI.Scheduled.CheckDepotSupplyLevels - Successfully spawned convoy group at " 
        .. nearestSupplier.Name .. " for depot " .. _d.Name)
      else
        env.info("KI.Scheduled.CheckDepotSupplyLevels ERROR - Failed to spawn convoy group at " 
        .. nearestSupplier.Name .. " for depot " .. _d.Name)
      end
    else
      env.info("KI.Scheduled.CheckDepotSupplyLevels ERROR - KI.Query.GetClosestSupplierDepot returned nil")
    end
  end
  
  return time + KI.Config.DepotResupplyCheckRate
end

function KI.Scheduled.CheckConvoyCompletedRoute(args, time)
  env.info("KI.Scheduled.CheckConvoyCompletedRoute called")
  local _keysToRemove = {}
  for gname, o in pairs(KI.Data.Convoys) do
    local _grp = GROUP:FindByName(gname)
    local _depot = KI.Query.FindDepotByName(o.DestinationDepotName) 
    if _grp ~= nil and _grp:IsAlive() and _depot ~= nil then   
          
      local _gPos = _grp:GetVec3()
      local _dPos = _depot.Zone:GetVec3()
      local _distance = Spatial.Distance(_dPos, _gPos)
      env.info("KI.Scheduled.CheckConvoyCompletedRoute - Convoy " .. gname 
      .. " is still alive (distance to depot: " .. tostring(_distance) .. ")")
      if _distance <= KI.Config.ConvoyMinimumDistanceToDepot then
        env.info("KI.Scheduled.CheckConvoyCompletedRoute - Convoy is resupplying depot")
        _depot:Resupply(KI.Config.ResupplyConvoyAmount)
        _depot.IsSuppliesEnRoute = false
        table.insert(_keysToRemove, gname)
        _grp:Destroy()
      end
   
    elseif _depot == nil then
      env.info("KI.Scheduled.CheckConvoyCompletedRoute ERROR - KI.Query.FindDepotByName returned nil (criteria: " .. gname .. ")")
      table.insert(_keysToRemove, gname)
    else
      env.info("KI.Scheduled.CheckConvoyCompletedRoute - Convoy Group " .. gname .. " is dead - ignoring")
      _depot.IsSuppliesEnRoute = false
      KI.Toolbox.MessageCoalition(KI.Config.AllySide, "A convoy heading for " .. _depot.Name .. " has been destroyed!", 30)
      table.insert(_keysToRemove, gname)
    end -- end if group alive
  end
  
  env.info("KI.Scheduled.CheckConvoyCompletedRoute - cleaning up hash")
  for i = 1, #_keysToRemove do
    KI.Data.Convoys[_keysToRemove[i]] = nil
  end

  return time + KI.Config.ResupplyConvoyCheckRate
end

function KI.Scheduled.DataTransmissionPlayers(args, time)
  env.info("KI.Scheduled.DataTransmissionPlayers called")
  
  
  -- try to receive UDP data from Server MOD
  -- loop the UDP receive to get the last sent information
  -- this addresses the issue where the mission may send multiples of these udp messages
  -- and we are behind trying to process old ones with old data in them
  -- we also dont care about previous messages - we only care about the latest one that arrived
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
      for pid, op in pairs(KI.Data.OnlinePlayers) do
        if Data[pid] == nil then
          KI.Data.OnlinePlayers[pid] = nil
        end
      end
    else
      env.info("Error decoding UDP JSON Data - " .. _error)
    end
  end
  
  env.info("KI.Scheduled.DataTransmission - dumping online players : " .. KI.Toolbox.Dump(KI.Data.OnlinePlayers))
  
  -- send to Server Mod
  -- 1) Online Player list, with the current player life counts, sortieIDs
  socket.try(
        KI.UDPSendSocket:sendto(KI.JSON:encode({OnlinePlayers = KI.Data.OnlinePlayers}) .. KI.SocketDelimiter, 
                                "127.0.0.1", KI.Config.SERVERMOD_SEND_TO_PORT)
      )
  env.info("KI.Scheduled.DataTransmission - sent JSON OnlinePlayers to Server MOD")
  
  return time + KI.Config.DataTransmissionPlayerUpdateRate
end




function KI.Scheduled.DataTransmissionGeneral(args, time)
  env.info("KI.Scheduled.DataTransmissionGeneral called")
  
  -- because of the limits on UDP maximum receive size (which is limited to 8192 bytes according to LuaSocket implementation
  -- we segment this data into chunks so that we can send all of it without fear of dropping packets or losing data
  
  env.info("KI.Scheduled.DataTransmissionGeneral - Preparing CapturePoints Data")
  local CapturePointSegments = { }
  table.insert(CapturePointSegments, {})  -- create an inner array
  if true then
    local index = 1
    for i = 1, #KI.Data.CapturePoints do
      -- segment capture points every 6 elements
      if i % 6 == 0 then
        index = index + 1
        table.insert(CapturePointSegments, {})
      end
      local _cp = KI.Data.CapturePoints[i]
        
      local data = 
      { 
        ServerID = KI.Data.ServerID, 
        Name = _cp.Name,
        Type = _cp.Type,
        Status = _cp:GetOwnership(),
        BlueUnits = _cp.BlueUnits,
        RedUnits = _cp.RedUnits,    
        MaxCapacity = _cp.MaxCapacity,
        Text = _cp.Text or KI.Null,
        LatLong = _cp.Position.LatLong,
        MGRS = _cp.Position.MGRS,
        Latitude = _cp.Position.Latitude,
        Longitude = _cp.Position.Longitude
      }
      table.insert(CapturePointSegments[index], data)
    end
  end
  
  env.info("KI.Scheduled.DataTransmissionGeneral - Preparing Depot Data")
  local DepotSegments = {}
  table.insert(DepotSegments, {})  -- create an inner array
  if true then
    local index = 1
    local depot_status = "Red"
    if KI.Config.AllySide == 2 then
      depot_status = "Blue"
    end
    for i = 1, #KI.Data.Depots do
      -- segment depots every 6 elements
        if i % 6 == 0 then
          index = index + 1
          table.insert(DepotSegments, {})
        end
      local _depot = KI.Data.Depots[i]
      local _currentCapacity = _depot.CurrentCapacity
      local _maxCapacity = _depot.Capacity
      
      if _depot.IsSupplier then
        _currentCapacity = -1
        _maxCapacity = -1
      end
      local data = 
      { 
        ServerID = KI.Data.ServerID, 
        Name = _depot.Name,
        Status = depot_status,
        ResourceString = _depot:GetResourceEncoded(),
        CurrentCapacity = _currentCapacity,
        Capacity = _maxCapacity,
        LatLong = _depot.Position.LatLong,
        MGRS = _depot.Position.MGRS,
        Latitude = _depot.Position.Latitude,
        Longitude = _depot.Position.Longitude
      }
      table.insert(DepotSegments[index], data)
    end
  end
  
  env.info("KI.Scheduled.DataTransmissionGeneral - Preparing Active Missions Data")
  local DSMTSegments = {}
  
  if true then
    local index = 1
    for i = 1, #KI.Data.ActiveMissions do
      if index == 1 then
        table.insert(DSMTSegments, {})  -- create an inner array
      end
      -- segment dsmt every 6 elements
      if i % 6 == 0 then
        index = index + 1
        table.insert(DSMTSegments, {})
      end
      local _task = KI.Data.ActiveMissions[i]
      local data = {}
      if _task.InsertNewDBRecord then
        data = 
        { 
          IsAdd = true,
          ServerID = KI.Data.ServerID, 
          ServerMissionID = _task.TaskID,
          Status = _task.Status,
          TimeRemaining = _task.Expiry - _task.Life,
          Image = _task.Image,
          TaskName = _task.Name,
          TaskDesc = _task.Desc,   
          LatLong = _task.CurrentPosition.LatLong,
          MGRS = _task.CurrentPosition.MGRS,
          Latitude = _task.CurrentPosition.Latitude,
          Longitude = _task.CurrentPosition.Longitude
        }
        KI.Data.ActiveMissions[i].InsertNewDBRecord = false   -- set to false, as we dont need to add the same record multiple times
      else
        data = 
        { 
          IsAdd = false,
          ServerID = KI.Data.ServerID, 
          ServerMissionID = _task.TaskID,
          Status = _task.Status,
          TimeRemaining = _task.Expiry - _task.Life,
          Image = _task.Image,
          TaskName = KI.Null,
          TaskDesc = KI.Null,          
          LatLong = KI.Null,
          MGRS = KI.Null,
          Latitude = KI.Null,
          Longitude = KI.Null
        }
      end
      table.insert(DSMTSegments[index], data)
    end
    
    env.info("KI.Scheduled.DataTransmissionGeneral - Preparing Inactive Missions Data")
    -- prepare the inactive mission segment queue
    local inactivemissionsegments = {}
    for i = 1, #KI.Data.InactiveMissionsQueue do
      local _task = KI.Data.InactiveMissionsQueue[i]
      local data = {}
      if _task.InsertNewDBRecord then
        data = 
        { 
          IsAdd = true,
          ServerID = KI.Data.ServerID, 
          ServerMissionID = _task.TaskID,
          Status = _task.Status,
          TimeRemaining = _task.Expiry - _task.Life,
          TaskName = _task.Name,
          TaskDesc = _task.Desc,
          Image = _task.Image,
          LatLong = _task.CurrentPosition.LatLong,
          MGRS = _task.CurrentPosition.MGRS,
          Latitude = _task.CurrentPosition.Latitude,
          Longitude = _task.CurrentPosition.Longitude
        }
      else
        data = 
        { 
          IsAdd = false,
          ServerID = KI.Data.ServerID, 
          ServerMissionID = _task.TaskID,
          Status = _task.Status,
          TimeRemaining = _task.Expiry - _task.Life,
          Image = _task.Image,
          TaskName = KI.Null,
          TaskDesc = KI.Null,        
          LatLong = KI.Null,
          MGRS = KI.Null,
          Latitude = KI.Null,
          Longitude = KI.Null
        }
      end
      table.insert(inactivemissionsegments, data)
    end
    
    KI.Data.InactiveMissionsQueue = {}  -- empty the queue
    
    if #inactivemissionsegments > 0 then
      table.insert(DSMTSegments, inactivemissionsegments)
    end
  end

  env.info("KI.Scheduled.DataTransmissionGeneral - DSMTSegments count: " .. tostring(#DSMTSegments))
  --env.info("KI.Scheduled.DataTransmissionGeneral - dumping capture points : " .. KI.Toolbox.Dump(CapturePointSegments))
  --env.info("KI.Scheduled.DataTransmissionGeneral - dumping depots : " .. KI.Toolbox.Dump(DepotSegments))

  env.info("KI.Scheduled.DataTransmissionGeneral - prepaing UDP Send to Server MOD")
  
  -- 1) Depot Segments
  for i = 1, #DepotSegments do
    socket.try(
        KI.UDPSendSocket:sendto(KI.JSON:encode({Depots = DepotSegments[i]}) .. KI.SocketDelimiter, 
                                "127.0.0.1", KI.Config.SERVERMOD_SEND_TO_PORT)
      )
  end
  env.info("KI.Scheduled.DataTransmissionGeneral - sent JSON Depots to Server MOD")
  
  -- 2) Capture Point Segments
  for i = 1, #CapturePointSegments do
    socket.try(
        KI.UDPSendSocket:sendto(KI.JSON:encode({CapturePoints = CapturePointSegments[i]}) .. KI.SocketDelimiter, 
                                "127.0.0.1", KI.Config.SERVERMOD_SEND_TO_PORT)
      )
  end
  env.info("KI.Scheduled.DataTransmissionGeneral - sent JSON Capture Points to Server MOD")
  
  -- 3) Active Mission Segments
  for i = 1, #DSMTSegments do
    socket.try(
        KI.UDPSendSocket:sendto(KI.JSON:encode({SideMissions = DSMTSegments[i]}) .. KI.SocketDelimiter, 
                                "127.0.0.1", KI.Config.SERVERMOD_SEND_TO_PORT)
      )
  end
  env.info("KI.Scheduled.DataTransmissionGeneral - sent JSON Side Missions to Server MOD")
  
  return time + KI.Config.DataTransmissionGeneralUpdateRate
end



function KI.Scheduled.DataTransmissionGameEvents(args, time)
  env.info("DataTransmissionGameEvents called")
  KI.Scheduled.ScanForSlingloadEvents(args, time)
  
  if KI.Data.GameEventQueue and #KI.Data.GameEventQueue > 0 then
    local FilePath = KI.Config.PathGameEvents .. "\\GE_" .. KI.IncrementGameEventFileID() .. ".lua"
    env.info("DataTransmissionGameEvents - Generated File Path : " .. FilePath)
    
    if KI.Toolbox.WriteFile(KI.Data.GameEventQueue, FilePath) then
      env.info("KI.Scheduled.DataTransmissionGameEvents - data written to file")
      KI.Data.GameEventQueue = {} -- flush the game event queue
    else
      env.info("KI.Scheduled.DataTransmissionGameEvents - ERROR - failed to write to file")
    end
  end
  return time + KI.Config.DataTransmissionGameEventsUpdateRate
end



function KI.Scheduled.IncrementPlayerLives(args,time)
  env.info("KI.Scheduled.IncrementPlayerLives called")
  for pid, op in pairs(KI.Data.OnlinePlayers) do
    if op.Lives ~= KI.Null and op.Lives < 5 then
      op.Lives = op.Lives + 1
    end
  end
  
  KI.Toolbox.MessageCoalition(1, "Players have regained 1 life!", 60)
  KI.Toolbox.MessageCoalition(2, "Players have regained 1 life!", 60)
  
  return time + 3600
end