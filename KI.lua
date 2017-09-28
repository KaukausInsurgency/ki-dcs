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



--================= START OF INIT ================

SLC.Config.PreOnRadioAction = KI.Hooks.SLCPreOnRadioAction
SLC.Config.PostOnRadioAction = KI.Hooks.SLCPostOnRadioAction
--GC.OnLifeExpired = KI.Hooks.GCOnLifeExpired
GC.OnDespawn = KI.Hooks.GCOnDespawn

KI.Init.Depots()
KI.Init.CapturePoints()
KI.Init.SideMissions()
KI.Init.SessionID()
KI.Init.SortieID()
KI.Init.ServerID()
KI.Init.OnlinePlayers()

SLC.InitSLCRadioItemsForUnits()

AICOM.Init()


-- taken from KO - score tracking init
--world.addEventHandler(koScoreBoard.eventHandler)
--timer.scheduleFunction(koScoreBoard.main, {}, timer.getTime() + koScoreBoard.loopFreq)
--for ucid, sortie in pairs(koScoreBoard.activeSorties) do
--	koEngine.debugText("found active Sortie for player "..sortie.playerName..", closing it")
--	koScoreBoard.closeSortie(sortie.playerName, "Mission Restart")
--end


timer.scheduleFunction(KI.Scheduled.UpdateCPStatus, {}, timer.getTime() + 5)
timer.scheduleFunction(KI.Scheduled.CheckSideMissions, {}, timer.getTime() + 5)
timer.scheduleFunction(AICOM.DoTurn, {}, timer.getTime() + 5)
--AICOM.DoTurn({}, 5)
--KI.Loader.SaveData()
KI.Loader.LoadData()


return true