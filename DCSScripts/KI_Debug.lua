if not KI then
  KI = { UTDATA = {} }
end

local function ValidateKIStart()
  local requiredModules =
  {
    ["lfs"] = lfs,
    ["io"] = io,
    ["require"] = require,
    ["loadfile"] = loadfile,
    ["package.path"] = package.path,
    ["package.cpath"] = package.cpath,
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
      callSuccess, callResult = xpcall(function() return item ~= nil end, errorHandler)
    end
    
    if not callSuccess or not callResult then
      isValid = false
      msg = msg .. "\t" .. key
    end
  end
  
  if not isValid then
    env.info("KI - FATAL ERROR STARTING KAUKASUS INSURGENCY - The following modules are missing:\n" .. msg)
    return false
  else
    env.info("KI - STARTUP VALIDATION COMPLETE")
    return true
  end
  
  return isValid
end

if not ValidateKIStart() then
  trigger.action.outText("ERROR STARTING KI - REQUIRED MODULES MISSING - SEE LOG", 30)
  return false
end








local path = "C:\\Users\\david\\Documents\\GitHub\\KI\\DCSScripts\\"
local require = require
local loadfile = loadfile

package.path = package.path..";.\\LuaSocket\\?.lua"
package.cpath = package.cpath..";.\\LuaSocket\\?.dll"

local JSON = loadfile("Scripts\\JSON.lua")()
local socket = require("socket")

--local initconnection = require("debugger")
--initconnection( "127.0.0.1", 10000, "dcsserver", nil, "win", "" )

-- do a partial load of KI because we need access to certain data
assert(loadfile(path .. "Spatial.lua"))()
assert(loadfile(path .. "KI_Toolbox.lua"))()
assert(loadfile(path .. "KI_Config_Debug.lua"))()

env.info("KI - INITIALIZING")
KI.JSON = JSON
-- nil placeholder - we need this because JSON requests require all parameters be passed in (including nils) otherwise the database call will fail
KI.Null = -9999   

env.info("KI - Loading Scripts")

assert(loadfile(path .. "GC.lua"))()
assert(loadfile(path .. "SLC_Config.lua"))()
assert(loadfile(path .. "SLC.lua"))()
assert(loadfile(path .. "LOCPOS.lua"))()
assert(loadfile(path .. "DWM.lua"))()
assert(loadfile(path .. "DSMT.lua"))()
assert(loadfile(path .. "CP.lua"))()
assert(loadfile(path .. "GameEvent.lua"))()
assert(loadfile(path .. "CustomEvent.lua"))()

assert(loadfile(path .. "KI_Data.lua"))()
assert(loadfile(path .. "KI_Defines.lua"))()
assert(loadfile(path .. "KI_Socket.lua"))()
assert(loadfile(path .. "KI_Query.lua"))()
assert(loadfile(path .. "KI_Init.lua"))()
assert(loadfile(path .. "KI_Loader.lua"))()
assert(loadfile(path .. "KI_Scheduled.lua"))()
assert(loadfile(path .. "KI_Hooks.lua"))()
assert(loadfile(path .. "AICOM_Config.lua"))()
assert(loadfile(path .. "AICOM.lua"))()
env.info("KI - Scripts Loaded")


env.info("KI - Initializing Data")
--================= START OF INIT ================
SLC.Config.PreOnRadioAction = KI.Hooks.SLCPreOnRadioAction
SLC.Config.PostOnRadioAction = KI.Hooks.SLCPostOnRadioAction
AICOM.Config.OnSpawnGroup = KI.Hooks.AICOMOnSpawnGroup
--GC.OnLifeExpired = KI.Hooks.GCOnLifeExpired
GC.OnDespawn = KI.Hooks.GCOnDespawn
KI.Init.Depots()
KI.Init.CapturePoints()
KI.Init.SideMissions()
SLC.InitSLCRadioItemsForUnits()
AICOM.Init()
--KI.Loader.LoadData()          -- this can fail, and it's safe to ignore (ie. If starting a brand new game from scratch)
env.info("KI - Data Loaded")


return true
