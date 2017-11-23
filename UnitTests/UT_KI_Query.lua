KI.Init.Depots()
KI.Init.CapturePoints()
KI.Init.SideMissions()

UT.TestCase("KI_Query", 
  -- Validate
function()
  UT.ValidateSetup(function() return GROUP:FindByName("TestGroupInsideDepotZone") ~= nil end)
  UT.ValidateSetup(function() return GROUP:FindByName("TestGroupOutsideDepotZone") ~= nil end)
  UT.ValidateSetup(function() return StaticObject.getByName("TestStaticInsideDepotZone") ~= nil end)
  UT.ValidateSetup(function() return StaticObject.getByName("TestStaticOutsideDepotZone") ~= nil end)
  UT.ValidateSetup(function() return StaticObject.getByName("TestQueryCargo") ~= nil end)
  UT.ValidateSetup(function() return Unit.getByName("SLCPilot1") ~= nil end)
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
  
  
  if true then
    UT.TestCompare(function() return KI.Query.FindNearestPlayer_Static(UT.TestData.testStaticInZone) ~= nil end)
    UT.TestCompare(function() return KI.Query.FindNearestPlayer_Static(UT.TestData.testStaticInZone):getPlayerName() == Unit.getByName("SLCPilot1"):getPlayerName() end)
  end
  
end,

-- TearDown
function()
  KI.Data.CapturePoints = {}
  KI.Data.SideMissions = {}
  KI.Data.Depots = {}
  KI.Data.OnlinePlayers = {}
end)