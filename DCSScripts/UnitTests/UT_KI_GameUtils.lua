local _groupName = "GameUtilsGroup"

UT.TestCase("KI_GameUtils", function() 
  UT.ValidateSetup(function() return Group.getByName(_groupName) ~= nil end, "Group '" .. _groupName .. "' not found!")
  UT.ValidateSetup(function() return GROUP:FindByName(_groupName) ~= nil end, "Group '" .. _groupName .. "' not found!")
end, nil, function()
    
  -- MessageCoalition
  UT.TestFunction(KI.GameUtils.MessageCoalition, 1, "TEST MSG FOR RED COALITION")
  UT.TestFunction(KI.GameUtils.MessageCoalition, 2, "TEST MSG FOR BLUE COALITION")
  
  -- KI.GameUtils.TryDisableAIDispersion
  UT.TestFunction(KI.GameUtils.TryDisableAIDispersion, GROUP:FindByName(_groupName))
  UT.TestFunction(KI.GameUtils.TryDisableAIDispersion, Group.getByName(_groupName))
  UT.TestFunction(KI.GameUtils.TryDisableAIDispersion, _groupName)
  
  -- SyncWithMoose tests
  do
    local _groupTable = 
    {
      ["visible"] = false,
      ["taskSelected"] = true,
      ["route"] = {},
      ["tasks"] = {},
      ["hidden"] = false,
      ["units"] = {
        [1] = {
          ["type"] = 'BTR-80',
          ["transportable"] = 
          {
            ["randomTransportable"] = false,
          },
          ["unitId"] = '137',
          ["skill"] = "Average",
          ["y"] = 759919.5625,
          ["x"] = -124175.84375,
          ["name"] = 'UT_KI_GameUtils_Mock_Unit',
          ["playerCanDrive"] = true,
          ["heading"] = 1.8556762826387,
        }
      },
      ["y"] = 759919.5625,
      ["x"] = -124175.84375,
      ["name"] = 'UT_KI_GameUtils_Mock_Group',
      ["start_time"] = 0,
      ["task"] = "Ground Nothing",
    }
    local _countryId = 0 -- Russia
    local _categoryId = 2 -- vehicle
    local _dcsGroup = coalition.addGroup(_countryId, _categoryId, _groupTable)
       
    -- test with dcsGroup as argument
    do
      local _mooseGroup = KI.GameUtils.SyncWithMoose(_dcsGroup)
      UT.TestCompare(function() return _mooseGroup ~= nil end, "SyncWithMoose - expected Moose Group but got nil")
      UT.TestCompare(function() return _mooseGroup.ClassName == "GROUP" end, "SyncWithMoose - expected object to be type 'GROUP'")
    end
    
    -- test with a dcsUnit as argument
    do
      local _dcsUnit = _dcsGroup:getUnit(1)
      local _mooseGroup = KI.GameUtils.SyncWithMoose(_dcsUnit)
      UT.TestCompare(function() return _mooseGroup ~= nil end, "SyncWithMoose - expected Moose Group but got nil")
      UT.TestCompare(function() return _mooseGroup.ClassName == "GROUP" end, "SyncWithMoose - expected object to be type 'GROUP'")
    end
    
    -- test when an invalid type is passed in
    do
      UT.TestCompare(function() return KI.GameUtils.SyncWithMoose({}) == nil end, "SyncWithMoose - expected nil with wrong type argument")
    end
    
    if _dcsGroup ~= nil then
      _dcsGroup:destroy()
    end
  end
end)
  
