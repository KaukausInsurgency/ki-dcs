local GenerateEventMock = function(evt_id, target, t)
  return 
    {
      id = evt_id,
      time = t or 0,
      initiator = target
    }
end


UT.TestCase("KI_GameEvent", 
function()
  UT.ValidateSetup(function() return Unit.getByName("SLCPilot1") ~= nil end)
  UT.ValidateSetup(function() return Unit.getByName("TestKIScoreEnemyAir1") ~= nil end)
  UT.ValidateSetup(function() return Unit.getByName("TestKIScoreEnemyAir2") ~= nil end)
  UT.Log("GAME EVENT LOG: getTypename: " .. Unit.getByName("TestKIScoreEnemyAir1"):getTypeName() )
  UT.ValidateSetup(function() return Unit.getByName("TestKIScoreEnemyAir1"):getTypeName() == "Su-25T" end)
  UT.ValidateSetup(function() return Unit.getByName("TestKIScoreEnemyAir2"):getTypeName() == "A-10C" end)
  UT.ValidateSetup(function() return Unit.getByName("TestKIScoreEnemyGround1") ~= nil end)
  UT.ValidateSetup(function() return Unit.getByName("TestKIScoreEnemyGround2") ~= nil end)
  
  UT.ValidateSetup(function() return Airbase.getByName("Batumi") ~= nil end)
end, 
-- SETUP  
function()
  UT.TestData.EvtBirthMock = GenerateEventMock(world.event.S_EVENT_BIRTH, Unit.getByName("SLCPilot1"))
  UT.TestData.EvtCrashMock = GenerateEventMock(world.event.S_EVENT_CRASH, Unit.getByName("SLCPilot1"), 1200)
  UT.TestData.EvtEjectMock = GenerateEventMock(world.event.S_EVENT_EJECTION, Unit.getByName("SLCPilot1"), 1200)
  UT.TestData.EvtDeathMock = GenerateEventMock(world.event.S_EVENT_DEAD, Unit.getByName("SLCPilot1"), 1200)
  UT.TestData.EvtPilotDeadMock = GenerateEventMock(world.event.S_EVENT_PILOT_DEAD, Unit.getByName("SLCPilot1"), 1600)
  
  UT.TestData.EvtHitAirMock =
  {
    id = world.event.S_EVENT_HIT ,
    time = 945,
    initiator = Unit.getByName("SLCPilot1"),
    weapon = Weapon,
    target = Unit.getByName("TestKIScoreEnemyAir1")
  }
  
  UT.TestData.EvtHitGroundMock =
  {
    id = world.event.S_EVENT_HIT ,
    time = 1110,
    initiator = Unit.getByName("SLCPilot1"),
    weapon = Weapon,
    target = Unit.getByName("TestKIScoreEnemyGround1")
  }
  
  UT.TestData.EvtShotMock =
  {
    id = world.event.S_EVENT_SHOT ,
    time = 900,
    initiator = Unit.getByName("SLCPilot1"),
    weapon = Weapon
  }
  
  UT.TestData.EvtPlayerTakeoffMock =
  {
    id = world.event.S_EVENT_TAKEOFF ,
    time = 600,
    initiator = Unit.getByName("SLCPilot1"),
    place = Airbase.getByName("Batumi"),
    subPlace = 0
  }
  
  UT.TestData.EvtAITakeoffMock =
  {
    id = world.event.S_EVENT_TAKEOFF ,
    time = 500,
    initiator = Unit.getByName("TestKIScoreEnemyAir1"),
    place = Airbase.getByName("Tbilisi"),
    subPlace = 0
  }
  
  UT.TestData.EvtLandMock =
  {
    id = world.event.S_EVENT_LAND ,
    time = 1200,
    initiator = Unit.getByName("SLCPilot1"),
    place = Airbase.getByName("Batumi"),
    subPlace = 0
  }
  
end,
function()
  
  if true then
    local ge = GameEvent.CreateGameEvent(1, 1, 1, "AAA", UT.TestData.EvtPlayerTakeoffMock, 1300)

    UT.TestCompare(function() return ge ~= nil end)
    UT.TestCompare(function() return ge["SessionID"] == 1 end)
    UT.TestCompare(function() return ge["ServerID"] == 1 end)
    UT.TestCompare(function() return ge["SortieID"] == 1 end)
    UT.TestCompare(function() return ge["Event"] == "TAKEOFF" end)
    UT.TestCompare(function() return ge["UCID"] == "AAA" end)
    UT.TestCompare(function() return ge["PlayerName"] == "DemoPlayer" end)
    UT.TestCompare(function() return ge["RealTime"] == 1300 end)
    UT.TestCompare(function() return ge["GameTime"] == 600 end)
    UT.TestCompare(function() return ge["Role"] == "Ka-50" end)
    UT.TestCompare(function() return ge["Airfield"] == "Batumi" end)
    UT.TestCompare(function() return ge["Weapon"] == nil end)
    UT.TestCompare(function() return ge["WeaponCategory"] == nil end)
    UT.TestCompare(function() return ge["TargetName"] == nil end)
    UT.TestCompare(function() return ge["Target"] == nil end)
    UT.TestCompare(function() return ge["TargetType"] == nil end)
    UT.TestCompare(function() return ge["TargetCategory"] == nil end)
    UT.TestCompare(function() return ge["TargetIsPlayer"] == false end)
    UT.TestCompare(function() return ge["TargetPlayerUCID"] == nil end)
    UT.TestCompare(function() return ge["TargetPlayerName"] == nil end)
  end
  
  if true then
    local ge = GameEvent.CreateGameEvent(1, 1, 1, "AAA", UT.TestData.EvtShotMock, 930)
    UT.TestCompare(function() return ge["SessionID"] == 1 end)
    UT.TestCompare(function() return ge["ServerID"] == 1 end)
    UT.TestCompare(function() return ge["SortieID"] == 1 end)
    UT.TestCompare(function() return ge["Event"] == "SHOT" end)
    UT.TestCompare(function() return ge["UCID"] == "AAA" end)
    UT.TestCompare(function() return ge["PlayerName"] == "DemoPlayer" end)
    UT.TestCompare(function() return ge["RealTime"] == 930 end)
    UT.TestCompare(function() return ge["GameTime"] == 930 end)
    UT.TestCompare(function() return ge["Role"] == "KA50" end)
    UT.TestCompare(function() return ge["Airfield"] == nil end)
    UT.TestCompare(function() return ge["Weapon"] == "VIHKR" end)
    UT.TestCompare(function() return ge["WeaponCategory"] == "ATGM" end)
    UT.TestCompare(function() return ge["TargetName"] == nil end)
    UT.TestCompare(function() return ge["Target"] == nil end)
    UT.TestCompare(function() return ge["TargetType"] == nil end)
    UT.TestCompare(function() return ge["TargetCategory"] == nil end)
    UT.TestCompare(function() return ge["TargetIsPlayer"] == false end)
    UT.TestCompare(function() return ge["TargetPlayerUCID"] == nil end)
    UT.TestCompare(function() return ge["TargetPlayerName"] == nil end)
  end
  
  if true then
    local ge = GameEvent.CreateGameEvent(1, 1, 1, "AAA", UT.TestData.EvtHitAirMock, 930)
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
    UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetName"] == "TestKIScoreEnemyAir1" end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[3]["Target"] == "Su-25T" end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetType"] == "STRIKER" end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetCategory"] == "AIR" end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetIsPlayer"] == false end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetPlayerUCID"] == nil end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetPlayerName"] == nil end)
  end









  -- Test Case 1 - Raise Mock Event - GameEventQueue should record this event
	KI.Hooks.GameEventHandler:onEvent(UT.TestData.EvtPlayerTakeoffMock)	
	
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
	KI.Hooks.GameEventHandler:onEvent(UT.TestData.EvtShotMock)	
	KI.Hooks.GameEventHandler:onEvent(UT.TestData.EvtHitAirMock)
	
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
	UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetName"] == "TestKIScoreEnemyAir1" end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[3]["Target"] == "Su-25T" end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetType"] == "STRIKER" end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetCategory"] == "AIR" end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetIsPlayer"] == false end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetPlayerUCID"] == nil end)
	UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetPlayerName"] == nil end)
	
	-- Test 3 - Ignores any events that are AI only and not death, crash, eject, pilot death (we want to track whether an AI unit was killed, and use the database to process who got the kill and apply scores)
	KI.Hooks.GameEventHandler:onEvent(UT.TestData.EvtAITakeoffMock)
	UT.TestCompare(function() return #KI.Data.GameEventQueue == 3 end)		-- size should still be 3, ignoring this AI event
  
  -- Test 4 - Bulk Insert socket request message
	local _SocketRequestMessageBulk = KI.Socket.GenerateGameEventRequest(KI.Score.GameEventQueue)
	UT.TestCompare(function() return _SocketRequestMessage.Action == "InsertGameEvent" end)
	UT.TestCompare(function() return _SocketRequestMessage.BulkInsert == true end)
	UT.TestCompare(function() return #_SocketRequestMessage.Data == 3 end)
	UT.TestCompare(function() return KI.Toolbox.AreTablesEqual(_SocketRequestMessage.Data, KI.Score.GameEventQueue) end)
      
end)