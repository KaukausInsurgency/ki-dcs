-- simple Unit Testing module


UT = {}
UT.Pass = 0
UT.Fail = 0
UT.FileData = {}
UT.FilePath = lfs.writedir() .. "Missions\\Kaukasus Insurgency\\Tests\\UnitTestResults.txt"
UT.TestData = {}
UT.Setup = nil
UT.TearDown = nil
UT.SetupValidationCollection = {}
UT.PreInitValidationCollection = {}
UT.CaughtError = ""

function UT.Log(data)
  table.insert(UT.FileData, data)
  env.info(data)
  --UT.FileData = UT.FileData .. data .. "\n"
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
  UT.Setup = nil
  UT.TearDown = nil
  UT.SetupValidationCollection = {}
end

function UT.AddSetupValidation(fnc)
  table.insert(UT.SetupValidationCollection, fnc)
end

function UT.AddPreInitValidation(fnc)
  table.insert(UT.PreInitValidationCollection, fnc)
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
  
function UT.TestCase(casename, fnc)
  -- setup file path
  UT.FilePath = lfs.writedir() .. "Missions\\Kaukasus Insurgency\\Tests\\" .. casename .. ".txt"
  
  UT.Log("============================================================")
  UT.Log("UT - Starting Test for " .. casename)
  
  
  
  -- If there is any preinit code that must be run - validate it first, then run it
  
  -- if there is any validation, check that the resources are valid before attempting preinit
  if #UT.PreInitValidationCollection > 0 then
    UT.Log("UT - Validating PreInit")
  else
    UT.Log("UT - No PreInit Validation - Ignoring")
  end
  
  for i = 1, #UT.PreInitValidationCollection do
    assert(UT.PreInitValidationCollection[i]() == true, "ASSERT FAILED")
    local _validSuccess, _result = xpcall (UT.PreInitValidationCollection[i], UT.ErrorHandler)
    if (not _validSuccess) or (not _result) then
      UT.Log("UT - PreInit Validation FAILED - ERROR - " .. UT.GetCaughtError() 
             .. " - " .. debug.traceback( "PreInitValidate TraceBack", 1))
      UT.Log("UT - Test Case FAILED - PreInit is not valid!")
      UT.WriteToFile()
      UT.Reset()
      return false
    end
  end
  
  UT.Log("UT - PreInit Validation Complete")
  
  -- check if a setup function exists and run it
  if UT.Setup ~= nil then
    UT.Log("UT - Running Setup for " .. casename)
    local _setupSuccess, _r = xpcall (UT.Setup, UT.ErrorHandler)
    if _setupSuccess then
      UT.Log("UT - Setup Complete")
      -- if there is any validation, check that the resources are valid before attempting setup
      if #UT.SetupValidationCollection > 0 then
        UT.Log("UT - Validating Setup")
      else
        UT.Log("UT - No Setup Validation - Ignoring")
      end
      
      for i = 1, #UT.SetupValidationCollection do
        local _validSuccess, _result = xpcall (UT.SetupValidationCollection[i], UT.ErrorHandler)
        if (not _validSuccess) or (not _result) then
          UT.Log("UT - Setup Validation FAILED - ERROR - " .. UT.GetCaughtError() 
                 .. " - " .. debug.traceback( "ValidateSetup TraceBack", 1))
          UT.Log("UT - Test Case FAILED - Setup is not valid!")
          UT.WriteToFile()
          UT.Reset()
          return false
        end
      end
      UT.Log("UT - Setup Validation Completed")
    else
      UT.Log("UT - Setup FAILED - ERROR - " .. UT.GetCaughtError() .. " - " .. debug.traceback("Setup TraceBack", 1))
      UT.Log("UT - Test Case FAILED - Setup is not valid!")
      UT.WriteToFile()
      UT.Reset()
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
  else
    UT.Log("UT ERROR IN TEST CASE " .. casename .. " - Error - " .. UT.GetCaughtError() .. " - " .. debug.traceback("TestCase TraceBack", 2))
    UT.Log("UT - Test Case FAILED - Error in Test Case!")
  end
  
  -- tear down the test data
  if UT.TearDown ~= nil then
    UT.Log("Tearing Down Test Case Data")
    local _TearDownResult, _result = xpcall(UT.TearDown, UT.ErrorHandler)
    if (not _TearDownResult) then
      UT.Log("Tear Down FAILED - ERROR - " .. UT.GetCaughtError() .. " - " .. debug.traceback("TearDown TraceBack", 2))
    end
  end
  
  -- reset all data
  UT.WriteToFile()
  UT.Reset()
 
end
  
  
  
  