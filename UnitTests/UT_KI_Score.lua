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

UT.TestCase("KI_Score", 
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
    
	
	-- GameEvents should look like the following:
	--{
	--		Name = "BIRTH",
	--		EventID = 15,
	--		RealTime = 1350,
	--		GameTime = 60,
	--		UCID = "AAA",
	--}
	-- it appears there is no way to get the player UCID from the mission script environment - we will need to go to the Server Mod in order to obtain that information
	
	-- Test Case 1 - Raise Mock Event - GameEventQueue should record this event
	KI.Score.eventHandler:handleEvent(UT.TestData.EvtPlayerTakeoffMock)	
	
	UT.TestCompare(function() return KI.Score.GameEventQueue ~= nil end)
	UT.TestCompare(function() return #KI.Score.GameEventQueue == 1 end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[1]["SessionID"] == 1 end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[1]["ServerID"] == 1 end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[1]["SortieID"] == 1 end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[1]["Event"] == "TAKEOFF" end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[1]["UCID"] == "AAA" end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[1]["PlayerName"] == "DemoPlayer" end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[1]["RealTime"] == 1300 end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[1]["GameTime"] == 1200 end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[1]["Role"] == "KA50" end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[1]["Airfield"] == "Batumi" end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[1]["Weapon"] == nil end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[1]["WeaponCategory"] == nil end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[2]["TargetName"] == nil end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[1]["Target"] == nil end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[1]["TargetType"] == nil end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[1]["TargetCategory"] == nil end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[1]["TargetIsPlayer"] == false end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[1]["TargetPlayerUCID"] == nil end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[1]["TargetPlayerName"] == nil end)
	
	-- Test 2 - Validate Generate Request is correct
	local _SocketRequestMessage = KI.Score.GenerateRequest(KI.Score.GameEventQueue)
	
	UT.TestCompare(function() return _SocketRequestMessage.Action == "InsertGameEvent" end)
	UT.TestCompare(function() return _SocketRequestMessage.BulkInsert == false end)
	UT.TestCompare(function() return #_SocketRequestMessage.Data == 1 end)
	UT.TestCompare(function() return KI.Toolbox.AreTablesEqual(_SocketRequestMessage.Data, KI.Score.GameEventQueue[1]) end)

	-- Test 3 - raise 2 more events
	KI.Score.eventHandler:handleEvent(UT.TestData.EvtShot2Mock)	
	KI.Score.eventHandler:handleEvent(UT.TestData.EvtHitAir1Mock)
	
	UT.TestCompare(function() return KI.Score.GameEventQueue ~= nil end)
	UT.TestCompare(function() return #KI.Score.GameEventQueue == 3 end)
	
	UT.TestCompare(function() return KI.Score.GameEventQueue[2]["SessionID"] == 1 end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[2]["ServerID"] == 1 end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[2]["SortieID"] == 1 end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[2]["Event"] == "SHOT" end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[2]["UCID"] == "AAA" end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[2]["PlayerName"] == "DemoPlayer" end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[2]["RealTime"] == 930 end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[2]["GameTime"] == 930 end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[2]["Role"] == "KA50" end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[2]["Airfield"] == nil end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[2]["Weapon"] == "VIHKR" end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[2]["WeaponCategory"] == "ATGM" end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[2]["TargetName"] == nil end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[2]["Target"] == nil end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[2]["TargetType"] == nil end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[2]["TargetCategory"] == nil end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[2]["TargetIsPlayer"] == false end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[2]["TargetPlayerUCID"] == nil end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[2]["TargetPlayerName"] == nil end)
	
	UT.TestCompare(function() return KI.Score.GameEventQueue[3]["SessionID"] == 1 end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[3]["ServerID"] == 1 end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[3]["SortieID"] == 1 end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[3]["Event"] == "HIT" end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[3]["UCID"] == "AAA" end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[3]["PlayerName"] == "DemoPlayer" end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[3]["RealTime"] == 930 end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[3]["GameTime"] == 930 end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[3]["Role"] == "KA50" end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[3]["Airfield"] == nil end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[3]["Weapon"] == "VIHKR" end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[3]["WeaponCategory"] == "ATGM" end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[2]["TargetName"] == "SU27 Spawn #001" end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[3]["Target"] == "SU27" end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[3]["TargetType"] == "FIGHTER" end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[3]["TargetCategory"] == "AIR" end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[3]["TargetIsPlayer"] == false end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[3]["TargetPlayerUCID"] == nil end)
	UT.TestCompare(function() return KI.Score.GameEventQueue[3]["TargetPlayerName"] == nil end)
	
	-- Test 3 - Ignores any events that are AI only and not death, crash, eject, pilot death (we want to track whether an AI unit was killed, and use the database to process who got the kill and apply scores)
	KI.Score.eventHandler:handleEvent(UT.TestData.EvtAITakeoffMock)
	UT.TestCompare(function() return #KI.Score.GameEventQueue == 3 end)		-- size should still be 3, ignoring this AI event
	
	-- Test 4 - Bulk Insert socket request message
	local _SocketRequestMessageBulk = KI.Score.GenerateRequest(KI.Score.GameEventQueue)
	UT.TestCompare(function() return _SocketRequestMessage.Action == "InsertGameEvent" end)
	UT.TestCompare(function() return _SocketRequestMessage.BulkInsert == true end)
	UT.TestCompare(function() return #_SocketRequestMessage.Data == 3 end)
	UT.TestCompare(function() return KI.Toolbox.AreTablesEqual(_SocketRequestMessage.Data, KI.Score.GameEventQueue) end)
	
	
	-- test sortie 
	-- Sortie should start when the airframe is taking off
	-- The sortie should end when either the airframe is crashed, pilot killed, ejected, dead, or pilot landed
    KI.Score.eventHandler:handleEvent(UT.TestData.EvtPlayerTakeoffMock)														-- player has taken off 10 minutes after game time (600 seconds) from Batumi
	KI.Score.eventHandler:handleEvent(UT.TestData.EvtAITakeoffMock)															-- AI has taken off 500 seconds after game time from Tbilisi
	KI.Score.eventHandler:handleEvent(UT.TestData.EvtShot1Mock)																-- player fires a shot (aim-120) 5 minutes after (900 seconds)
	KI.Score.eventHandler:handleEvent(UT.TestData.EvtShot2Mock)																-- player fires a second shot (aim-120) 30 seconds after first (930 seconds)
	KI.Score.eventHandler:handleEvent(UT.TestData.EvtHitAir1Mock)															-- Enemy Air 1 is hit by player at 945 seconds
	KI.Score.eventHandler:handleEvent(GenerateEventMock(GameEvent.CRASH, Unit.getByName("TestKIScoreEnemyAir1"), 955))		-- Enemy Air Crashes 10 seconds after being hit (955 seconds)
	KI.Score.eventHandler:handleEvent(UT.TestData.EvtShot3Mock)																-- Player fires a shot AIM-9C (990 seconds)
	KI.Score.eventHandler:handleEvent(UT.TestData.EvtHitAir2Mock)															-- Enemy Air 2 is hit by player at 1000 seconds
	KI.Score.eventHandler:handleEvent(GenerateEventMock(GameEvent.CRASH, Unit.getByName("TestKIScoreEnemyAir2"), 1015))		-- Enemy Air Crashes 10 seconds after being hit (1015 seconds)
	KI.Score.eventHandler:handleEvent(UT.TestData.EvtShot4Mock)																-- Player dropped bomb (CBU-82) on 2 ground targets at (1090 seconds)
	KI.Score.eventHandler:handleEvent(UT.TestData.EvtHitGround1Mock)														-- Tank1 is hit  (1110 seconds)
	KI.Score.eventHandler:handleEvent(UT.TestData.EvtHitGround2Mock)														-- Tank2 is hit  (1110 seconds)
	KI.Score.eventHandler:handleEvent(GenerateEventMock(GameEvent.DEATH, Unit.getByName("TestKIScoreEnemyGround1"), 1111))	-- Tank1 is destroyed (1111 seconds)
	KI.Score.eventHandler:handleEvent(UT.TestData.EvtLandMock)																-- Player lands at Batumi (1200 seconds)
	
	
	UT.TestCompare(function() return KI.Score.Sorties ~= nil end)
	UT.TestCompare(function() return #KI.Score.Sorties == 1 end)
	UT.TestCompare(function() return KI.Score.Sorties["AAAA"] ~= nil end)		-- Sorties table should have a key for the player (UCID - AAAA)	
	UT.TestCompare(function() return #KI.Score.Sorties["AAAA"] == 1 end)		-- Sorties table has 1 sortie entry for UCID AAAA
	local PlayerSortie = KI.Score.Sorties["AAAA"][1]
	UT.TestCompare(function() return PlayerSortie.SortieTime == 1200 end)		-- Overall Sortie length should be 20 minutes (1200 seconds)
	UT.TestCompare(function() return PlayerSortie.TookOffFrom == "Batumi" end)
	UT.TestCompare(function() return PlayerSortie.LandedAt == "Batumi" end)
	UT.TestCompare(function() return PlayerSortie.Status == "SUCCESS" end)
	UT.TestCompare(function() return #PlayerSortie.AirKills == 2 end)
	UT.TestCompare(function() return PlayerSortie.AirKills[1] == "SU27" end)
	UT.TestCompare(function() return PlayerSortie.AirKills[1] == "A10C" end)
	UT.TestCompare(function() return #PlayerSortie.GroundKills == 1 end)
	UT.TestCompare(function() return PlayerSortie.GroundKills[1] == "T72" end)
	UT.TestCompare(function() return #PlayerSortie.WeaponsFired == 4 end)
	UT.TestCompare(function() return PlayerSortie.WeaponsFired[1].Name == "AIM-120C" end)
	UT.TestCompare(function() return PlayerSortie.WeaponsFired[2].Name == "AIM-120C" end)
	UT.TestCompare(function() return PlayerSortie.WeaponsFired[3].Name == "AIM-9C" end)
	UT.TestCompare(function() return PlayerSortie.WeaponsFired[4].Name == "CBU-82" end)
	UT.TestCompare(function() return PlayerSortie.PilotStatus == "LANDED" end)
end)

















