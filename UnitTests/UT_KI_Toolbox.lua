UT.TestCase("KI.Toolbox", 
  function()
    local _testTable =
    {
      num = 1,
      flag = false,
      innerT = { val = "string", num = 5 },
      str = "stringval",
      list = { 23, 24, 25, 239 }
    }
    
    -- Test Deep Copy
    UT.TestFunction(KI.Toolbox.DeepCopy, _testTable)
    local _copy = KI.Toolbox.DeepCopy(_testTable)
    setmetatable( _copy, _testTable )
    _copy.__index = _copy	
    UT.TestCompare(function() return _copy.num == _testTable.num end)
    UT.TestCompare(function() return _copy.flag == _testTable.flag end)
    UT.TestCompare(function() return _copy.str == _testTable.str end)
    UT.TestCompare(function() return _copy.innerT.val == _testTable.innerT.val end)
    UT.TestCompare(function() return _copy.innerT.num == _testTable.innerT.num end)
    UT.TestCompare(function() return _copy.list[1] == _testTable.list[1] end)
    UT.TestCompare(function() return _copy.list[2] == _testTable.list[2] end)
    UT.TestCompare(function() return _copy.list[3] == _testTable.list[3] end)
    UT.TestCompare(function() return _copy.list[4] == _testTable.list[4] end)
    
    -- Test Dump
    UT.TestFunction(KI.Toolbox.Dump, _copy)
    UT.TestCompareOnce(function() env.info(KI.Toolbox.Dump(_testTable)) return true end)
    
    -- Test Serialize
    UT.TestFunction(KI.Toolbox.SerializeTable, _copy)
    UT.TestCompare(function() env.info(KI.Toolbox.SerializeTable(_testTable)) return true end)
    
    -- Test WriteFile
    UT.TestFunction(KI.Toolbox.WriteFile, KI.Toolbox.SerializeTable(_copy), lfs.writedir() .. "Missions\\Kaukasus Insurgency\\KI_UnitTest.lua")
    UT.TestCompare(function()
        return KI.Toolbox.WriteFile(KI.Toolbox.SerializeTable(_copy), lfs.writedir() .. "Missions\\Kaukasus Insurgency\\KI_UnitTest.lua")
      end)
  
    -- Test Round
    UT.TestCompare(function() return KI.Toolbox.Round(10.3) == 10 end)
    UT.TestCompare(function() return KI.Toolbox.Round(10.5) == 11 end)
    UT.TestCompare(function() return KI.Toolbox.Round(11.32, 1) == 11.3 end)
    UT.TestCompare(function() return KI.Toolbox.Round(15.754, 2) == 15.75 end)
    UT.TestCompare(function() return KI.Toolbox.Round(15.755, 2) == 15.76 end)

    -- HoursToSeconds
    UT.TestCompare(function() return KI.Toolbox.HoursToSeconds(3) == 10800 end)
    UT.TestCompare(function() return KI.Toolbox.HoursToSeconds(1) == 3600 end)
    UT.TestCompare(function() return KI.Toolbox.HoursToSeconds(0.5) == 1800 end)
    
    -- SecondsToHours
    UT.TestCompare(function() return KI.Toolbox.SecondsToHours(10800) == 3 end)
    UT.TestCompare(function() return KI.Toolbox.SecondsToHours(3600) == 1 end)
    UT.TestCompare(function() return KI.Toolbox.SecondsToHours(1800) == 0.5 end)
    
    -- MinutesToSeconds
    UT.TestCompare(function() return KI.Toolbox.MinutesToSeconds(30) == 1800 end)
    UT.TestCompare(function() return KI.Toolbox.MinutesToSeconds(60) == 3600 end)
    UT.TestCompare(function() return KI.Toolbox.MinutesToSeconds(120) == 7200 end)
    
    -- SecondsToMinutes
    UT.TestCompare(function() return KI.Toolbox.SecondsToMinutes(1800) == 30 end)
    UT.TestCompare(function() return KI.Toolbox.SecondsToMinutes(3600) == 60 end)
    UT.TestCompare(function() return KI.Toolbox.SecondsToMinutes(7200) == 120 end)    
    
    -- MessageCoalition
    UT.TestFunction(KI.Toolbox.MessageRedCoalition, "TEST MSG FOR RED COALITION")
    UT.TestFunction(KI.Toolbox.MessageBlueCoalition, "TEST MSG FOR BLUE COALITION")
  end)
  
