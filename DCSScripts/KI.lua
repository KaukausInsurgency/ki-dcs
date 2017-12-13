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
  KI.Toolbox.MessageRedCoalition("ERROR STARTING KI - REQUIRED MODULES MISSING - SEE LOG")
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
assert(loadfile(path .. "KI_Config.lua"))()

local function StartKI()
  
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


  env.info("KI - Creating External Connections")
  -- Init UDP Sockets
  KI.UDPSendSocket = socket.udp()
  KI.UDPReceiveSocket = socket.udp()
  KI.UDPReceiveSocket:setsockname("*", KI.Config.SERVERMOD_RECEIVE_PORT)
  KI.UDPReceiveSocket:settimeout(.0001) --receive timer
  KI.SocketDelimiter = "\n"
  env.info("KI - External Connections created")
  
  
  env.info("KI - Getting Data From Server...")
  if not KI.Init.GetServerAndSession() then
    KI.Toolbox.MessageRedCoalition("FAILED TO GET ServerID and SessionID from Database! Check Connection!")
    return false
  else
    KI.Toolbox.MessageRedCoalition("RECEIVED DATA FROM DATABASE (ServerID : " .. tostring(KI.Data.ServerID) .. ", SessionID : " .. tostring(KI.Data.SessionID) .. ")")
  end


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
  KI.Loader.LoadData()          -- this can fail, and it's safe to ignore (ie. If starting a brand new game from scratch)
  env.info("KI - Data Loaded")
  
  timer.scheduleFunction(function(args, t)
    local success, result = xpcall(function() return KI.Scheduled.IsPlayerInZone(1, t) end,
                                   function(err) env.info("KI.Scheduled.IsPlayerInZone ERROR : " .. err) end)
                                   
    if not success then
      return t + KI.Config.PlayerInZoneCheckRate
    else
      return result
    end
  end, 1, timer.getTime() + KI.Config.PlayerInZoneCheckRate)
  timer.scheduleFunction(KI.Scheduled.UpdateCPStatus, {}, timer.getTime() + KI.Config.CPUpdateRate)
  timer.scheduleFunction(KI.Scheduled.CheckSideMissions, {}, timer.getTime() + KI.Config.SideMissionUpdateRate)
  timer.scheduleFunction(KI.Scheduled.DataTransmissionPlayers, {}, timer.getTime() + KI.Config.DataTransmissionPlayerUpdateRate)
  timer.scheduleFunction(KI.Scheduled.DataTransmissionGameEvents, {}, timer.getTime() + KI.Config.DataTransmissionGameEventsUpdateRate)
  timer.scheduleFunction(KI.Scheduled.DataTransmissionGeneral, {}, timer.getTime() + KI.Config.DataTransmissionGeneralUpdateRate)
  timer.scheduleFunction(function(args, time) 
      KI.Loader.SaveData() 
      return time + KI.Config.SaveMissionRate
    end, {}, timer.getTime() + KI.Config.SaveMissionRate)
  timer.scheduleFunction(AICOM.DoTurn, {}, timer.getTime() + AICOM.Config.TurnRate)
  env.info("KI - Scheduled functions created")

  world.addEventHandler(KI.Hooks.GameEventHandler)
  env.info("KI - World Event Handlers registered")
end

-- creating instances of this socket as we need to have this ready before the server Mod can send data
KI.UDPReceiveSocketServerSession = socket.udp()
KI.UDPReceiveSocketServerSession:setsockname("*", KI.Config.SERVER_SESSION_RECEIVE_PORT)
KI.UDPReceiveSocketServerSession:settimeout(10) --receive timer

-- GAME IS READY TO RECEIVE DATA FROM SERVERMOD
trigger.action.setUserFlag("9000", 1) -- Notify Server Mod
env.info("KI - Waiting to receive signal from Server Mod")

timer.scheduleFunction(function(args, t)
    env.info("KI - scheduledfunction (wait for Init Flag) called...")    
    
    if trigger.misc.getUserFlag("9000") ~= 1 then
      env.info("KI - Received Signal from SERVER MOD - Initializing KI Mission")
      local _error = ""
      local ki_start_result = xpcall(function() return StartKI() end, function(err) _error = err end)
      if not ki_start_result or _error ~= "" then
        env.info("KI Initialization FATAL ERROR : " .. _error)
      else
        env.info("KI - Initialization Complete")
      end
      return nil
    end
    return t + 1  

end, {}, timer.getTime() + 5)


return true
