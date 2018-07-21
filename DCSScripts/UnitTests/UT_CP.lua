-- Unit Tests for Capture Point Class

UT.TestCase("CP", 
  function()
    UT.ValidateSetup(function() return ZONE:New("TestCPZone") ~= nil end)  -- zone must exist in ME
  end, 
  function()
    UT.TestData.Zone = ZONE:New("TestCPZone")
    UT.TestData.Vec3 = UT.TestData.Zone:GetVec3(0)
  end,
    function()    
      local _lat, _lon = coord.LOtoLL(UT.TestData.Vec3)
      -- testing base contructor
      if true then
        local _cp = CP:New("Test CP", "TestCPZone", CP.Enum.CAPTUREPOINT)
        UT.TestCompare(function() return _cp ~= nil end)
        UT.TestCompare(function() return _cp.Zone ~= nil end)
        UT.TestCompare(function() return _cp.Name == "Test CP" end)
        UT.TestCompare(function() return _cp.Zone.ZoneName == UT.TestData.Zone.ZoneName end)
        UT.TestCompare(function() return _cp.SpawnZone1 == nil end)
        UT.TestCompare(function() return _cp.SpawnZone2 == nil end)
        UT.TestCompare(function() return _cp.Text == nil end)
        UT.TestCompare(function() return _cp.Type == CP.Enum.CAPTUREPOINT end)
        UT.TestCompare(function() return _cp.MaxCapacity == 0 end)
        UT.TestCompare(function() return _cp.Position.Latitude == _lat end)
        UT.TestCompare(function() return _cp.Position.Longitude == _lon end)
      end
      
      -- testing constructor with 1 optional param
      if true then
        local _cp = CP:New("Test CP", "TestCPZone", CP.Enum.CAPTUREPOINT, "TestCPZone")
        UT.TestCompare(function() return _cp ~= nil end)
        UT.TestCompare(function() return _cp.Zone ~= nil end)
        UT.TestCompare(function() return _cp.Name == "Test CP" end)
        UT.TestCompare(function() return _cp.Zone.ZoneName == UT.TestData.Zone.ZoneName end)
        UT.TestCompare(function() return _cp.SpawnZone1.ZoneName == UT.TestData.Zone.ZoneName end)
        UT.TestCompare(function() return _cp.SpawnZone2 == nil end)
        UT.TestCompare(function() return _cp.Text == nil end)
        UT.TestCompare(function() return _cp.Type == CP.Enum.CAPTUREPOINT end)
        UT.TestCompare(function() return _cp.MaxCapacity == 0 end)
        UT.TestCompare(function() return _cp.Position.Latitude == _lat end)
        UT.TestCompare(function() return _cp.Position.Longitude == _lon end)
      end
      
      -- testing constructor with 2 optional param
      if true then
        local _cp = CP:New("Test CP", "TestCPZone", CP.Enum.CAPTUREPOINT, "TestCPZone", "TestCPZone")
        UT.TestCompare(function() return _cp ~= nil end)
        UT.TestCompare(function() return _cp.Zone ~= nil end)
        UT.TestCompare(function() return _cp.Name == "Test CP" end)
        UT.TestCompare(function() return _cp.Zone.ZoneName == UT.TestData.Zone.ZoneName end)
        UT.TestCompare(function() return _cp.SpawnZone1.ZoneName == UT.TestData.Zone.ZoneName end)
        UT.TestCompare(function() return _cp.SpawnZone2.ZoneName == UT.TestData.Zone.ZoneName end)
        UT.TestCompare(function() return _cp.Text == nil end)
        UT.TestCompare(function() return _cp.Type == CP.Enum.CAPTUREPOINT end)
        UT.TestCompare(function() return _cp.MaxCapacity == 0 end)
        UT.TestCompare(function() return _cp.Position.Latitude == _lat end)
        UT.TestCompare(function() return _cp.Position.Longitude == _lon end)
      end
        
      -- testing constructor with 3 optional param
      if true then
        local _cp = CP:New("Test CP", "TestCPZone", CP.Enum.CAPTUREPOINT, "TestCPZone", "TestCPZone", "VHF 130.000 AM MHz")
        UT.TestCompare(function() return _cp ~= nil end)
        UT.TestCompare(function() return _cp.Zone ~= nil end)
        UT.TestCompare(function() return _cp.Name == "Test CP" end)
        UT.TestCompare(function() return _cp.Zone.ZoneName == UT.TestData.Zone.ZoneName end)
        UT.TestCompare(function() return _cp.SpawnZone1.ZoneName == UT.TestData.Zone.ZoneName end)
        UT.TestCompare(function() return _cp.SpawnZone2.ZoneName == UT.TestData.Zone.ZoneName end)
        UT.TestCompare(function() return _cp.Text == "VHF 130.000 AM MHz" end)
        UT.TestCompare(function() return _cp.Type == CP.Enum.CAPTUREPOINT end)
        UT.TestCompare(function() return _cp.MaxCapacity == 0 end)
        UT.TestCompare(function() return _cp.Position.Latitude == _lat end)
        UT.TestCompare(function() return _cp.Position.Longitude == _lon end)
      end
      
      
      
      
      if true then
        local _cp = CP:New("Test CP", "TestCPZone", CP.Enum.CAPTUREPOINT)       
        _cp.MaxCapacity = 0
        UT.TestCompare(function() return _cp:Fortify("TestKey") == false end) -- should be false because cap is 0
        _cp.MaxCapacity = 1
        _cp.RedUnits = 0
        UT.TestCompare(function() return _cp:Fortify("TestKey") == true end)   -- should be true
        _cp.RedUnits = 1
        UT.TestCompare(function() return _cp:Fortify("TestKey") == false end)  -- should be false because cap has been reached
        _cp.MaxCapacity = 10
        _cp.RedUnits = 5
        UT.TestCompare(function() return _cp:Fortify("TestKey", 5) == true end) -- should be 5 + 5 = 10 still in the limit
        
        -- testing ViewResources method
        UT.TestFunction(CP.ViewResources, _cp)
      end
      
      
      if true then
        local _cp = CP:New("Test CP", "TestCPZone", CP.Enum.CAPTUREPOINT)
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
        UT.TestCompare(function() return _cp:GetOwnership() == "Neutral" end)
        UT.TestFunction(CP.SetCoalitionCounts, _cp, 1, 0)
        UT.TestCompare(function() return _cp:GetOwnership() == "Red" end)
        UT.TestFunction(CP.SetCoalitionCounts, _cp, 0, 1)
        UT.TestCompare(function() return _cp:GetOwnership() == "Blue" end)
        UT.TestFunction(CP.SetCoalitionCounts, _cp, 1, 1)
        UT.TestCompare(function() return _cp:GetOwnership() == "Contested" end)
      
      end    
    end)
  
