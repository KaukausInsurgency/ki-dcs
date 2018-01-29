if not KI then
  KI = { UTDATA = {} }
end

local function ValidateKIStart()
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

if not ValidateKIStart() then
  trigger.action.outTextForCoalition(1, "ERROR STARTING KI - REQUIRED MODULES MISSING - SEE LOG", 300, true)
  trigger.action.outTextForCoalition(2, "ERROR STARTING KI - REQUIRED MODULES MISSING - SEE LOG", 300, true)
  return false
end



local path = ...
local require = require
local loadfile = loadfile

package.path = package.path..";.\\LuaSocket\\?.lua"
package.cpath = package.cpath..";.\\LuaSocket\\?.dll"

local JSON = loadfile("Scripts\\JSON.lua")()
local socket = require("socket")

--local initconnection = require("debugger")
--initconnection( "127.0.0.1", 10000, "dcsserver", nil, "win", "" )

-- load profiler
--assert(loadfile(path .. "Profiler\\PepperfishProfiler.lua"))()

-- do a partial load of KI because we need access to certain modules
assert(loadfile(path .. "Spatial.lua"))()
assert(loadfile(path .. "KI_Toolbox.lua"))()
assert(loadfile(path .. "ConfigChecker.lua"))()

local kiconfigpath = path .. "KI_Config.lua"
--local kiconfigpath = path .. "KI_Config_BrokenTest.lua"
if not ConfigChecker.KIConfig(kiconfigpath) then
  env.info("KI - FAILED TO START BECAUSE OF CONFIGURATION ERRORS - REVIEW LOGS IN - " .. lfs.writedir() .. "Logs")
  return false
end



