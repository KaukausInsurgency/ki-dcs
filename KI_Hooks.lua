if not KI then
  KI = {}
end




KI.Hooks = {}

-- KI Hooks into SLC and integration with DWM Depots
function KI.Hooks.SLCPreOnRadioAction(actionName, parentAction, transGroup, pilotname, comp)
  env.info("SLC.Config.PreOnRadioAction called")
  
  -- check if this is a depot call
  if parentAction == "Depot Management" or parentAction == "Troop Management" then
    local _depot = KI.Query.FindDepot_Group(transGroup)
    if _depot then
      env.info("SLC.Config.PreOnRadioAction - Group " .. transGroup.GroupName .. " inside zone " .. _depot.Zone.ZoneName)
      -- if in zone, check DWM contents
      if actionName == "Fuel Truck Crate" then
        return _depot:Take("Fuel Truck", 1)
      elseif actionName == "Command Truck Crate" then
        return _depot:Take("Command Truck", 1)
      elseif actionName == "Ammo Truck Crate" then
        return _depot:Take("Ammo Truck", 1)
      elseif actionName == "Power Truck Crate" then
        return _depot:Take("Power Truck", 1)
      elseif actionName == "BTR 80 Crate" then
        return _depot:Take("APC", 1)
      elseif actionName == "T-72 Crate" then
        return _depot:Take("Tank", 1)
      elseif actionName == "Watch Tower Wood" then
        return _depot:Take("Watchtower Wood", 1)
      elseif actionName == "Watch Tower Supply Crate" then
        return _depot:Take("Watchtower Supplies", 1)
      elseif actionName == "Outpost Pipes" then
        return _depot:Take("Outpost Pipes", 1)
      elseif actionName == "Outpost Supply Crate" then
        return _depot:Take("Outpost Supplies", 1)
      elseif actionName == "Outpost Wood" then
        return _depot:Take("Outpost Wood", 1)
      elseif actionName == "Infantry Squad" then
        return _depot:Take("Infantry", comp.Size)
      elseif actionName == "Anti Tank Squad" then
        return _depot:Take("Infantry", comp.Size)
      elseif actionName == "MANPADS Squad" then
        return _depot:Take("Infantry", comp.Size) 
      else
        env.info("SLC.Config.PreOnRadioAction - attempt to take an unknown resource from a depot")
        return false
      end
    else
      env.info("SLC.Config.OnRadioAction - Group " .. transGroup.GroupName .. " is not inside a zone")
      trigger.action.outText("SLC - This action is only available when near a depot!", 10)
      return false
    end
  elseif parentAction == "Crate Management" then
    local _cp = KI.Query.FindCP_Group(transGroup)
    if not _cp then
      env.info("SLC.Config.PreOnRadioAction - Crate Unpacking cannot be called outside of a capture zone")
      trigger.action.outText("SLC - You cannot unpack crates in the wild or at depots! Unpack this crate in a capture zone!", 10)
      return false
    else
      if _cp:Fortify("Vehicle", 1) then
        return true
      else
        return false
      end
      return true
    end
  elseif parentAction == "Deploy Management" then
    local _cp = KI.Query.FindCP_Group(transGroup)
    -- if the pilot has troops already loaded and not in capture point, disallow 
    if not _cp and SLC.TransportInstances[pilotname] then
      env.info("SLC.Config.PreOnRadioAction - Troop Deployment cannot be called outside of a capture zone")
      trigger.action.outText("SLC - You cannot deploy infantry in the wild or at depots! Bring them to a capture zone!", 10)
      return false
    elseif _cp and SLC.TransportInstances[pilotname] then
      env.info("SLC.Config.PreOnRadioAction - Troop Deployment is valid and inside a capture zone")
      if _cp:Fortify("Infantry", 1) then
        return true
      else
        return false
      end
    else
      env.info("SLC.Config.PreOnRadioAction - Pilot is trying to load troops")
      return true
    end
  else
    return true
  end
end




