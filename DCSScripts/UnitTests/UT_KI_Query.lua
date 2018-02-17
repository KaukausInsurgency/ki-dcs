UT.TestCase("KI_Query", 
  -- Validate
function()


  UT.ValidateSetup(function() return GROUP:FindByName("TestGroupInsideDepotZone") ~= nil end)
  UT.ValidateSetup(function() return GROUP:FindByName("TestGroupOutsideDepotZone") ~= nil end)
  UT.ValidateSetup(function() return StaticObject.getByName("TestStaticInsideDepotZone") ~= nil end)
  UT.ValidateSetup(function() return StaticObject.getByName("TestStaticOutsideDepotZone") ~= nil end)
  UT.ValidateSetup(function() return StaticObject.getByName("TestQueryCargo") ~= nil end)
  UT.ValidateSetup(function() return Unit.getByName("SLCPilot1") ~= nil end)
  --[[
  UT.ValidateSetup(function() 
      -- this depot must exist for this test case to run
      for i = 1, #KI.Data.Depots do
        if KI.Data.Depots[i].Name == "TestDepotKIQuery" then
          return true
        end
      end
      return false
    end)
  UT.ValidateSetup(function() 
      -- this capture point must exist for this test case to run
      for i = 1, #KI.Data.CapturePoints do
        if KI.Data.CapturePoints[i].Name == "TestCPKIQuery" then
          return true
        end
      end
      return false
    end)
  ]]
  UT.ValidateSetup(function() return StaticObject.getByName("Supplier 1") ~= nil end)
  UT.ValidateSetup(function() return StaticObject.getByName("Supplier 2") ~= nil end)
  UT.ValidateSetup(function() return StaticObject.getByName("Depot 1") ~= nil end)
  UT.ValidateSetup(function() return StaticObject.getByName("Depot 2") ~= nil end)
  UT.ValidateSetup(function() return ZONE:New("Supplier 1 Zone") ~= nil end)
  UT.ValidateSetup(function() return ZONE:New("Supplier 2 Zone") ~= nil end)
  UT.ValidateSetup(function() return ZONE:New("Depot 1 Zone") ~= nil end)
  UT.ValidateSetup(function() return ZONE:New("Depot 2 Zone") ~= nil end)
end,

-- Setup
function()
  UT.TestData.testGroupInZone = GROUP:FindByName("TestGroupInsideDepotZone")
  UT.TestData.testGroupOutZone = GROUP:FindByName("TestGroupOutsideDepotZone")
  UT.TestData.testStaticInZone = StaticObject.getByName("TestStaticInsideDepotZone")
  UT.TestData.testStaticOutZone = StaticObject.getByName("TestStaticOutsideDepotZone")
  UT.TestData.testCargo = StaticObject.getByName("TestQueryCargo")
  UT.TestData.DepotName = "TestDepotKIQuery"
  UT.TestData.CPName = "TestCPKIQuery"
  KI.Data.OnlinePlayers = 
  {
    ["1"] = { UCID = "AAAA", Name = "DemoPlayer", Role = "A10C", Unit = Unit.getByName("SLCPilot1") }
    
  }
  KI.Init.Depots()
  KI.Init.CapturePoints()
  KI.Init.SideMissions()
end,

-- Test Case
function()
  
  -- KI.Query.FindDepot_Group
  if true then
    local depot = KI.Query.FindDepot_Group(UT.TestData.testGroupInZone)
    
    -- Check that the proper zone is returned
    UT.TestCompare(function() return depot ~= nil end)
    UT.TestCompare(function() return UT.TestData.DepotName end)
    -- Check that this result returns nothing - this unit is not inside any zone
    UT.TestCompare(function() return KI.Query.FindDepot_Group(UT.TestData.testGroupOutZone) == nil end)
  end
  
  -- KI.Query.FindDepot_Static(obj)
  if true then
    local depot = KI.Query.FindDepot_Static(UT.TestData.testStaticInZone)
    
    -- Check that the proper zone is returned
    UT.TestCompare(function() return depot ~= nil end)
    UT.TestCompare(function() return depot.Name == UT.TestData.DepotName end)
    -- Check that this result returns nothing - this unit is not inside any zone
    UT.TestCompare(function() return KI.Query.FindDepot_Static(UT.TestData.testStaticOutZone) == nil end)
  end
  
  -- KI.Query.FindCP_Group(transGroup)
  if true then
    local cpObj = KI.Query.FindCP_Group(UT.TestData.testGroupInZone)
    
    -- Check that the proper CP is returned
    UT.TestCompare(function() return cpObj ~= nil end)
    UT.TestCompare(function() return cpObj.Name == UT.TestData.CPName end)
    -- Check that this result returns nothing - this unit is not inside any CP zone
    UT.TestCompare(function() return KI.Query.FindCP_Group(UT.TestData.testGroupOutZone) == nil end)
  end
  
  -- KI.Query.FindCP_Static(obj)
  if true then
    local cpObj = KI.Query.FindCP_Static(UT.TestData.testStaticInZone)
    
    -- Check that the proper zone is returned
    UT.TestCompare(function() return cpObj ~= nil end)
    UT.TestCompare(function() return cpObj.Name == UT.TestData.CPName end)
    -- Check that this result returns nothing - this unit is not inside any zone
    UT.TestCompare(function() return KI.Query.FindCP_Static(UT.TestData.testStaticOutZone) == nil end)
  end
  
  -- KI.Query.FindUCID_Player(name)
  if true then
    UT.TestCompare(function() return KI.Query.FindUCID_Player("DemoPlayer") == "AAAA" end)
    UT.TestCompare(function() return KI.Query.FindUCID_Player("NOPLAYER") == nil end)
  end
  
  -- testing FindNearestPlayer to Static
  if true then
    local _player, _dist = KI.Query.FindNearestPlayer_Static(UT.TestData.testStaticInZone)
    UT.TestCompare(function() return _player:getPlayerName() == Unit.getByName("SLCPilot1"):getPlayerName() end)
    UT.TestCompare(function() return _dist > 0 end)
  end
  
  -- KI.Query.GetDepots
  if true then
    local function IsEqualArrays(arr1, arr2)
      if #arr1 ~= #arr2 then return false end
      
      for i = 1, #arr1 do
        if arr1[i].Name ~= arr2[i].Name then
          return false
        end
      end
      return true
    end
    
    -- first prepare the KI.Data.Depots array for testing
    KI.Data.Depots = {}
    table.insert(KI.Data.Depots, DWM:New("Supplier 1", "Supplier 1 Zone", 7200, 150, true))
    table.insert(KI.Data.Depots, DWM:New("Supplier 2", "Supplier 2 Zone", 7200, 150, true))
    table.insert(KI.Data.Depots, DWM:New("Depot 1", "Depot 1 Zone", 7200, 150, false))
    
    -- This should return all depots that have IsSupplier == true
    if true then
      local resultset = KI.Query.GetDepots(true)
      UT.TestCompare(function() return #resultset == 2 end)
      UT.TestCompare(function() return resultset[1].Name == "Supplier 1" end)
      UT.TestCompare(function() return resultset[2].Name == "Supplier 2" end)
      
      local resultset2 = KI.Query.GetDepots("string")
      -- these results should be equal, as any arg type should translate to true
      UT.TestCompare(function() return IsEqualArrays(resultset, resultset2) end)
    end
    
    -- This should return all depots that have IsSupplier == false
    if true then
      local resultset = KI.Query.GetDepots(false)
      UT.TestCompare(function() return #resultset == 1 end)
      UT.TestCompare(function() return resultset[1].Name == "Depot 1" end)
      
      local resultset2 = KI.Query.GetDepots()
      
      -- these results should be equal, as no args is equivalent to IsSupplier = false
      UT.TestCompare(function() return IsEqualArrays(resultset, resultset2) end)
    end
  end
  
  
  -- KI.Query.GetDepotsResupplyRequired
  if true then   
    -- first prepare the KI.Data.Depots array for testing
    KI.Data.Depots = {}
    table.insert(KI.Data.Depots, DWM:New("Supplier 1", "Supplier 1 Zone", 7200, 150, true))
    table.insert(KI.Data.Depots, DWM:New("Depot 1", "Depot 1 Zone", 7200, 150, false))
    table.insert(KI.Data.Depots, DWM:New("Depot 2", "Depot 2 Zone", 7200, 150, false))
    KI.Data.Depots[2].CurrentCapacity = 75
    KI.Data.Depots[3].CurrentCapacity = 130
    -- This should return a single result - the depot that has 50% current capacity
    local resultset = KI.Query.GetDepotsResupplyRequired(0.5)
    UT.TestCompare(function() return #resultset == 1 end)
    UT.TestCompare(function() return resultset[1].Name == "Depot 1" end)
    
    local resultset2 = KI.Query.GetDepotsResupplyRequired()
    -- should return empty result set, as no depots have 0% current capacity
    UT.TestCompare(function() return #resultset2 == 0 end)   
  end
  
  -- KI.Query.GetClosestSupplierDepot
  if true then
    local Suppliers = {}
    table.insert(Suppliers, DWM:New("Supplier 1", "Supplier 1 Zone", 7200, 150, true))
    table.insert(Suppliers, DWM:New("Supplier 2", "Supplier 2 Zone", 7200, 150, true))
    local _depotA = DWM:New("Depot 1", "Depot 1 Zone", 7200, 150, false)
    local _depotB = DWM:New("Depot 2", "Depot 2 Zone", 7200, 150, false)
    
    -- Depot 1 should be closest to Supplier 1
    local _closestA = KI.Query.GetClosestSupplierDepot(Suppliers, _depotA)
    UT.TestCompare(function() return _closestA ~= nil end)   
    UT.TestCompare(function() return _closestA.Name == "Supplier 1" end)   
    
    -- Depot 2 should be closest to Supplier 2
    local _closestB = KI.Query.GetClosestSupplierDepot(Suppliers, _depotB)
    UT.TestCompare(function() return _closestB ~= nil end)   
    UT.TestCompare(function() return _closestB.Name == "Supplier 2" end)  
    
    -- should return nil
    UT.TestCompare(function() return KI.Query.GetClosestSupplierDepot(Suppliers, nil) == nil end)   
    UT.TestCompare(function() return KI.Query.GetClosestSupplierDepot(nil, _depotA) == nil end)  
    UT.TestCompare(function() return KI.Query.GetClosestSupplierDepot(nil, nil) == nil end)  
  end
  
  -- KI.Query.FindDepotByName
  if true then   
    -- first prepare the KI.Data.Depots array for testing
    KI.Data.Depots = {}
    table.insert(KI.Data.Depots, DWM:New("Supplier 1", "Supplier 1 Zone", 7200, 150, true))
    table.insert(KI.Data.Depots, DWM:New("Depot 1", "Depot 1 Zone", 7200, 150, false))
    table.insert(KI.Data.Depots, DWM:New("Depot 2", "Depot 2 Zone", 7200, 150, false))
    
    -- should return Depot 1
    local resultset = KI.Query.FindDepotByName("Depot 1")
    UT.TestCompare(function() return resultset.Name == "Depot 1" end)
    
    local resultset2 = KI.Query.FindDepotByName()
    -- should return nil
    UT.TestCompare(function() return resultset2 == nil end)   
  end
  
  if true then
    -- KI.Query.FindFriendlyCPAirport()
    UT.TestCompare(function() return 1 == 2 end, "KI.Query.FindFriendlyCPAirport tests not implemented")
  end
  
end,

-- TearDown
function()
  KI.Data.CapturePoints = {}
  KI.Data.SideMissions = {}
  KI.Data.Depots = {}
  KI.Data.OnlinePlayers = {}
end)
