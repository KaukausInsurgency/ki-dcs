--[[
KI.Loader Module

This module is responsible for handling all forms of file read / write.
Exposes functions for converting DCS Objects into extract tables to export to a file.
Exports units, static objects, cargo, active side missions, SLC units, CapturePoints, Garbage Collection, and Depot Contents

Exposes functions for importing extract tables into DCS.

The bread and butter of persistent mission data is handled here.

Author: Igneous01

]]--

if not KI then
  KI = {}
end

KI.Loader = {}


-- generates unit table that DCS Spawn Group expects
function KI.Loader.GenerateUnitsTable(unitsObj)
  env.info("KI.Loader.GenerateUnitsTable called")
  local unitsData = {}
  
  for i = 1, #unitsObj do
    local _unit = 
      {
        ["type"] = unitsObj[i].Type,
        ["transportable"] = 
        {
          ["randomTransportable"] = false,
        },
        ["unitId"] = unitsObj[i].ID,
        ["skill"] = "Average",
        ["y"] = unitsObj[i].Position.p.z,
        ["x"] = unitsObj[i].Position.p.x,
        ["name"] = unitsObj[i].Name,
        ["playerCanDrive"] = false,
        ["heading"] = unitsObj[i].Heading,
      }
    table.insert(unitsData, _unit)
  end
  
  return unitsData
end


-- Generates table that DCS spawn group expects
function KI.Loader.GenerateGroupTable(groupObj, hidden)
  env.info("KI.Loader.GenerateGroupTable called")
  hidden = hidden or true
  local unitData = KI.Loader.GenerateUnitsTable(groupObj.Units)
  local groupData = 
  {
    ["visible"] = true,
    ["taskSelected"] = true,
    ["route"] = {},
    --["groupId"] = groupObj.ID,        -- is an optional parameter, and may be interfering with group spawning
    ["tasks"] = {},
    ["hidden"] = false,
    ["units"] = unitData,
    ["y"] = unitData[1]["y"],
    ["x"] = unitData[1]["x"],
    ["name"] = groupObj.Name,
    ["start_time"] = 0,
    ["task"] = "Ground Nothing",
  }
  
  return groupData
end



-- extracts key information about the coalitions groups and packs it into a simple table for serialization and file write
function KI.Loader.ExtractCoalitionGroupData(side, category, byrefTable)
  env.info("KI.Loader.ExtractCoalitionGroupData called")
  for i, gp in pairs(coalition.getGroups(side, category)) do
    if gp:isExist() then
      local _group = 
      { 
        Coalition = gp:getCoalition(), 
        Size = gp:getSize(), 
        Name = gp:getName(), 
        ID = gp:getID(), 
        Category = gp:getCategory(),
      }
      _group.Units = {}
      local _first = true
      local _groupActive = false
      for k, up in pairs(gp:getUnits()) do
        _groupActive = up:isActive()
        if up:isExist() and up:getLife() > 0 and _groupActive then
          if _first then
            _group.Country = up:getCountry()
            _first = false
          end
          local _unit = 
          { 
            Name = up:getName(), 
            ID = up:getID(), 
            Type = up:getTypeName(), 
            Position = up:getPosition(), 
            Heading = mist.getHeading(up, true) 
          }
          table.insert(_group.Units, _unit)
        end
      end
      if _groupActive then
        table.insert(byrefTable, _group)
      else
        env.info("KI.Loader.ExtractCoalitionGroupsData - Group " .. gp:getName() .. " is not active - ignoring")
      end
    else
      env.info("KI.Loader.ExtractCoalitionGroupsData - Group " .. gp:getName() .. " does not exist - ignoring")
    end
  end
end



