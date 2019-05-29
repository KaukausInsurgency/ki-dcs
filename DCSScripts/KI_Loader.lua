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

-- define locals to prevent constant lookups when trying to access global
local _kiDataWaypoints = KI.Data.Waypoints
local _generateGroupTable = KI.Loader.GenerateGroupTable
local _tryDisableAIDispersion = KI.Toolbox.TryDisableAIDispersion
local _envInfo = env.info
local _tableInsert = table.insert
local _stringMatch = string.match

-- prunes dead groups from KI.Data.Waypoints
-- KI.Data.Waypoints is a hash table, thus need to convert back using toDictionary()
function KI.Loader.PruneWaypoints(data, waypoints)
  waypoints = lualinq.from(waypoints)
                      :intersection(data["GroundGroups"], function(a,b) 
                        return a.Name == b.key 
                      end)
                      :toDictionary(function(val) 
                        return val.key, val.value
                      end)
  
  return waypoints
end

function KI.Loader.SyncWithMoose(dcsGroup)
  -- need to properly register this group and units with MOOSE in order for GROUP to work
  -- this is caused by another DCS timing issue, where-by event-birth is called a few frames after some code has executed
  -- MOOSE actually auto handles this by registering any units created via event-birth 
  -- in this case here the event birth has not fired when the group was spawned above
  -- therefore MOOSE does not know about it and it has not been registered
  -- this work around addresses this issue
  local _groupName = dcsGroup:getName()
  local _mooseGroup = GROUP:Find(dcsGroup)
  
  if _mooseGroup == nil then
    _envInfo("KI.Loader.SyncWithMoose - group '" .. _groupName .. "' not found in MOOSE Database - syncing")
    _DATABASE:AddGroup(_groupName)
    for _, _unit in pairs(dcsGroup:getUnits()) do
      _DATABASE:AddUnit(_unit:getName())                
    end             
    _mooseGroup = GROUP:Find(dcsGroup)
  end
  
  return _mooseGroup
end

-- handles waypoints for spawned groups - ie whether group needs to be retasked with moving to waypoint, or whether waypoint is complete
-- and should be removed from the KI.Data.Waypoints hash
function KI.Loader.HandleWaypoints(dcsGroup, scheduleFunction)
  local _groupName = dcsGroup:getName()
  local _wp = _kiDataWaypoints[_groupName]
  if _wp then
    _envInfo("KI.Loader.HandleWaypoints - found waypoints for group " .. _groupName)   

    local _mooseGroup = KI.Loader.SyncWithMoose(dcsGroup)
    local _groupPosition = _mooseGroup:GetVec3()
    _wp.z = _wp.y -- translate vec3 back into vec2
   
    _envInfo("KI.Loader.HandleWaypoints vec2: Group " .. _mooseGroup.GroupName .. " {x = " .. _groupPosition.x .. ", z = " .. _groupPosition.z .. "}")
    _envInfo("KI.Loader.HandleWaypoints vec2: Waypoint {x = " .. _wp.x .. ", z = " .. _wp.z .. "}")
   
    local _distance = Spatial.Distance(_wp, _groupPosition)
    _envInfo("KI.Loader.HandleWaypoints - group " .. _groupName .. " distance to waypoint - " .. tostring(_distance))
   
    if _distance > KI.Config.RespawnUnitWaypointDistance then
      _envInfo("KI.Loader.HandleWaypoints - group " .. _groupName .. " is still enroute to this waypoint - tasking")
    
      -- Schedule a function to retask waypoints to groups - we cant do this right away because group may not exist yet
      scheduleFunction(function(args, t) 
        _envInfo("KI.Loader.HandleWaypoints - Scheduled RouteToWP called")
        args.grp:TaskRouteToVec2(args.pos, args.pos.speed, args.pos.formation)
      
        _tryDisableAIDispersion(args.grp, "MOOSE")
        return nil
      end, { grp = _mooseGroup, pos = _wp}, timer.getTime() + KI.Config.RespawnTimeBeforeWaypointTasking)
  
    else
      _envInfo("KI.Loader.HandleWaypoints - group " .. _groupName .. " has completed this waypoint - ignoring")
      _kiDataWaypoints[_groupName] = nil  -- remove the group from the hash
    end
  else
    _envInfo("KI.Loader.HandleWaypoints - no waypoints found for group " .. _groupName)
  end      
end

