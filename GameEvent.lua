
GameEvent = {}

function GameEvent.CreateGameEvent(sessionID, serverID, sortieID, dcs_event_obj, realTime)
  env.info("GameEvent.CreateGameEvent called")
  if not sessionID or 
     not serverID or 
     not sortieID or 
     not ucid or 
     not dcs_event_obj or 
     not dcs_event_obj.initiator or
     not realTime then
    
    env.info("GameEvent.CreateGameEvent - invalid parameters (one or more is nil) exiting")
    return nil
  end
  
  local playerName = dcs_event_obj.initiator:getPlayerName()
  local airfield = nil
  local weapon = nil
  local weaponCategory = nil
  local target = nil
  local targetName = nil
  local targetType = nil
  local targetCategory = nil
  local targetIsPlayer = false
  local targetPlayerUCID = nil
  local targetPlayerName = nil
  
  if dcs_event_obj.place then
    airfield = dcs_event_obj.place:getName()
  end
  
  if dcs_event_obj.weapon then
    weapon = dcs_event_obj.weapon:getTypeName()
    weaponCategory = KI.Defines.WeaponCategories[dcs_event_obj.weapon:getCategory()]
  end
  
  if dcs_event_obj.target then
    targetName = dcs_event_obj.target:getName()
    target = dcs_event_obj.target:getTypeName()
    targetType = KI.Defines.UnitTypes[target]
    targetCategory = KI.Defines.UnitCategories[dcs_event_obj.target:getCategory()]
    targetPlayerName = dcs_event_obj.target:getPlayerName()
    
    if targetPlayerName then
      targetIsPlayer = true
      targetPlayerUCID = KI.Query.FindUCID_Player(KI.MP.GetPlayerNameFix(targetPlayerName))
    end
    
  end
  
  local gameevent =
  {
    SessionID = sessionID,
    ServerID = serverID,
    SortieID = sortieID,
    UCID = KI.Query.FindUCID_Player(KI.MP.GetPlayerNameFix(playerName)),
    Event = KI.GameEvent.EventKeyPair[dcs_event_obj.id],
    PlayerName = playerName,
    RealTime = realTime,
    GameTime = dcs_event_obj.time,
    Role = dcs_event_obj.initiator:getTypeName(),
    -- optional fields
    Airfield = airfield,
    Weapon = weapon,
    WeaponCategory = weaponCategory,
    TargetName = targetName,
    Target = target,
    TargetType = targetType,
    TargetCategory = targetCategory,
    TargetIsPlayer = targetIsPlayer,
    TargetPlayerUCID = targetPlayerUCID,
    TargetPlayerName = targetPlayerName
  }
  
  return gameevent
end