-- extracts key information about the coalitions static objects and packs it into a simple table for serialization and file write
function KI.Loader.ExtractStaticData()
  env.info("KI.Loader.ExtractStaticData called")
  
  local _data = {}
  -- first extract all cargo objects from SLC
  if SLC then
    env.info("KI.Loader.ExtractStaticData - Extracting SLC Cargo Objects")
    for i, cargo in pairs(SLC.CargoInstances) do
      
      if cargo.Object:isExist() then
        env.info("SLC cargo.Object: " .. cargo.Object:getName() .. " exists - saving")
        local _staticTable = KI.Loader.GenerateStaticTable(cargo.Object, "Cargos", "SLC", true)
        table.insert(_data, _staticTable)
      else
        env.info("SLC cargo.Object does not exist - ignoring")
      end
    end
  else
    env.info("KI.Loader.ExtractStaticData - FATAL ERROR (SLC NOT INITIALIZED)")
  end
  
  return _data
end
--

-- Generates a static table that written to file (similar to what DCS Spawn Static expects, but not 100%)
function KI.Loader.GenerateStaticTable(staticObj, category, component, isCargo)
  env.info("KI.Loader.GenerateStaticTable called")
  --isHidden = isHidden or true
  isCargo = isCargo or false
  
  local _country = ""
  if staticObj:getCoalition() == 1 then
    _country = "Russia"
  else
    _country = "Insurgents"
  end

  --local _category = "Warehouses" -- this can also be 'Fortifications', 'Warehouses', 'Cargos'
  
  local staticData = 
  {
    ["Coalition"] = staticObj:getCoalition(),
    ["Country"] = _country, 
    ["CountryID"] = staticObj:getCountry(),
    ["Category"] = category,
    ["Type"] = staticObj:getTypeName(),
    ["Name"] = staticObj:getName(),
    ["ID"] = staticObj:getID(),
    ["CanCargo"] = isCargo,
    ["Heading"] = mist.getHeading(staticObj, true),
    ["y"] = staticObj:getPosition().p.z,
    ["x"] = staticObj:getPosition().p.x,
    ["Component"] = component
  }
  
  if isCargo then
    staticData["mass"] = staticObj:getCargoWeight()
  end
  
  return staticData
end
--



