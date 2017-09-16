--math.random(5)
--math.randomseed(5)

--assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\luaunit\\luaunit.lua"))()

local _success, _error, _result = xpcall(function() return 25 == 25 end, function(err) env.info("TEST ERROR: " .. err) end)

env.info("TEST: SUCCESS: " .. tostring(_success))
env.info("TEST: ERROR: " .. tostring(_error))
env.info("TEST: RESULT: " .. tostring(_result))

assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\Spatial.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\KI_Toolbox.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\GC.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\SLC_Config.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\SLC.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\DWM.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\DSMT.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\CP.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\KI_Config_UT.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\KI_Socket.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\KI_Query.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\KI_Init.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\KI_Loader.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\KI_Scheduled.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\KI_Hooks.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\AICOM_Config.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\AICOM.lua"))()

assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\UnitTests\\UT.lua"))()

-- IMPLEMENTED UNIT TESTS
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\UnitTests\\UT_CP.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\UnitTests\\UT_DSMT.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\UnitTests\\UT_DWM.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\UnitTests\\UT_GC.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\UnitTests\\UT_AICOM.lua"))()

-- WIP
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\UnitTests\\UT_KI_Query.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\UnitTests\\UT_KI_Loader.lua"))()

-- TO BE IMPLEMENTED
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\UnitTests\\UT_KI_Toolbox.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\UnitTests\\UT_SLC.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\UnitTests\\UT_Spatial.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\UnitTests\\UT_KI_Scheduled.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\UnitTests\\UT_KI_Socket.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\UnitTests\\UT_KI_MP.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\UnitTests\\UT_KI_Score.lua"))()





