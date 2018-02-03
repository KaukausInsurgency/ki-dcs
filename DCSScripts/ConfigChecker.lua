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

function ConfigChecker.AreGroups(x)
  local _msg = ""
  local result = true
  for i = 1, #x do
    if Group.getByName(x[i]) == nil then
      _msg = _msg .. "Group '" .. tostring(x[i]) .. "' must exist!\n"
      result = false
    end
  end
  
  return result, _msg
end

function ConfigChecker.AreGroupsAllySide(x)
  local _msg = ""
  local result = true
  for i = 1, #x do
    local _grp = Group.getByName(x[i])
    if _grp ~= nil then
      if _grp:getCoalition() ~= KI.Config.AllySide then
        _msg = _msg .. "Group '" .. tostring(x[i]) .. "' is on the wrong coalition! Must be part of Ally Coalition!\n"
        result = false
      end
    end
  end
  
  return result, _msg
end

function ConfigChecker.AreGroupsInsurgentSide(x)
  local _msg = ""
  local result = true
  for i = 1, #x do
    local _grp = Group.getByName(x[i])
    if _grp ~= nil then
      if _grp:getCoalition() ~= KI.Config.InsurgentSide then
        _msg = _msg .. "Group '" .. tostring(x[i]) .. "' is on the wrong coalition! Must be part of Insurgent Coalition!\n"
        result = false
      end
    end
  end
  
  return result, _msg
end

function ConfigChecker.AreClients(x)

  local _msg = ""
  local result = true

  -- currently no implementation exists for getting client groups
--[[
  for i = 1, #x do
    if CLIENT:FindByName(x[i], "", true) == nil then
      _msg = _msg .. "Client Group '" .. tostring(x[i]) .. "' must exist!\n"
      result = false
    end
  end
]]--

  return result, _msg
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

function ConfigChecker.IsNumberPositiveOrZero(x)
  return x >= 0, "Must be positive number or 0!"
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

    return false, "Invalid Value '" .. tostring(val) .. "'"
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







-- since users may have multiple copies of a config, pass in a path here instead
function ConfigChecker.Check(path, dict, configname, logfilename)
  env.info("ConfigChecker.Check() called")
  local filedata = {}
  local loadSuccess, config = xpcall(function() return assert(loadfile(path))() end, 
                                     function(err) table.insert(filedata, "KI ConfigChecker - ERROR loading " .. configname .. " - " .. err) end)
  local canrun = true
                    
  if loadSuccess then
    for i = 1, #dict do
    
      local _config = dict[i]
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
      
        if _config.Default ~= nil then
          if ConfigChecker.SetConfigValue(_config.Name, _config.Default) then
            table.insert(filedata, "KI ConfigChecker - WARNING - property " .. _config.Name .. " Defaulted to value " .. tostring(_config.Default))
          else
            table.insert(filedata, "KI ConfigChecker - ERROR - could not set default on property " .. _config.Name .. " - Aborting")
            canrun = false
          end
        else
          table.insert(filedata, "KI ConfigChecker - ERROR - property " .. _config.Name .. " Cannot be defaulted to any value - Aborting")
          canrun = false
        end
        
        -- seperate each config item by newline for better readability
        table.insert(filedata, "\n")
      
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
  
  local _logpath = lfs.writedir() .. "Logs\\" .. logfilename
  
  ConfigChecker.WriteFileArray(_logpath, filedata)
  
  return canrun
end



function ConfigChecker.ValidateModules()
  local requiredModules =
  {
    ["lfs"] = lfs ~= nil,
    ["io"] = io ~= nil,
    ["os"] = os ~= nil,
    ["require"] = require ~= nil,
    ["loadfile"] = loadfile ~= nil,
    ["package.path"] = package.path ~= nil,
    ["package.cpath"] = package.cpath ~= nil,
    ["JSON"] = "Scripts\\JSON.lua",
    ["Socket"] = "socket"
  }
  
  local isValid = true    -- assume everything exists and is in place, then determine if it's false
  local msg = ""
  
  local function errorHandler(err) 
      -- do nothing
  end

  for key, item in pairs(requiredModules) do 
    local callSuccess, callResult
    if key == "JSON" then
      callSuccess, callResult = xpcall(function() return loadfile(item)() ~= nil end, errorHandler)
    elseif key == "Socket" then
      package.path = package.path..";.\\LuaSocket\\?.lua"
      package.cpath = package.cpath..";.\\LuaSocket\\?.dll"
      callSuccess, callResult = xpcall(function() return require(item) ~= nil end, errorHandler)
    else
      callSuccess, callResult = xpcall(function() return item end, errorHandler)
    end

    if not callSuccess or not callResult then
      isValid = false
      msg = msg .. "\t" .. key .. ","
    end
  end
  
  if not isValid then
    env.info("KI - FATAL ERROR STARTING KAUKASUS INSURGENCY - The following modules are missing: " .. msg)
    env.info("KI - Please review MissionScripting.lua as important modules have been sanitized.")
    return false
  else
    env.info("KI - STARTUP VALIDATION COMPLETE")
    return true
  end
  
  return isValid
end