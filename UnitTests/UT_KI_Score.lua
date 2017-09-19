local GenerateEventMock = function(evt_id, target)
  return 
    {
      id = evt_id,
      time = 0,
      initiator = target
    }
end

UT.TestCase("KI_Score", 
function()
  UT.ValidateSetup(function() return Unit.getByName("SLCPilot1") ~= nil end)
  UT.ValidateSetup(function() return Airbase.getByName("Batumi") ~= nil end)
end, 
-- SETUP  
function()
  UT.TestData.EvtBirthMock = GenerateEventMock(15, Unit.getByName("SLCPilot1"))
  UT.TestData.EvtCrashMock = GenerateEventMock(5, Unit.getByName("SLCPilot1"))
  UT.TestData.EvtEjectMock = GenerateEventMock(6, Unit.getByName("SLCPilot1"))
  UT.TestData.EvtDeathMock = GenerateEventMock(8, Unit.getByName("SLCPilot1"))
  UT.TestData.EvtEngineShutdownMock = GenerateEventMock(18, Unit.getByName("SLCPilot1"))
  UT.TestData.EvtEngineStartMock = GenerateEventMock(17, Unit.getByName("SLCPilot1"))
  UT.TestData.EvtHumanFailureMock = GenerateEventMock(16, Unit.getByName("SLCPilot1"))
  
  UT.TestData.EvtBaseCaptureMock =
  {
    id = 10,
    time = 0,
    initiator = Unit.getByName("SLCPilot1"),
    place = Airbase.getByName("Batumi"),
    subPlace = 0
  }
  
  UT.TestData.EvtHitMock =
  {
    id = 10,
    time = 0,
    initiator = Unit.getByName("SLCPilot1"),
    weapon = Weapon,
    target = Unit.getByName("SLCPilot1")
  }
  
  UT.TestData.EvtShotMock =
  {
    id = 1,
    time = 0,
    initiator = Unit.getByName("SLCPilot1"),
    weapon = Weapon
  }
  
  UT.TestData.EvtTakeoffMock =
  {
    id = 3,
    time = 0,
    initiator = Unit.getByName("SLCPilot1"),
    place = Airbase.getByName("Batumi"),
    subPlace = 0
  }
  
  UT.TestData.EvtLandMock =
  {
    id = 4,
    time = 900,
    initiator = Unit.getByName("SLCPilot1"),
    place = Airbase.getByName("Batumi"),
    subPlace = 0
  }
  
end,
function()
      
      
end)