-- UNIT TEST SUITE FOR KI
-- LOADS ALL KI MODULES AND TESTS
-- LOGS RESULTS TO BOTH DCS LOG AND FILE

env.info("KI - KAUKASUS INSURGENCY - STARTING UNIT TEST")

local function ValidateKIStart()
  env.info("KI.ValidateKIStart() called")
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
end

if not ValidateKIStart() then
  return false
end


local path = "C:\\Users\\david\\Documents\\GitHub\\KI\\DCSScripts\\"

env.info("KI - Loading Files")
assert(loadfile(path .. "ConfigChecker.lua"))()
assert(loadfile(path .. "Spatial.lua"))()
assert(loadfile(path .. "KI_Toolbox.lua"))()
assert(loadfile(path .. "LOCPOS.lua"))()
assert(loadfile(path .. "GC.lua"))()
assert(loadfile(path .. "UnitTests\\SLC_Config_UT.lua"))()
assert(loadfile(path .. "SLC.lua"))()
assert(loadfile(path .. "UnitTests\\DWM_Config_UT.lua"))()
assert(loadfile(path .. "DWM.lua"))()
assert(loadfile(path .. "DSMT.lua"))()
assert(loadfile(path .. "CP.lua"))()
assert(loadfile(path .. "GameEvent.lua"))()
assert(loadfile(path .. "CustomEvent.lua"))()
assert(loadfile(path .. "UnitTests\\KI_Config_UT.lua"))()
assert(loadfile(path .. "KI_Defines.lua"))()
assert(loadfile(path .. "KI_Data.lua"))()
assert(loadfile(path .. "KI_Socket.lua"))()
assert(loadfile(path .. "KI_Query.lua"))()
assert(loadfile(path .. "KI_Init.lua"))()
assert(loadfile(path .. "KI_Loader.lua"))()
assert(loadfile(path .. "KI_Scheduled.lua"))()
assert(loadfile(path .. "KI_Hooks.lua"))()
assert(loadfile(path .. "UnitTests\\AICOM_Config_UT.lua"))()
assert(loadfile(path .. "AICOM.lua"))()

KI.UTDATA = {}
KI.Null = -9999

env.info("KI - Loading Tests")

assert(loadfile(path .. "UnitTests\\UT.lua"))()

-- IMPLEMENTED UNIT TESTS
assert(loadfile(path .. "UnitTests\\UT_DCS.lua"))()
assert(loadfile(path .. "UnitTests\\UT_ConfigChecker.lua"))()
assert(loadfile(path .. "UnitTests\\UT_Spatial.lua"))()
assert(loadfile(path .. "UnitTests\\UT_LOCPOS.lua"))
assert(loadfile(path .. "UnitTests\\UT_CP.lua"))()
assert(loadfile(path .. "UnitTests\\UT_DSMT.lua"))()
assert(loadfile(path .. "UnitTests\\UT_DWM.lua"))()
assert(loadfile(path .. "UnitTests\\UT_GC.lua"))()
assert(loadfile(path .. "UnitTests\\UT_AICOM.lua"))()
assert(loadfile(path .. "UnitTests\\UT_KI_Query.lua"))()
assert(loadfile(path .. "UnitTests\\UT_KI_Loader.lua"))()
assert(loadfile(path .. "UnitTests\\UT_KI_Toolbox.lua"))()
assert(loadfile(path .. "UnitTests\\UT_SLC.lua"))()
assert(loadfile(path .. "UnitTests\\UT_GameEvent.lua"))()
assert(loadfile(path .. "UnitTests\\UT_CustomEvent.lua"))()
assert(loadfile(path .. "UnitTests\\UT_KI_Hooks_EH.lua"))()
assert(loadfile(path .. "UnitTests\\UT_KI_Scheduled.lua"))()
--assert(loadfile(path .. "UnitTests\\UT_KI_Socket.lua"))()
assert(loadfile(path .. "UnitTests\\UT_KI_Score.lua"))()
assert(loadfile(path .. "UnitTests\\UT_SLC_Callbacks.lua"))()

-- End the test
UT.EndTest()

env.info("KI - Tests Complete")
return true
