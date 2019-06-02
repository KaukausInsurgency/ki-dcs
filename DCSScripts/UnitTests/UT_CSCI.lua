local _csciZone = "CSCI Zone"
local _csciCP = "CSCI CP"
local _csciGroup = "CSCIGroup"
local _nonCSCIUnit = "NotCSCIUnit"
local _nonExistantUnit = "NonExistantCSCIUnit"
local _csciUnit = "CSCIPilot 1"

UT.TestCase("CSCI", 
function()
  -- Validate
  UT.ValidateSetup(function() return ZONE:New(_csciZone) ~= nil end, "Zone '" .. _csciZone .. "' not found!")
  UT.ValidateSetup(function() return GROUP:FindByName(_csciGroup) ~= nil end, "Group '" .. _csciGroup .. "' not found!")
  UT.ValidateSetup(function() return Unit.getByName(_nonCSCIUnit) ~= nil end, "Unit '" .. _nonCSCIUnit .. "' not found!")
  UT.ValidateSetup(function() return Unit.getByName(_csciUnit) ~= nil end, "Unit '" .. _csciUnit .. "' not found!")
  UT.ValidateSetup(function() return Unit.getByName(_nonExistantUnit) == nil end, "Unit '" .. _nonExistantUnit .. "' should not exist!")
end, function()
  -- setup
  UT.TestData.CSCIGroup = GROUP:FindByName(_csciGroup)
  UT.TestData.CapturePoint = CP:New(_csciCP, _csciZone, CP.Enum.CAPTUREPOINT)
end, function() 
  -- CSCI.CanCall tests
  do  
    local _cp = UT.TestData.CapturePoint
    local _actionData = 
    {
      CooldownCallsRemaining = 3,
      CallsRemaining = 3,
    }
    
    -- should return false if actionData is nil
    UT.TestCompare(function() return not CSCI.CanCall(nil, _cp) end, "Expected CSCI.CanCall to return false when actionData is nil")
    
    -- should return false if CSCICalled is true
    _cp.CSCICalled = true
    UT.TestCompare(function() return not CSCI.CanCall(_actionData, _cp) end, "Expected CSCI.CanCall to return false when CP.CSCICalled is true")
    _cp.CSCICalled = false -- reset state
      
    -- should return true
    UT.TestCompare(function() return CSCI.CanCall(_actionData, _cp) end, "Expected CSCI.CanCall to return true")
    
    -- should return false if the action is on cooldown
    _actionData.CooldownCallsRemaining = 0
    UT.TestCompare(function() return not CSCI.CanCall(_actionData, _cp) end, "Expected CSCI.CanCall to return false when CooldownCallsRemaining is <= 0")
    _actionData.CooldownCallsRemaining = 3 -- reset state
    
    -- should return false if no more actions are available this session
    _actionData.CallsRemaining = 0
    UT.TestCompare(function() return not CSCI.CanCall(_actionData, _cp) end, "Expected CSCI.CanCall to return false when CallsRemaining is <= 0")
    _actionData.CallsRemaining = 3 -- reset state
  end
  
  
  -- CSCI.TryGetActionData tests
  do   
    do
      local _fakeAction = "action"
      CSCI.Data[_fakeAction] = nil
      local _result, _actionData = CSCI.TryGetActionData(_fakeAction)
      UT.TestCompare(function() return not _result end, "CSCI.TryGetActionData expected false")
      UT.TestCompare(function() return _actionData == nil end, "CSCI.TryGetActionData expected nil for actionData")
    end
    
    do
      local _realAction = "action"
      CSCI.Data[_realAction] = {}
      local _result, _actionData = CSCI.TryGetActionData(_realAction)
      UT.TestCompare(function() return _result end, "CSCI.TryGetActionData expected true")
      UT.TestCompare(function() return _actionData ~= nil end, "CSCI.TryGetActionData expected not nil for actionData")
      CSCI.Data[_realAction] = nil
    end
  end
  
  -- CSCI.CheckPreCondition tests
  do
    local _preConditionCalled = false
    local _preConditionResult = true
    local _preConditionFunction = function(actionname, parentmenu, moosegrp, csci_config, capturepoint)
      _preConditionCalled = true
      return _preConditionResult
    end  
    
    -- when no pre condition function defined, return true
    CSCI.Config.PreOnRadioAction = nil
    UT.TestCompare(function() return CSCI.CheckPreCondition(nil, nil, nil, nil, nil) end, "CSCI.CheckPreCondition - expected true")
    
    -- with defined pre condition function that returns true, should return true
    CSCI.Config.PreOnRadioAction = _preConditionFunction
    UT.TestCompare(function() return CSCI.CheckPreCondition(nil, nil, nil, nil, nil) end, "CSCI.CheckPreCondition - expected true")
    UT.TestCompare(function() return _preConditionCalled end, "CSCI.CheckPreCondition - expected pre condition to be called")
    
    -- with defined pre condition function that returns false, should return false
    _preConditionResult = false
    UT.TestCompare(function() return not CSCI.CheckPreCondition(nil, nil, nil, nil, nil) end, "CSCI.CheckPreCondition - expected false")
  end
  
  -- CSCI.IsValidCSCIUnit tests
  do  
    local _configValue = CSCI.Config.RestrictToCSCIPilot
    
    -- test that ensures function returns true for all existing units
    do
      CSCI.Config.RestrictToCSCIPilot = false  
      UT.TestCompare(function() return not CSCI.IsValidCSCIUnit(_nonExistantUnit) end, "CSCI.IsValidCSCIUnit - expected false")
      UT.TestCompare(function() return CSCI.IsValidCSCIUnit(_nonCSCIUnit) end, "CSCI.IsValidCSCIUnit - expected true")
      UT.TestCompare(function() return CSCI.IsValidCSCIUnit(_csciUnit) end, "CSCI.IsValidCSCIUnit - expected true")   
      CSCI.Config.RestrictToCSCIPilot = _configValue
    end
    
    -- test that ensures function only returns true if unit name matches CSCIPilot
    do 
      CSCI.Config.RestrictToCSCIPilot = true     
      UT.TestCompare(function() return not CSCI.IsValidCSCIUnit(_nonExistantUnit) end, "CSCI.IsValidCSCIUnit - expected false")
      UT.TestCompare(function() return not CSCI.IsValidCSCIUnit(_nonCSCIUnit) end, "CSCI.IsValidCSCIUnit - expected false")
      UT.TestCompare(function() return CSCI.IsValidCSCIUnit(_csciUnit) end, "CSCI.IsValidCSCIUnit - expected true")
      CSCI.Config.RestrictToCSCIPilot = _configValue
    end
  end
  
  -- ShowAirdropContents test - ensure no errors when calling
  do
    local _mooseGroup = UT.TestData.CSCIGroup
    UT.TestFunction(CSCI.ShowAirdropContents, _mooseGroup)
  end
  
end, function()
  -- teardown
  CSCI.Data = {}
end)