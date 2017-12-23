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

UT.TestCase("KI_Hooks_onEvent", 
function()
  UT.ValidateSetup(function() return Unit.getByName("SLCPilot1") ~= nil end)
  UT.ValidateSetup(function() return Unit.getByName("TestKIScoreEnemyAir1") ~= nil end)
  UT.ValidateSetup(function() return Unit.getByName("TestKIScoreEnemyAir2") ~= nil end)
  UT.ValidateSetup(function() return Unit.getByName("TestKIScoreEnemyAir1"):getTypeName() == "Su-25T" end)
  UT.ValidateSetup(function() return Unit.getByName("TestKIScoreEnemyAir2"):getTypeName() == "A-10C" end)
  UT.ValidateSetup(function() return Unit.getByName("TestKIScoreEnemyGround1") ~= nil end)
  UT.ValidateSetup(function() return Unit.getByName("TestKIScoreEnemyGround2") ~= nil end)
  UT.ValidateSetup(function() return Airbase.getByName("Batumi") ~= nil end)
end, 
-- SETUP  
function()
  UT.TestData.MockWeapon =
  { 
    ["Desc"] = 
    { 
      ["missileCategory"] = 6,
      ["rangeMaxAltMax"] = 11000,
      ["rangeMin"] = 800,
      ["_origin"] = "",
      ["rangeMaxAltMin"] = 7000,
      ["altMax"] = 5000,
      ["RCS"] = 0.014999999664724,
      ["displayName"] = "Vikhr M",
      ["altMin"] = 5,
      ["life"] = 2,
      ["fuseDist"] = 0,
      ["category"] = 1,
      ["guidance"] = 7,
      ["warhead"] = 
      { 
        ["mass"] = 8,
        ["explosiveMass"] = 4,
        ["shapedExplosiveArmorThickness"] = 0.89999997615814,
        ["shapedExplosiveMass"] = 12,
        ["caliber"] = 0,
        ["type"] = 2,
      },
      ["typeName"] = "weapons.missiles.Vikhr_M",
      ["Nmax"] = 12,
    },
    ["TypeName"] = "weapons.missiles.Vikhr_M",
    ["Name"] = 16820992,
    ["Category"] = Weapon.Category.MISSILE,
  } 
  function UT.TestData.MockWeapon.getTypeName(me)
    return UT.TestData.MockWeapon["TypeName"]
  end
  function UT.TestData.MockWeapon.getDesc(me)
    return UT.TestData.MockWeapon["Desc"]
  end
  function UT.TestData.MockWeapon.getCategory(me)
    UT.Log("UT.TestData.MockWeapon.getCategory() - " .. tostring(UT.TestData.MockWeapon["Category"]))
    return UT.TestData.MockWeapon["Category"]
  end
  
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
  
  UT.TestData.EvtAITakeoffMock =
  {
    id = GameEvent.TAKEOFF,
    time = 500,
    initiator = Unit.getByName("TestKIScoreEnemyAir1"),
    place = Airbase.getByName("Tbilisi"),
    subPlace = 0
  }
  
  UT.TestData.EvtPlayerLandMock =
  {
    id = GameEvent.LAND,
    time = 1200,
    initiator = Unit.getByName("SLCPilot1"),
    place = Airbase.getByName("Batumi"),
    subPlace = 0
  }
  
  UT.TestData.PlayerName = Unit.getByName("SLCPilot1"):getPlayerName()
  
  KI.Data.OnlinePlayers["1"] = 
  {
    Name = UT.TestData.PlayerName,
    SortieID = 0,
    Lives = 5,
    UCID = "AAA"
  }
  
  KI.Data.SortieID = 0
  KI.Data.SessionID = 1
  KI.Data.ServerID = 1
  
end,
function()
    
  
  -- GameEvents should look like the following:
  --{
  --    Name = "BIRTH",
  --    EventID = 15,
  --    RealTime = 1350,
  --    GameTime = 60,
  --    UCID = "AAA",
  --}

  
  -- Test Case 1 - Player Take Off Event
  if true then
    local evt =
    {
      id = world.event.S_EVENT_TAKEOFF,
      time = 600,
      initiator = Unit.getByName("SLCPilot1"),
      place = Airbase.getByName("Batumi"),
      subPlace = 0
    }
    KI.Hooks.GameEventHandler:onEvent(evt) 
    UT.TestCompare(function() return KI.Data.GameEventQueue ~= nil end)
    UT.TestCompare(function() return #KI.Data.GameEventQueue == 1 end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[1]["SessionID"] == 1 end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[1]["ServerID"] == 1 end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[1]["SortieID"] == 1 end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[1]["Event"] == "TAKEOFF" end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[1]["UCID"] == "AAA" end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[1]["PlayerName"] == UT.TestData.PlayerName end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[1]["RealTime"] ~= 0 end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[1]["GameTime"] == 600 end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[1]["Role"] == "Ka-50" end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[1]["Location"] == "Batumi" end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[1]["Weapon"] == KI.Null end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[1]["WeaponCategory"] == KI.Null end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[1]["TargetName"] == KI.Null end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[1]["TargetModel"] == KI.Null end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[1]["TargetType"] == KI.Null end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[1]["TargetCategory"] == KI.Null end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[1]["TargetIsPlayer"] == false end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[1]["TargetPlayerUCID"] == KI.Null end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[1]["TargetPlayerName"] == KI.Null end)
  end
  
  
  -- Test 2 - Player Shot Event
  if true then
    local evt =
    {
      id = world.event.S_EVENT_SHOT,
      time = 900,
      initiator = Unit.getByName("SLCPilot1"),
      weapon = UT.TestData.MockWeapon
    }
    
    KI.Hooks.GameEventHandler:onEvent(evt) 
    UT.TestCompare(function() return #KI.Data.GameEventQueue == 2 end)   
    UT.TestCompare(function() return KI.Data.GameEventQueue[2]["SessionID"] == 1 end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[2]["ServerID"] == 1 end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[2]["SortieID"] == 1 end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[2]["Event"] == "SHOT" end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[2]["UCID"] == "AAA" end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[2]["PlayerName"] == UT.TestData.PlayerName end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[2]["RealTime"] ~= 0 end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[2]["GameTime"] == 900 end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[2]["Role"] == "Ka-50" end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[2]["Location"] == KI.Null end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[2]["Weapon"] == "Vikhr M" end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[2]["WeaponCategory"] == "MISSILE" end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[2]["TargetName"] == KI.Null end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[2]["TargetModel"] == KI.Null end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[2]["TargetType"] == KI.Null end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[2]["TargetCategory"] == KI.Null end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[2]["TargetIsPlayer"] == false end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[2]["TargetPlayerUCID"] == KI.Null end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[2]["TargetPlayerName"] == KI.Null end)
  end
  
  -- test 3 - player hit something mock
  if true then
    local evt = 
    {
      id = world.event.S_EVENT_HIT,
      time = 945,
      initiator = Unit.getByName("SLCPilot1"),
      weapon = UT.TestData.MockWeapon,
      target = Unit.getByName("TestKIScoreEnemyAir1")
    }
    KI.Hooks.GameEventHandler:onEvent(evt)
    UT.TestCompare(function() return #KI.Data.GameEventQueue == 3 end)   
    UT.TestCompare(function() return KI.Data.GameEventQueue[3]["SessionID"] == 1 end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[3]["ServerID"] == 1 end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[3]["SortieID"] == 1 end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[3]["Event"] == "HIT" end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[3]["UCID"] == "AAA" end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[3]["PlayerName"] == UT.TestData.PlayerName end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[3]["RealTime"] ~= 0 end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[3]["GameTime"] == 945 end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[3]["Role"] == "Ka-50" end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[3]["Location"] == KI.Null end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[3]["Weapon"] == "Vikhr M" end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[3]["WeaponCategory"] == "MISSILE" end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetName"] == "TestKIScoreEnemyAir1" end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetModel"] == "Su-25T" end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetType"] == "STRIKER" end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetCategory"] == "AIR" end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetIsPlayer"] == false end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetPlayerUCID"] == KI.Null end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetPlayerName"] == KI.Null end)
  
  end
  
  if true then
    local evt = GenerateEventMock(GameEvent.BIRTH, Unit.getByName("SLCPilot1"))
    UT.TestFunction(KI.Hooks.GameEventHandler.onEvent, KI.Hooks.GameEventHandler, evt)
    UT.TestCompare(function() return #KI.Data.GameEventQueue == 3 end)    -- birth event should not be captured here
  end
  
  if true then
    local evt =
    {
      id = world.event.S_EVENT_TAKEOFF,
      time = 600,
      initiator = Unit.getByName("SLCPilot1"),
      place = Airbase.getByName("Batumi"),
      subPlace = 0
    }
    
    -- test to see if the sortie ID increments when we raise the takeoff event again
    KI.Hooks.GameEventHandler:onEvent(evt) 
    UT.TestCompare(function() return #KI.Data.GameEventQueue == 4 end)
    UT.TestCompare(function() return KI.Data.GameEventQueue[4]["SortieID"] == 2 end)
  end
  
  --[[
  -- Test 3 - Ignores any events that are AI only and not death, crash, eject, pilot death (we want to track whether an AI unit was killed, and use the database to process who got the kill and apply scores)
  KI.Hooks.GameEventHandler:onEvent(UT.TestData.EvtPlayerTakeoffMock)
  UT.TestCompare(function() return #KI.Data.GameEventQueue == 3 end)    -- size should still be 3, ignoring this AI event
  
  
  
  -- test sortie 
  -- Sortie should start when the airframe is taking off
  -- The sortie should end when either the airframe is crashed, pilot killed, ejected, dead, or pilot landed
  KI.Hooks.GameEventHandler:onEvent(UT.TestData.EvtPlayerTakeoffMock)                    -- player has taken off 10 minutes after game time (600 seconds) from Batumi
  KI.Hooks.GameEventHandler:onEvent(UT.TestData.EvtAITakeoffMock)                         -- AI has taken off 500 seconds after game time from Tbilisi
  KI.Hooks.GameEventHandler:onEvent(UT.TestData.EvtShot1Mock)                              -- player fires a shot (aim-120) 5 minutes after (900 seconds)
  KI.Hooks.GameEventHandler:onEvent(UT.TestData.EvtShot2Mock)                             -- player fires a second shot (aim-120) 30 seconds after first (930 seconds)
  KI.Hooks.GameEventHandler:onEvent(UT.TestData.EvtHitAir1Mock)                    -- Enemy Air 1 is hit by player at 945 seconds
  KI.Hooks.GameEventHandler:onEvent(GenerateEventMock(GameEvent.CRASH, Unit.getByName("TestKIScoreEnemyAir1"), 955))    -- Enemy Air Crashes 10 seconds after being hit (955 seconds)
  KI.Hooks.GameEventHandler:onEvent(UT.TestData.EvtShot3Mock)                               -- Player fires a shot AIM-9C (990 seconds)
  KI.Hooks.GameEventHandler:onEvent(UT.TestData.EvtHitAir2Mock)                             -- Enemy Air 2 is hit by player at 1000 seconds
  KI.Hooks.GameEventHandler:onEvent(GenerateEventMock(GameEvent.CRASH, Unit.getByName("TestKIScoreEnemyAir2"), 1015))   -- Enemy Air Crashes 10 seconds after being hit (1015 seconds)
  KI.Hooks.GameEventHandler:onEvent(UT.TestData.EvtShot4Mock)                               -- Player dropped bomb (CBU-82) on 2 ground targets at (1090 seconds)
  KI.Hooks.GameEventHandler:onEvent(UT.TestData.EvtHitGround1Mock)                            -- Tank1 is hit  (1110 seconds)
  KI.Hooks.GameEventHandler:onEvent(UT.TestData.EvtHitGround2Mock)                            -- Tank2 is hit  (1110 seconds)
  KI.Hooks.GameEventHandler:onEvent(GenerateEventMock(GameEvent.DEATH, Unit.getByName("TestKIScoreEnemyGround1"), 1111))  -- Tank1 is destroyed (1111 seconds)
  KI.Hooks.GameEventHandler:onEvent(UT.TestData.EvtLandMock)                                -- Player lands at Batumi (1200 seconds)
  
  
  UT.TestCompare(function() return KI.Score.Sorties ~= nil end)
  UT.TestCompare(function() return #KI.Score.Sorties == 1 end)
  UT.TestCompare(function() return KI.Score.Sorties["AAAA"] ~= nil end)   -- Sorties table should have a key for the player (UCID - AAAA) 
  UT.TestCompare(function() return #KI.Score.Sorties["AAAA"] == 1 end)    -- Sorties table has 1 sortie entry for UCID AAAA
  ]]--
  --[[
  local PlayerSortie = KI.Score.Sorties["AAAA"][1]
  UT.TestCompare(function() return PlayerSortie.SortieTime == 1200 end)   -- Overall Sortie length should be 20 minutes (1200 seconds)
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
  ]]--
end,
function()
  KI.Data.OnlinePlayers["1"] = nil
  KI.Data.SessionID = KI.Null
  KI.Data.ServerID = KI.Null
  KI.Data.SortieID = KI.Null
  KI.Data.GameEventQueue = {}
end)

















