-- THERE ARE KNOWN FAILURES IN THIS TEST CASE
-- THE Weapon.Category Enums are not correct - Weapon:getCategory for VIHKR-M Returns 1, but Weapon.Category.MISSILE is 2 (instead it thinks it's a ROCKET)
-- The Unit.Category Enums are also not correct - Unit:getCategory for Su-25T returns 1, but Unit.Category.AIRPLANE is 0
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
  --UT.Log("KI.Defines.WeaponCategories : " .. KI.Toolbox.Dump(KI.Defines.WeaponCategories))
  --UT.Log("KI.Defines.UnitCategories : " .. KI.Toolbox.Dump(KI.Defines.UnitCategories))
  --UT.Log("TestKIScoreEnemyGround1 Type: " .. Unit.getByName("TestKIScoreEnemyGround1"):getTypeName())
  --UT.Log("TestKIScoreEnemyGround1 Category: " .. Unit.getByName("TestKIScoreEnemyGround1"):getCategory())
  --UT.Log("TestKIScoreEnemyGround2 Type: " .. Unit.getByName("TestKIScoreEnemyGround2"):getTypeName())
  --UT.Log("TestKIScoreEnemyGround2 Category: " .. Unit.getByName("TestKIScoreEnemyGround2"):getCategory())
  --UT.Log("SLCPilot1 Category: " .. Unit.getByName("SLCPilot1"):getCategory())
  --UT.Log("TestKIScoreEnemyAir1 Category: " .. Unit.getByName("TestKIScoreEnemyAir1"):getCategory())
  UT.ValidateSetup(function() return Unit.getByName("SLCPilot1") ~= nil end)
  UT.ValidateSetup(function() return Unit.getByName("TestKIScoreEnemyAir1") ~= nil end)
  UT.ValidateSetup(function() return Unit.getByName("TestKIScoreEnemyAir2") ~= nil end)
  UT.ValidateSetup(function() return Unit.getByName("TestKIScoreEnemyAir1"):getTypeName() == "Su-25T" end)
  UT.ValidateSetup(function() return Unit.getByName("TestKIScoreEnemyAir2"):getTypeName() == "A-10C" end)
  UT.ValidateSetup(function() return Unit.getByName("TestKIScoreEnemyGround1") ~= nil end)
  UT.ValidateSetup(function() return Unit.getByName("TestKIScoreEnemyGround2") ~= nil end)
  UT.ValidateSetup(function() return StaticObject.getByName("TestKIStaticObject") ~= nil end)
  UT.ValidateSetup(function() return Airbase.getByName("Batumi") ~= nil end)
  UT.ValidateSetup(function() return KI.Null == -9999 end)
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
    return UT.TestData.MockWeapon["Category"]
  end

  UT.TestData.EvtBirthMock = GenerateEventMock(world.event.S_EVENT_BIRTH, Unit.getByName("SLCPilot1"))
  UT.TestData.EvtCrashMock = GenerateEventMock(world.event.S_EVENT_CRASH, Unit.getByName("SLCPilot1"), 1200)
  UT.TestData.EvtEjectMock = GenerateEventMock(world.event.S_EVENT_EJECTION, Unit.getByName("SLCPilot1"), 1200)
  UT.TestData.EvtDeathMock = GenerateEventMock(world.event.S_EVENT_DEAD, Unit.getByName("SLCPilot1"), 1200)
  UT.TestData.EvtCargoDeathMock = GenerateEventMock(world.event.S_EVENT_CRASH, StaticObject.getByName("TestKIStaticObject"), 1200)
  UT.TestData.EvtPilotDeadMock = GenerateEventMock(world.event.S_EVENT_PILOT_DEAD, Unit.getByName("SLCPilot1"), 1600)
  
  UT.TestData.EvtHitAirMock =
  {
    id = world.event.S_EVENT_HIT ,
    time = 945,
    initiator = Unit.getByName("SLCPilot1"),
    weapon = UT.TestData.MockWeapon,
    target = Unit.getByName("TestKIScoreEnemyAir1")
  }
  
  UT.TestData.EvtHitGroundMock =
  {
    id = world.event.S_EVENT_HIT ,
    time = 1110,
    initiator = Unit.getByName("SLCPilot1"),
    weapon = UT.TestData.MockWeapon,
    target = Unit.getByName("TestKIScoreEnemyGround1")
  }
  
  UT.TestData.EvtShotMock =
  {
    id = world.event.S_EVENT_SHOT ,
    time = 900,
    initiator = Unit.getByName("SLCPilot1"),
    weapon = UT.TestData.MockWeapon
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
  
  UT.TestData.EvtDeathSceneryMock = GenerateEventMock(world.event.S_EVENT_DEAD,
  {
    isExist = function() return true end,
    destroy = function() return nil end,
    getCategory = function() return "Building" end,
    getName = function() return "Scenery 11AA3" end,
    getTypeName = function() return "SCENERY" end
  }, 1200)
  
  KI.Data.OnlinePlayers = 
  { 
    { Name = "New callsign", UCID = "AAA", Role = "Ka-50", Lives = 5, Banned = false, SortieID = 1 }
  }
end,
function()
  
  if true then
    local ge = GameEvent.CreateGameEvent(1, 1, UT.TestData.EvtPlayerTakeoffMock, 1300)
    UT.TestCompare(function() return ge ~= nil end)
    UT.TestCompare(function() return ge["SessionID"] == 1 end)
    UT.TestCompare(function() return ge["ServerID"] == 1 end)
    UT.TestCompare(function() return ge["SortieID"] == 1 end)
    UT.TestCompare(function() return ge["Event"] == "TAKEOFF" end)
    UT.TestCompare(function() return ge["UCID"] == "AAA" end)
    UT.TestCompare(function() return ge["PlayerName"] == "New callsign" end)
    UT.TestCompare(function() return ge["PlayerSide"] == 1 end)
    UT.TestCompare(function() return ge["ModelTime"] == 1300 end)
    UT.TestCompare(function() return ge["GameTime"] == 600 end)
    UT.TestCompare(function() return ge["Role"] == "Ka-50" end)
    UT.TestCompare(function() return ge["Location"] == "Batumi" end)
    UT.TestCompare(function() return ge["Weapon"] == KI.Null end)
    UT.TestCompare(function() return ge["WeaponCategory"] == KI.Null end)
    UT.TestCompare(function() return ge["TargetName"] == KI.Null end)
    UT.TestCompare(function() return ge["TargetModel"] == KI.Null end)
    UT.TestCompare(function() return ge["TargetType"] == KI.Null end)
    UT.TestCompare(function() return ge["TargetCategory"] == KI.Null end)
    UT.TestCompare(function() return ge["TargetSide"] == KI.Null end)
    UT.TestCompare(function() return ge["TargetIsPlayer"] == false end)
    UT.TestCompare(function() return ge["TargetPlayerUCID"] == KI.Null end)
    UT.TestCompare(function() return ge["TargetPlayerName"] == KI.Null end)
    
  end
  
  if true then
    local ge = GameEvent.CreateGameEvent(1, 1, UT.TestData.EvtShotMock, 930)
    UT.TestCompare(function() return ge["SessionID"] == 1 end)
    UT.TestCompare(function() return ge["ServerID"] == 1 end)
    UT.TestCompare(function() return ge["SortieID"] == 1 end)
    UT.TestCompare(function() return ge["Event"] == "SHOT" end)
    UT.TestCompare(function() return ge["UCID"] == "AAA" end)
    UT.TestCompare(function() return ge["PlayerName"] == "New callsign" end)
    UT.TestCompare(function() return ge["PlayerSide"] == 1 end)
    UT.TestCompare(function() return ge["ModelTime"] == 930 end)
    UT.TestCompare(function() return ge["GameTime"] == 900 end)
    UT.TestCompare(function() return ge["Role"] == "Ka-50" end)
    UT.TestCompare(function() return ge["Location"] == KI.Null end)
    UT.TestCompare(function() return ge["Weapon"] == "Vikhr M" end)
    UT.TestCompare(function() return ge["WeaponCategory"] == "MISSILE" end)
    UT.TestCompare(function() return ge["TargetName"] == KI.Null end)
    UT.TestCompare(function() return ge["TargetModel"] == KI.Null end)
    UT.TestCompare(function() return ge["TargetType"] == KI.Null end)
    UT.TestCompare(function() return ge["TargetCategory"] == KI.Null end)
    UT.TestCompare(function() return ge["TargetSide"] == KI.Null end)
    UT.TestCompare(function() return ge["TargetIsPlayer"] == false end)
    UT.TestCompare(function() return ge["TargetPlayerUCID"] == KI.Null end)
    UT.TestCompare(function() return ge["TargetPlayerName"] == KI.Null end)
  end
  
  if true then
    local ge = GameEvent.CreateGameEvent(1, 1, UT.TestData.EvtHitAirMock, 930)
    UT.TestCompare(function() return ge["SessionID"] == 1 end)
    UT.TestCompare(function() return ge["ServerID"] == 1 end)
    UT.TestCompare(function() return ge["SortieID"] == 1 end)
    UT.TestCompare(function() return ge["Event"] == "HIT" end)
    UT.TestCompare(function() return ge["UCID"] == "AAA" end)
    UT.TestCompare(function() return ge["PlayerName"] == "New callsign" end)
    UT.TestCompare(function() return ge["PlayerSide"] == 1 end)
    UT.TestCompare(function() return ge["ModelTime"] == 930 end)
    UT.TestCompare(function() return ge["GameTime"] == 945 end)
    UT.TestCompare(function() return ge["Role"] == "Ka-50" end)
    UT.TestCompare(function() return ge["Location"] == KI.Null end)
    UT.TestCompare(function() return ge["Weapon"] == "Vikhr M" end)
    UT.TestCompare(function() return ge["WeaponCategory"] == "MISSILE" end)
    UT.TestCompare(function() return ge["TargetName"] == "TestKIScoreEnemyAir1" end)
    UT.TestCompare(function() return ge["TargetModel"] == "Su-25T" end)
    UT.TestCompare(function() return ge["TargetType"] == "STRIKER" end)
    UT.TestCompare(function() return ge["TargetCategory"] == "AIR" end,"Target Category not 'AIR'",true) -- expected failure - current bug in DCS returns bad category
    UT.TestCompare(function() return ge["TargetSide"] == 2 end)
    UT.TestCompare(function() return ge["TargetIsPlayer"] == false end)
    UT.TestCompare(function() return ge["TargetPlayerUCID"] == KI.Null end)
    UT.TestCompare(function() return ge["TargetPlayerName"] == KI.Null end)
  end

  if true then
    local ge = GameEvent.CreateGameEvent(1, 1, UT.TestData.EvtHitGroundMock, 930)
    UT.TestCompare(function() return ge["SessionID"] == 1 end)
    UT.TestCompare(function() return ge["ServerID"] == 1 end)
    UT.TestCompare(function() return ge["SortieID"] == 1 end)
    UT.TestCompare(function() return ge["Event"] == "HIT" end)
    UT.TestCompare(function() return ge["UCID"] == "AAA" end)
    UT.TestCompare(function() return ge["PlayerName"] == "New callsign" end)
    UT.TestCompare(function() return ge["PlayerSide"] == 1 end)
    UT.TestCompare(function() return ge["ModelTime"] == 930 end)
    UT.TestCompare(function() return ge["GameTime"] == 1110 end)
    UT.TestCompare(function() return ge["Role"] == "Ka-50" end)
    UT.TestCompare(function() return ge["Location"] == KI.Null end)
    UT.TestCompare(function() return ge["Weapon"] == "Vikhr M" end)
    UT.TestCompare(function() return ge["WeaponCategory"] == "MISSILE" end)
    UT.TestCompare(function() return ge["TargetName"] == "TestKIScoreEnemyGround1" end)
    UT.TestCompare(function() return ge["TargetModel"] == "T-55" end)
    UT.TestCompare(function() return ge["TargetType"] == "TANK" end)
    UT.TestCompare(function() return ge["TargetCategory"] == "GROUND" end,"Target Category not 'GROUND'",true)  -- expected failure - current bug in DCS returns bad category
    UT.TestCompare(function() return ge["TargetSide"] == 2 end)
    UT.TestCompare(function() return ge["TargetIsPlayer"] == false end)
    UT.TestCompare(function() return ge["TargetPlayerUCID"] == KI.Null end)
    UT.TestCompare(function() return ge["TargetPlayerName"] == KI.Null end)
  end

  if true then
    local ge = GameEvent.CreateGameEvent(1,1,UT.TestData.EvtCargoDeathMock,1200)
    UT.TestCompare(function() return ge["SessionID"] == 1 end)
    UT.TestCompare(function() return ge["ServerID"] == 1 end)
    UT.TestCompare(function() return ge["SortieID"] == KI.Null end)
    UT.TestCompare(function() return ge["Event"] == "CRASH" end)
    UT.TestCompare(function() return ge["UCID"] == KI.Null end)
    UT.TestCompare(function() return ge["PlayerName"] == "STATIC OBJECT" end)
    UT.TestCompare(function() return ge["PlayerSide"] == 1 end)
    UT.TestCompare(function() return ge["ModelTime"] == 1200 end)
    UT.TestCompare(function() return ge["GameTime"] == 1200 end)
    UT.TestCompare(function() return ge["Role"] == "iso_container_small" end)
    UT.TestCompare(function() return ge["Location"] == KI.Null end)
    UT.TestCompare(function() return ge["Weapon"] == KI.Null end)
    UT.TestCompare(function() return ge["WeaponCategory"] == KI.Null end)
    UT.TestCompare(function() return ge["TargetName"] == KI.Null end)
    UT.TestCompare(function() return ge["TargetModel"] == KI.Null end)
    UT.TestCompare(function() return ge["TargetType"] == KI.Null end)
    UT.TestCompare(function() return ge["TargetCategory"] == KI.Null end)
    UT.TestCompare(function() return ge["TargetSide"] == KI.Null end)
    UT.TestCompare(function() return ge["TargetIsPlayer"] == false end)
    UT.TestCompare(function() return ge["TargetPlayerUCID"] == KI.Null end)
    UT.TestCompare(function() return ge["TargetPlayerName"] == KI.Null end)
  end
  
  -- unit tests for bug #171 (Error when scenery object dies)
  if true then
    local ge = GameEvent.CreateGameEvent(1,1,UT.TestData.EvtDeathSceneryMock,1200)
    UT.TestCompare(function() return ge["Event"] == "DEAD" end)
    UT.TestCompare(function() return ge["PlayerName"] == "STATIC OBJECT" end)
    UT.TestCompare(function() return ge["PlayerSide"] == 0 end)
    UT.TestCompare(function() return ge["Role"] == "SCENERY" end)
  end

  -- Test Cases for Custom KI Events




  --[[
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
  UT.TestCompare(function() return KI.Data.GameEventQueue[1]["ModelTime"] == 1300 end)
  UT.TestCompare(function() return KI.Data.GameEventQueue[1]["GameTime"] == 1200 end)
  UT.TestCompare(function() return KI.Data.GameEventQueue[1]["Role"] == "KA50" end)
  UT.TestCompare(function() return KI.Data.GameEventQueue[1]["Location"] == "Batumi" end)
  UT.TestCompare(function() return KI.Data.GameEventQueue[1]["Weapon"] == nil end)
  UT.TestCompare(function() return KI.Data.GameEventQueue[1]["WeaponCategory"] == nil end)
  UT.TestCompare(function() return KI.Data.GameEventQueue[1]["TargetName"] == nil end)
  UT.TestCompare(function() return KI.Data.GameEventQueue[1]["TargetModel"] == nil end)
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
  UT.TestCompare(function() return KI.Data.GameEventQueue[2]["ModelTime"] == 930 end)
  UT.TestCompare(function() return KI.Data.GameEventQueue[2]["GameTime"] == 930 end)
  UT.TestCompare(function() return KI.Data.GameEventQueue[2]["Role"] == "KA50" end)
  UT.TestCompare(function() return KI.Data.GameEventQueue[2]["Location"] == nil end)
  UT.TestCompare(function() return KI.Data.GameEventQueue[2]["Weapon"] == "VIHKR" end)
  UT.TestCompare(function() return KI.Data.GameEventQueue[2]["WeaponCategory"] == "ATGM" end)
  UT.TestCompare(function() return KI.Data.GameEventQueue[2]["TargetName"] == nil end)
  UT.TestCompare(function() return KI.Data.GameEventQueue[2]["TargetModel"] == nil end)
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
  UT.TestCompare(function() return KI.Data.GameEventQueue[3]["ModelTime"] == 930 end)
  UT.TestCompare(function() return KI.Data.GameEventQueue[3]["GameTime"] == 930 end)
  UT.TestCompare(function() return KI.Data.GameEventQueue[3]["Role"] == "KA50" end)
  UT.TestCompare(function() return KI.Data.GameEventQueue[3]["Location"] == nil end)
  UT.TestCompare(function() return KI.Data.GameEventQueue[3]["Weapon"] == "Vikhr M" end)
  UT.TestCompare(function() return KI.Data.GameEventQueue[3]["WeaponCategory"] == "ATGM" end)
  UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetName"] == "TestKIScoreEnemyAir1" end)
  UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetModel"] == "Su-25T" end)
  UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetType"] == "STRIKER" end)
  UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetCategory"] == "AIR" end)
  UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetIsPlayer"] == false end)
  UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetPlayerUCID"] == nil end)
  UT.TestCompare(function() return KI.Data.GameEventQueue[3]["TargetPlayerName"] == nil end)
  
  -- Test 3 - Ignores any events that are AI only and not death, crash, eject, pilot death (we want to track whether an AI unit was killed, and use the database to process who got the kill and apply scores)
  KI.Hooks.GameEventHandler:onEvent(UT.TestData.EvtAITakeoffMock)
  UT.TestCompare(function() return #KI.Data.GameEventQueue == 3 end)    -- size should still be 3, ignoring this AI event
  
  -- Test 4 - Bulk Insert socket request message
  local _SocketRequestMessageBulk = KI.Socket.GenerateGameEventRequest(KI.Score.GameEventQueue)
  UT.TestCompare(function() return _SocketRequestMessage.Action == "InsertGameEvent" end)
  UT.TestCompare(function() return _SocketRequestMessage.BulkInsert == true end)
  UT.TestCompare(function() return #_SocketRequestMessage.Data == 3 end)
  UT.TestCompare(function() return KI.Toolbox.AreTablesEqual(_SocketRequestMessage.Data, KI.Score.GameEventQueue) end)
  ]]--
end,

function()
  KI.Data.OnlinePlayers = {}
end)