function KI.Hooks.SLCPostOnRadioAction(actionName, actionResult, parentAction, transportGroup, pilotname, comp)
  env.info("SLC.Config.PostOnRadioAction called (actionName: " .. actionName .. ", parentAction: " .. parentAction .. ")")
  -- create a timer function that will despawn the crate and put it back into the warehouse if left inactive
  if parentAction == "Depot Management" then
    -- add to despawn queue
    --KI.DespawnQueue[actionResult:getName()] = { lastPosition = actionResult:getPoint(), inDepotZone = false, timesChecked = 0 }
    env.info("SLC.Config.PostOnRadioAction - adding Depot item to GC Queue")
    
    local gc_item = GCItem:New(actionResult:getName(), 
                              actionResult, 
                              function(obj)
                                return obj:isExist()
                              end,
                              function(obj)
                                return obj:destroy()
                              end,
                              KI.Hooks.GCOnLifeExpiredCrate,
                              { LastPosition = actionResult:getPoint(), Depot = nil, Object = actionResult, DepotIdleTime = 0 },
                              KI.Hooks.GC_Crate_IsIdle, KI.Hooks.GC_Crate_DepotExpired, KI.Config.CrateDespawnTime_Wild)
    
    GC.Add(gc_item)
    
    -- action result returned from unPack is the staticobject
    --timer.scheduleFunction(KI.Scheduled.DespawnHandler, actionResult, timer.getTime() + 60) -- end embedded timer function
  elseif parentAction == "Troop Management" then
    env.info("SLC.Config.PostOnRadioAction - adding troop group to GC Queue")
    if actionResult then
      env.info("SLC.Config.PostOnRadioAction - troop instance found - adding to GC Queue")
      local gc_item = GCItem:New(actionResult.GroupName, 
                              actionResult, 
                              function(obj)
                                return obj:IsAlive()
                              end,
                              function(obj)
                                return obj:Destroy()
                              end,
                              KI.Hooks.GCOnLifeExpiredTroops,
                              { Depot = nil, Object = actionResult },
                              KI.Hooks.GC_Troops_IsIdle, nil, KI.Config.CrateDespawnTime_Depot)
    
      GC.Add(gc_item)
    else
      env.info("SLC.Config.PostOnRadioAction - troop instance was not found - doing nothing")
    end
  
  else
    env.info("SLC.PostOnRadioAction - doing nothing")
  end -- end if depot management
end






-- KI HOOKS INTO GC
function KI.Hooks.GCOnLifeExpiredCrate(gc_item)
  env.info("GC.GCOnLifeExpiredCrate callback called")
  -- if the item is a crate and is inside a depot zone - despawn it and put contents back into depot
  local _args = gc_item.PredicateArgs
  local n = _args.Object:getName()
  if _args.Depot then
    env.info("GC.OnLifeExpired - crate is in depot and is being despawned")
    local _depot = _args.Depot
    KI.Toolbox.MessageRedCoalition("Crate " .. n .. " has been despawned and contents put back into depot!")
    if string.match(n, "SLC FuelTruckCrate") then
      _depot:Give("Fuel Truck", 1)
    elseif string.match(n, "SLC CommandTruckCrate") then
      _depot:Give("Command Truck", 1)
    elseif string.match(n, "SLC AmmoTruckCrate") then
      _depot:Give("Ammo Truck", 1)
    elseif string.match(n, "SLC PowerTruckCrate") then
      _depot:Give("Power Truck", 1)
    elseif string.match(n, "SLC BTRCrate") then
      _depot:Give("APC", 1)
    elseif string.match(n, "SLC TankCrate") then
      _depot:Give("Tank", 1)
    elseif string.match(n, "SLC WTWood") then
      _depot:Give("Watchtower Wood", 1)
    elseif string.match(n, "SLC WTCrate") then
      _depot:Give("Watchtower Supplies", 1)
    elseif string.match(n, "SLC OPPipe") then
      _depot:Give("Outpost Pipes", 1)
    elseif string.match(n, "SLC OPCrate") then
      _depot:Give("Outpost Supplies", 1)
    elseif string.match(n, "SLC OPWood") then
      _depot:Give("Outpost Wood", 1)
    else
      env.info("GC.OnLifeExpired - attempt to give an unknown resource to a depot (Entity: " .. n ..")")
    end
  else
    env.info("GC.OnLifeExpired - crate is in wild and is being despawned")
    KI.Toolbox.MessageRedCoalition("Crate " .. n .. " in the wild has been despawned!")
  end  