function KI.Loader.ImportCoalitionGroups(data)
  env.info("KI.Loader.ImportCoalitionGroups called")
  
  -- first, remove any dead group entries from the waypoints table as there's no need to store a dead groups waypoint information
  local groups_to_remove = {}
  for gname, wpdata in pairs(KI.Data.Waypoints) do
    local group_found = false
    for i = 1, #data["GroundGroups"] do
      local ggname = data["GroundGroups"][i]["Name"]
      if ggname == gname then
        env.info("KI.Loader.ImportCoalitionGroups - found wp info for " .. gname)
        group_found = true
        break
      end    
    end
    
    if not group_found then
      env.info("KI.Loader.ImportCoalitionGroups - group " .. gname .. " is dead or nil - removing from waypoints")
      table.insert(groups_to_remove, gname)
    end
  end
  
  for i = 1, #groups_to_remove do
    KI.Data.Waypoints[groups_to_remove[i]] = nil
  end
  
  for i = 1, #data["GroundGroups"] do
    local _g = data["GroundGroups"][i]
    
    local IsSideMissionObject = false
    for k = 1, #data["SideMissionGroundObjects"] do
      local _sm = data["SideMissionGroundObjects"][k]
      if _g["Name"] == _sm then
        env.info("KI.Loader.ImportStaticObjects - found side mission ground group - ignoring")
        IsSideMissionObject = true
        break
      end
    end
    
    -- check if the group has size > 0 and ignore if it does
    if _g["Size"] > 0 and #_g["Units"] > 0 and not IsSideMissionObject then
      local _newg = coalition.addGroup(_g["Country"], _g["Category"], KI.Loader.GenerateGroupTable(_g, false))
      -- if the group is spawned successfully
      if _newg ~= nil then
        env.info("KI.Loader.ImportCoalitionGroups Newly Spawned Group created -- " .. _newg:getName())
        local _wp = KI.Data.Waypoints[_newg:getName()]
        if _wp then
          env.info("KI.Loader.ImportCoalitionGroups - found waypoints for group " .. _newg:getName())   
          local moosegrp = GROUP:Find(_newg)
          local grpvec2 = moosegrp:GetVec3()
          _wp.z = _wp.y -- translate vec3 back into vec2
          env.info("AICOM.Spawn vec2: Group " .. moosegrp.GroupName .. " {x = " .. grpvec2.x .. ", z = " .. grpvec2.z .. "}")
          env.info("AICOM.Spawn vec2: Waypoint {x = " .. _wp.x .. ", z = " .. _wp.z .. "}")
          local distance = Spatial.Distance(_wp, grpvec2)
          env.info("KI.Loader.ImportCoalitionGroups - group " .. _newg:getName() .. " distance to waypoint - " .. tostring(distance))
          if distance > KI.Config.RespawnUnitWaypointDistance then
            env.info("KI.Loader.ImportCoalitionGroups - group " .. _newg:getName() .. " is still enroute to this waypoint - tasking")
            
            -- Schedule a function to retask waypoints to groups - we cant do this right away because group may not exist yet
            timer.scheduleFunction(function(args, t) 
              env.info("KI.Loader.ImportCoalitionGroups - Scheduled Spawn called")
              args.grp:TaskRouteToVec2(args.pos, args.pos.speed, args.pos.formation)
              return nil
            end, { grp = moosegrp, pos = _wp}, timer.getTime() + KI.Config.RespawnTimeBeforeWaypointTasking)
            
          else
            env.info("KI.Loader.ImportCoalitionGroups - group " .. _newg:getName() .. " has completed this waypoint - ignoring")
            KI.Data.Waypoints[_newg:getName()] = nil  -- remove the group from the hash
          end
        else
          env.info("KI.Loader.ImportCoalitionGroups - no waypoints found for group " .. _newg:getName())
        end -- end if wp
        
      else
        env.info("KI.Loader.ImportCoalitionGroups ERROR failed to spawn group")
      end -- end if _newg ~= nil
    end -- end if size and units > 0
  end -- end for
  
  return true
end
--



function KI.Loader.ImportStaticObjects(data)
  env.info("KI.Loader.ImportStaticObjects called")
  for i = 1, #data["StaticObjects"] do
    local _s = data["StaticObjects"][i]
    local IsSideMissionObject = false
    for k = 1, #data["SideMissionGroundObjects"] do
      local _sm = data["SideMissionGroundObjects"][k]
      if _s["Name"] == _sm then
        env.info("KI.Loader.ImportStaticObjects - found side mission static object - ignoring")
        IsSideMissionObject = true
        break
      end
    end
    
    if not IsSideMissionObject then
    
      local obj = coalition.addStaticObject(_s["CountryID"], {
        country = _s["Country"],
        category = _s["Category"],
        x = _s["x"],
        y = _s["y"],
        type = _s["Type"],
        name = _s["Name"],
        mass = _s["Mass"],
        canCargo = _s["CanCargo"],
        heading = _s["Heading"]
      })
    
      -- if the static object belongs to SLC, Relink the Cargo with SLC module (and GC if necessary)
      if obj then
        env.info("KI.Loader.ImportStaticObjects - static object spawned (" .. _s["Name"] .. ")")
      
        if _s["Component"] == "SLC" then
          SLC.RelinkCargo(obj)
        elseif _s["Component"] == "DSMT" then
          -- somepoint will need to relink the GC and DSMT to this item
        end
      else
        env.info("KI.Loader.ImportStaticObjects - ERROR - Static Object failed to spawn (" .. _s["Name"] .. ")")
      end
    
    end
    
  end
  
  return true
end
--



