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
  else
    env.info("KI - STARTUP VALIDATION COMPLETE")
  end
end

ValidateKIStart()

if not ValidateKIStart() then
  return false
end


local path = "C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\"

assert(loadfile(path .. "Spatial.lua"))()
assert(loadfile(path .. "KI_Toolbox.lua"))()
assert(loadfile(path .. "GC.lua"))()
assert(loadfile(path .. "UnitTests\\SLC_Config_UT.lua"))()
assert(loadfile(path .. "SLC.lua"))()
assert(loadfile(path .. "DWM.lua"))()
assert(loadfile(path .. "DSMT.lua"))()
assert(loadfile(path .. "CP.lua"))()
assert(loadfile(path .. "UnitTests\\KI_Config_UT.lua"))()
assert(loadfile(path .. "KI_Socket.lua"))()
assert(loadfile(path .. "KI_Query.lua"))()
assert(loadfile(path .. "KI_Init.lua"))()
assert(loadfile(path .. "KI_Loader.lua"))()
assert(loadfile(path .. "KI_Scheduled.lua"))()
assert(loadfile(path .. "KI_Hooks.lua"))()
assert(loadfile(path .. "AICOM_Config.lua"))()
assert(loadfile(path .. "AICOM.lua"))()

assert(loadfile(path .. "UnitTests\\UT.lua"))()

-- IMPLEMENTED UNIT TESTS
assert(loadfile(path .. "UnitTests\\UT_CP.lua"))()
assert(loadfile(path .. "UnitTests\\UT_DSMT.lua"))()
assert(loadfile(path .. "UnitTests\\UT_DWM.lua"))()
assert(loadfile(path .. "UnitTests\\UT_GC.lua"))()
assert(loadfile(path .. "UnitTests\\UT_AICOM.lua"))()
assert(loadfile(path .. "UnitTests\\UT_KI_Query.lua"))()
assert(loadfile(path .. "UnitTests\\UT_KI_Loader.lua"))()
assert(loadfile(path .. "UnitTests\\UT_KI_Toolbox.lua"))()

-- WIP


-- TO BE IMPLEMENTED

assert(loadfile(path .. "UnitTests\\UT_SLC.lua"))()
assert(loadfile(path .. "UnitTests\\UT_Spatial.lua"))()
assert(loadfile(path .. "UnitTests\\UT_KI_Scheduled.lua"))()
assert(loadfile(path .. "UnitTests\\UT_KI_Socket.lua"))()
assert(loadfile(path .. "UnitTests\\UT_KI_MP.lua"))()
assert(loadfile(path .. "UnitTests\\UT_KI_Score.lua"))()


-- End the test
UT.EndTest()




--local staticObj = StaticObject.getByName("TestCargoSLC")
--env.info("TestCargoSLC Alive (Should be true): " .. tostring(staticObj:isExist()))
--env.info("TestCargoSLC GetLife (Should be true): " .. tostring(staticObj:getLife()))
--staticObj:destroy()
--env.info("TestCargoSLC Alive (Should be false): " .. tostring(staticObj:isExist()))
--env.info("TestCargoSLC GetLife (Should be false): " .. tostring(staticObj:getLife()))

return true