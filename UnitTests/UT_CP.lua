-- Unit Tests for Capture Point Class

UT.TestCase("CP", 
    function()
      local function count_hash(hash)
        local _c = 0
        for i, p in pairs(hash) do
          _c = _c + 1
        end
        return _c
      end
      
      -- testing constructor
      UT.TestCompare(function() return CP:New("Test CP", "TestCPZone") ~= nil end)
      local _cp = CP:New("Test CP", "TestCPZone")
      UT.TestCompare(function() return _cp.Zone ~= nil end)
      UT.TestCompare(function() return _cp.Name == "Test CP" end)
      UT.TestCompare(function() return _cp.Zone.ZoneName == "TestCPZone" end)
      UT.TestCompare(function() return _cp.Defenses ~= nil end)
      UT.TestCompare(function() return count_hash(_cp.Defenses) == 0 end)
      
      -- testing SetDefenseUnit method
      UT.TestFunction(CP.SetDefenseUnit, _cp, "TestKey", 5)
      UT.TestCompare(function() return count_hash(_cp.Defenses) == 1 end)
      UT.TestCompare(function() return _cp.Defenses["TestKey"] ~= nil end)
      UT.TestCompare(function() return _cp.Defenses["TestKey"].qty == 0 end)
      UT.TestCompare(function() return _cp.Defenses["TestKey"].cap == 5 end)
      
      -- testing Fortify method
      UT.TestFunction(CP.Fortify, _cp, "TestKey", 1)
      UT.TestCompare(function() return _cp.Defenses["TestKey"].qty == 1 end)
      UT.TestCompareOnce(function() return _cp:Fortify("TestKey", 1) == true end)
      UT.TestCompare(function() return _cp.Defenses["TestKey"].qty == 2 end)
      UT.TestFunction(CP.Fortify, _cp, "TestKey", 22)
      UT.TestCompareOnce(function() return _cp:Fortify("TestKey", 22) == false end)
      
      -- testing ViewResources method
      UT.TestFunction(CP.ViewResources, _cp)
      
      -- testing GetOwnership method
      _cp.BlueUnits = 1
      _cp.RedUnits = 0
      UT.TestCompare(function() return _cp:GetOwnership() == "Blue" end)
      _cp.BlueUnits = 0
      _cp.RedUnits = 0
      UT.TestCompare(function() return _cp:GetOwnership() == "Neutral" end)
      _cp.BlueUnits = 0
      _cp.RedUnits = 1
      UT.TestCompare(function() return _cp:GetOwnership() == "Red" end)
      _cp.BlueUnits = 1
      _cp.RedUnits = 1
      UT.TestCompare(function() return _cp:GetOwnership() == "Contested" end)
      
      -- testing SetCoalitionCounts method
      UT.TestFunction(CP.SetCoalitionCounts, _cp, 0, 0)
      UT.TestFunction(CP.SetCoalitionCounts, _cp, 1, 0)
      UT.TestFunction(CP.SetCoalitionCounts, _cp, 0, 1)
      UT.TestFunction(CP.SetCoalitionCounts, _cp, 1, 1)
    end)
  
