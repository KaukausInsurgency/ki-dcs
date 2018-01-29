if not ConfigChecker then
  ConfigChecker = {}
end

function ConfigChecker.IsNumber(x)
  return type(x) == "number", "Must be type number!"
end

function ConfigChecker.IsString(x)
  return type(x) == "string", "Must be type string!"
end

function ConfigChecker.IsBoolean(x)
  return type(x) == "boolean", "Must be type boolean! (true, false)"
end

function ConfigChecker.IsTable(x)
  return type(x) == "table", "Must be type table!"
end

function ConfigChecker.IsFunction(x)
  return type(x) == "function", "Must be type function!"
end

function ConfigChecker.IsStaticObject(x)
  return StaticObject.getByName(x) ~= nil, "Static Object '" .. tostring(x) .. "' must exist!"
end

function ConfigChecker.IsZone(x)
  return trigger.misc.getZone(x) ~= nil, "Zone '" .. tostring(x) .. "' must exist!"
end

function ConfigChecker.IsGroup(x)
  return Group.getByName(x) ~= nil, "Group '" .. tostring(x) .. "' must exist!"
end

function ConfigChecker.AreZones(x)
  local _msg = ""
  local result = true
  for i = 1, #x do
    if trigger.misc.getZone(x[i]) == nil then
      _msg = _msg .. "Zone '" .. tostring(x[i]) .. "' must exist!\n"
      result = false
    end
  end
  
  return result, _msg
end

function ConfigChecker.IsNumberPositive(x)
  return x > 0, "Must be positive number!"
end

--- Check if a file or directory exists in this path
function ConfigChecker.IsFile(file)
  local _filehandle, _err = io.open(file, "w")
  if _filehandle then
    _filehandle:close()
    _filehandle = nil
    os.remove(file)
    return true, "Path must exist!"
  else
    env.info("ConfigChecker.IsFile ERROR: " .. _err)
    return false, "Path must exist!"
  end
   
end

--- Check if a directory exists in this path
function ConfigChecker.IsPath(path)
   return ConfigChecker.IsFile(path .. "\\test.txt")
end

function ConfigChecker.IsPort(x)
  return x > 1023 and x < 65536, "Invalid Port Number! Cannot use privileged port (0 to 1023) - please choose another port number"
end

function ConfigChecker.IsReservedPort(x)
  return x > 1023 and x < 49152, "This is a reserved port number (1024 to 49151) - other windows services may use or block this port"
end

function ConfigChecker.ValueInArray(array, val)
    for index, value in ipairs(array) do
        if value == val then
            return true
        end
    end

    return false
end