end

-- KI HOOKS INTO GC
function KI.Hooks.GCOnLifeExpiredTroops(gc_item)
  env.info("GC.GCOnLifeExpiredTroops callback called")
  -- if the item is a crate and is inside a depot zone - despawn it and put contents back into depot
  --if gc_item == nil then env.info("GC.GCOnLifeExpiredTroops gc_item is nil") end
  local n = gc_item.Name
  local _args = gc_item.PredicateArgs
  --if _args == nil then env.info("GC.GCOnLifeExpiredTroops _args is nil") end
  
  if _args.Depot then
    env.info("GC.GCOnLifeExpiredTroops - troop is in depot and is being despawned")
    local _depot = _args.Depot
    trigger.action.outText("Infantry " .. n .. " has been despawned and contents put back into depot!", 10)
    if string.match(n, "SLC Infantry") then
      _depot:Give("Infantry", 10)
    elseif string.match(n, "SLC ATInfantry") then
      _depot:Give("Infantry", 6)
    elseif string.match(n, "SLC MANPADS") then
      _depot:Give("Infantry", 3)
    else
      env.info("GC.GCOnLifeExpiredTroops - attempt to give an unknown resource to a depot (Entity: " .. n ..")")
    end
  else
    env.info("GC.GCOnLifeExpiredTroops - troops is in wild and is being despawned")
    trigger.action.outText("Infantry " .. n .. " in the wild has been despawned!", 10)
  end  
end



-- args is a table, which is passed by reference to functions according to lua 5.1 Reference Manual
-- https://stackoverflow.com/questions/6128152/function-variable-scope-pass-by-value-or-reference
function KI.Hooks.GC_Crate_IsIdle(args)
  env.info("KI.Hooks.GC_Crate_IsIdle called for " .. args.Object:getName())
  local _lastPos = args.LastPosition
  local _newPos = args.Object:getPoint()
  
    -- check if in a depot zone
  local _depot = KI.Query.FindDepot_Static(args.Object)
  if _depot then
    env.info("KI.Hooks.GC_Crate_IsIdle - " .. args.Object:getName() .. " is inside depot zone " .. _depot.Name)
    args.Depot = _depot
  else
    env.info("KI.Hooks.GC_Crate_IsIdle - " .. args.Object:getName() .. " is not inside a depot zone")
    args.Depot = nil
  end
  
  -- if the distance is less than 5 metres increment count
  if Spatial.Distance(_newPos, _lastPos) < 5 then
    env.info("KI.Hooks.GC_Crate_Predicate - crate position has not changed since last check")
    if args.Depot then
      args.DepotIdleTime = args.DepotIdleTime + GC.LoopRate
    else
      args.DepotIdleTime = 0
    end
    return true
  else
    env.info("KI.Hooks.GC_Crate_Predicate - crate position has changed, resetting")
    args.LastPosition = _newPos
    return false
  end
end

-- this function is only called when troops are first spawned in from depot (but not picked up/dropped)
-- once the troops are loaded/unloaded in SLC the GC is removed entirely for them
function KI.Hooks.GC_Troops_IsIdle(args)
  env.info("KI.Hooks.GC_Troops_IsIdle called for " .. args.Object.GroupName)
    -- check if in a depot zone
  local _depot = KI.Query.FindDepot_Group(args.Object)
  if _depot then
    env.info("KI.Hooks.GC_Troops_IsIdle - " .. args.Object.GroupName .. " is inside depot zone " .. _depot.Name)
    args.Depot = _depot
  else
    env.info("KI.Hooks.GC_Troops_IsIdle - " .. args.Object.GroupName .. " is not inside a depot zone")
    args.Depot = nil
  end
  
  return true
end

function KI.Hooks.GC_Crate_DepotExpired(args)
  if args.Depot and args.DepotIdleTime >= KI.Config.CrateDespawnTime_Depot then
    env.info("KI.Hooks.GC_Crate_DepotExpired returned true")
    return true
  else
    env.info("KI.Hooks.GC_Crate_DepotExpired returned false")
    return false
  end
end

