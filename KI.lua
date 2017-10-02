if not KI then
  KI = {}
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
  return false
end

local require = require
local loadfile = loadfile

package.path = package.path..";.\\LuaSocket\\?.lua"
package.cpath = package.cpath..";.\\LuaSocket\\?.dll"

local JSON = loadfile("Scripts\\JSON.lua")()
local socket = require("socket")

KI.JSON = JSON


local path = "C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\"

assert(loadfile(path .. "Spatial.lua"))()
assert(loadfile(path .. "KI_Toolbox.lua"))()
assert(loadfile(path .. "GC.lua"))()
assert(loadfile(path .. "SLC_Config.lua"))()
assert(loadfile(path .. "SLC.lua"))()
assert(loadfile(path .. "DWM.lua"))()
assert(loadfile(path .. "DSMT.lua"))()
assert(loadfile(path .. "CP.lua"))()
assert(loadfile(path .. "GameEvent.lua"))()
assert(loadfile(path .. "KI_Config.lua"))()
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


-- Init UDP Sockets
KI.UDPSendSocket = socket.udp()
KI.UDPReceiveSocket = socket.udp()
KI.UDPReceiveSocket:setsockname("*", KI.Config.SERVERMOD_RECEIVE_PORT)
KI.UDPReceiveSocket:settimeout(.0001) --receive timer
KI.SocketDelimiter = "\n"

--================= START OF INIT ================

SLC.Config.PreOnRadioAction = KI.Hooks.SLCPreOnRadioAction
SLC.Config.PostOnRadioAction = KI.Hooks.SLCPostOnRadioAction
--GC.OnLifeExpired = KI.Hooks.GCOnLifeExpired
GC.OnDespawn = KI.Hooks.GCOnDespawn

--KI.Socket.Connect()

KI.Init.Depots()
KI.Init.CapturePoints()
KI.Init.SideMissions()

SLC.InitSLCRadioItemsForUnits()

AICOM.Init()

timer.scheduleFunction(KI.Scheduled.UpdateCPStatus, {}, timer.getTime() + 5)
timer.scheduleFunction(KI.Scheduled.CheckSideMissions, {}, timer.getTime() + 5)

KI.Loader.LoadData()

KI.Scheduled.DataTransmission({}, 5)
KI.Scheduled.DataTransmission({}, 5)
timer.scheduleFunction(KI.Scheduled.DataTransmission, {}, timer.getTime() + KI.Config.DataTransmissionUpdateRate)
timer.scheduleFunction(function(args, time) 
    KI.Loader.SaveData() 
    return time + KI.Config.SaveMissionRate
  end, {}, timer.getTime() + KI.Config.SaveMissionRate)
timer.scheduleFunction(AICOM.DoTurn, {}, timer.getTime() + AICOM.Config.TurnRate)

--AICOM.DoTurn({}, 5)

world.addEventHandler(KI.Hooks.GameEventHandler)

if not KI.Init.RequestNewSession() then
  return false
end

return true