-- Gets the GroundGroup data and filters out any side mission objects as well as empty groups (groups with no units)
function KI.Loader.GetGroundGroupsForImport(data)
  _envInfo("KI.Loader.GetGroundGroupsForImport called")
  return lualinq.from(data["GroundGroups"])
         :except(data["SideMissionGroundObjects"], function(_sm,_g) return _sm == _g.Name end)
         :where(function(_g) return _g.Size > 0 and #_g.Units > 0 end)
end

-- Gets DCS Groups for side and category, filtering for only existing groups and if there is an ignore prefix set
function KI.Loader.GetGroupsForExtraction(side, category, getGroupFunction)
  _envInfo("KI.Loader.GetGroupsForExtraction called")
  local _ignorePrefixGroups = false
  local _ignoreSaveGroupPrefix = KI.Config.IgnoreSaveGroupPrefix
  
  if _ignoreSaveGroupPrefix ~= nil and _ignoreSaveGroupPrefix ~= "" then
    _ignorePrefixGroups = true
  end

  return lualinq.from(getGroupFunction(side, category))
             :where(function(group) return 
                group:isExist() and group:getUnit(1) ~= nil and
                group:getUnit(1):isActive() and group:getUnit(1):getLife() > 0 
              end)
             :where(function(group) return 
                not _ignorePrefixGroups or 
                (
                  _ignorePrefixGroups and 
                  not _stringMatch(group:getName(), _ignoreSaveGroupPrefix)
                )
              end)
end

-- generates unit table that DCS Spawn Group expects
function KI.Loader.GenerateUnitsTable(unitsObj)
  _envInfo("KI.Loader.GenerateUnitsTable called")
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
        ["playerCanDrive"] = true,        -- Issue #207 on github
        ["heading"] = unitsObj[i].Heading,
      }
    _tableInsert(unitsData, _unit)
  end
  
  return unitsData
end


-- Generates table that DCS spawn group expects
function KI.Loader.GenerateGroupTable(groupObj, hidden)
  _envInfo("KI.Loader.GenerateGroupTable called")
  if hidden == nil then 
    hidden = true
  end
  local _unitData = KI.Loader.GenerateUnitsTable(groupObj.Units)
  local _groupData = 
  {
    ["visible"] = not hidden,
    ["taskSelected"] = true,
    ["route"] = {},
    --["groupId"] = groupObj.ID,        -- is an optional parameter, and may be interfering with group spawning
    ["tasks"] = {},
    ["hidden"] = hidden,
    ["units"] = _unitData,
    ["y"] = _unitData[1]["y"],
    ["x"] = _unitData[1]["x"],
    ["name"] = groupObj.Name,
    ["start_time"] = 0,
    ["task"] = "Ground Nothing",
  }
  
  return _groupData
end



-- extracts key information about the coalitions groups and packs it into a simple table for serialization and file write
function KI.Loader.ExtractCoalitionGroupData(side, category, byrefTable)
  _envInfo("KI.Loader.ExtractCoalitionGroupData called")
  
  
  local _linqResults = KI.Loader.GetGroupsForExtraction(side, category, coalition.getGroups)
  _linqResults:foreach(function(dcsGroup)
    local _groupTable = 
    { 
      Coalition = dcsGroup:getCoalition(), 
      Size = dcsGroup:getSize(), 
      Name = dcsGroup:getName(), 
      ID = dcsGroup:getID(), 
      Category = dcsGroup:getCategory(),
      Units = {}
    }
    local _first = true
    
    for k, _unit in pairs(dcsGroup:getUnits()) do
      if _unit:isExist() and _unit:getLife() > 0 then
        
        if _first then
          _groupTable.Country = _unit:getCountry()
          _first = false
        end
        
        local _unitTable = 
        { 
          Name = _unit:getName(), 
          ID = _unit:getID(), 
          Type = _unit:getTypeName(), 
          Position = _unit:getPosition(), 
          Heading = mist.getHeading(_unit, true) 
        }
        _tableInsert(_groupTable.Units, _unitTable)
      end
    end
    
    _tableInsert(byrefTable, _groupTable)
  end)
end



-- extracts key information about the coalitions static objects and packs it into a simple table for serialization and file write
function KI.Loader.ExtractStaticData()
  _envInfo("KI.Loader.ExtractStaticData called")
  
  local _data = {}
  -- first extract all cargo objects from SLC
  if SLC then
    _envInfo("KI.Loader.ExtractStaticData - Extracting SLC Cargo Objects")
    for i, cargo in pairs(SLC.CargoInstances) do
      
      if cargo.Object:isExist() then
        _envInfo("SLC cargo.Object: " .. cargo.Object:getName() .. " exists - saving")
        local _staticTable = KI.Loader.GenerateStaticTable(cargo.Object, "Cargos", "SLC", true)
        _tableInsert(_data, _staticTable)
      else
        _envInfo("SLC cargo.Object does not exist - ignoring")
      end
    end
  else
    _envInfo("KI.Loader.ExtractStaticData - FATAL ERROR (SLC NOT INITIALIZED)")
  end
  
  return _data
