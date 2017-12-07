-- simple Unit Testing module


UT = {}
UT.Pass = 0           -- Tracks how many tests passed in this case
UT.Fail = 0           -- Tracks how many tests failed in this case
UT.FileData = {}      -- Stores log data to be written after test case completion
UT.FilePath = ""      -- File path that is dynamically generated based on test case
UT.TestData = {}      -- Stores User Test Data - used in Setup and Teardown functions
UT.AbortTest = false  -- Whether the test must be aborted because of an error during validation
UT.CaughtError = ""   -- Stores an error that was caught in the UT.ErrorHandler when using xpcall
UT.FilePathAllFailures = lfs.writedir() .. "Missions\\Kaukasus Insurgency\\Tests\\UnitTestResults.txt"
UT.FailedTestCases = {} -- stores an array of failed test cases to be written to a special file

function UT.Log(data)
  table.insert(UT.FileData, data)
  env.info(data)
end

function UT.EndTest()
  local msg = ""
  env.info("UT.EndTest() Called (failed Cases: " .. #UT.FailedTestCases .. ")")
  if #UT.FailedTestCases > 0 then
    for i = 1, #UT.FailedTestCases do
      msg = msg .. "TEST CASE " .. UT.FailedTestCases[i] .. " FAILED\n"
    end
  else
    msg = "ALL TEST CASES PASSED"
  end
  local _filehandle, _err = io.open(UT.FilePathAllFailures, "w")
  if _filehandle then
    _filehandle:write(msg, "\n")
    _filehandle:flush()
    _filehandle:close()
    _filehandle = nil
    UT.FailedTestCases  = {}
    return true
  else
    env.info("UT.EndTest ERROR: " .. _err)
    UT.FailedTestCases  = {}
    return false
  end
end

function UT.WriteToFile()
  local _filehandle, _err = io.open(UT.FilePath, "w")
  if _filehandle then
    for i = 1, #UT.FileData do
      _filehandle:write(UT.FileData[i], "\n")
    end
    
    _filehandle:flush()
    _filehandle:close()
    _filehandle = nil
    UT.FileData = {}
    return true
  else
    env.info("UT.WriteToFile ERROR: " .. _err)
    UT.FileData = {}
    return false
  end
end

function UT.ErrorHandler(err)
  UT.CaughtError = err
end

function UT.GetCaughtError()
  if UT.CaughtError == "" then
    return "NO ERROR"
  end
  local _err = UT.CaughtError
  UT.CaughtError = ""
  return _err
end

function UT.Reset()
  UT.Pass = 0
  UT.Fail = 0
  UT.TestData = {}
end

function UT.TestFunction(fnc, ...)
  local args = { ... } 
  local n = select("#", ...) 
  local function _test()
    return fnc( unpack( args, 1, n ) ) 
  end
  
  return xpcall(_test, UT.ErrorHandler)
end

function UT.TestCompare(cmp)
  --local line = ""
  --line = debug.getinfo(1).currentline
  
  local _success, _result = xpcall(cmp, UT.ErrorHandler)
  -- debug.traceback()
  -- debug.getinfo(1, "n").name returns current function name
  -- debug.getinfo(2) returns calling function
  if _success and _result then
    --env.info("UT: PASS - " .. debug.getinfo(2, "n").name .. " - Line: " .. debug.getinfo(2).currentline)
    UT.Pass = UT.Pass + 1
  else
    local m = "UT: FAILURE - ERROR - " .. UT.GetCaughtError() .. " - " .. debug.traceback("TestCompare TraceBack", 2)
    UT.Log(m)
    UT.Fail = UT.Fail + 1
  end
end

function UT.ValidateSetup(cmp)
  local _success, _result = xpcall(cmp, UT.ErrorHandler)
  if not _success or not _result then
    local m = "UT: Setup Validate Failed - ERROR - " .. UT.GetCaughtError() .. " - " .. debug.traceback("TestCompare TraceBack", 2)
    UT.Log(m)
    UT.AbortTest = true
  end
end

function UT.TestCompareOnce(cmp)
  if cmp() then
    --env.info("UT: PASS - " .. debug.getinfo(2, "n").name .. " - Line: " .. debug.getinfo(2).currentline)
    UT.Pass = UT.Pass + 1
  else
    local m = "UT: FAILURE - " .. " - " .. debug.traceback("TestCompareOnce TraceBack", 2)
    UT.Log(m)
    UT.Fail = UT.Fail + 1
  end
end
  
function UT.TestCase(casename, validFnc, setupFnc, fnc, teardownFnc)
  -- setup file path
  UT.FilePath = lfs.writedir() .. "Missions\\Kaukasus Insurgency\\Tests\\" .. casename .. ".txt"
  
  UT.Log("============================================================")
  UT.Log("UT - Starting Test for " .. casename)
  
  UT.AbortTest = false
  -- if there is any validation, check that the resources are valid before attempting test case
  if validFnc ~= nil then
    UT.Log("UT - Validating Test Setup")
    local _success, _r = xpcall (validFnc, UT.ErrorHandler)
    if _success and (not UT.AbortTest) then
      UT.Log("UT - Test Setup Validation Complete")
    else
      UT.Log("UT - Test Setup Validation FAILED - ERROR - " .. UT.GetCaughtError())
      UT.Log("UT - Test Case FAILED - Setup is not valid!")
      table.insert(UT.FailedTestCases, casename)
      UT.WriteToFile()
      UT.Reset()
      return false
    end
  else
    UT.Log("UT - No PreInit Validation - Ignoring")
  end
  
  -- check if a setup function exists and run it
  if setupFnc ~= nil then
    UT.Log("UT - Running Setup for " .. casename)
    local _setupSuccess, _r = xpcall (setupFnc, UT.ErrorHandler)
    if _setupSuccess then
      UT.Log("UT - Setup Complete")
    else
      UT.Log("UT - Setup FAILED - ERROR - " .. UT.GetCaughtError())
      UT.Log("UT - Test Case FAILED - Setup failed to complete!")
      UT.WriteToFile()
      UT.Reset()
      table.insert(UT.FailedTestCases, casename)
      return false
    end
  else
    UT.Log("UT - No Setup Found for " .. casename .. " - Ignoring")
  end
  
  local _caseSuccess, _result  = xpcall (fnc, UT.ErrorHandler)
  
  if _caseSuccess then   
    UT.Log("============================================================")
    UT.Log("UT Results for Test Case " .. casename)
    UT.Log("Total Test Cases: " .. tostring(UT.Pass + UT.Fail))
    UT.Log("Pass: " .. tostring(UT.Pass))
    UT.Log("Fail: " .. tostring(UT.Fail))
    UT.Log("============================================================")
    if UT.Fail > 0 then
      table.insert(UT.FailedTestCases, casename)
    end
  else
    UT.Log("UT ERROR IN TEST CASE " .. casename .. " - Error - " .. UT.GetCaughtError() .. " - TraceBack - " .. debug.traceback())
    UT.Log("UT - Test Case FAILED - Error in Test Case!")
    table.insert(UT.FailedTestCases, casename)
    UT.WriteToFile()
    UT.Reset()
    return false
  end
  
  -- tear down the test data
  if teardownFnc ~= nil then
    UT.Log("Tearing Down Test Case Data")
    local _TearDownResult, _result = xpcall(teardownFnc, UT.ErrorHandler)
    if (not _TearDownResult) then
      UT.Log("Tear Down FAILED - ERROR - " .. UT.GetCaughtError())
      table.insert(UT.FailedTestCases, casename)
    end
  end
  
  -- reset all data
  UT.WriteToFile()
  UT.Reset()
  return true
end
  
  
  
  
