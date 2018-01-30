UT.TestCase("ConfigChecker", 
function()
end, nil,
function()
  if true then
    UT.TestCompare(function() return ConfigChecker.IsNumber(20) end)
    UT.TestCompare(function() return not ConfigChecker.IsNumber(nil) end)
    UT.TestCompare(function() return not ConfigChecker.IsNumber("str") end)
    
    UT.TestCompare(function() return ConfigChecker.IsString("str") end)
    UT.TestCompare(function() return not ConfigChecker.IsString(nil) end)
    UT.TestCompare(function() return not ConfigChecker.IsString(20) end)
    
    UT.TestCompare(function() return ConfigChecker.IsBoolean(false) end)
    UT.TestCompare(function() return not ConfigChecker.IsBoolean(nil) end)
    UT.TestCompare(function() return not ConfigChecker.IsBoolean(20) end)
    
    UT.TestCompare(function() return ConfigChecker.IsTable({}) end)
    UT.TestCompare(function() return not ConfigChecker.IsTable(nil) end)
    UT.TestCompare(function() return not ConfigChecker.IsTable(20) end)
    
    UT.TestCompare(function() return ConfigChecker.IsFunction(function() return false end) end)
    UT.TestCompare(function() return not ConfigChecker.IsFunction(nil) end)
    UT.TestCompare(function() return not ConfigChecker.IsFunction(20) end)
    
    UT.TestCompare(function() return ConfigChecker.IsNumberPositive(20) end)
    UT.TestCompare(function() return not ConfigChecker.IsNumberPositive(-10) end)
    
    UT.TestCompare(function() return ConfigChecker.IsPort(3400) end)
    UT.TestCompare(function() return not ConfigChecker.IsPort(-10) end)
    UT.TestCompare(function() return not ConfigChecker.IsPort(80) end)
    
    UT.TestCompare(function() return ConfigChecker.IsReservedPort(3400) end)
    UT.TestCompare(function() return not ConfigChecker.IsReservedPort(49155) end)
    UT.TestCompare(function() return not ConfigChecker.IsReservedPort(-1) end)
    
    UT.TestCompare(function() return ConfigChecker.ValueInArray({"apples", "bananas", "peach"}, "peach") end)
    UT.TestCompare(function() return not ConfigChecker.ValueInArray({"apples", "bananas", "peach"}, "orange") end)
    
    local path = lfs.writedir() .. "Logs\\dcs.log.old"
    UT.Log("Path: " .. path)
    UT.TestCompare(function() return ConfigChecker.IsFile(path) end)
    UT.TestCompare(function() return not ConfigChecker.IsFile(lfs.writedir() .. "garbageaueuaege\\smk.ernadom") end)
    
    UT.TestCompare(function() return ConfigChecker.IsPath(lfs.writedir() .. "Logs") end)
    UT.TestCompare(function() return not ConfigChecker.IsPath(lfs.writedir() .. "GarbageRandomFOlderNotExist234134513") end)

    T = 
    {
      A = 
      {
        B = 25,
        C = "String",
        D = true,
        E = function() return 6969 end,
        F = {}
      }
    }
    
    UT.TestCompare(function() return ConfigChecker.GetConfigValue("T.A.B") == 25 end)
    UT.TestCompare(function() return ConfigChecker.GetConfigValue("T.A.C") == "String" end)
    UT.TestCompare(function() return ConfigChecker.GetConfigValue("T.A.D") == true end)
    UT.TestCompare(function() return ConfigChecker.GetConfigValue("T.A.E")() == 6969 end)
    UT.TestCompare(function() return type(ConfigChecker.GetConfigValue("T.A.F")) == "table" end)
    UT.TestCompare(function() return type(ConfigChecker.GetConfigValue("T.A")) == "table" end)
    
    UT.TestCompare(function() return ConfigChecker.SetConfigValue("T.A.B", 66) == true end)
    UT.TestCompare(function() return T.A.B == 66 end)
    UT.TestCompare(function() return ConfigChecker.GetConfigValue("T.A.B") == 66 end)
    
    UT.TestCompare(function() return ConfigChecker.SetConfigValue("T.A.C", "Test") == true end)
    UT.TestCompare(function() return T.A.C == "Test" end)
    UT.TestCompare(function() return ConfigChecker.GetConfigValue("T.A.C") == "Test" end)
    
    UT.TestCompare(function() return ConfigChecker.SetConfigValue("T.A.D", false) == true end)
    UT.TestCompare(function() return T.A.D == false end)
    UT.TestCompare(function() return ConfigChecker.GetConfigValue("T.A.D") == false end)
  end
      
end,
function()
  T = nil
end)