end
--

-- Generates a static table that written to file (similar to what DCS Spawn Static expects, but not 100%)
function KI.Loader.GenerateStaticTable(staticObj, category, component, isCargo)
  _envInfo("KI.Loader.GenerateStaticTable called")
  --isHidden = isHidden or true
  isCargo = isCargo or false
  
  local _country = ""
  if staticObj:getCoalition() == KI.Config.AllySide then
    _country = KI.Config.AllyCountryName -- USA
  else
    _country = "Insurgents"
  end
  
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
  _envInfo("KI.Loader.ImportCoalitionGroups called")
  
  -- first, remove any dead group entries from the waypoints table as there's no need to store a dead groups waypoint information
  KI.Data.Waypoints = KI.Loader.PruneWaypoints(data, KI.Data.Waypoints)
  -- GetGroundGroupsForImport
  local _linqResults = KI.Loader.GetGroundGroupsForImport(data)
  
  _linqResults:foreach(function(_g)
     -- hide the group on the map if insurgent coalition
     local _hidden = _g.Coalition == KI.Config.InsurgentSide
     if not _hidden then
       _envInfo("KI.Loader.ImportCoalitionGroups Group " .. _g["Name"] .. " is not hidden")
     end
     
     local _group = coalition.addGroup(_g.Country, _g.Category, _generateGroupTable(_g, _hidden))
     
     if _group ~= nil then
       _envInfo("KI.Loader.ImportCoalitionGroups Newly Spawned Group created -- " .. _group:getName())
       _tryDisableAIDispersion(_group, "DCS")
       KI.Loader.HandleWaypoints(_group, timer.scheduleFunction)
     else
       _envInfo("KI.Loader.ImportCoalitionGroups ERROR failed to spawn group")
     end 
   end)
  
  return true
end
--



function KI.Loader.ImportStaticObjects(data)
  _envInfo("KI.Loader.ImportStaticObjects called")
  for i = 1, #data["StaticObjects"] do
    local _s = data["StaticObjects"][i]
    local IsSideMissionObject = false
    for k = 1, #data["SideMissionGroundObjects"] do
      local _sm = data["SideMissionGroundObjects"][k]
      if _s["Name"] == _sm then
        _envInfo("KI.Loader.ImportStaticObjects - found side mission static object - ignoring")
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
        _envInfo("KI.Loader.ImportStaticObjects - static object spawned (" .. _s["Name"] .. ")")
      
        if _s["Component"] == "SLC" then
          SLC.RelinkCargo(obj)
        elseif _s["Component"] == "DSMT" then
          -- somepoint will need to relink the GC and DSMT to this item
        end
      else
        _envInfo("KI.Loader.ImportStaticObjects - ERROR - Static Object failed to spawn (" .. _s["Name"] .. ")")
      end
    
    end
    
  end
  
  return true
end
--



function KI.Loader.ImportCapturePoints(data)
  _envInfo("KI.Loader.ImportCapturePoints called")
  for i = 1, #data["CapturePoints"] do
    
    local _s = data["CapturePoints"][i]
    for k, _cp in pairs(KI.Data.CapturePoints) do
      
      if _cp.Name == _s["Name"] then
        _envInfo("KI.Loader.ImportCapturePoints - found matching CP (" .. _cp.Name .. ") - Updating")
        _cp.RedUnits = _s["RedUnits"]
        _cp.BlueUnits = _s["BlueUnits"]
        _cp.Owner = _s["Owner"]
        _cp.Defenses = _s["Defenses"]
        if _s["ID"] ~= nil then
          _cp.ID = _s["ID"]
        end
        break
      end
      
    end
    
  end
  
  return true
end
--