function KI.Loader.ImportCapturePoints(data)
  env.info("KI.Loader.ImportCapturePoints called")
  for i = 1, #data["CapturePoints"] do
    
    local _s = data["CapturePoints"][i]
    for k, _cp in pairs(KI.Data.CapturePoints) do
      
      if _cp.Name == _s["Name"] then
        env.info("KI.Loader.ImportCapturePoints - found matching CP (" .. _cp.Name .. ") - Updating")
        _cp.RedUnits = _s["RedUnits"]
        _cp.BlueUnits = _s["BlueUnits"]
        _cp.Owner = _s["Owner"]
        _cp.Defenses = _s["Defenses"]
        break
      end
      
    end
    
  end
  
  return true
end
--



function KI.Loader.ImportSLC(data)
  env.info("KI.Loader.ImportSLC called")
  for i = 1, #data["SLC"]["InfantryInstances"] do
    local _slc = data["SLC"]["InfantryInstances"][i]
    local _grp = GROUP:FindByName(_slc["Group"]["GroupName"])
    if (_grp ~= nil) then
      env.info("KI.Loader.ImportSLC - Adding SLC Infantry Instance " .. _slc["Group"]["GroupName"])
      SLC.AddInfantryInstance(_grp, _slc["SpawnTemplate"], _slc["SpawnName"])
    else
      env.info("KI.Loader.ImportSLC - ERROR could not find SLC Infantry Instance " .. _slc["Group"]["GroupName"])
    end
  end
  return true
end
--



function KI.Loader.ImportDWM(data)
  env.info("KI.Loader.ImportDWM called")
  for i = 1, #data["Depots"] do
    local _depotdata = data["Depots"][i]
    for k, depot in pairs(KI.Data.Depots) do
      if _depotdata["Name"] == depot.Name then
        env.info("KI.Loader.ImportDWM - updating Depot " .. depot.Name)
        depot.CurrentCapacity = _depotdata["CurrentCapacity"]
        depot.Resources = _depotdata["Resources"] -- overwrite the existing resources of the depot
      end
    end
  end
  return true
end
--



function KI.Loader.ImportGC(data)
  env.info("KI.Loader.ImportGC called")
  for i = 1, #data["GarbageCollectionQueue"] do
    local _gcdata = data["GarbageCollectionQueue"][i]
    local _gcObj = _gcdata["Object"]
    
    if _gcObj["GroupName"] ~= nil then
      -- this is a group so reattach existing group to GC
      local _grp = GROUP:FindByName(_gcdata["Name"])
      if _grp ~= nil then
        env.info("KI.Loader.ImportGC - Adding Group " .. _gcdata["Name"] .. " to GC Queue")
        local gc_item = GCItem:New(_gcdata["Name"], 
                                _grp, 
                                function(obj)
                                  return obj:IsAlive()
                                end,
                                function(obj)
                                  return obj:Destroy()
                                end,
                                KI.Hooks.GCOnLifeExpiredTroops,
                                { Depot = nil, Object = _grp },
                                KI.Hooks.GC_Troops_IsIdle, nil, KI.Config.CrateDespawnTime_Depot)
        gc_item.LifeTime = _gcdata["LifeTime"]
        GC.Add(gc_item)
      else
        env.info("KI.Loader.ImportGC - ERROR Group " .. _gcdata["Name"] .. " cannot be found - cannot add to GC Queue")
      end
    else
      -- this is a static object - search and re add to GC
      local _static = StaticObject.getByName(_gcdata["Name"])
      
      if _static ~= nil then
        env.info("KI.Loader.ImportGC - Adding Static Object " .. _gcdata["Name"] .. " to GC Queue")
        local gc_item = GCItem:New(_gcdata["Name"], 
                                _static, 
                                function(obj)
                                  return obj:isExist()
                                end,
                                function(obj)
                                  return obj:destroy()
                                end,
                                KI.Hooks.GCOnLifeExpiredCrate,
                                { LastPosition = _static:getPoint(), Depot = nil, Object = _static, DepotIdleTime = 0 },
                                KI.Hooks.GC_Crate_IsIdle, KI.Hooks.GC_Crate_DepotExpired, KI.Config.CrateDespawnTime_Wild)
        gc_item.LifeTime = _gcdata["LifeTime"]
        GC.Add(gc_item)
      else
        env.info("KI.Loader.ImportGC - ERROR Static Object " .. _gcdata["Name"] .. " cannot be found - cannot add to GC Queue")
      end
    end
  end
  return true
