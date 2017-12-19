UT.TestCase("CustomEvent", 
function()
  UT.ValidateSetup(function() return Unit.getByName("SLCPilot1") ~= nil end)  -- player pilot must exist
  UT.ValidateSetup(function() return KI.Config.CP ~= nil end) -- CP configuration must exist
  UT.ValidateSetup(function() return ZONE:New("Test Depot Zone") ~= nil end)  -- depot zone must exist
end, 
-- SETUP  
function() 
  UT.TestData.PlayerUnit = Unit.getByName("SLCPilot1")
  UT.TestData.SimpleTable = { Name = "SimpleTable" }
  UT.TestData.CP = CP:New(KI.Config.CP[1].name, KI.Config.CP[1].zone, CP.Enum.CAPTUREPOINT, KI.Config.CP[1].spawnzone1)
  UT.TestData.Depot = DWM:New("Test Depot", "Test Depot Zone", 7200, 150, true)
end,
function()
  
  -- test the caster using a simple table with a single property
  if true then
    local spoofObj = CustomEventCaster.CastToAirbase(UT.TestData.SimpleTable, function(o) return o.Name end)
    UT.TestCompare(function() return spoofObj ~= nil end)
    UT.TestCompare(function() return spoofObj.Name ~= nil end)
    UT.TestCompare(function() return spoofObj.getCallsign ~= nil end)
    UT.TestCompare(function() return spoofObj.getName ~= nil end)
    UT.TestCompare(function() return spoofObj:getCallsign() == "SimpleTable" end)
    UT.TestCompare(function() return spoofObj:getName() == "SimpleTable" end)
  end
  
  -- test the caster on an empty table
  if true then
    local spoofObj = CustomEventCaster.CastToAirbase({}, function(o) return "Test" end)
    UT.TestCompare(function() return spoofObj ~= nil end)
    UT.TestCompare(function() return spoofObj.getCallsign ~= nil end)
    UT.TestCompare(function() return spoofObj.getName ~= nil end)
    UT.TestCompare(function() return spoofObj:getCallsign() == "Test" end)
    UT.TestCompare(function() return spoofObj:getName() == "Test" end)
  end
  
  -- test the caster on a CP
  if true then
    local spoofObj = CustomEventCaster.CastToAirbase(UT.TestData.CP, function(o) return o.Name end)
    UT.TestCompare(function() return spoofObj ~= nil end)
    UT.TestCompare(function() return spoofObj.Name ~= nil end)
    UT.TestCompare(function() return spoofObj.getCallsign ~= nil end)
    UT.TestCompare(function() return spoofObj.getName ~= nil end)
    UT.TestCompare(function() return spoofObj:getCallsign() == "TestCPKIQuery" end)
    UT.TestCompare(function() return spoofObj:getName() == "TestCPKIQuery" end)
  end
  
  -- test the caster on a Depot
  if true then
    local spoofObj = CustomEventCaster.CastToAirbase(UT.TestData.Depot, function(o) return o.Name end)
    UT.TestCompare(function() return spoofObj ~= nil end)
    UT.TestCompare(function() return spoofObj.Name ~= nil end)
    UT.TestCompare(function() return spoofObj.getCallsign ~= nil end)
    UT.TestCompare(function() return spoofObj.getName ~= nil end)
    UT.TestCompare(function() return spoofObj:getCallsign() == "Test Depot" end)
    UT.TestCompare(function() return spoofObj:getName() == "Test Depot" end)
  end
  
  -- test creating a simple dismount event using CP location
  if true then
    local spoofObj = CustomEventCaster.CastToAirbase(UT.TestData.CP, function(o) return o.Name end)
    local evt = CustomEvent:New(KI.Defines.Event.KI_EVENT_TRANSPORT_MOUNT, UT.TestData.PlayerUnit, spoofObj)
    UT.TestCompare(function() return evt ~= nil end)
    UT.TestCompare(function() return evt.id == KI.Defines.Event.KI_EVENT_TRANSPORT_MOUNT end)
    UT.TestCompare(function() return KI.Toolbox.TablesEqual(evt.initiator, UT.TestData.PlayerUnit, true) end)
    UT.TestCompare(function() return evt.place == spoofObj end)
    UT.TestCompare(function() return evt.place:getCallsign() == "TestCPKIQuery" end)
    UT.TestCompare(function() return evt.place:getName() == "TestCPKIQuery" end)
    UT.TestCompare(function() return evt.time ~= nil end)
  end
  
  -- test creating a simple dismount event using Depot location
  if true then
    local spoofObj = CustomEventCaster.CastToAirbase(UT.TestData.Depot, function(o) return o.Name end)
    local evt = CustomEvent:New(KI.Defines.Event.KI_EVENT_TRANSPORT_MOUNT, UT.TestData.PlayerUnit, spoofObj)
    UT.TestCompare(function() return evt ~= nil end)
    UT.TestCompare(function() return evt.id == KI.Defines.Event.KI_EVENT_TRANSPORT_MOUNT end)
    UT.TestCompare(function() return KI.Toolbox.TablesEqual(evt.initiator, UT.TestData.PlayerUnit, true) end)
    UT.TestCompare(function() return evt.place == spoofObj end)
    UT.TestCompare(function() return evt.place:getCallsign() == "Test Depot" end)
    UT.TestCompare(function() return evt.place:getName() == "Test Depot" end)
    UT.TestCompare(function() return evt.time ~= nil end)
  end
end,
function()
end)