function KI.Loader.ImportSLC(data)
  _envInfo("KI.Loader.ImportSLC called")
  for i = 1, #data["SLC"]["InfantryInstances"] do
    local _slc = data["SLC"]["InfantryInstances"][i]
    local _grp = GROUP:FindByName(_slc["Group"]["GroupName"])
    if (_grp ~= nil) then
      _envInfo("KI.Loader.ImportSLC - Adding SLC Infantry Instance " .. _slc["Group"]["GroupName"])
      SLC.AddInfantryInstance(_grp, _slc["SpawnTemplate"], _slc["SpawnName"], _slc["MenuName"], _grp:GetSize())
    else
      _envInfo("KI.Loader.ImportSLC - ERROR could not find SLC Infantry Instance " .. _slc["Group"]["GroupName"])
    end
  end
  return true
end
--



function KI.Loader.ImportDWM(data)
  _envInfo("KI.Loader.ImportDWM called")
  for i = 1, #data["Depots"] do
    local _depotdata = data["Depots"][i]
    for k, depot in pairs(KI.Data.Depots) do
      if _depotdata["Name"] == depot.Name then
        _envInfo("KI.Loader.ImportDWM - updating Depot " .. depot.Name)
        depot.CurrentCapacity = _depotdata["CurrentCapacity"]
        depot.Resources = _depotdata["Resources"] -- overwrite the existing resources of the depot
        depot.IsSuppliesEnRoute = _depotdata["IsSuppliesEnRoute"] or false
        if _depotdata["ID"] ~= nil then
          depot.ID = _depotdata["ID"]
        end
      end
    end
  end
  return true
end
--



function KI.Loader.ImportGC(data)
  _envInfo("KI.Loader.ImportGC called")
  for i = 1, #data["GarbageCollectionQueue"] do
    local _gcdata = data["GarbageCollectionQueue"][i]
    local _gcObj = _gcdata["Object"]
    
    if _gcObj["GroupName"] ~= nil then
      -- this is a group so reattach existing group to GC
      local _grp = GROUP:FindByName(_gcdata["Name"])
      if _grp ~= nil then
        _envInfo("KI.Loader.ImportGC - Adding Group " .. _gcdata["Name"] .. " to GC Queue")
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
        _envInfo("KI.Loader.ImportGC - ERROR Group " .. _gcdata["Name"] .. " cannot be found - cannot add to GC Queue")
      end
    else
      -- this is a static object - search and re add to GC
      local _static = StaticObject.getByName(_gcdata["Name"])
      
      if _static ~= nil then
        _envInfo("KI.Loader.ImportGC - Adding Static Object " .. _gcdata["Name"] .. " to GC Queue")
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
                                KI.Hooks.GC_Crate_IsIdle, KI.Hooks.GC_Crate_DepotExpired, 
                                KI.Config.CrateDespawnTime_Wild)
        gc_item.LifeTime = _gcdata["LifeTime"]
        GC.Add(gc_item)
      else
        _envInfo("KI.Loader.ImportGC - ERROR Static Object " .. _gcdata["Name"] .. " cannot be found - cannot add to GC Queue")
      end
    end
  end
  return true
end


function KI.Loader.ImportDSMT(data)
  _envInfo("KI.Loader.ImportDSMT called")
  
  for i = 1, #data["ActiveMissions"] do
    
    local task = data["ActiveMissions"][i]
    local taskFound = false
    
    if not task.Done then
    
      _envInfo("KI.Loader.ImportDSMT - searching for side mission " .. task.Name)
      
      -- locate the existing task in this table
      for j = 1, #KI.Data.SideMissions do
      
        local _sidemission = KI.Data.SideMissions[j]
        
        if task.Name == _sidemission.Name then
        
          taskFound = true
          _envInfo("KI.Loader.ImportDSMT - found side mission " .. task.Name .. " - reinitializing")
          local activemission = KI.Toolbox.DeepCopy(_sidemission)
          
          _envInfo("KI.Loader.ImportDSMT - finding current zone")
          for z = 1, #_sidemission.Zones do
          
            local _zone = _sidemission.Zones[z]
            local p = _zone.Zone.point
            local cp = task["CurrentZone"]["Zone"]["point"]
            
            if p.y == cp.y and p.x == cp.x and p.z == cp.z then
              _envInfo("KI.Loader.ImportDSMT - found zone " .. _zone:GetName())
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
            _tableInsert(KI.Data.ActiveMissions, activemission)
            _envInfo("KI.Loader.ImportDSMT - created active mission")
          else
            _envInfo("KI.Loader.ImportDSMT - ERROR - could not find CurrentZone for mission!")
          end
          
          break         
        end
        
      end -- end for
      
    end -- if not task done
    
    if not taskFound and not task.Done then
      _envInfo("KI.Loader.ImportDSMT - ERROR - could not find side mission " .. task.Name .. " !")
    end
    
  end -- end for

  return true
  