end


function KI.Loader.ImportDSMT(data)
  env.info("KI.Loader.ImportDSMT called")
  
  for i = 1, #data["ActiveMissions"] do
    
    local task = data["ActiveMissions"][i]
    local taskFound = false
    
    if not task.Done then
    
      env.info("KI.Loader.ImportDSMT - searching for side mission " .. task.Name)
      
      -- locate the existing task in this table
      for j = 1, #KI.Data.SideMissions do
      
        local _sidemission = KI.Data.SideMissions[j]
        
        if task.Name == _sidemission.Name then
        
          taskFound = true
          env.info("KI.Loader.ImportDSMT - found side mission " .. task.Name .. " - reinitializing")
          local activemission = KI.Toolbox.DeepCopy(_sidemission)
          
          env.info("KI.Loader.ImportDSMT - finding current zone")
          for z = 1, #_sidemission.Zones do
          
            local _zone = _sidemission.Zones[z]
            local p = _zone.Zone.point
            local cp = task["CurrentZone"]["Zone"]["point"]
            
            if p.y == cp.y and p.x == cp.x and p.z == cp.z then
              env.info("KI.Loader.ImportDSMT - found zone " .. _zone:GetName())
              activemission.CurrentZone = _zone
              break
            end
            
          end
          
          if activemission.CurrentZone then
            activemission.InsertNewDBRecord = task.InsertNewDBRecord
            activemission.TaskID = task.TaskID
            activemission.Expiry = task.Expiry
            activemission.DestroyTime = task.DestroyTime
            activemission.Life = task.Life
            activemission.Done = task.Done
            activemission:Start(activemission.CurrentZone)
            table.insert(KI.Data.ActiveMissions, activemission)
            env.info("KI.Loader.ImportDSMT - created active mission")
          else
            env.info("KI.Loader.ImportDSMT - ERROR - could not find CurrentZone for mission!")
          end
          
          break         
        end
        
      end -- end for
      
    end -- if not task done
    
    if not taskFound and not task.Done then
      env.info("KI.Loader.ImportDSMT - ERROR - could not find side mission " .. task.Name .. " !")
    end
    
  end -- end for

  return true
  
end



function KI.Loader.SaveData()
  env.info("KI.Loader.SaveData() called") 
  local _groups = {}
  
  KI.Loader.ExtractCoalitionGroupData(1, 2, _groups)
  KI.Loader.ExtractCoalitionGroupData(2, 2, _groups)
  
  local t = {}
  t.CapturePoints = KI.Data.CapturePoints
  t.Depots = KI.Data.Depots
  t.ActiveMissions = KI.Data.ActiveMissions
  t.InactiveMissionsQueue = KI.Data.InactiveMissionsQueue
  t.GameEventQueue = KI.Data.GameEventQueue
  t.SpawnID = KI.Data.SpawnID
  t.SortieID = KI.Data.SortieID
  t.GameEventFileID = KI.Data.GameEventFileID
  t.TaskID = KI.Data.TaskID
  t.Waypoints = KI.Data.Waypoints
  t.SideMissionGroundObjects = KI.Data.SideMissionGroundObjects
  --t.UnitIDs = KI.Data.UnitIDs
  
  -- append GroundGroups, Statics to missiondata
  t.GroundGroups = _groups
  t.StaticObjects = KI.Loader.ExtractStaticData()
  t.GarbageCollectionQueue = GC.Queue
  t.SLC = {} 
  t.SLCSpawnID = SLC.Config.SpawnID
  t.SLC.InfantryInstances = SLC.InfantryInstances
  t.SLC.CargoInstances = SLC.CargoInstances
  t.SLC.TransportInstances = SLC.TransportInstances
  t.SLC.ZoneInstances = SLC.ZoneInstances
  
  if KI.Toolbox.WriteFile(t, KI.Config.PathMissionData) then
    env.info("KI.Loader.SaveData - successful write to file: " .. KI.Config.PathMissionData)
  else
    env.info("KI.Loader.SaveData - write to file FAILED! (Path: " .. KI.Config.PathMissionData .. ")")
  end
