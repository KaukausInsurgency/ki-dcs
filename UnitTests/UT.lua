-- simple Unit Testing module


UT = {}
UT.Pass = 0
UT.Fail = 0
UT.FileData = {}
UT.FilePath = lfs.writedir() .. "Missions\Kaukasus Insurgency\Tests\UnitTestResults.txt"

function UT.AppendFileData(data)
  table.insert(UT.FileData, data)
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
    return true
  else
    env.info("UT.WriteToFile ERROR: " .. _err)
    return false
  end
end

function UT.ErrorHandler(err)
  local m = "UT ERROR: " .. err
  env.info(m)
  UT.AppendFileData(m)
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

  
  local _result = xpcall(cmp, UT.ErrorHandler)
  -- debug.traceback()
  -- debug.getinfo(1, "n").name returns current function name
  -- debug.getinfo(2) returns calling function
  if _result and cmp() then
    --env.info("UT: PASS - " .. debug.getinfo(2, "n").name .. " - Line: " .. debug.getinfo(2).currentline)
    UT.Pass = UT.Pass + 1
  else
    local m = "UT: FAILURE - " .. debug.traceback()
    env.info(m)
    UT.AppendFileData(m)
    UT.Fail = UT.Fail + 1
  end
end

function UT.TestCompareOnce(cmp)
  if cmp() then
    --env.info("UT: PASS - " .. debug.getinfo(2, "n").name .. " - Line: " .. debug.getinfo(2).currentline)
    UT.Pass = UT.Pass + 1
  else
    local m = "UT: FAILURE - " .. debug.traceback()
    env.info(m)
    UT.AppendFileData(m)
    UT.Fail = UT.Fail + 1
  end
end
  
function UT.TestCase(casename, fnc)
  UT.FilePath = lfs.writedir() .. "Missions\\Kaukasus Insurgency\\Tests\\" .. casename .. ".txt"
  env.info("============================================================")
  UT.AppendFileData("============================================================")
  env.info("UT - Starting Test for " .. casename)
  UT.AppendFileData("UT - Starting Test for " .. casename)
  local _caseresult = xpcall (fnc, UT.ErrorHandler)
  
  if _caseresult then
    env.info("============================================================")
    env.info("UT Results for Test Case " .. casename)
    env.info("Total Test Cases: " .. tostring(UT.Pass + UT.Fail))
    env.info("Pass: " .. tostring(UT.Pass))
    env.info("Fail: " .. tostring(UT.Fail))
    env.info("============================================================")
    
    UT.AppendFileData("============================================================")
    UT.AppendFileData("UT Results for Test Case " .. casename)
    UT.AppendFileData("Total Test Cases: " .. tostring(UT.Pass + UT.Fail))
    UT.AppendFileData("Pass: " .. tostring(UT.Pass))
    UT.AppendFileData("Fail: " .. tostring(UT.Fail))
    UT.AppendFileData("============================================================")
  else
    env.info("UT ERROR IN TEST CASE " .. casename .. " - Trace - " .. debug.traceback())
    UT.AppendFileData("UT ERROR IN TEST CASE " .. casename .. " - Trace - " .. debug.traceback())
  end
  UT.Pass = 0
  UT.Fail = 0
  
  UT.WriteToFile()
end
  
  
  
  