-- taken from https://stackoverflow.com/questions/1426954/split-string-in-lua
function ConfigChecker.SplitString(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

function ConfigChecker.GetConfigValue(config)

  -- splits strings on . operator
  local keys = ConfigChecker.SplitString(config, ".")
  
  -- iterate over all the keys/subkeys to get the final value
  local ok, result = xpcall(function() 
    local val
    for i = 1, #keys do
      if val == nil then
        val = _G[keys[i]]
      else
        val = val[keys[i]]
      end
    end
    return val end, 
  function(err) env.info("KI ConfigChecker.GetConfigValue - ERROR - " .. err) end)
  
  if ok then
    return result
  else
    return nil
  end                          
end

function ConfigChecker.SetConfigValue(config, val)

  -- splits strings on . operator
  local keys = ConfigChecker.SplitString(config, ".")
  
  -- iterate over all the keys/subkeys to get the final value
  local ok, result = xpcall(function() 
    local str = ""
    for i = 1, #keys do
      if i == 1 then
        str = "_G[\"" .. tostring(keys[i]) .. "\"]"
      else
        str = str .. "[\"" .. tostring(keys[i]) .. "\"]"
      end
    end
    if type(val) == "string" then
      str = str .. " = \"" .. tostring(val) .. "\""
    else
      str = str .. " = " .. tostring(val)
    end
    return str 
  end, 
  function(err) env.info("KI ConfigChecker.SetConfigValue - ERROR - " .. err) end)
                            
  if ok then
    assert(loadstring(result))()
    return true
  else
    return false
  end      
end

function ConfigChecker.WriteFileArray(path, arr)
  local _filehandle, _err = io.open(path, "w")
  if _filehandle then
    for i = 1, #arr do
      _filehandle:write(arr[i], "\n")
    end
    _filehandle:flush()
    _filehandle:close()
    _filehandle = nil
    return true
  else
    env.info("ConfigChecker.KIConfig Write To File ERROR: " .. _err)
    return false
  end
end

ConfigChecker.KIConfigDictionary = 
{
  { 
    Name = "KI.Config.DataTransmissionPlayerUpdateRate", Default = 5, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive},
    Warnings = 
    {
      function(x) return x < 3, "Low values can have a large impact on game and network performance." end,
      function(x) return x > 10, "High values can have a large impact on player experience and waiting time to slot in." end
    }
  },
  { 
    Name = "KI.Config.DataTransmissionGameEventsUpdateRate", Default = 30, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive},
    Warnings =
    {
      function(x) return x < 5, "Low values can have a large impact on game and network performance." end
    }
  },
  { 
    Name = "KI.Config.DataTransmissionGeneralUpdateRate", Default = 15, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive},
    Warnings =
    {
      function(x) return x < 8, "Low values can have a large impact on game and network performance." end,
      function(x) return x > 30, "High values cause significant delay between live map and in game status." end
    }
  },
  { 
    Name = "KI.Config.SaveMissionRate", Default = 300, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive},
    Warnings = 
    {
      function(x) return x < 60, "Low values can have a significant impact on game performance" end
    }
  },
  { 
    Name = "KI.Config.CPUpdateRate", Default = 10, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive}
  },
  { 
    Name = "KI.Config.PlayerInZoneCheckRate", Default = 3, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive},
    Warnings =
    {
      function(x) return x > 5, "High values will negatively effect the players experience when entering/leaving zones" end
    }
  },
  { 
    Name = "KI.Config.SideMissionUpdateRate", Default = 2700, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive}
  },
  { 
    Name = "KI.Config.SERVERMOD_RECEIVE_PORT", Default = 6005, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive, ConfigChecker.IsPort},
    Warnings = {ConfigChecker.IsReservedPort}
  },
  { 
    Name = "KI.Config.SERVERMOD_SEND_TO_PORT", Default = 6006, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive, ConfigChecker.IsPort},
    Warnings = {ConfigChecker.IsReservedPort}
  },
  { 
    Name = "KI.Config.SERVER_SESSION_RECEIVE_PORT", Default = 6007, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive, ConfigChecker.IsPort},
    Warnings = {ConfigChecker.IsReservedPort}
  },
  
  
  { Name = "KI.Config.CrateDespawnTime_Depot", Default = 300, Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive}},
  { Name = "KI.Config.CrateDespawnTime_Wild", Default = 14400, Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive}}, 
  { Name = "KI.Config.RespawnTimeBeforeWaypointTasking", Default = 20, Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive}}, 
  { Name = "KI.Config.SideMissionUpdateRateRandom", Default = 900, Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive}},
  { Name = "KI.Config.SideMissionsMax", Default = 3, Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive}},
  
  { 
    Name = "KI.Config.SideMissionMaxTime", Default = 3600, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive},
    Warnings =
    {
      function(x) return x < 1800, "Low values may make it impossible for players to complete the mission in any reasonable amount of time. Please consider using larger value." end
    }
  },

  { Name = "KI.Config.SideMissionsDestroyTime", Default = 600, Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive}},
  { Name = "KI.Config.ParentFolder", Default = "Missions\\\\Kaukasus Insurgency\\\\", 
    Rules = 
    {
      ConfigChecker.IsString, 
      function(x)
        return ConfigChecker.IsPath(lfs.writedir() .. x)
      end    
    }
  },
  { 
    Name = "KI.Config.PathMissionData", 
    Default = lfs.writedir() .. "Missions\\\\Kaukasus Insurgency\\\\KI_Entities.lua", 
    Rules = {ConfigChecker.IsString}
  },
  { 
    Name = "KI.Config.PathGameEvents", 
    Default = lfs.writedir() .. "Missions\\\\Kaukasus Insurgency\\\\GameEvents", 
    Rules = {ConfigChecker.IsString, ConfigChecker.IsPath}
  },
  { 
    Name = "KI.Config.PathSlingloadEvents", 
    Default = lfs.writedir() .. "Missions\\\\Kaukasus Insurgency\\\\SlingloadEvents", 
    Rules = {ConfigChecker.IsString, ConfigChecker.IsPath}
  },
  { 
    Name = "KI.Config.RespawnUnitWaypointDistance", 
    Default = 200, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive},
    Warnings = {function(x) return x < 200, "Groups may get stuck and never complete their waypoints if this value is too small" end}
  },
  { 
    Name = "KI.Config.DepotMinCapacityToResupply", 
    Default = 0.5, 
    Rules = {ConfigChecker.IsNumber, function(x) return x >= 0 and x <= 1, "Value must be between 0 and 1!" end},
    Warnings = 
    {
      function(x) return x >= 0.81, "This may cause performance issues in multiplayer, we recommend reducing this value to at least 0.8." end,
      function(x) return x >= 0 and x <= 0.05, "This is a very low value; resupply convoy may never be called for this depot." end
    }
  },
  { 
    Name = "KI.Config.ResupplyConvoyAmount", 
    Default = 25, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive}
  },
  { 
    Name = "KI.Config.DepotResupplyCheckRate", 
    Default = 600, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive}
  },
  { Name = "KI.Config.ResupplyConvoyCheckRate", Default = 300, Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive}},
  { 
    Name = "KI.Config.ConvoyMinimumDistanceToDepot", 
    Default = 200, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive},
    Warnings = {function(x) return x < 200, "Groups may get stuck and never complete their waypoints if this value is too small" end}
  },

  { Name = "KI.Config.DisplayDepotMarkers", Default = false, Rules = {ConfigChecker.IsBoolean}},
  { Name = "KI.Config.DisplayCapturePointMarkers", Default = true, Rules = {ConfigChecker.IsBoolean}},
  
  { 
    Name = "KI.Config.Depots", 
    Rules = 
    {
      ConfigChecker.IsTable, 
      function(t)
        local msg = ""
        local result = true
        for i = 1, #t do
          local tt = t[i]
          if tt.name == nil then
            msg = msg .. "\n" .. "depot property 'name' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsString(tt.name) then
            msg = msg .. "\n" .. "depot property 'name' must be type string!"
            result = false
          elseif not ConfigChecker.IsStaticObject(tt.name) then
            local _, _innerMsg = ConfigChecker.IsStaticObject(tt.name)
            msg = msg .. "\n" .. _innerMsg
            result = false
          elseif tt.supplier == nil then
            msg = msg .. "\n" .. "depot property 'supplier' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsBoolean(tt.supplier)  then
            msg = msg .. "\n" .. "depot property 'supplier' must be type boolean (true, false)!"
            result = false
          end
        end
        
        return result, msg
      end  
    }
  },
  { 
    Name = "KI.Config.CP", 
    Rules = {ConfigChecker.IsTable}
  },
  { 
    Name = "KI.Config.SideMissions", 
    Rules = 
    {
      ConfigChecker.IsTable, 
      function(t)
        local msg = ""
        local result = true
        for i = 1, #t do
          local tt = t[i]
          if tt.name == nil then
            msg = msg .. "\n" .. "sidemission property 'name' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsString(tt.name) then
            msg = msg .. "\n" .. "sidemission property 'name' must be type string!"
            result = false
          elseif tt.desc == nil then
            msg = msg .. "\n" .. "sidemission property 'desc' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsString(tt.desc) then
            msg = msg .. "\n" .. "sidemission property 'desc' must be type string!"
            result = false
          elseif tt.image == nil then
            msg = msg .. "\n" .. "sidemission property 'image' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsString(tt.image) then
            msg = msg .. "\n" .. "sidemission property 'image' must be type string!"
            result = false
          elseif not ConfigChecker.ValueInArray({"camp"}, tt.image) then
            msg = msg .. "\n" .. "sidemission property 'image' has an invalid value, please use valid value!"
            result = false
          elseif tt.rate == nil then
            msg = msg .. "\n" .. "sidemission property 'rate' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsNumber(tt.rate) then
            msg = msg .. "\n" .. "sidemission property 'rate' must be type number!"
            result = false
          elseif tt.zones == nil then
            msg = msg .. "\n" .. "sidemission property 'zones' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsTable(tt.zones) then
            msg = msg .. "\n" .. "sidemission property 'zones' must be type table!"
            result = false    
          elseif not ConfigChecker.AreZones(tt.zones) then
            local _, _innerMsg = ConfigChecker.AreZones(tt.zones)
            msg = msg .. "\n" .. _innerMsg
            result = false    
          elseif tt.init == nil then
            msg = msg .. "\n" .. "sidemission property 'init' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsFunction(tt.init) then
            msg = msg .. "\n" .. "sidemission property 'init' must be type function!"
            result = false           
          elseif tt.destroy == nil then
            msg = msg .. "\n" .. "sidemission property 'destroy' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsFunction(tt.destroy) then
            msg = msg .. "\n" .. "sidemission property 'destroy' must be type function!"
            result = false    
          elseif tt.complete == nil then
            msg = msg .. "\n" .. "sidemission property 'complete' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsFunction(tt.complete) then
            msg = msg .. "\n" .. "sidemission property 'complete' must be type function!"
            result = false      
          elseif tt.fail == nil then
            msg = msg .. "\n" .. "sidemission property 'fail' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsFunction(tt.fail) then
            msg = msg .. "\n" .. "sidemission property 'fail' must be type function!"
            result = false         
          elseif tt.oncomplete == nil then
            msg = msg .. "\n" .. "sidemission property 'oncomplete' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsFunction(tt.oncomplete) then
            msg = msg .. "\n" .. "sidemission property 'oncomplete' must be type function!"
            result = false        
          elseif tt.onfail == nil then
            msg = msg .. "\n" .. "sidemission property 'onfail' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsFunction(tt.onfail) then
            msg = msg .. "\n" .. "sidemission property 'onfail' must be type function!"
            result = false            
          elseif tt.ontimeout == nil then
            msg = msg .. "\n" .. "sidemission property 'ontimeout' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsFunction(tt.ontimeout) then
            msg = msg .. "\n" .. "sidemission property 'ontimeout' must be type function!"
            result = false
          end -- end if
          
          
          
        end -- end for
        
        return result, msg
      end,
    }
  },
}





