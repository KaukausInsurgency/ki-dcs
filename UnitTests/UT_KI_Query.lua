UT.TestCase("KI_Query", 
function()
  
  local testGroupInZone = GROUP:GetByName("TestGroupInsideDepotZone")
  local testGroupOutZone = GROUP:GetByName("TestGroupOutsideDepotZone")
  local testStaticInZone = static.GetByName("TestStaticInsideDepotZone")
  local testStaticOutZone = static.GetByName("TestStaticOutsideDepotZone")
  
  -- KI.Query.FindDepot_Group
  if true then
    local depot = KI.Query.FindDepot_Group(testGroupInZone)
    
    -- Check that the proper zone is returned
    UT.TestCompare(function() return depot ~= nil end)
    UT.TestCompare(function() return depot.Name == "TestZone" end)
    -- Check that this result returns nothing - this unit is not inside any zone
    UT.TestCompare(function() return KI.Query.FindDepot_Group(testGroupOutZone) == nil end)
  end
  
  -- KI.Query.FindDepot_Static(obj)
  if true then
    local depot = KI.Query.FindDepot_Static(testStaticInZone)
    
    -- Check that the proper zone is returned
    UT.TestCompare(function() return depot ~= nil end)
    UT.TestCompare(function() return depot.Name == "TestZone" end)
    -- Check that this result returns nothing - this unit is not inside any zone
    UT.TestCompare(function() return KI.Query.FindDepot_Static(testStaticOutZone) == nil end)
  end
  
  -- KI.Query.FindCP_Group(transGroup)
  if true then
    local cpObj = KI.Query.FindCP_Group(testGroupInZone)
    
    -- Check that the proper CP is returned
    UT.TestCompare(function() return cpObj ~= nil end)
    UT.TestCompare(function() return cpObj.Name == "TestZone" end)
    -- Check that this result returns nothing - this unit is not inside any CP zone
    UT.TestCompare(function() return KI.Query.FindCP_Group(testGroupOutZone) == nil end)
  end
  
  -- KI.Query.FindCP_Static(obj)
  if true then
    local cpObj = KI.Query.FindCP_Static(testStaticInZone)
    
    -- Check that the proper zone is returned
    UT.TestCompare(function() return cpObj ~= nil end)
    UT.TestCompare(function() return cpObj.Name == "TestZone" end)
    -- Check that this result returns nothing - this unit is not inside any zone
    UT.TestCompare(function() return KI.Query.FindCP_Static(testStaticOutZone) == nil end)
  end
  
end)