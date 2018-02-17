env.info("Starting LuaLinq")

function Dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k,v in pairs(o) do  
      if k == "__index" then 
        s = s .. '"' .. k .. '" = "table"'
      else
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. Dump(v) .. ','
      end
    end
    return s .. '} '
  elseif type(o) == "string" then
    return '"' .. tostring(o) .. '"'
  else
    return tostring(o)
  end
end

function WriteFile(data, path)
  env.info("KI.Toolbox.SafeWriteFile called for path: " .. path)		
	env.info("KI.Toolbox.SafeWriteFile - Data serialized")
	local _filehandle, _err = io.open(path, "w")
  if _filehandle then
    _filehandle:write(data)
    _filehandle:flush()
    _filehandle:close()
    _filehandle = nil
    return true
  else
    env.info("KI.Toolbox.SafeWriteFile ERROR: " .. _err)
    return false
  end
end

WriteFile(Dump(env.mission), "C:\\Users\\david\\Documents\\GitHub\\env_mission_dump.lua")

env.info("ENV MISSION DUMPED")

package.path = package.path .. ";C:\\Users\\david\\Documents\\GitHub\\lualinq-master\\lualinq-master\\build\\lualinq.lua"
local lualinq = require ("lualinq")

if lualinq == nil then
  env.info("lualinq is nil")
end
if from == nil then
  env.info("from is nil")
end
env.info("Running LuaLinq Query...")
xpcall(function()
  from(env.mission.coalition)
  :select(function(o) 
      env.info("Selecting coalitions")
      return o.value 
  end) -- select coalitions
  :selectMany(function(o) 
      env.info("Selecting Many countries")
      return o.country 
  end)
  :selectManyUnion(function(o) 
      env.info("Selecting plane and helicopter")
      env.info(Dump(o))
      return o.plane 
  end, function(o) return o.helicopter end)
  :selectMany(function(o) 
      env.info("Selecting Many group")
      if o.group ~= nil then
        env.info(Dump(o))
      end
      return o.group 
  end) -- groups
  :selectMany(function(o) return o.units end)
  :where(function(o) return o.skill == "Client" or o.skill == "Player" end)
  :foreach(function(o) env.info(o.name) end)
end, function(err) env.info("LuaLinq ERROR: " .. err) end)