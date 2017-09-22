local GenerateEventMock = function(evt_id, target, t)
  return 
    {
      id = evt_id,
      time = t or 0,
      initiator = target
    }
end

local GameEvent = {}
GameEvent.BIRTH = 15
GameEvent.CRASH = 5
GameEvent.EJECT = 6
GameEvent.DEATH = 8
GameEvent.PILOTDEATH = 9 
GameEvent.ENGINESHUTDOWN = 18 
GameEvent.ENGINESTART = 17 
GameEvent.HUMANFAIL = 16 
GameEvent.BASECAPTURE = 10 
GameEvent.HIT = 10 
GameEvent.SHOT = 1 
GameEvent.TAKEOFF = 3
GameEvent.LAND = 4

UT.TestCase("KI_GameEvent", 
function()
  UT.ValidateSetup(function() return Unit.getByName("SLCPilot1") ~= nil end)
  UT.ValidateSetup(function() return Unit.getByName("TestKIScoreEnemyAir1") ~= nil end)
  UT.ValidateSetup(function() return Unit.getByName("TestKIScoreEnemyAir2") ~= nil end)
  UT.ValidateSetup(function() return Unit.getByName("TestKIScoreEnemyAir1"):getType == "SU27" end)
  UT.ValidateSetup(function() return Unit.getByName("TestKIScoreEnemyAir2"):getType == "A10C" end)
  UT.ValidateSetup(function() return Unit.getByName("TestKIScoreEnemyGround1") ~= nil end)
  UT.ValidateSetup(function() return Unit.getByName("TestKIScoreEnemyGround2") ~= nil end)
  
  UT.ValidateSetup(function() return Airbase.getByName("Batumi") ~= nil end)
end, 
-- SETUP  
function()
  UT.TestData.EvtBirthMock = GenerateEventMock(GameEvent.BIRTH, Unit.getByName("SLCPilot1"))
  UT.TestData.EvtCrashMock = GenerateEventMock(GameEvent.CRASH, Unit.getByName("SLCPilot1"), 1200)
  UT.TestData.EvtEjectMock = GenerateEventMock(GameEvent.EJECT, Unit.getByName("SLCPilot1"), 1200)
  UT.TestData.EvtDeathMock = GenerateEventMock(GameEvent.DEATH, Unit.getByName("SLCPilot1"), 1200)
  UT.TestData.EvtPilotDeadMock = GenerateEventMock(GameEvent.PILOTDEATH, Unit.getByName("SLCPilot1"), 1600)
  UT.TestData.EvtEngineShutdownMock = GenerateEventMock(GameEvent.ENGINESHUTDOWN, Unit.getByName("SLCPilot1"))
  UT.TestData.EvtEngineStartMock = GenerateEventMock(GameEvent.ENGINESTART, Unit.getByName("SLCPilot1"))
  UT.TestData.EvtHumanFailureMock = GenerateEventMock(GameEvent.HUMANFAIL, Unit.getByName("SLCPilot1"))
  
  UT.TestData.EvtBaseCaptureMock =
  {
    id = GameEvent.BASECAPTURE,
    time = 0,
    initiator = Unit.getByName("SLCPilot1"),
    place = Airbase.getByName("Batumi"),
    subPlace = 0
  }
  
  UT.TestData.EvtHitAir1Mock =
  {
    id = GameEvent.HIT,
    time = 945,
    initiator = Unit.getByName("SLCPilot1"),
    weapon = Weapon,
    target = Unit.getByName("TestKIScoreEnemyAir1")
  }
  
  UT.TestData.EvtHitAir2Mock =
  {
    id = GameEvent.HIT,
    time = 1000,
    initiator = Unit.getByName("SLCPilot1"),
    weapon = Weapon,
    target = Unit.getByName("TestKIScoreEnemyAir2")
  }
  
  UT.TestData.EvtHitGround1Mock =
  {
    id = GameEvent.HIT,
    time = 1110,
    initiator = Unit.getByName("SLCPilot1"),
    weapon = Weapon,
    target = Unit.getByName("TestKIScoreEnemyGround1")
  }

  UT.TestData.EvtHitGround2Mock =
  {
    id = GameEvent.HIT,
    time = 1110,
    initiator = Unit.getByName("SLCPilot1"),
    weapon = Weapon,
    target = Unit.getByName("TestKIScoreEnemyGround2")
  }
  
  UT.TestData.EvtShot1Mock =
  {
    id = GameEvent.SHOT,
    time = 900,
    initiator = Unit.getByName("SLCPilot1"),
    weapon = Weapon
  }
  
  UT.TestData.EvtShot2Mock =
  {
    id = GameEvent.SHOT,
    time = 930,
    initiator = Unit.getByName("SLCPilot1"),
    weapon = Weapon
  }
  
  UT.TestData.EvtShot3Mock =
  {
    id = GameEvent.SHOT,
    time = 990,
    initiator = Unit.getByName("SLCPilot1"),
    weapon = Weapon
  }
  
  UT.TestData.EvtShot4Mock =
  {
    id = GameEvent.SHOT,
    time = 1090,
    initiator = Unit.getByName("SLCPilot1"),
    weapon = Weapon
  }
  
  UT.TestData.EvtPlayerTakeoffMock =
  {
    id = GameEvent.TAKEOFF,
    time = 600,
    initiator = Unit.getByName("SLCPilot1"),
    place = Airbase.getByName("Batumi"),
    subPlace = 0
  }
  
  UT.TestData.EvtAITakeoffMock =
  {
    id = GameEvent.TAKEOFF,
    time = 500,
    initiator = Unit.getByName("TestKIScoreEnemyAir1"),
    place = Airbase.getByName("Tbilisi"),
    subPlace = 0
  }
  
  UT.TestData.EvtLandMock =
  {
    id = GameEvent.LAND,
    time = 1200,
    initiator = Unit.getByName("SLCPilot1"),
    place = Airbase.getByName("Batumi"),
    subPlace = 0
  }
  
end,
function()
  UT.TestCompare(function() return 1 == 2 end)
      
end)