-- since users may have multiple copies of a config, pass in a path here instead
function ConfigChecker.KIConfig(path)
  env.info("ConfigChecker.KIConfig() called")
  local filedata = {}
  local loadSuccess, config = xpcall(function() return assert(loadfile(path))() end, 
                                     function(err) table.insert(filedata, "KI ConfigChecker - ERROR loading KI.Config - " .. err) end)
  local canrun = true
                    
  if loadSuccess then
    for i = 1, #ConfigChecker.KIConfigDictionary do
    
      local _config = ConfigChecker.KIConfigDictionary[i]
      local _val = ConfigChecker.GetConfigValue(_config.Name)
      local _failed = false
      
      if _val == nil then
        table.insert(filedata, "KI ConfigChecker - property " .. _config.Name .. " cannot be undefined!")
        _failed = true
      else
      
        for r = 1, #_config.Rules do
          local _rule = _config.Rules[r]
          local _result, _msg = _rule(_val)
          if _msg == nil then
            _msg = "Missing Message"
          end
          if not _result then
            table.insert(filedata, "KI ConfigChecker - property " .. _config.Name .. " " .. _msg)
            _failed = true
            break
          end
          
        end
        
      end
      
      if _failed then
      
        if _config.Default then
          if ConfigChecker.SetConfigValue(_config.Name, _config.Default) then
            table.insert(filedata, "KI ConfigChecker - property " .. _config.Name .. " Defaulted to value " .. tostring(_config.Default))
          else
            table.insert(filedata, "KI ConfigChecker - ERROR - could not set default on property " .. _config.Name .. " - Aborting")
            canrun = false
          end
        else
          table.insert(filedata, "KI ConfigChecker - property " .. _config.Name .. " ERROR - Cannot be defaulted to any value - Aborting")
          canrun = false
        end
      
      else
        -- successful config item - if there are warnings try validating those as well
        if _config.Warnings then
          for r = 1, #_config.Warnings do
            local _w = _config.Warnings[r]
            local _result, _msg = _w(_val)
            if _result then
              table.insert(filedata, "KI ConfigChecker - property " .. _config.Name .. " WARNING - " .. _msg)
            end
          end
        end -- end if warnings
        
      end -- end if failed/succeeded
      
    end -- end for
    
  else
    canrun = false
  end
  
  local _kiconfiglog = lfs.writedir() .. "Logs\\kiconfig.log"
  
  ConfigChecker.WriteFileArray(_kiconfiglog, filedata)
  
  return canrun
end