local function StartKI()
  
  env.info("KI - INITIALIZING")
  KI.JSON = JSON
  -- nil placeholder - we need this because JSON requests require all parameters be passed in (including nils) otherwise the database call will fail
  KI.Null = -9999   
  
  -- function that forces a mission restart
  KI.MissionRestart = function()
    local _e = {}
    _e.id = world.event.S_EVENT_MISSION_END
    KI.Hooks.GameEventHandler:onEvent(_e)
  end

  env.info("KI - Loading Scripts")
  
  
  assert(loadfile(path .. "GC.lua"))()
  assert(loadfile(path .. "SLC_Config.lua"))()
  assert(loadfile(path .. "SLC.lua"))()
  assert(loadfile(path .. "LOCPOS.lua"))()
  assert(loadfile(path .. "DWM_Config.lua"))()
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
  DWM.Config.OnSpawnGroup = KI.Hooks.DWMOnSpawnGroup
  DWM.Config.OnDepotResupplied = KI.Hooks.DWMOnDepotResupplied
  
  --GC.OnLifeExpired = KI.Hooks.GCOnLifeExpired
  GC.OnDespawn = KI.Hooks.GCOnDespawn
  KI.Init.Depots()
  KI.Init.CapturePoints()
  KI.Init.SideMissions()
  SLC.InitSLCRadioItemsForUnits()
  AICOM.Init()
  KI.Loader.LoadData()          -- this can fail, and it's safe to ignore (ie. If starting a brand new game from scratch)
  env.info("KI - Data Loaded")
  
  env.info("KI - Enabling SSB")
  trigger.action.setUserFlag("SSB",100) -- enable SSB Simple Slot Blocking
  env.info("KI - SSB Enabled")
  
  
  env.info("KI - Initializing Scheduled Functions")
  timer.scheduleFunction(function(args, t)
    local success, result = xpcall(function() return KI.Scheduled.IsPlayerInZone(1, t) end,
                                   function(err) env.info("KI.Scheduled.IsPlayerInZone ERROR : " .. err) end)
                                   
    if not success then
      return t + KI.Config.PlayerInZoneCheckRate
    else
      return result
    end
  end, 1, timer.getTime() + KI.Config.PlayerInZoneCheckRate)
  
  
  xpcall(function() return KI.Scheduled.UpdateCPStatus(true,0) end,
         function(err) env.info("KI.Scheduled.UpdateCPStatus (First Run) ERROR : " .. err) end)
         
  -- this will be called instantly
  timer.scheduleFunction(function(args, t)
    local success, result = xpcall(function() return KI.Scheduled.UpdateCPStatus(args,t) end,
                                   function(err) env.info("KI.Scheduled.UpdateCPStatus ERROR : " .. err) end)
    if not success then
      return t + KI.Config.CPUpdateRate
    else
      return result
    end
  end, false, timer.getTime() + KI.Config.CPUpdateRate)
  
  
  timer.scheduleFunction(function(args, t)
    local success, result = xpcall(function() return KI.Scheduled.CheckSideMissions(args,t) end,
                                   function(err) env.info("KI.Scheduled.CheckSideMissions ERROR : " .. err) end)
    if not success then
      return t + KI.Config.SideMissionUpdateRate
    else
      return result
    end
  end, {}, timer.getTime() + KI.Config.SideMissionUpdateRate)
  
  
  timer.scheduleFunction(function(args, t)
    local success, result = xpcall(function() return KI.Scheduled.CheckDepotSupplyLevels(args,t) end,
                                   function(err) env.info("KI.Scheduled.CheckDepotSupplyLevels ERROR : " .. err) end)
    if not success then
      return t + KI.Config.DepotResupplyCheckRate
    else
      return result
    end
  end, {}, timer.getTime() + KI.Config.DepotResupplyCheckRate)
  
  
  timer.scheduleFunction(function(args, t)
    local success, result = xpcall(function() return KI.Scheduled.CheckConvoyCompletedRoute(args,t) end,
                                   function(err) env.info("KI.Scheduled.CheckConvoyCompletedRoute ERROR : " .. err) end)
    if not success then
      return t + KI.Config.ResupplyConvoyCheckRate
    else
      return result
    end
  end, {}, timer.getTime() + KI.Config.ResupplyConvoyCheckRate)
  
  
  timer.scheduleFunction(function(args, t)
    local success, result = xpcall(function() return KI.Scheduled.DataTransmissionPlayers(args,t) end,
                                   function(err) env.info("KI.Scheduled.DataTransmissionPlayers ERROR : " .. err) end)
    if not success then
      return t + KI.Config.DataTransmissionPlayerUpdateRate
    else
      return result
    end
  end, {}, timer.getTime() + KI.Config.DataTransmissionPlayerUpdateRate)


  timer.scheduleFunction(function(args, t)
    local success, result = xpcall(function() return KI.Scheduled.DataTransmissionGameEvents(args,t) end,
                                   function(err) env.info("KI.Scheduled.DataTransmissionGameEvents ERROR : " .. err) end)
    if not success then
      return t + KI.Config.DataTransmissionGameEventsUpdateRate
    else
      return result
    end
  end, {}, timer.getTime() + KI.Config.DataTransmissionGameEventsUpdateRate)
  
  
  timer.scheduleFunction(function(args, t)
    local success, result = xpcall(function() return KI.Scheduled.DataTransmissionGeneral(args,t) end,
                                   function(err) env.info("KI.Scheduled.DataTransmissionGeneral ERROR : " .. err) end)
    if not success then
      return t + KI.Config.DataTransmissionGeneralUpdateRate
    else
      return result
    end
  end, {}, timer.getTime() + KI.Config.DataTransmissionGeneralUpdateRate)
  
  
  timer.scheduleFunction(function(args, time) 
    local success, result = xpcall(function() 
          KI.Loader.SaveData() 
          return time + KI.Config.SaveMissionRate 
      end,
      function(err) env.info("KI.Loader.SaveData ERROR : " .. err) end)
      
    if not success then
      return t + KI.Config.SaveMissionRate
    else
      return result
    end   
  end, {}, timer.getTime() + KI.Config.SaveMissionRate)
    
    
  timer.scheduleFunction(function(args, t)
    local success, result = xpcall(function() return AICOM.DoTurn(args,t) end,
                                   function(err) env.info("AICOM.DoTurn ERROR : " .. err) end)
    if not success then
      return t + AICOM.Config.TurnRate
    else
      return result
    end
  end, {}, timer.getTime() + AICOM.Config.TurnRate)
  
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
    
    if trigger.misc.getUserFlag("9000") == 2 then
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
