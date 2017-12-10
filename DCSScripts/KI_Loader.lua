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
    ["groupId"] = groupObj.ID,
    ["tasks"] = {},
    ["hidden"] = hidden,
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
      for k, up in pairs(gp:getUnits()) do
        if up:isExist() and up:getLife() > 0 then
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
      table.insert(byrefTable, _group)
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
  
  if KI.Data.ActiveMissions then
    env.info("KI.Loader.ExtractStaticData - Extracting DSMT Static Objects") 
    for i = 1, #KI.Data.ActiveMissions do
      if not KI.Data.ActiveMissions[i].Done and KI.Data.ActiveMissions[i].Resource and KI.Data.ActiveMissions[i].Resource.Statics then
        env.info("KI.Loader.ExtractStaticData - found active side mission with static object resources")
        for k = 1, #KI.Data.ActiveMissions[i].Resource.Statics do
          local _staticTable = KI.Loader.GenerateStaticTable(KI.Data.ActiveMissions[i].Resource.Statics[k][1], 
                                                             KI.Data.ActiveMissions[i].Resource.Statics[k][2], "DSMT", false)
          table.insert(_data, _staticTable)
        end
      end
    end
  else
    env.info("KI.Loader.ExtractStaticData - FATAL ERROR (KI.Data.ActiveMissions NOT INITIALIZED)")
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
  for i = 1, #data["GroundGroups"] do
    local _g = data["GroundGroups"][i]
    -- check if the group has size > 0 and ignore if it does
    if _g["Size"] > 0 and #_g["Units"] > 0 then
      if not string.match(_g["Name"], "Template") then
        local _newg = coalition.addGroup(_g["Country"], _g["Category"], KI.Loader.GenerateGroupTable(_g))
        if _newg ~= nil then
          env.info("KI.Loader.ImportCoalitionGroups Newly Spawned Group created -- " .. _newg:getName())
        else
          env.info("KI.Loader.ImportCoalitionGroups ERROR failed to spawn group")
        end
      else
        env.info("KI.Loader.ImportCoalitionGroups - Template group found, ignoring")
      end
    end
  end
  
  return true
end
--



function KI.Loader.ImportStaticObjects(data)
  env.info("KI.Loader.ImportStaticObjects called")
  for i = 1, #data["StaticObjects"] do
    local _s = data["StaticObjects"][i]
    
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




function KI.Loader.SaveData()
  env.info("KI.Loader.SaveData() called")
  local t = KI.Data
  local _groups = {}
  
  KI.Loader.ExtractCoalitionGroupData(1, 2, _groups)
  KI.Loader.ExtractCoalitionGroupData(2, 2, _groups)
  
  -- append GroundGroups, Statics to missiondata
  t.GroundGroups = _groups
  t.StaticObjects = KI.Loader.ExtractStaticData()
  t.GarbageCollectionQueue = GC.Queue
  t.SLC = {} 
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
    
    if not _dataTable["SpawnID"] then
      env.info("KI.Loader.LoadData ERROR - SpawnID could not be found in file")
      return false
    else
      KI.Data.SpawnID = _dataTable["SpawnID"] -- load the current SortieID saved in memory
    end
    
    if not _dataTable["GameEventFileID"] then
      env.info("KI.Loader.LoadData ERROR - GameEventFileID could not be found in file")
      return false
    else
      KI.Data.GameEventFileID = _dataTable["GameEventFileID"] -- load the current SortieID saved in memory
    end
    
    
    return true
  else
    env.info("KI.Loader.LoadData ERROR opening file (" .. KI.Config.PathMissionData .. ") error: " .. _err)
    return false
  end
  
end
--

