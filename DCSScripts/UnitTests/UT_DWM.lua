-- Unit Tests for Depot Warehouse Management class

UT.TestCase("DWM", nil, nil,
    function()
      local function count_hash(hash)
        local _c = 0
        for i, p in pairs(hash) do
          _c = _c + 1
        end
        return _c
      end
      
      -- testing constructor
      UT.TestCompare(function() return DWM:New("Test Depot", "Test Depot Zone") ~= nil end)
      
      local _z = ZONE:New("Test Depot Zone")
      local _zvec3 = _z:GetVec3(0)
      
      local _d = DWM:New("Test Depot", "Test Depot Zone")
      UT.TestCompare(function() return _d.Zone ~= nil end)
      UT.TestCompare(function() return _d.Name == "Test Depot" end)
      UT.TestCompare(function() return _d.Zone.ZoneName == "Test Depot Zone" end)
      UT.TestCompare(function() return _d.Resources ~= nil end)
      UT.TestCompare(function() return count_hash(_d.Resources) == 0 end)
      UT.TestCompare(function() return _d.Capacity == 100 end)
      UT.TestCompare(function() return _d.CurrentCapacity == 0 end)
      UT.TestCompare(function() return _d.IsSupplier == false end)
      UT.TestCompare(function() return _d.SupplyCheckRate == 600 end)
      UT.TestCompare(function() return _d.Position.X == _zvec3.z end)      -- DCS treats the z axis as the 2d x axis from the map point of view
      UT.TestCompare(function() return _d.Position.Y == _zvec3.x end)      -- DCS treats the x axis as the 2d y axis from the map point of view
      
      -- testing SetResource method
      UT.TestFunction(DWM.SetResource, _d, "Infantry", 30, 1)
      UT.TestFunction(DWM.SetResource, _d, "Tanks", 30, 2)
      UT.TestFunction(DWM.SetResource, _d, "Building", 2, 5)
      
      UT.TestCompare(function() return count_hash(_d.Resources) == 3 end)
      UT.TestCompare(function() return _d.Resources["Infantry"] ~= nil end)
      UT.TestCompare(function() return _d.Resources["Infantry"].qty == 30 end)
      UT.TestCompare(function() return _d.Resources["Infantry"].cap == 1 end)
      UT.TestCompare(function() return _d.Resources["Tanks"] ~= nil end)
      UT.TestCompare(function() return _d.Resources["Tanks"].qty == 30 end)
      UT.TestCompare(function() return _d.Resources["Tanks"].cap == 2 end)
      UT.TestCompare(function() return _d.Resources["Building"] ~= nil end)
      UT.TestCompare(function() return _d.Resources["Building"].qty == 2 end)
      UT.TestCompare(function() return _d.Resources["Building"].cap == 5 end) 
      UT.TestCompare(function() return _d.CurrentCapacity == _d.Capacity end) 
      
      -- testing Take method
      UT.TestFunction(DWM.Take, _d, "Infantry", 1)
      UT.TestCompare(function() return _d.Resources["Infantry"].qty == 29 end)
      UT.TestCompare(function() return _d.Resources["Infantry"].cap == 1 end)
      
      UT.TestCompareOnce(function() return _d:Take("Building", 1) == true end)
      UT.TestCompare(function() return _d.Resources["Building"].qty == 1 end)
      UT.TestCompare(function() return _d.Resources["Building"].cap == 5 end)
      
      UT.TestCompareOnce(function() return _d:Take("Tanks", 10) == true end)
      UT.TestCompare(function() return _d.Resources["Tanks"].qty == 20 end)
      UT.TestCompare(function() return _d.Resources["Tanks"].cap == 2 end)
      UT.TestCompare(function() return _d.CurrentCapacity == 74 end)
      
      UT.TestCompareOnce(function() return _d:Take("Tanks", 40) == false end)
      UT.TestCompareOnce(function() return _d:Take("TestKey", 22) == false end)
      
      -- testing ViewResources method
      UT.TestFunction(DWM.ViewResources, _d)
      UT.TestFunction(DWM.GetResourceEncoded, _d)
      
      -- testing Give method
      UT.TestFunction(DWM.Give, _d, "Infantry", 1)
      UT.TestCompare(function() return _d.Resources["Infantry"].qty == 30 end)
      UT.TestCompare(function() return _d.Resources["Infantry"].cap == 1 end)
      
      UT.TestCompareOnce(function() return _d:Give("Building", 1) == true end)
      UT.TestCompare(function() return _d.Resources["Building"].qty == 2 end)
      UT.TestCompare(function() return _d.Resources["Building"].cap == 5 end)
      
      UT.TestCompareOnce(function() return _d:Give("Tanks", 10) == true end)
      UT.TestCompare(function() return _d.Resources["Tanks"].qty == 30 end)
      UT.TestCompare(function() return _d.Resources["Tanks"].cap == 2 end)
      UT.TestCompare(function() return _d.CurrentCapacity == 100 end)
      
      UT.TestCompareOnce(function() return _d:Give("Tanks", 40) == false end)
      UT.TestCompareOnce(function() return _d:Give("TestKey", 22) == false end)
      
      -- Testing a depot constructed with infinite supply option
      if true then
        local _infdepot = DWM:New("Test Depot", "Test Depot Zone", 0, -1, true)
        -- testing SetResource method
        UT.TestFunction(DWM.SetResource, _infdepot, "Infantry", 0, 0)
        UT.TestFunction(DWM.SetResource, _infdepot, "Tanks", 0, 0)
        UT.TestFunction(DWM.SetResource, _infdepot, "Building", 0, 0)
      
        -- number of calls to take should not matter as the depot has an infinite capacity
        for i = 1, 50 do
          UT.TestCompare(function() return _infdepot:Take("Tanks", 1) end)
        end
        
        -- all of these should return true as there is no validation to take place when IsSupplier is set to true
        UT.TestCompare(function() return _infdepot:Take("Infantry", 1000) end)
        UT.TestCompare(function() return _infdepot:Take("Building", -19358) end)
      
      end
    end)
  
