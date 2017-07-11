-- simple Unit Testing module


UT = {}
UT.Pass = 0
UT.Fail = 0

function UT.ErrorHandler(err)
  env.info("UT ERROR: " .. err)
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
    env.info("UT: FAILURE - " .. debug.traceback())
    UT.Fail = UT.Fail + 1
  end
end

function UT.TestCompareOnce(cmp)
  if cmp() then
    --env.info("UT: PASS - " .. debug.getinfo(2, "n").name .. " - Line: " .. debug.getinfo(2).currentline)
    UT.Pass = UT.Pass + 1
  else
    env.info("UT: FAILURE - " .. debug.traceback())
    UT.Fail = UT.Fail + 1
  end
end
  
function UT.TestCase(casename, fnc)
  env.info("============================================================")
  env.info("UT - Starting Test for " .. casename)
  local _caseresult = xpcall (fnc, UT.ErrorHandler)
  
  if _caseresult then
    env.info("============================================================")
    env.info("UT Results for Test Case " .. casename)
    env.info("Total Test Cases: " .. tostring(UT.Pass + UT.Fail))
    env.info("Pass: " .. tostring(UT.Pass))
    env.info("Fail: " .. tostring(UT.Fail))
    env.info("============================================================")
  else
    env.info("UT ERROR IN TEST CASE " .. casename .. " - Trace - " .. debug.traceback())
  end
  UT.Pass = 0
  UT.Fail = 0
end
  
  
  
  