end



function KI.Loader.SaveData()
  _envInfo("KI.Loader.SaveData() called") 
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
  t.Convoys = KI.Data.Convoys
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
  
  -- JTAC objects
  t.JTACs = GLOBAL_JTAC_UNITS
  
  if KI.Toolbox.WriteFile(t, KI.Config.PathMissionData) then
    _envInfo("KI.Loader.SaveData - successful write to file: " .. KI.Config.PathMissionData)
  else
    _envInfo("KI.Loader.SaveData - write to file FAILED! (Path: " .. KI.Config.PathMissionData .. ")")
  end
end




function KI.Loader.LoadData()
  _envInfo("KI.Loader.LoadData() called")
  
  local _data, _err = loadfile(KI.Config.PathMissionData)
  
  if _data then
    _envInfo("KI.Loader.LoadData - file load successful")
    local _dataTable = _data()
    
    if not _dataTable["Waypoints"] then
      _envInfo("KI.Loader.LoadData WARNING - Data.Waypoints could not be found in file")
    else
      KI.Data.Waypoints = _dataTable["Waypoints"]
    end
    
    if not _dataTable["Convoys"] then
      _envInfo("KI.Loader.LoadData WARNING - Convoys could not be found in file")
    else
      KI.Data.Convoys = _dataTable["Convoys"] -- load the current TaskID saved in memory
    end
    
    -- spawn in ground units
    if not KI.Loader.ImportCoalitionGroups(_dataTable) then
      _envInfo("KI.Loader.LoadData ERROR - ImportCoalitionGroups returned false")
      return false
    end
    
    -- spawn in static objects
    if not KI.Loader.ImportStaticObjects(_dataTable) then
      _envInfo("KI.Loader.LoadData ERROR - ImportStaticObjects returned false")
      return false
    end
    
    if not KI.Loader.ImportSLC(_dataTable) then
      _envInfo("KI.Loader.LoadData ERROR - ImportSLC returned false")
      return false
    end
    
    if not KI.Loader.ImportDWM(_dataTable) then
      _envInfo("KI.Loader.LoadData ERROR - ImportDWM returned false")
      return false
    end
    
    if not KI.Loader.ImportGC(_dataTable) then
      _envInfo("KI.Loader.LoadData ERROR - ImportGC returned false")
      return false
    end
    
    if not KI.Loader.ImportDSMT(_dataTable) then
      _envInfo("KI.Loader.LoadData ERROR - ImportDSMT returned false")
      return false
    end
    
    if not KI.Loader.ImportCapturePoints(_dataTable) then
      _envInfo("KI.Loader.LoadData ERROR - ImportCapturePoints returned false")
      return false
    end
    
    if not _dataTable["SortieID"] then
      _envInfo("KI.Loader.LoadData ERROR - SortieID could not be found in file")
      return false
    else
      KI.Data.SortieID = _dataTable["SortieID"]
    end
    
    if not _dataTable["SLCSpawnID"] then
      _envInfo("KI.Loader.LoadData ERROR - SLCSpawnID could not be found in file")
      return false
    else
      SLC.Config.SpawnID = _dataTable["SLCSpawnID"]
    end
    
    if not _dataTable["SpawnID"] then
      _envInfo("KI.Loader.LoadData ERROR - SpawnID could not be found in file")
      return false
    else
      KI.Data.SpawnID = _dataTable["SpawnID"] -- load the current SpawnID saved in memory
    end
    
    if not _dataTable["GameEventFileID"] then
      _envInfo("KI.Loader.LoadData ERROR - GameEventFileID could not be found in file")
      return false
    else
      KI.Data.GameEventFileID = _dataTable["GameEventFileID"] -- load the current GameEventFileID saved in memory
    end
    
    if not _dataTable["TaskID"] then
      _envInfo("KI.Loader.LoadData ERROR - TaskID could not be found in file")
      return false
    else
      KI.Data.TaskID = _dataTable["TaskID"] -- load the current TaskID saved in memory
    end
    
    if _dataTable["JTACs"] then
      _envInfo("KI.Loader.LoadData - Loading JTACs")
      for grpname, u in pairs(_dataTable["JTACs"]) do
        JTACAutoLase(grpname)    
      end
    end
    
    return true
  else
    _envInfo("KI.Loader.LoadData ERROR opening file (" .. KI.Config.PathMissionData .. ") error: " .. _err)
    return false
  end
  
end
--

