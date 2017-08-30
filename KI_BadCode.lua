--CiriBob's get groupID function
function getGroupId(_unit)
	local _unitDB =  mist.DBs.unitsById[tonumber(_unit:getID())]
    if _unitDB ~= nil and _unitDB.groupId then
        return _unitDB.groupId
    end

    return nil
end

--CiriBob's get groupName function
function getGroupName(_unit)
    local _unitDB =  mist.DBs.unitsById[tonumber(_unit:getID())]
    if _unitDB ~= nil and _unitDB.groupId then
        return _unitDB.groupName
    end

    return nil
end

-- not working for clients!!!
function getGroupFromUnit(_unit)
	local _groupName = getGroupName(_unit)
	koEngine.debugText("groupname = ".._groupName)
	return Group.getByName(_groupName)
end

-- ciribobs group-check functions
local function isGroupThere(_groupName)
	return Group.getByName(_groupName)
			and Group.getByName(_groupName):isExist()
			and #Group.getByName(_groupName):getUnits() >= 1
			and Group.getByName(_groupName):getUnits()[1]:isActive()
end

local function isAllOfGroupThere(_groupName)
	if not isGroupThere(_groupName) then
		return false
	end

	local _group = Group.getByName(_groupName)

	--check current group size is equal to actual group size
	if _group:getInitialSize() == _group:getSize() then
		return true
	else
		return false
	end
end


-- gets a spawngroup from the savegame and checks if it has losses
-- returns false if there is a loss
local function isAllOfSpawngroupThere(spawnGroup)
	if not isGroupThere(spawnGroup.name) then
		return false
	end

	-- get all alive units from the spawned group 
	local units = Group.getUnits(Group.getByName(spawnGroup.name))
	
	if not units then return false end
	
	-- run through all units in the spawntable
	for i, spawnUnit in pairs(spawnGroup.units) do
		local unitFound = false
		
		-- run through all alive-units to see if theres one unit missing
		for k, unit in pairs(units) do
			local unitName = unit:getName()
			if spawnUnit.name == unitName then
				unitFound = true
				break
			end
		end
		
		if not unitFound then
			return false
		end
	end

	return true
end









--------------------------------------------
-- KI eventHandler() - scheduled function
--------------------------------------------
--
-- checks BIRTH, TAKEOFF and LANDING events
-- to keep track of player lives
local eventHandler = {}
function eventHandler:onEvent(event)
	if event.id == world.event.S_EVENT_PLAYER_LEAVE_UNIT or event.id == world.event.S_EVENT_BASE_CAPTURED then
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