function KI.Hooks.GCOnDespawn(name)
  env.info("GC.OnDespawn called for " .. name)
  return
end


-- Handlers for GameEvents
KI.Hooks.GameEventHandler = {}

function KI.Hooks.GameEventHandler:onEvent(event)
  if not event.initiator then return end
  local playerName = event.initiator:getPlayerName() or nil
  
  -- catch all forms of shooting events from a player
	if (event.id == world.event.S_EVENT_SHOT or
     event.id == world.event.S_EVENT_SHOOTING_START or
     event.id == world.event.S_EVENT_SHOOTING_END) and
     playerName then
       
  -- catch all hit events that were initiated by a player
  elseif event.id == world.event.S_EVENT_HIT and playerName then
    
  elseif event.id == world.event.S_EVENT_TAKEOFF and playerName then
    
  elseif event.id == world.event.S_EVENT_LAND and playerName then
    
  -- catch all forms of death / airframe destruction
  elseif event.id == world.event.S_EVENT_CRASH or 
         event.id == world.event.S_EVENT_DEAD or
         event.id == world.event.S_EVENT_EJECTION or 
         event.id == world.event.S_EVENT_PILOT_DEAD or 
         event.id == world.event.S_EVENT_PLAYER_LEAVE_UNIT then
           
  elseif event.id == world.event.S_EVENT_REFUELING or
         event.id == world.event.S_EVENT_REFUELING_STOP and playerName then
           
  elseif event.id == world.event.S_EVENT_MISSION_START then
    
  elseif event.id == world.event.S_EVENT_MISSION_END then
    
  -- Initialize any radio menu items for the player
  elseif event.id == world.event.S_EVENT_BIRTH and playerName then
    SLC.InitSLCForUnit(event.initiator:getName())
    return
    
  --elseif event.id == world.event.S_EVENT_PLAYER_COMMENT  then
  else
    return
	end
	
	env.info("KI.eventHandler("..eventTable[event.id]..")"..tostring(event.id), 1)
	
	if event.id == world.event.S_EVENT_MISSION_END then
		
		for ucid, sortie in pairs(koScoreBoard.activeSorties) do
			env.info("found active Sortie for player "..sortie.playerName..", closing it")
			koScoreBoard.closeSortie(sortie.playerName, "Mission End")
		end
		
		koTCPSocket.send({ status = "restarting" }, "restart")
		
		koTCPSocket.forceTransmit()	-- try to send it right away
		--koTCPSocket.saveBuffer() -- called inside forceTransmit()
		return
	end

	
	--check that there's an initiator
	--if event.initiator and event.initiator:isExist() then
	if event.initiator then
		if Object.getCategory(event.initiator) ~= Object.Category.UNIT then 
			env.info("event initiator is not a unit! returning")
			return 
		end	
		
		-- no playername means AI
		local playerName = event.initiator:getPlayerName()
		
		-- not interested in AI here
		if not playerName then 
			env.info("AI, returning")
			return 		-- only run if not AI, no player name is AI
		end
		
		if playerName == '' then
			env.info("FATAL WARNING: playerName is empty String! Trying to find original player")
			
			-- try to find the player in PlayerUnitList
			for groupID, player in pairs(KI.MP.PlayerUnitList) do
				if tonumber(groupID) == getGroupId(event.initiator) then
					env.info("found groupID in PlayerUnitList: playerName = '"..player.playerName.."'")
					playerName = player.playerName
				elseif player.unit == event.iniator then
					-- found the player
					playerName = player.playerName
					env.info("found playername for empty-string Player in PlayerUnitList")
				end	
			end
		end 
		
		--create vars
		local ownGroupID = getGroupId(event.initiator) if not ownGroupID then env.info("FATAL ERROR: initiator has no groupId!") return end	-- uses ciribobs getGroupI
		local playerUnitName = event.initiator:getName() if not playerUnitName then env.info("FATAL ERROR: initiator has no name!") return end	
		local playerNameFix = KI.MP.GetPlayerNameFix(playerName)
		local playerUCID = KI.MP.GetPlayerUCID(playerName)
		local coalition = coalitionTable[event.initiator:getCoalition()]

		--------------------------------------
		--	BIRTH event
		--	- make the radio menu
		--	- debug functions
		if event.id == world.event.S_EVENT_BIRTH then
			env.info("Player '"..playerName.."' has entered "..coalition.."("..event.initiator:getTypeName()..") '"..playerUnitName.."'")
			
			KI.MP.PlayerUnitList[tostring(ownGroupID)] = {
				unit = event.initiator,
				playerName = playerName,
				playerUCID = playerUCID,
				playerUnitName = playerUnitName,
				playerUnitCategory = unitCategoryTable[event.initiator:getDesc().category],
				playerUnitType = event.initiator:getTypeName(),
				side = coalition,
			}
			env.info("PlayerUnitList["..tostring(ownGroupID).."] = "..KI.Toolbox.SerializeTable(KI.MP.PlayerUnitList[tostring(ownGroupID)]))
			
			env.info("creating radio-menu")
			-- create menu items
			koEngine.makeRadioMenu(event, ownGroupID, playerName, event.initiator)
			
			local zone = nil
			
			-- check if old sortie was not closed (respawned?)
			if koScoreBoard.getActiveSortie(playerName) then
				koScoreBoard.closeSortie(playerName)
			end				
			
			-- open a new sortie
			local newSortie = koScoreBoard.newSortie(playerName)
			newSortie.type = event.initiator:getTypeName()
			newSortie.unitName = playerUnitName
			newSortie.unitCategory = unitCategoryTable[event.initiator:getDesc().category]
			newSortie.unitType = event.initiator:getTypeName()
			newSortie.side = coalition
			newSortie.zone = zone
			newSortie.birthTime = timer.getTime()
			
			-- if its a heli make sure to start CSAR stuff (by Ciribob) --
			if unitCategoryTable[event.initiator:getDesc().category] == "HELICOPTER" then
				env.info("adding medevac menu to HELICOPTER")
				
				for _, _heliName in pairs(csar.csarUnits) do
	                if _heliName == event.initiator:getName() then
	                    -- add back the status script
						env.info("found heli in csarUnits")
						
	                    for _woundedName, _groupInfo in pairs(csar.woundedGroups) do
	                    	env.info("_woundedName = ".._woundedName)
		                    	if Group.getByName(_woundedName) and Group.getByName(_woundedName):isExist() then 
		                    		
			                    	local _woundedGroup = csar.getWoundedGroup(_woundedName)
			                    	if csar.checkGroupNotKIA(_woundedGroup, _woundedName, event.initiator, _heliName) then
				                    	local _woundedLeader = _woundedGroup[1]
				                    	local _lookupKeyHeli = event.initiator:getID() .. "_" .. _woundedLeader:getID()
				                    	csar.enemyCloseMessage[_lookupKeyHeli] = false -- start fresh
				                    else
				                    	env.info("csar: preparing heli after spawn: group _woundedName: '".._woundedName.."' is KIA")
			                    	end
			                    else
			                    	env.info("csar: preparing heli after spawn: group _woundedName: '".._woundedName.."' does not exist")
		                    	end
	                    	
                            -- queue up script and chedule timer to check when to pop smoke
                            env.info("CSAR: scheduling checkWoundedGroupStatus()")
                            timer.scheduleFunction(csar.checkWoundedGroupStatus, { _heliName, _woundedName }, timer.getTime() + 5)
                        end
	                end
	            end
			end
			
		end
		
		--------------------------------------
		--	TAKEOFF event
		--check event when unit takeoff
		if event.id == world.event.S_EVENT_TAKEOFF then
			
			
			-- check if player is valid!
		
			env.info("player is valid")
			MissionData['properties']['playerLimit'][playerNameFix] = MissionData['properties']['playerLimit'][playerNameFix] or 0

			local placeName = "in the field"
			local placeCallsign = ""
			local placeCategory = "grass"
			
			if event.place then
				placeCallsign = event.place:getCallsign()
			end

			-- check if player is in a zone
			local zone = nil
			if zone then
				placeName = zone
				placeCategory = "Capture Point"
			end
			
			env.info(playerName.."("..event.initiator:getTypeName()..") took off from "..placeName)
			
			--player tookoff take limit if the player is in a zone
			if zone then
				for pName,limit in pairs(MissionData['properties']['playerLimit']) do
					if pName == playerNameFix then
						env.info("Player has taken off from Zone, removing live from "..playerNameFix)
						MissionData['properties']['playerLimit'][playerNameFix] = limit+1
					end
				end
				
				local msg = "_______________________________________________________________________________________________________\n\n"
				msg = msg .. "  Have a good flight "..playerName.."\n\n"
				msg = msg .. "  You took off from "..placeName.."/"..placeCallsign.."/"..placeCategory..".\n\n"
				msg = msg .. '  You currently have '..format_num(koScoreBoard.getCashcountForPlayer(playerName))..'$\n'
				msg = msg .. "  Lives - "..MissionData['properties']['playerLimit'][playerNameFix].."/"..MissionData['properties']['lifeLimit'].."\n"
				msg = msg .. "  Land your aircraft on a base to get your life back.\n"
				msg = msg .. "_______________________________________________________________________________________________________\n"
				
				trigger.action.outTextForGroup(ownGroupID,msg,30)
			end
			
			-- #choppersdeserveascore!
			local newScore = {
				unitGroupID = getGroupId(event.initiator),
				unitCategory = unitCategoryTable[event.initiator:getDesc().category],
				unitType = event.initiator:getTypeName(),
				unitName = playerUnitName,
				timestamp = event.time,
				timer = timer.getTime(),
				achievment = "takeoff",
				place = placeName,
				placeCategory = placeCategory,
				side = coalition,
			}
			koScoreBoard.insertScoreForPlayer(playerName, newScore)
		end
		
		--------------------------------------
		--	LAND event
		--check event when unit lands
		if event.id == world.event.S_EVENT_LAND then
			
			--env.info(KI.Toolbox.SerializeTable(event))

			local validLanding = true
			local placeName = "in the field"
			local placeCallsign = ""
			local placeCategory = "grass"
			
			if event.place then
				placeCallsign = event.place:getCallsign()
			end
			
			-- check if player is in a zone
			local zone = nil
			if zone then
				placeName = zone
				placeCategory = nil
			end	
			
			env.info(playerName.."("..event.initiator:getTypeName()..") landed at "..placeName)
			
			local newScore = {
				unitGroupID = getGroupId(event.initiator),
				unitCategory = unitCategoryTable[event.initiator:getDesc().category],
				unitType = event.initiator:getTypeName(),
				unitName = playerUnitName,
				timestamp = event.time,
				achievment = "landing",
				place = placeName,
				placeCategory = placeCategory,
				side = coalition,  
				timer = timer.getTime(),
			}
			
			--player landed take limit if the player is in a zone
			if zone then
				if MissionData['properties']['playerLimit'] and MissionData['properties']['playerLimit'][playerNameFix] then
					--player landed put back limit
					for pName,limit in pairs(MissionData['properties']['playerLimit']) do
						if pName == playerNameFix then
							env.info("Player has landed in Zone, adding live to "..playerNameFix)
							MissionData['properties']['playerLimit'][playerNameFix] = limit-1
							break
						end
					end
					
					local msg = "_______________________________________________________________________________________________________\n\n"
					msg = msg .. "  Good to have you back "..playerName.."\n\n"
					msg = msg .. "  You have landed at "..placeName.."/"..placeCallsign.."/"..placeCategory..".\n\n"
					msg = msg .. '  You currently have '..format_num(koScoreBoard.getCashcountForPlayer(playerName))..'$\n'
					msg = msg .. "  Lives - "..MissionData['properties']['playerLimit'][playerNameFix].."/"..MissionData['properties']['lifeLimit'].."\n"
					msg = msg .. "  Land your aircraft on a base to get your life back.\n"
					msg = msg .. "_______________________________________________________________________________________________________\n"
					
					trigger.action.outTextForGroup(ownGroupID, msg, 30)
				end
			elseif not event.place and event.initiator:getDesc().category ~= Unit.Category.HELICOPTER then -- when airplanes land off airport
				newScore.achievment = "emergencylanding"
			end
			
			koScoreBoard.insertScoreForPlayer(playerName, newScore)
		end
	else
		if event.initiator then
			env.info("initiator does not exist!")
		else
			env.info("there is no initiator")
		end
	end

end