end




function KI.Loader.LoadData()
  env.info("KI.Loader.LoadData() called")
  
  local _data, _err = loadfile(KI.Config.PathMissionData)
  
  if _data then
    env.info("KI.Loader.LoadData - file load successful")
    local _dataTable = _data()
    
    if not _dataTable["Waypoints"] then
      env.info("KI.Loader.LoadData ERROR - Data.Waypoints is nil")
      return false
    else
      KI.Data.Waypoints = _dataTable["Waypoints"]
    end
    
    -- spawn in ground units
    if not KI.Loader.ImportCoalitionGroups(_dataTable) then
      env.info("KI.Loader.LoadData ERROR - ImportCoalitionGroups returned false")
      return false
    end
    
    -- spawn in static objects
    if not KI.Loader.ImportStaticObjects(_dataTable) then
      env.info("KI.Loader.LoadData ERROR - ImportStaticObjects returned false")
      return false
    end
    
    if not KI.Loader.ImportSLC(_dataTable) then
      env.info("KI.Loader.LoadData ERROR - ImportSLC returned false")
      return false
    end
    
    if not KI.Loader.ImportDWM(_dataTable) then
      env.info("KI.Loader.LoadData ERROR - ImportDWM returned false")
      return false
    end
    
    if not KI.Loader.ImportGC(_dataTable) then
      env.info("KI.Loader.LoadData ERROR - ImportGC returned false")
      return false
    end
    
    if not KI.Loader.ImportDSMT(_dataTable) then
      env.info("KI.Loader.LoadData ERROR - ImportDSMT returned false")
      return false
    end
    
    if not KI.Loader.ImportCapturePoints(_dataTable) then
      env.info("KI.Loader.LoadData ERROR - ImportCapturePoints returned false")
      return false
    end
    
    if not _dataTable["SortieID"] then
      env.info("KI.Loader.LoadData ERROR - SortieID could not be found in file")
      return false
    else
      KI.Data.SortieID = _dataTable["SortieID"]
    end
    
    if not _dataTable["SLCSpawnID"] then
      env.info("KI.Loader.LoadData ERROR - SLCSpawnID could not be found in file")
      return false
    else
      SLC.Config.SpawnID = _dataTable["SLCSpawnID"]
    end
    
    if not _dataTable["SpawnID"] then
      env.info("KI.Loader.LoadData ERROR - SpawnID could not be found in file")
      return false
    else
      KI.Data.SpawnID = _dataTable["SpawnID"] -- load the current SpawnID saved in memory
    end
    
    if not _dataTable["GameEventFileID"] then
      env.info("KI.Loader.LoadData ERROR - GameEventFileID could not be found in file")
      return false
    else
      KI.Data.GameEventFileID = _dataTable["GameEventFileID"] -- load the current GameEventFileID saved in memory
    end
    
    if not _dataTable["TaskID"] then
      env.info("KI.Loader.LoadData ERROR - TaskID could not be found in file")
      return false
    else
      KI.Data.TaskID = _dataTable["TaskID"] -- load the current TaskID saved in memory
    end
    
    return true
  else
    env.info("KI.Loader.LoadData ERROR opening file (" .. KI.Config.PathMissionData .. ") error: " .. _err)
    return false
  end
  
end
--

