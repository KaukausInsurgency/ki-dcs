--[[
GameEvent module

Exposes some functions for wrapping up DCS and KI events into a message that can be sent to TCP Server

Author: Igneous01
]]--

GameEvent = {}

GameEvent.CreateGameEvent = function(sessionID, serverID, dcs_event_obj, realTime)
  env.info("GameEvent.CreateGameEvent called (sessionID: " 
           .. tostring(sessionID) .. ", serverID: " 
           .. tostring(serverID) .. ", dcs_event_obj: "
           .. tostring(dcs_event_obj ~= nil) .. ", realTime: "
           .. tostring(realTime) .. ")")
  if sessionID == nil or 
    serverID == nil or 
    dcs_event_obj == nil or 
    dcs_event_obj.initiator == nil or
    realTime == nil then
    
    env.info("GameEvent.CreateGameEvent - invalid parameters (one or more is nil) exiting")
    return nil
  end
  
  local playerName = KI.Null
  local UCID = KI.Null
  local sortieID = KI.Null
  -- crate and static objects may be returned which do not have this function
  if dcs_event_obj.initiator.getPlayerName then
    playerName = dcs_event_obj.initiator:getPlayerName()  -- Its possible a player could be named "AI" which would blow this up
    if playerName then
      UCID = KI.Query.FindUCID_Player(playerName)
      sortieID = KI.Query.FindSortieID_Player(playerName) or KI.Null
    else
      playerName = "AI"
    end
  else
    playerName = "STATIC OBJECT"
  end
  
  
  local location = KI.Null
  local weapon = KI.Null
  local weaponCategory = KI.Null
  local target = KI.Null
  local targetName = KI.Null
  local targetType = KI.Null
  local targetCategory = KI.Null
  local targetIsPlayer = false
  local targetPlayerName = KI.Null
  local targetPlayerUCID = KI.Null
  local targetSide = KI.Null
  local numUnitsUnloaded = dcs_event_obj.unloaded or KI.Null
  local cargo = dcs_event_obj.cargo or KI.Null
  
  if dcs_event_obj.place then
    location = dcs_event_obj.place:getCallsign() or "Ground"
  end
  
  if dcs_event_obj.weapon then
    weapon = dcs_event_obj.weapon:getDesc()["displayName"]
    weaponCategory = KI.Defines.WeaponCategories[dcs_event_obj.weapon:getCategory()]
  else
    if dcs_event_obj.id == world.event.S_EVENT_SHOOTING_START or 
       dcs_event_obj.id == world.event.S_EVENT_SHOOTING_END then
      weapon = "Cannon"
      weaponCategory = "CANNON"
    end
  end
  
  if dcs_event_obj.target then
    targetName = dcs_event_obj.target:getName()
    target = dcs_event_obj.target:getTypeName()
    targetType = KI.Defines.UnitTypes[target] or KI.Null
    targetCategory = KI.Defines.UnitCategories[dcs_event_obj.target:getCategory()] or KI.Null
    targetPlayerName = KI.Null
    if dcs_event_obj.target.getPlayerName then
      targetPlayerName = dcs_event_obj.target:getPlayerName() or KI.Null
    end
    targetSide = dcs_event_obj.target:getCoalition()
    
    if targetPlayerName ~= KI.Null then
      targetIsPlayer = true
      targetPlayerUCID = KI.Query.FindUCID_Player(targetPlayerName) or KI.Null
    end
    
  end

  
  local gameevent =
  {
    ["SessionID"] = sessionID,
    ["ServerID"] = serverID,
    ["SortieID"] = sortieID,
    ["UCID"] = UCID,
    ["Event"] = KI.Defines.EventNames[dcs_event_obj.id],
    ["PlayerName"] = playerName,
    ["PlayerSide"] = dcs_event_obj.initiator:getCoalition(),
    ["RealTime"] = realTime,
    ["GameTime"] = dcs_event_obj.time,
    ["Role"] = dcs_event_obj.initiator:getTypeName(),
    -- optional fields
    ["Location"] = location,
    ["Weapon"] = weapon,
    ["WeaponCategory"] = weaponCategory,
    ["TargetName"] = targetName,
    ["TargetModel"] = target,
    ["TargetType"] = targetType,
    ["TargetCategory"] = targetCategory,
    ["TargetSide"] = targetSide,
    ["TargetIsPlayer"] = targetIsPlayer,
    ["TargetPlayerUCID"] =  targetPlayerUCID,
    ["TargetPlayerName"] = targetPlayerName,
    ["TransportUnloadedCount"] = numUnitsUnloaded,
    ["Cargo"] = cargo
  }
  env.info("GameEvent.CreateGameEvent() returning table")
  return gameevent
end
