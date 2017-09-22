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
  UT.ValidateSetup(function() return Unit.getByName("TestKIScoreEnemyAir1"):getType() == "SU27" end)
  UT.ValidateSetup(function() return Unit.getByName("TestKIScoreEnemyAir2"):getType() == "A10C" end)
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
  
  UT.TestData.EvtHitAirMock =
  {
    id = GameEvent.HIT,
    time = 945,
    initiator = Unit.getByName("SLCPilot1"),
    weapon = Weapon,
    target = Unit.getByName("TestKIScoreEnemyAir1")
  }
  
  UT.TestData.EvtHitGroundMock =
  {
    id = GameEvent.HIT,
    time = 1110,
    initiator = Unit.getByName("SLCPilot1"),
    weapon = Weapon,
    target = Unit.getByName("TestKIScoreEnemyGround1")
  }
  
  UT.TestData.EvtShotMock =
  {
    id = GameEvent.SHOT,
    time = 900,
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
  -- Test Case 1 - Raise Mock Event - GameEventQueue should record this event
	KI.Score.eventHandler:handleEvent(UT.TestData.EvtPlayerTakeoffMock)	
	
	UT.TestCompare(function() return KI.Data.GameEventQueue ~= nil end)
	UT.TestCompare(function() return #KI.Data.GameEventQueue == 1 end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[1]["SessionID"] == 1 end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[1]["ServerID"] == 1 end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[1]["SortieID"] == 1 end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[1]["Event"] == "TAKEOFF" end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[1]["UCID"] == "AAA" end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[1]["PlayerName"] == "DemoPlayer" end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[1]["RealTime"] == 1300 end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[1]["GameTime"] == 1200 end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[1]["Role"] == "KA50" end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[1]["Airfield"] == "Batumi" end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[1]["Weapon"] == nil end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[1]["WeaponCategory"] == nil end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[1]["TargetName"] == nil end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[1]["Target"] == nil end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[1]["TargetType"] == nil end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[1]["TargetCategory"] == nil end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[1]["TargetIsPlayer"] == false end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[1]["TargetPlayerUCID"] == nil end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[1]["TargetPlayerName"] == nil end)
	
	-- Test 2 - Validate Generate Request is correct
	local _SocketRequestMessage = KI.Socket.GenerateGameEventRequest(KI.Data.GameEventQueue)
	
	UT.TestCompare(function() return _SocketRequestMessage.Action == "InsertGameEvent" end)
	UT.TestCompare(function() return _SocketRequestMessage.BulkInsert == false end)
	UT.TestCompare(function() return #_SocketRequestMessage.Data == 1 end)
	UT.TestCompare(function() return 
      KI.Toolbox.AreTablesEqual(_SocketRequestMessage.Data, KI.Score.GameEventQueue[1]) 
  end)

	-- Test 3 - raise 2 more events
	KI.Score.eventHandler:handleEvent(UT.TestData.EvtShotMock)	
	KI.Score.eventHandler:handleEvent(UT.TestData.EvtHitAirMock)
	
	UT.TestCompare(function() return KI.Data.GameEventQueue ~= nil end)
	UT.TestCompare(function() return #KI.Data.GameEventQueue == 3 end)
	
	UT.TestCompare(function() return KI.Data.GameEventQueue[2]["SessionID"] == 1 end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[2]["ServerID"] == 1 end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[2]["SortieID"] == 1 end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[2]["Event"] == "SHOT" end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[2]["UCID"] == "AAA" end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[2]["PlayerName"] == "DemoPlayer" end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[2]["RealTime"] == 930 end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[2]["GameTime"] == 930 end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[2]["Role"] == "KA50" end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[2]["Airfield"] == nil end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[2]["Weapon"] == "VIHKR" end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[2]["WeaponCategory"] == "ATGM" end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[2]["TargetName"] == nil end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[2]["Target"] == nil end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[2]["TargetType"] == nil end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[2]["TargetCategory"] == nil end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[2]["TargetIsPlayer"] == false end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[2]["TargetPlayerUCID"] == nil end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[2]["TargetPlayerName"] == nil end)
	
	UT.TestCompare(function() return KI.Data.GameEventQueue[3]["SessionID"] == 1 end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[3]["ServerID"] == 1 end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[3]["SortieID"] == 1 end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[3]["Event"] == "HIT" end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[3]["UCID"] == "AAA" end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[3]["PlayerName"] == "DemoPlayer" end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[3]["RealTime"] == 930 end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[3]["GameTime"] == 930 end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[3]["Role"] == "KA50" end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[3]["Airfield"] == nil end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[3]["Weapon"] == "VIHKR" end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[3]["WeaponCategory"] == "ATGM" end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetName"] == "SU27 Spawn #001" end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[3]["Target"] == "SU27" end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetType"] == "FIGHTER" end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetCategory"] == "AIR" end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetIsPlayer"] == false end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetPlayerUCID"] == nil end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetPlayerName"] == nil end)
	
	-- Test 3 - Ignores any events that are AI only and not death, crash, eject, pilot death (we want to track whether an AI unit was killed, and use the database to process who got the kill and apply scores)
	KI.Score.eventHandler:handleEvent(UT.TestData.EvtAITakeoffMock)
	UT.TestCompare(function() return #KI.Data.GameEventQueue == 3 end)		-- size should still be 3, ignoring this AI event
  
  -- Test 4 - Bulk Insert socket request message
	local _SocketRequestMessageBulk = KI.Socket.GenerateGameEventRequest(KI.Score.GameEventQueue)
	UT.TestCompare(function() return _SocketRequestMessage.Action == "InsertGameEvent" end)
	UT.TestCompare(function() return _SocketRequestMessage.BulkInsert == true end)
	UT.TestCompare(function() return #_SocketRequestMessage.Data == 3 end)
	UT.TestCompare(function() return KI.Toolbox.AreTablesEqual(_SocketRequestMessage.Data, KI.Score.GameEventQueue) end)
      
end)