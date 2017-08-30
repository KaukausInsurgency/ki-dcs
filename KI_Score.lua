--env.setErrorMessageBoxEnabled(false)

koScoreBoard = {}
-----------------------------------
-- score definition
--[[
table scoreTable = {
	unitCategory = "Helicopter",			-- Helicopter, Aircraft, Groundunit
	unitType = event.unit:getTypeName(),	-- UH-1H, Su27, A10C
	achievment = "dropped_in_hotzone",		-- "dropped_in_hotzone", "troops_dropped", "vehicle_dropped", "pilot_rescued", "sortieStarted", "troops_loaded", "vehicle_loaded", "unpacked", "troops_returned", "vehicles_returned"
	zone = dropzone,
	captured = -1, 							-- -1 = undecided, 0 = didnt capture, 1 = captured
	droppedGroup							-- groupID of the troops dropped
}
--]]

koScoreBoard.loopFreq = 2 					-- how frequent do we check for kills?
koScoreBoard.lastMainLoop = 0
koScoreBoard.eventInfoDisplayTime = 5		-- how long shall kill/death/shot messages be displayed?
koScoreBoard.eventFileName = lfs.writedir() .. [[Missions\The Kaukasus Offensive\ko_EventBuffer.lua]]
koScoreBoard.scoreID = -100
koScoreBoard.sortieID = -100
koScoreBoard.lastCollisions = {}			-- stores collision-timestamps for playernames to prevent double collision messages (once is enough)
koScoreBoard.lastHits = {}					-- stores hit-timestamps for playernames to prevent hitmessage spams (once every second is enough)
koScoreBoard.recentHits = {}
koScoreBoard.recentShots = {}
koScoreBoard.activeSorties = {}

local coalitionTable = {
	[0] = 'neutral',
	[1] = 'red',
	[2] = 'blue',
}

local coaNameTable = {
	['neutral'] = 0,
	['red'] = 1,
	['blue'] = 2,
}

local weaponCategory = {
	[0] = 'shell',
	[1] = 'missile',
	[2] = 'rocket',
	[3] = 'bomb',
}

local weaponMissileCategory = {
	[0] = 'AAM',
	[1] = 'SAM',
	[2] = 'BM',
	[3] = 'ANTISHIP',
	[4] = 'CRUISE',
	[5] = 'OTHER',
}

local eventTable = {
	[0] = "S_EVENT_INVALID",
	[1] = "S_EVENT_SHOT",
	[2] = "S_EVENT_HIT",
	[3] = "S_EVENT_TAKEOFF",
	[4] = "S_EVENT_LAND",
	[5] = "S_EVENT_CRASH",
	[6] = "S_EVENT_EJECTION",
	[7] = "S_EVENT_REFUELING",
	[8] = "S_EVENT_DEAD",
	[9] = "S_EVENT_PILOT_DEAD",
	[10] = "S_EVENT_BASE_CAPTURED",
	[11] = "S_EVENT_MISSION_START",
	[12] = "S_EVENT_MISSION_END",
	[13] = "S_EVENT_TOOK_CONTROL",
	[14] = "S_EVENT_REFUELING_STOP",
	[15] = "S_EVENT_BIRTH",
	[16] = "S_EVENT_HUMAN_FAILURE",
	[17] = "S_EVENT_ENGINE_STARTUP",
	[18] = "S_EVENT_ENGINE_SHUTDOWN",
	[19] = "S_EVENT_PLAYER_ENTER_UNIT",
	[20] = "S_EVENT_PLAYER_LEAVE_UNIT",
	[21] = "S_EVENT_PLAYER_COMMENT",
	[22] = "S_EVENT_SHOOTING_START",
	[23] = "S_EVENT_SHOOTING_END",
	[24] = "S_EVENT_MAX"
}

koScoreBoard.cashForAchievement = {
	-- standards
	["takeoff"]				= { value = 0, desc = nil },
	["landing"] 			= { value = 100, desc = "landing" },
	["crashed"] 			= { value = 0, desc = nil },
	["ejected"] 			= { value = 500, desc = "ejecting" },	-- encourage people to eject by giving them a bonus for not dying
	["died"] 				= { value = 0, desc = nil },
	["sortie"] 				= { value = 0, desc = nil },
	
	-- destructive stuff
	["kill_fighter"]		= { value = 1000, desc = "killing a fighter" },
	["kill_striker"] 		= { value = 500, desc = "killing a striker" },
	["kill_helicopter"] 	= { value = 250, desc = "killing a helicopter" },
	["kill_ground"] 		= { value = 1000, desc = "killing a ground target" },
	["kill_ground2air"] 	= { value = 1000, desc = "a G2A kill" },
	["kill_ground2ground"] 	= { value = 1000, desc = "a G2G kill" },
	
	["teamkill"] 			= { value = -10000, desc = "teamkilling" },
	["selfkill"] 			= { value = 0, desc = "selfkill" },
	["hit"] 				= { value = 0, desc = "scoring a hit" },
	["teamhit"] 			= { value = -1000, desc = "hitting a friendly" },
	["shot"] 				= { value = 0, desc = "shot" },
	
	-- cargo
	["hoverpickup"] 					= { value = 200, desc = "picking up a crate in hover" },
	["crate_safely_unhooked"] 			= { value = 200, desc = "safely unhooking a crate in low altitude" },
	["crate_safely_dropped"] 			= { value = 100, desc = "rudely dropping a crate" },
	["crate_dropped_on_ground"] 		= { value = 200, desc = "dropping a crate on the ground" },
	["crate_safely_unhooked_inzone"] 	= { value = 500, desc = "safely unhooking a crate in a zone" },
	["crate_safely_dropped_inzone"] 	= { value = 250, desc = "rudely dropping a crate in a zone" },
	["crate_dropped_on_ground_inzone"] 	= { value = 500, desc = "dropping a crate in a zone" },
	
	-- slingload deployments
	["neutral_base_occupied"] 		= { value = 3000, desc = "occupying a neutral base" },
	["cargo_unpacked_in_zone"] 		= { value = 2000, desc = "supplying a friendly base" },
	["neutral_farp_opened"] 		= { value = 4000, desc = "opening a farp" },
	["farp_groundcrew_supplied"] 	= { value = 1000, desc = "supplying a farp with groundcrew" },	-- bonus on top of supplying base!
	["crate_deployed"] 				= { value = 1000, desc = "deploying a unit in the wild" },
	["rearmed_sam"] 				= { value = 1000, desc = "rearming a SAM" },
	["repaired_sam"] 				= { value = 1000, desc = "reparing a SAM" },
	
	-- CSAR
	["pilot_rescued"] 				= { value = 1000, desc = nil },
	["pilot_captured"] 				= { value = 2000, desc = nil },
	["csar_friendly_pickup"] 		= { value = 250, desc = "picking up an ejected pilot" },
	["csar_enemy_pickup"] 			= { value = 500, desc = "picking up an enemy pilot" },
	
	-- convoy
	["defensive_convoy_deployed"] 	= { value = 0, desc = "deploying a defensive convoy" },
	["groundcrew_convoy_deployed"] 	= { value = 0, desc = "deploying a groundcrew convoy" },
	["offensive_convoy_deployed"] 	= { value = 0, desc = "deploying a offensive convoy" },
}

local unitCategoryTable = {
	[0] = "AIRPLANE",
	[1] = "HELICOPTER",
	[2] = "GROUND_UNIT",
	[3] = "SHIP",
	[4] = "STRUCTURE",
}

-- setup score logfile
koScoreBoard.scoreLogFile = io.open(lfs.writedir()..[[Missions\\The Kaukasus Offensive\\scores.log]], "w")
function koScoreBoard.log(txt)
	if koScoreBoard.scoreLogFile then
	 	koScoreBoard.scoreLogFile:write(string.format("%09.3f", tostring(timer.getTime())).."\t"..txt.."\n")
	    koScoreBoard.scoreLogFile:flush()
    else
    	env.info("koScoreBoard.log() - LOG FAILED")
    end
end

function koScoreBoard.loadScoreBoardFile()
	env.info("koScoreBoard.loadScoreBoardFile()")
	
	local dataLoader = loadfile(KI.Config.PathScores)
	if dataLoader ~= nil then		-- File open?
		--env.info(" - success!")
		koScoreBoard.ScoreBoard = dataLoader()
	else
		env.info("Scoreboard not found! Starting from scratch")
		koScoreBoard.ScoreBoard = {}
	end
end

function koScoreBoard.loadScoreID()
	local dataLoader = loadfile(KI.Config.PathScoreID)
	if dataLoader ~= nil then		-- File open?
		koScoreBoard.scoreID = dataLoader()
		env.info("current ScoreID: "..koScoreBoard.scoreID.." loaded!")
	else
		env.info("Score ID not found, starting at ID=0")
		koScoreBoard.scoreID = 0
	end
end


function koScoreBoard.save()
	env.info("koScoreBoard.save()")
	-- save the scoreboard to a separate file!
	local exportData = "local t = " .. KI.Toolbox.SerializeTable(koScoreBoard.ScoreBoard) .. "return t"
	local exportFile = assert(io.open(KI.Config.PathScores, "w"))
	exportFile:write(exportData)
	exportFile:flush()
	exportFile:close()
	exportFile = nil
	
	koScoreBoard.saveSorties()
	
	env.info("Scoreboard Saved")
end

function koScoreBoard.saveSingleScore(scoreTable, scoreID)
	env.info("koScoreBoard.saveSingleScore()")
	-- save the scoreboard to a separate file!
	local exportData = "local t = " .. kKI.Toolbox.SerializeTable(scoreTable) .. "return t"
	local exportFile = assert(io.open(KI.Config.PathScores2..scoreID..".lua", "w"))
	exportFile:write(exportData)
	exportFile:flush()
	exportFile:close()
	exportFile = nil
	
	koScoreBoard.saveSorties()
	
	env.info("Scoreboard Saved")
end

function koScoreBoard.saveScoreID()
	local exportData = "return "..koScoreBoard.scoreID
	local exportFile = assert(io.open(KI.Config.PathScoreID, "w"))
	exportFile:write(exportData)
	exportFile:flush()
	exportFile:close()
	exportFile = nil
	
	env.info("ScoreID Saved")
end

function koScoreBoard.loadSortiesFile()
	env.info("koScoreBoard.loadSortiesFile()")
	
	local dataLoader = loadfile(KI.Config.PathSorties)
	if dataLoader ~= nil then		-- File open?
		--env.info(" - success!")
		koScoreBoard.activeSorties = dataLoader()
	else
		env.info("Sorties not found! Starting from scratch")
		koScoreBoard.activeSorties = {}
	end
end

function koScoreBoard.saveSorties()
	local exportData = "local t = " .. KI.Toolbox.SerializeTable(koScoreBoard.activeSorties) .. "return t"
	local exportFile = assert(io.open(KI.Config.PathSorties, "w"))
	exportFile:write(exportData)
	exportFile:flush()
	exportFile:close()
	exportFile = nil
	
	env.info("Sorties Saved")
end

function koScoreBoard.getScoreBoardForPlayer(playerName)
	local playerUcid = KI.MP.GetPlayerUCID(playerName)
	
	koScoreBoard.loadScoreBoardFile()
	koScoreBoard.ScoreBoard[playerUcid] = koScoreBoard.ScoreBoard[playerUcid] or {}
		
	return koScoreBoard.ScoreBoard[playerUcid]
end

function koScoreBoard.insertScoreForPlayer(playerName, newScore)
	env.info("koScoreBoard.insertScoreForPlayer("..playerName..", "..newScore.achievment..")")
	koScoreBoard.loadScoreID()
	koScoreBoard.scoreID = koScoreBoard.scoreID + 1
	newScore.scoreID = koScoreBoard.scoreID
	newScore.sessionID = KI.Config.SessionID
	newScore.timer = timer.getTime()
	
	-- TODO Hand out some cash!
	env.info("hand out some cash")
	if newScore.achievment ~= "landing" then	-- landing will get cash per flight minute in calcAirTimeForSortie()!
		local achievment = newScore.achievment
		
		if achievment == "kill" then
			if newScore.unitCategory == "AIRPLANE" and newScore.targetCategory == "AIRPLANE" then
				local unitName = newScore.targetUnitName
				-- fighter
				if unitName:find("CAP") or unitName:find("Intercept") or unitName:find("Escort") then
					achievment = "kill_fighter"
				-- striker
				elseif unitName:find("CAS") or unitName:find("SEAD") then 
					achievment = "kill_striker"				
				-- user joined a Helicopter  	
				elseif unitName:find("Transport") or unitName:find("Attack") then
					achievment = "kill_helicopter"
				end
			
			elseif newScore.unitCategory == "DEPLOYED" then
				achievment = "kill_ground2air"
				
			elseif newScore.unitCategory == "AIRPLANE" and newScore.targetCategory == "GROUND_UNIT" then
				achievment = "kill_ground"
				
			elseif newScore.unitCategory == "GOUND_UNIT" and newScore.targetCategory == "GROUND_UNIT" then
				achievment = "kill_ground2ground"
			end
			
			env.info("converted kill event to "..achievment)
		end
		local cash = koScoreBoard.cashForAchievement[achievment]
		
		env.info("cash = "..KI.Toolbox.SerializeTable(cash))
		if cash and cash.value > 0 then
			env.info("adding "..cash.value.."$ to '"..playerName.."s' wallet")
			koScoreBoard.addCashToPlayer(playerName, cash.value, cash.desc)
		end
	end
	
	if newScore.achievment ~= "sortie" then
		-- koScoreBoard.linkToSortie(playerName, newScore)
		local sortie = koScoreBoard.getActiveSortie(playerName)
		if sortie then
			env.info("linking score to sortie "..sortie.ID)
			--sortie.achievments[newScore.achievment] =  sortie.achievments[newScore.achievment] or {}
			
			newScore.sortieID = sortie.ID
			
			-- calculate airtime for landings
			if newScore.achievment == "takeoff" then
				sortie.status = "airborne"
			elseif newScore.achievment == "landing" then
				env.info("player hast to have been airborne after landing, calculating airtime")
				sortie.status = "landed"
				koScoreBoard.calcAirTimeForSortie(sortie, newScore.timer)
			elseif newScore.achievment == "emergencylanding" then
				env.info("player hast to have been airborne after emergencylandingAirborne, calculating airtime")
				sortie.status = "emergencylanded"
				koScoreBoard.calcAirTimeForSortie(sortie, newScore.timer)
			elseif newScore.achievment == "crashed" then
				if sortie.status == "airborne" then
					env.info("player was Airborne, calculating airtime")
					koScoreBoard.calcAirTimeForSortie(sortie, newScore.timer)
				end
				sortie.status = "crashed"
				sortie.hasCrashed = true
			elseif newScore.achievment == "ejected" then
				koScoreBoard.calcAirTimeForSortie(sortie, newScore.timer)
				sortie.status = "ejected"
				sortie.hasEjected = true
			elseif newScore.achievment == "died" then
				if sortie.status == "airborne" then
					env.info("player was Airborne, calculating airtime")
					koScoreBoard.calcAirTimeForSortie(sortie, newScore.timer)
				end
				sortie.status = "dead"
				sortie.hasDied = true
			end
			
			table.insert(sortie.achievments, newScore)
		--else
			--env.info("insertScoreForPlayer: no active sortie for "..playerName..", cannot insert score "..newScore.achievment.." into sortie")
		end
	end
	
	env.info("inserting score for '"..playerName.."' - achievment = "..newScore.achievment)
	--table.insert(koScoreBoard.getScoreBoardForPlayer(playerName), newScore)
	--koScoreBoard.save()
	koScoreBoard.log("dispatching score: "..newScore.scoreID)
	local scoreToSave = {}
	scoreToSave[KI.MP.GetPlayerUCID(playerName)] = newScore
	koScoreBoard.saveSingleScore(scoreToSave, newScore.scoreID)
	koScoreBoard.saveScoreID()
	koTCPSocket.send(scoreToSave, "Score")
end


-- calculates the airtime of the last flight (from last takeoff till last score or endtime) 
function koScoreBoard.calcAirTimeForSortie(sortie, endTime) 
	if #sortie.achievments == 0 then
		env.info("koScoreboard.calcAirTimeForSortie() - no takeoff for sortie, not calculating airtime")
		return
	end
	
	-- if no endTime is supplied, use the last known time the player saved a score
	if not endTime then
		env.info("koScoreboard.calcAirTimeForSortie() - using last score.timer for endTime!")
		endTime = sortie.achievments[#sortie.achievments].timer
	end
	
	env.info("koScoreboard.calcAirTimeForSortie(endTime = "..endTime..")")
	
	local scoreIdx = #sortie.achievments
	
	--env.info("scoreIdx = "..scoreIdx)
	--env.info("sortie.achievments = "..KI.Toolbox.SerializeTable(sortie.achievments))
	--env.info("init: sortie.achievments[scoreIdx] = "..sortie.achievments[scoreIdx].achievment)
	
	while sortie.achievments[scoreIdx].achievment ~= "takeoff" do
		--env.info("idx: "..scoreIdx..", achievment: "..sortie.achievments[scoreIdx].achievment..", reducing index")
		scoreIdx = scoreIdx - 1
		if scoreIdx <=  0 then break end
	end
	
	env.info("takeoff scoreIndex = "..scoreIdx)
	
	local takeoff = sortie.achievments[scoreIdx]
	if takeoff and takeoff.achievment == "takeoff" then
		local newAirTime = endTime - takeoff.timer		-- latest airtime in seconds
		sortie.airTime = sortie.airTime + newAirTime
		env.info(" - airTime = "..sortie.airTime.." of which are new: "..newAirTime)
		
		-- hand out some cash for landings:
		 if sortie.status == "landed" or sortie.status == "emergencylanded" then
			local newAirtimeMinutes = math.floor(newAirTime/60)
			local cashReward = newAirtimeMinutes * koScoreBoard.cashForAchievement['landing'].value
			if cashReward > 0 then
				koScoreBoard.addCashToPlayer(sortie.playerName, cashReward, newAirtimeMinutes.." Minutes of Airtime")
			end
		end
	else
		env.info("koScoreboard: FATAL ERROR - no takeoff event in sortie, can't close it")
	end
end

function koScoreBoard.newSortie(playerName)
	env.info("koScoreBoard.newSortie("..playerName..")")
	
	-- load sortieID
	DataLoader = loadfile(KI.Config.PathSortieID)
	if DataLoader ~= nil then		-- File open?
		koScoreBoard.sortieID = DataLoader()
		koScoreBoard.sortieID = koScoreBoard.sortieID + 1
		env.info("current sortieID: "..koScoreBoard.sortieID.." loaded!")
	else
		env.info("sortieID not found, starting at ID=0")
		koScoreBoard.sortieID = 0
	end

	local exportFile = assert(io.open(KI.Config.PathSortieID, "w"))
	exportFile:write("return "..koScoreBoard.sortieID)
	exportFile:flush()
	exportFile:close()
	exportFile = nil
	
	env.info("sortieID Saved")
	
	-- create sortie
	local playerUCID = KI.MP.GetPlayerUCID(playerName)
	if playerUCID then
		koScoreBoard.activeSorties[playerUCID] = {
			achievment = "sortie",
			playerName = playerName, 
			playerUCID = playerUCID,
			ID = koScoreBoard.sortieID,
			sessionID = KI.Config.SessionID,
			status = "just spawned",
			airTime = 0,
			achievments = {},
		}
		return koScoreBoard.activeSorties[playerUCID]
	else
		env.info("koScoreBoard.newSortie: no UCID for playerName '"..playerName.."'")
		return nil
	end
end

function koScoreBoard.getActiveSortie(playerName)
	return koScoreBoard.activeSorties[KI.MP.GetPlayerUCID(playerName)]
end

function koScoreBoard.closeSortie(playerName, _reason)
	env.info("koScoreboard.closeSortie() - closing sortie for '"..playerName)
	local sortie = koScoreBoard.getActiveSortie(playerName)
	if sortie and sortie.status ~= "closed" then
		local endReason = _reason or "undetermined"
		
		-- check if the player has even taken off, no takeoff = no sortie to close
		
		-- if there was a landing we assume endreason is a landing, before we check crash/ejection/death
		if sortie.status == "landed" then
			endReason = "landed"
		elseif sortie.status == "emergencylanded" then
			endReason = "emergencylanded"
		elseif sortie.status == "airborne" and not _reason then
			endReason = "respawn"
			--koScoreBoard.calcAirTimeForSortie(sortie,timer.getTime())  -- if you respawn in flight you're not getting airtime for the sortie
		elseif endReason == "Mission End" then
			sortie.status = "missionEnd"
			koScoreBoard.calcAirTimeForSortie(sortie, timer.getTime())
		else
			env.info("sortie endReason is undetermined, not landed, not emergencylanded and was not airborne")
		end
		
		if sortie.status == "airborne" and (endReason == "disconnected" or endReason == "returned_to_specators") then
			env.info("user has "..endReason..", calculating airtime")
			koScoreBoard.calcAirTimeForSortie(sortie)
		end
		
		-- find the endreason:
		local scoreIdx = #sortie.achievments
	
		-- loop through all scores in reverse order to determine endReason
		local hasTakenOff = false
		while sortie.achievments[scoreIdx] do
			if sortie.achievments[scoreIdx].achievment == "takeoff" then
				hasTakenOff = true
			end
				
			if sortie.achievments[scoreIdx].achievment == "washit" then
				sortie.droppedUnit = "wasHit"
			
				
			elseif sortie.achievments[scoreIdx].achievment == "ejected" then
				endReason = "ejected"
				
				if not sortie.hasCrashed then	-- if there is no crash score but an ejection score add a crashed score
					env.info("found an ejection without a crash, adding the crash to the scoreboard!")
					local newScore = mist.utils.deepCopy(sortie.achievments[scoreIdx])
					newScore.achievment = "crashed"
					koScoreBoard.insertScoreForPlayer(playerName,newScore)
				end
				
			elseif sortie.achievments[scoreIdx].achievment == "died" then
				endReason = "died"
				
				if not sortie.hasCrashed then	-- if there is no crash score but a died score add a crashed score
					env.info("found a death without a crash, adding the crash to the scoreboard!")
					local newScore = mist.utils.deepCopy(sortie.achievments[scoreIdx])
					newScore.achievment = "crashed"
					koScoreBoard.insertScoreForPlayer(playerName,newScore)
				end		
							
			elseif sortie.achievments[scoreIdx].achievment == "crashed" then
				endReason = "crashed"
			end
		
			env.info("idx: "..scoreIdx..", achievment: "..sortie.achievments[scoreIdx].achievment..", reducing index")
			scoreIdx = scoreIdx - 1
			if scoreIdx <=  0 then break end
		end
		
		-- only save the sortie if there was a takeoff (sortie started with takeoff)
		if hasTakenOff then
			env.info("Player had taken off: closing sortie: "..sortie.ID..", endReason = "..endReason)
			sortie.status = "closed"
			sortie.endTime = timer.getTime()
			sortie.endReason = endReason
			koScoreBoard.insertScoreForPlayer(sortie.playerName, sortie)
		end
		
		koScoreBoard.activeSorties[sortie.playerUCID] = nil
		koScoreBoard.saveSorties()
		
		env.info("end closing sortie")
	else
		env.info("- no active sortie active for player, using id -1")
	end
end


function koScoreBoard.getCashcountForPlayer(playerName)
	return MissionData.properties.cashPile[KI.MP.GetPlayerUCID(playerName)] or 0
end

function koScoreBoard.addCashToPlayer(playerName, cash, reason)
	env.info("koScoreBoard.addCashToPlayer("..playerName..", "..cash..")")
	
	local playerUCID = KI.MP.GetPlayerUCID(playerName)
	MissionData.properties.cashPile[playerUCID] = MissionData.properties.cashPile[playerUCID] or 0
	MissionData.properties.cashPile[playerUCID] = MissionData.properties.cashPile[playerUCID] + cash
	env.info("added "..cash.." cash to Player "..playerName)
	
	-- if a reason is supplied issue a message to the player who got cash
	if reason then
		local msg = "_______________________________________________________________________________________________________\n\n"
		msg = msg.."  You received "..format_num(cash).."$  for "..reason
	
		msg = msg.."\n\n  You now have "..format_num(MissionData.properties.cashPile[playerUCID]).."$ in your wallet!\n"
		msg = msg.."_______________________________________________________________________________________________________\n"
		
		local groupID = false
		for gID, playerTable in pairs(KI.MP.PlayerUnitList) do
			if playerTable.playerName == playerName then
				groupID = gID
			end
		end
		
		if groupID then	trigger.action.outTextForGroup(groupID, msg, 15) end
	end 
end

-- returns the amount of cash left, nil if not enough cash are available
function koScoreBoard.deductCashFromPlayer(playerName, cash)
	env.info("koScoreBoard.deductCashFromPlayer("..playerName..", "..cash..")")
	
	local playerUCID = KI.MP.GetPlayerUCID(playerName)
	
	MissionData.properties.cashPile[playerUCID] = MissionData.properties.cashPile[playerUCID] or 0
	
	if MissionData.properties.cashPile[playerUCID] > cash then
		MissionData.properties.cashPile[playerUCID] = MissionData.properties.cashPile[playerUCID] - cash
		env.info("deducted "..cash.." cash from Player "..playerName)
		return MissionData.properties.cashPile[playerUCID]
	else
		env.info(playerName.." has only "..MissionData.properties.cashPile[playerUCID].." cash, not enough to deduct "..cash.." cash")
		return nil
	end
end




function koScoreBoard.main()
	--env.info("koScoreBoard.main()")
	
	-- cleanup recent hits, keep them for 2 minutes
	for victimName, times in pairs(koScoreBoard.recentHits) do
		for time, hit in pairs(times) do
			if (timer.getTime() - hit.timer) > 120 then	
				koScoreBoard.recentHits[victimName][time] = nil
			end
		end
	end
	
	-- cleanup recent shots, keep them for 2 minutes
	for victimName, times in pairs(koScoreBoard.recentShots) do
		for time, shot in pairs(times) do
			if (timer.getTime() - shot.timer) > 120 then	
				koScoreBoard.recentShots[victimName][time] = nil
			end
		end
	end
	
	-- load kills from client side
	local newScores = {}
	
	-- check if we receive killmessage from GameGui
	local received = koEngine.UDPGameGuiReceiveSocket:receive()
	
	while received do
		env.info("koScoreBoard.main(): Message from GameGui received")
		local newScore = koEngine.JSON:decode(received)
	    if newScore then
	    	env.info("received: "..KI.Toolbox.SerializeTable(newScore))
	    	table.insert(newScores,newScore)
		end
	
		received = koEngine.UDPGameGuiReceiveSocket:receive()
	end
	
	-- if there's new kill score.
	if newScores and #newScores > 0 then
		env.info("found "..#newScores.." new scores")
		for i, score in pairs(newScores) do
			if (score.achievment == "returned_to_specators" or score.achievment == "connected" or score.achievment == "disconnected")
				and score.playerName and score.playerName ~= "" then
				env.info(i..": "..score.playerName.." was "..score.achievment.."!")

				local newScore = {
					achievment = score.achievment,
					killerName = score.playerName,
					unitType = score.playerUnit,
					unitName = "GameGui",
					side = score.playerSide,
					airTime = score.onlineTime,
				}
				
				koScoreBoard.insertScoreForPlayer(score.playerName, newScore)
				koScoreBoard.closeSortie(score.playerName, score.achievment)
				
			elseif score.achievment == "kill" then
				env.info(i..": "..score.killerName.." has "..score.achievment.."ed "..score.victimName)
				
				local newScore = {
					achievment = score.achievment,
					unitType = score.killerUnit,
					killerName = score.killerName,
					side = score.killerSide,
					--unitName = playerUnitName,
					targetName = score.victimName,
					targetType = score.victimUnit,
					targetSide = score.victimSide,
					weapon = score.weaponName,
					modelTime = score.modelTime,
					timestamp = score.realTime,
					missionTime = timer.getTime(),
					unitName = "unknown",
				}
				local killerName = score.killerName
				
				if score.killerName ~= "AI" then
					env.info("Not AI: looking for hit that lead to the kill")
					-- now look for the last hit on the target to get all the additional info the killmessage on the serverside does not provid
					if koScoreBoard.recentHits[score.victimName] then
						local shortestDelay = math.huge
						local shortestDelayHit = false
						
						for time, hit in pairs(koScoreBoard.recentHits[score.victimName]) do	-- go through the recent hits table whre we store every hit by victimName
							env.info("checking hit.targetName ("..hit.targetName..") for score.victimName("..score.victimName..")")
							if hit.targetName == score.victimName then						-- only look for those who share the same victim
								env.info("we found a hit with matching target and victimnames!")
								
								local delay = (score.modelTime - hit.timer)
								env.info("delay = "..delay)
								if delay < shortestDelay then	-- not the newest hit
									env.info("this was the shortest delay so far")
									shortestDelay = delay
									shortestDelayHit = hit
								end
							end
						end
						
						if shortestDelayHit then
							newScore.unitName = shortestDelayHit.unitName 
							newScore.unitCategory = shortestDelayHit.unitCategory
							newScore.targetCategory = shortestDelayHit.targetCategory
							newScore.targetUnitName = shortestDelayHit.targetUnitName
							if newScore.weapon == '' then
								env.info("added missing weapon to kill! "..shortestDelayHit.weapon)
								--TODO 
								newScore.weapon = shortestDelayHit.weapon
							end
							
							-- sanitise MATRA against S530D and Magic II
							if newScore.weapon == "MATRA" then
								env.info("detected a MATRA missile, checking guidance: "..shortestDelayHit.weaponGuidance)
								if shortestDelayHit.weaponGuidance == 2 then -- if IR
									newScore.weapon = "Matra Magic II"
								else
									newScore.weapon = "Matra S530D"
								end
							end		
						
							newScore.weaponCategory = shortestDelayHit.weaponCategory
							newScore.weaponMissileCategory = shortestDelayHit.weaponMissileCategory
							newScore.weaponGuidance = shortestDelayHit.weaponGuidance					
							
							env.info("Found additional details for kill!")
						else
							env.info("did not find additional details for the kill")
						end
					else
						env.info("did not find a hit for the victim")
					end
				end
				
				
				
				---------------------------------------------
				-- check if it was a player-deployed-SAM kill
				if score.killerName == "AI" and koScoreBoard.recentHits[score.victimName] then
					env.info("killed by AI, checking recent hits the victim has taken")
					-- we need to check if it was a player deployed SAM
					local shortestDelay = math.huge
					local shortestDelaySAM = false
					local shortestDelaySAMdelay = math.huge
					local shortestDelayHit = false
					
					env.info("recent hits: "..KI.Toolbox.SerializeTable(koScoreBoard.recentHits))
					
					--env.info("checking "..#koScoreBoard.recentHits[score.victimName].." hits")
					for time, hit in pairs(koScoreBoard.recentHits[score.victimName]) do	-- go through the recent hits table whre we store every hit by victimName
						
						env.info("checking hit for victim: hit.targetName = "..hit.targetName..", score.victimName = "..score.victimName)
						if hit.targetName == score.victimName then	-- only look for those who share the same victim
							env.info("we found a hit with matching target and victimnames!")
							
							local delay = score.modelTime - hit.timer 
							if delay<0 then delay = delay*(-1) end
							
							env.info("delay = "..delay)
							
							if delay < shortestDelay then	-- the newest hit
								env.info("shortest delay so far, trying to find a matching player deployed unit")
								shortestDelay = delay
								shortestDelayHit = hit
								
								-- cycle through dropped SAMs
								for i, sam in pairs(MissionData.properties.droppedSAMs) do 		-- find the SAM in the saveGame
									for j, unit in pairs(sam.groupSpawnTable.units) do 			-- check if the sam matches 
										if unit.name == hit.unitName then						-- yes it does
											-- we found a possible sam! 
											env.info("we found a matching SAM! Player "..sam.playerName.."has placed the sam!")
											shortestDelaySAM = sam
											shortestDelaySAMdelay = delay -- ugly but necessary to check if the sam is valid
										end 
									end					
								end
								
								-- cycle through convoys on the move
								for i, convoy in pairs(MissionData.properties.spawnedConvoys) do 		-- find the SAM in the saveGame
									for j, unit in pairs(convoy.units) do 			-- check if the sam matches 
										if unit.name == hit.unitName and convoy.playerName then						-- yes it does
											-- we found a possible sam! 
											env.info("we found a matching SAM in convoys! Player "..convoy.playerName.."has requested the convoy!")
											shortestDelaySAM = convoy
											shortestDelaySAMdelay = delay -- ugly but necessary to check if the sam is valid
										end 
									end
								end
								
								-- cycle through objectives
								-- check objective groups
								for categoryName, categoryTable in pairs(MissionData) do
									if type(categoryTable) == "table" and categoryName ~= "properties" then
										for objectiveName, objectiveTable in pairs(categoryTable) do
											for groupName, groupTable in pairs (objectiveTable.groups) do
												for i, unit in pairs(groupTable.units) do
													--env.info("comparing unit.name '"..unit.name.."' with hit.unitName '"..hit.unitName.."'")
													if unit.name == hit.unitName and groupTable.playerName then
														-- we found a possible sam! 
														env.info("we found a matching SAM in Objectivedata! Player "..groupTable.playerName.."has placed the sam!")
														shortestDelaySAM = groupTable
														shortestDelaySAMdelay = delay -- ugly but necessary to check if the sam is valid
													end
												end
											end
										end
									end
								end
							end		
						end
					end
					
					-- check if we found a player deployed sam!
					if shortestDelayHit then
						env.info("found a hit belonging to an AI kill, filling up missing info")
						newScore.targetCategory = shortestDelayHit.targetCategory
						newScore.targetUnitName = shortestDelayHit.targetUnitName
						newScore.weapon = shortestDelayHit.weapon
						newScore.weaponCategory = shortestDelayHit.weaponCategory
						newScore.weaponMissileCategory = shortestDelayHit.weaponMissileCategory
						newScore.weaponGuidance = shortestDelayHit.weaponGuidance
						newScore.unitName = shortestDelayHit.unitName
						newScore.unitCategory = shortestDelayHit.unitCategory
					end 
					 
					if shortestDelaySAM and shortestDelaySAMdelay == shortestDelay then
						env.info("we found a player deployed sam!")
						newScore.unitCategory = "DEPLOYED";
						killerName = shortestDelaySAM.playerName
						trigger.action.outText("("..string.upper(newScore.side)..") Player '"..killerName.."' has killed ("..string.upper(newScore.targetSide)..") '"..newScore.targetName.."' in '"..newScore.targetType.."' with a '"..newScore.unitType.."' he deployed with a '"..shortestDelaySAM.playerType.."'", 25)
					else
						trigger.action.outText("("..string.upper(newScore.side)..") '"..killerName.."' has killed ("..string.upper(newScore.targetSide)..") '"..newScore.targetName.."' in '"..newScore.targetType.."' with '"..newScore.unitType.."'", 25)
					end
				else
					-- not AI Kill
					if newScore.side == newScore.targetSide then
						if newScore.targetName == newScore.killerName then
							trigger.action.outText("("..string.upper(newScore.side)..") "..killerName.."' in '"..newScore.unitType.."' has killed himself with '"..newScore.weapon.."'", 25)
							newScore.achievment = "selfkill"
						else
							trigger.action.outText("- TEAMKILL! -\n\n("..string.upper(newScore.side)..") "..killerName.."' in '"..newScore.unitType.."' has teamkilled ("..string.upper(newScore.targetSide)..") '"..newScore.targetName.."' in '"..newScore.targetType.."' with '"..newScore.weapon.."'", 25)
							newScore.achievment = "teamkill"
						end
					else
						trigger.action.outText("("..string.upper(newScore.side)..") "..killerName.."' in '"..newScore.unitType.."' has killed ("..string.upper(newScore.targetSide)..") '"..newScore.targetName.."' in '"..newScore.targetType.."' with '"..newScore.weapon.."'", 25)
					end
					
				end
							
				--env.info("inserting kill score for "..killerName..", he killed "..newScore.targetName)
				koScoreBoard.insertScoreForPlayer(killerName, newScore)
			end
		end
		
		--[[env.info("deleting file")
		local exportFile = assert(io.open(koScoreBoard.eventFileName, 'w'))
		exportFile:write("")
		exportFile:flush()
		exportFile:close()
		exportFile = nil--]]
	else
		--env.info("no scores to check")	
	end
	
	koScoreBoard.lastMainLoop = timer.getTime()
	mist.scheduleFunction(koScoreBoard.main, {}, timer.getTime() + koScoreBoard.loopFreq)
end

--CiriBob's get groupID function
function getGroupId(_unit)
	local _unitDB =  mist.DBs.unitsById[tonumber(_unit:getID())]
    if _unitDB ~= nil and _unitDB.groupId then
        return _unitDB.groupId
    end

    return nil
end

koScoreBoard.eventHandler = {}
function koScoreBoard.eventHandler:onEvent(event)
	--env.info("koScoreBoard.eventHandler("..eventTable[event.id]..")"..tostring(event.id), 1)
	
	if 	event.id == world.event.S_EVENT_PLAYER_LEAVE_UNIT or event.id == world.event.S_EVENT_BASE_CAPTURED then
		return
	end
	
	if event.initiator then
		env.info("koScoreBoard.eventHandler("..eventTable[event.id]..")"..tostring(event.id), 1)	
		--env.info(KI.Toolbox.SerializeTable(event))
		
		env.info("finding player Name")
		--create vars
		local playerName
		local initiatorCategory = Object.getCategory(event.initiator)
		if initiatorCategory == Object.Category.UNIT then 
			playerName = event.initiator:getPlayerName() or "AI"
		elseif initiatorCategory == Object.Category.STATIC then
			playerName = "Static Object"
			env.info("initiator is Static Object")
			return
		elseif initiatorCategory == Object.Category.BASE then
			playerName = "Airbase Object"
			env.info("initiator is Base Object")
			return
		else
			playerName = "unknown object"
			env.info("initiator exception: category = "..tostring(initiatorCategory))
			return
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
		
		env.info("playerName = "..tostring(playerName))
		
		local playerUCID = KI.MP.GetPlayerUCID(playerName)
		local playerUnitName = event.initiator:getName() or "invalid"
		local coalition = coalitionTable[event.initiator:getCoalition()]
		
		if event.id == world.event.S_EVENT_SHOOTING_END then
			env.info("S_EVENT_SHOOTING_END")
			
			--env.info("event = "..KI.Toolbox.SerializeTable(event))			
		end
		
		--------------------------------------
		--	SHOOTING_START event
		--  Occurs whenever an object is hit by a weapon.
		--  is going to be recorded regardless AI or not
		--[[
			event = {
			  id = 2,
			  time = Time,
			  initiator = Unit,
			  weapon = Weapon
			  target = Object
			}
		--]]  
		if event.id == world.event.S_EVENT_SHOOTING_START then
			env.info("S_EVENT_SHOOTING_START")
					
			local weapon = "Cannon"
			if event.weapon then
				local weaponTable = Weapon.getDesc(event.weapon)
				weapon = weaponTable.displayName
			end
			
			
			-- #chopperscoresmatter
			local newScore = {
				unitCategory = unitCategoryTable[event.initiator:getDesc().category],
				unitType = event.initiator:getTypeName(),
				unitName = playerUnitName,
				achievment = "shot",
				timestamp = event.time,
				weapon = weapon,
				weaponCategory = "shell",
				weaponMissileCategory = "none",
				weaponGuidance = "none",
				playerName = playerName,
				side = coalition,
			}
			koScoreBoard.insertScoreForPlayer(playerName, newScore)
			koScoreBoard.recentShots[playerUnitName] = koScoreBoard.recentShots[playerUnitName] or {}
			koScoreBoard.recentShots[playerUnitName][event.time] = newScore
			
			
		end

		--------------------------------------
		--	HIT event
		--  Occurs whenever an object is hit by a weapon.
		--  is going to be recorded regardless AI or not
		--[[
			event = {
			  id = 2,
			  time = Time,
			  initiator = Unit,
			  weapon = Weapon
			  target = Object
			}
		--]]  
		if event.id == world.event.S_EVENT_HIT then
			env.info("S_EVENT_HIT")
			
			--env.info("weaponDesc = "..KI.Toolbox.SerializeTable(Weapon.getDesc(event.weapon)))
		
			
			if not event.weapon then
				env.info("hit event without weapon is strange (BUG)")
				--env.info("no-weapon event: "..KI.Toolbox.SerializeTable(event))
				--return
			end
			
			if not event.target and not Weapon.getTarget(event.weapon) then
				env.info("hit event without target is strange (BUG)")
				--env.info("no-target event: "..KI.Toolbox.SerializeTable(event))
				--return
			end

			
			-- check if it was a collision
			if event.weapon == event.initiator then
				--	check if collision is valid
				--  one collision message is enough! -- borrowed from Ciribobs CSAR huey double ejection - genious!
				local _name = KI.MP.GetPlayerNameFix(event.initiator:getPlayerName() or "AI")
				
	            local _time = koScoreBoard.lastCollisions[_name]	
	            
				if _time ~= nil and timer.getTime() - _time < 5 then
	                env.info("Ignore! double collision")
	                koScoreBoard.lastCollisions[_name] = timer.getTime()
	                return
	            end	
	
	            koScoreBoard.lastCollisions[_name] = timer.getTime()
	            
				--TODO 
				trigger.action.outText((event.initiator:getPlayerName() or "AI").." ("..event.initiator:getTypeName()") collided with "..(event.target:getPlayerName() or "AI ("..event.initiator:getTypeName()")"))
				
				-- choppers deserve a score!
				local newScore = {
					unitCategory = unitCategoryTable[event.initiator:getDesc().category],
					unitType = event.initiator:getTypeName(),
					unitName = playerUnitName,
					achievment = "collided",
					timestamp = event.time,
					targetName = event.target:getPlayerName() or "AI",
					targetUnitName = event.target:getName() or "error in collision",
					targetType = event.target:getTypeName() or "error in collision",
					targetCategory = unitCategoryTable[target:getDesc().category] or "error in collision",
					side = coalition,
				}
				koScoreBoard.insertScoreForPlayer(event.initiator:getPlayerName() or "AI", newScore)
				return
			end
			
			--------------------------
	        -- now handle the hit
	        -- 
	        --env.info("weapon hit confirmed, event: "..KI.Toolbox.SerializeTable(event))
	       -- env.info("initiator: "..event.initiator:getName())
	        
	        local weapon = "unknown"
	        if event.weapon then
	        	env.info("valid weapon supplied with hit-event.")
				weapon = Weapon.getDesc(event.weapon)
				weapon.category = weaponCategory[weapon.category]
				weapon.missileCategory = weaponMissileCategory[weapon.weaponMissileCategory]
				
				-- sanitise MATRA against S530D and Magic II
				if weapon.displayName == "MATRA" then
					env.info("detected a MATRA missile, checking guidance: "..weapon.guidance)
					if weapon.guidance == 2 then -- if IR
						weapon.displayName = "Matra Magic II"
					else
						weapon.displayName = "Matra S530D"
					end
				end		
			else
				-- lets check if a recent shot matches
				--env.info("recentShots: "..KI.Toolbox.SerializeTable(koScoreBoard.recentShots))
				if koScoreBoard.recentShots[playerUnitName] then
					local shortestDelay = math.huge
					local shortestDelayShot = false
					for time, shot in pairs(koScoreBoard.recentShots[playerUnitName]) do 
						--env.info("checking shot: "..KI.Toolbox.SerializeTable(shot))
						if shot.unitName == playerUnitName then
							local delay = timer.getTime() - shot.timer
						
							--env.info("delay = "..delay)
							
							if delay < shortestDelay then	-- the newest hit
								shortestDelay = delay
								shortestDelayShot = shot
							end
						end
					end
					
					
					-- we found the missing weapon in the last shot fired by the iniator!
					if shortestDelayShot then
						--env.info("found the missing weapon in the shot table")
						weapon = { 
							displayName = shortestDelayShot.weapon,
							category = shortestDelayShot.weaponCategory,
							missileCategory = shortestDelayShot.weaponMissileCategory,
							guidance = shortestDelayShot.weaponGuidance,
						}
					else 
						env.info("Did not find the missing weapon in the shot table")
					end
				else
					env.info("no recent shots for playerUnitName "..playerUnitName.."...")
				end
			end
			
			--env.info("checked weapon: "..KI.Toolbox.SerializeTable(weapon))
			
			
			local target = event.target
			local targetName = "no target"
			local targetType = "no target"
			local targetCategory = "unkown"
			local targetSide = "unknown"
			local targetUnitName = "unkown"
			
			if target and Object.getCategory(target) == Object.Category.UNIT then 
				--env.info("Object.getCategory(target) == Object.Category.UNIT")
				targetName = target:getPlayerName() or "AI" 
				targetUnitName = target:getName()
				targetType = target:getTypeName()
				targetSide = coalitionTable[target:getCoalition()]
				targetCategory = unitCategoryTable[target:getDesc().category];
			elseif target and Object.getCategory(target) == Object.Category.STATIC then
				--env.info("Object.getCategory(target) == Object.Category.STATIC")
				targetName = "Static Object"
				targetUnitName = target:getName()
				targetType = target:getTypeName()
				targetCategory = "STATIC"
			--elseif target then
				--env.info("exception: category = "..tostring(Object.getCategory(target)))
			--else
				--env.info("target = nil")
			end	
			
			if targetName == "no target" and targetSide == "unknown" then
				return
			end
			
			if playerName == "AI" then
				-- search for player deployed sams
				-- cycle through dropped SAMs
				for i, sam in pairs(MissionData.properties.droppedSAMs) do 		-- find the SAM in the saveGame
					for j, unit in pairs(sam.groupSpawnTable.units) do 			-- check if the sam matches 
						if unit.name == event.initiator:getName() then						-- yes it does
							-- we found a possible sam! 
							--env.info("we found a matching player deployed SAM for the Hit! "..sam.playerName.." has placed the sam!")
							playerName = sam.playerName
							playerUCID = KI.MP.GetPlayerUCID(playerName)
						end 
					end					
				end
				
				-- cycle through convoys on the move
				for i, convoy in pairs(MissionData.properties.spawnedConvoys) do 		-- find the SAM in the saveGame
					for j, unit in pairs(convoy.units) do 			-- check if the sam matches 
						if unit.name == event.initiator:getName() and convoy.playerName then						-- yes it does
							-- we found a possible sam! 
							--env.info("we found a matching SAM! Player "..convoy.playerName.."has placed the sam!")
							playerName = convoy.playerName
							playerUCID = KI.MP.GetPlayerUCID(playerName)
						end 
					end
				end
				
				-- cycle through objectives
				-- check objective groups
				for categoryName, categoryTable in pairs(MissionData) do
					if type(categoryTable) == "table" and categoryName ~= "properties" then
						for objectiveName, objectiveTable in pairs(categoryTable) do
							for groupName, groupTable in pairs (objectiveTable.groups) do
								for i, unit in pairs(groupTable.units) do
									--env.info("comparing unit.name '"..unit.name.."' with hit.unitName '"..hit.unitName.."'")
									if unit.name == event.initiator:getName() and groupTable.playerName then
										-- we found a possible sam! 
										--env.info("we found a matching player deployed SAM for the Hit in Objectivedata! "..groupTable.playerName.." has placed the sam!")
										playerName = groupTable.playerName
										playerUCID = KI.MP.GetPlayerUCID(playerName)
									end
								end
							end
						end
					end
				end
			end
			
			local newScore
		
			-- choppers deserve a score!
			if coalition == targetSide then
				newScore = {
					unitCategory = unitCategoryTable[event.initiator:getDesc().category],
					unitType = event.initiator:getTypeName(),
					unitName = playerUnitName,
					achievment = "teamhit",
					timestamp = event.time,
					weapon = weapon.displayName or weapon,
					weaponCategory = weapon.category,
					weaponMissileCategory = weapon.missileCategory or "none",
					weaponGuidance = weapon.guidance,
					targetName = targetName,
					targetType = targetType,
					targetSide = targetSide,
					targetUnitName = targetUnitName,
					targetCategory = targetCategory,
					playerName = playerName,
					playerUCID = playerUCID,
					side = coalition,
				}
				koScoreBoard.insertScoreForPlayer(playerName, newScore)
			else
				newScore = {
					unitCategory = unitCategoryTable[event.initiator:getDesc().category],
					unitType = event.initiator:getTypeName(),
					unitName = playerUnitName,
					achievment = "hit",
					timestamp = event.time,
					weapon = weapon.displayName or weapon,
					weaponCategory = weapon.category,
					weaponMissileCategory = weapon.missileCategory or "none",
					weaponGuidance = weapon.guidance,
					targetName = targetName,
					targetType = targetType,
					targetSide = targetSide,
					targetUnitName = targetUnitName,
					targetCategory = targetCategory,
					playerName = playerName,
					playerUCID = playerUCID,
					side = coalition,
				}
				koScoreBoard.insertScoreForPlayer(playerName, newScore)
			end
			
			
			koScoreBoard.recentHits[targetName] = koScoreBoard.recentHits[targetName] or {}
			koScoreBoard.recentHits[targetName][event.time] = newScore
			
			-- also save that the player was hit
			if target then
				local wasHitScore = {
					unitCategory = targetCategory,
					unitType = targetType,
					unitName = targetName,
					achievment = "washit",
					timestamp = event.time,
					weapon = weapon.displayName or weapon,
					weaponCategory = weapon.category,
					weaponMissileCategory = weapon.missileCategory or "none",
					weaponGuidance = weapon.guidance,
					targetName = playerName,
					targetType = event.initiator:getTypeName(),
					targetSide = coalition,
					targetUnitName = playerUnitName,
					targetCategory = unitCategoryTable[event.initiator:getDesc().category],
					playerName = targetName,
					playerUCID = KI.MP.GetPlayerUCID(targetName),
					side = targetSide,
				}
				
				koScoreBoard.insertScoreForPlayer(targetName, wasHitScore)
			end
				
			-- make sure to send the message only once every second!
            local time = koScoreBoard.lastHits[playerName]
            
			if time ~= nil and timer.getTime() - time < 1 then
                env.info("Ignore! double hits")
                koScoreBoard.lastHits[playerName] = timer.getTime()
                return
            else	
				env.info("("..string.upper(coalition)..") "..playerName.." has hit ("..string.upper(targetSide)..") "..targetName.." with "..(weapon.displayName or "'unknown weapon'").." (initiator = "..event.initiator:getName()..")")	
			end
			
			koScoreBoard.lastHits[playerName] = timer.getTime()
			
			if targetName == "AI" then
				targetName = "AI in "..targetType
			end
			
			if playerName == "AI" then
				playerName = "AI in "..event.initiator:getTypeName()
			end
			
			local hitDesc = "HIT! "
			if coalition == targetSide then
				hitDesc = "TEAMHIT! "
			end
			
			koScoreBoard.eventInfo(hitDesc.."("..string.upper(coalition)..") "..playerName.." has hit ("..string.upper(targetSide)..") "..targetName.." with "..(weapon.displayName or "unknown"))
			return
		end
		
		
		
		
		--------------------------------------
		--	SHOT event
		--  Occurs whenever any unit in a mission fires a weapon.
		--[[
			event = {
			  id = 1,
			  time = Time,
			  initiator = Unit,
			  weapon = Weapon
			}
		--]]  
		if event.id == world.event.S_EVENT_SHOT then
			env.info("Scoreboard handling S_EVENT_SHOT")
			
			--env.info("event = "..KI.Toolbox.SerializeTable(event))
			--env.info("weaponDesc = "..KI.Toolbox.SerializeTable(Weapon.getDesc(event.weapon)))
			
			if not event.weapon then
				--env.info("shot with no weapon supplied!"..KI.Toolbox.SerializeTable(event))
				env.info("shot with no weapon supplied!")
				return
			end
			
			
			--env.info("event = "..KI.Toolbox.SerializeTable(event))
			
			local weapon = Weapon.getDesc(event.weapon)
			--env.info("weapon = "..KI.Toolbox.SerializeTable(weapon))
			
			-- sanitise MATRA against S530D and Magic II
			if weapon.displayName == "MATRA" then
				env.info("detected a MATRA missile, checking guidance: "..weapon.guidance)
				if weapon.guidance == 2 then -- if IR
					weapon.displayName = "Matra Magic II"
				else
					weapon.displayName = "Matra S530D"
				end
			end	
			
			local target = Weapon.getTarget(event.weapon)
			
			--env.info("target = "..KI.Toolbox.SerializeTable(target))
			
			local targetName = "no target"
			local targetType = "no target"
			local targetCategory = "unkown"
			local targetSide = "unknown"
			local targetUnitName = "unkown"
			if target and Object.getCategory(target) == Object.Category.UNIT then 
				--env.info("Object.getCategory(target) == Object.Category.UNIT")
				targetName = target:getPlayerName() or "AI" 
				targetUnitName = target:getName()
				targetType = target:getTypeName()
				targetSide = coalitionTable[target:getCoalition()]
				targetCategory = unitCategoryTable[target:getDesc().category];
			elseif target and Object.getCategory(target) == Object.Category.STATIC then
				--env.info("Object.getCategory(target) == Object.Category.STATIC")
				targetName = "Static Object"
				targetUnitName = target:getName()
				targetType = target:getTypeName()
				targetSide = coalitionTable[target:getCoalition()]
				targetCategory = "STATIC"
			--elseif target then
			--	env.info("exception: category = "..Object.getCategory(target))
			--else
			--	env.info("target = nil")
			end	
			
			if playerName == "AI" then
				-- search for player deployed sams
				-- cycle through dropped SAMs
				for i, sam in pairs(MissionData.properties.droppedSAMs) do 		-- find the SAM in the saveGame
					for j, unit in pairs(sam.groupSpawnTable.units) do 			-- check if the sam matches 
						if unit.name == event.initiator:getName() then						-- yes it does
							-- we found a possible sam! 
							--env.info("we found a matching player deployed SAM for the shot! "..sam.playerName.." has placed the sam!")
							playerName = sam.playerName
							playerUCID = KI.MP.GetPlayerUCID(playerName)
						end 
					end					
				end
				
				-- cycle through convoys on the move
				for i, convoy in pairs(MissionData.properties.spawnedConvoys) do 		-- find the SAM in the saveGame
					for j, unit in pairs(convoy.units) do 			-- check if the sam matches 
						if unit.name == event.initiator:getName() and convoy.playerName then						-- yes it does
							-- we found a possible sam! 
							--env.info("we found a matching SAM! Player "..convoy.playerName.."has placed the sam!")
							playerName = convoy.playerName
							playerUCID = KI.MP.GetPlayerUCID(playerName)
						end 
					end
				end
				
				-- cycle through objectives
				-- check objective groups
				for categoryName, categoryTable in pairs(MissionData) do
					if type(categoryTable) == "table" and categoryName ~= "properties" then
						for objectiveName, objectiveTable in pairs(categoryTable) do
							for groupName, groupTable in pairs (objectiveTable.groups) do
								for i, unit in pairs(groupTable.units) do
									--env.info("comparing unit.name '"..unit.name.."' with hit.unitName '"..hit.unitName.."'")
									if unit.name == event.initiator:getName() and groupTable.playerName then
										-- we found a possible sam! 
										--env.info("we found a matching player deployed SAM for the Hit in Objectivedata! "..groupTable.playerName.." has placed the sam!")
										playerName = groupTable.playerName
										playerUCID = KI.MP.GetPlayerUCID(playerName)
									end
								end
							end
						end
					end
				end
			end
			
			env.info(playerName.." has launched a "..weapon.displayName.." on "..targetName.." (initiator = "..event.initiator:getName()..")")
			
				
			
			-- choppers deserve a score!
			local newScore = {
				achievment = "shot",
				unitName = playerUnitName,
				unitType = event.initiator:getTypeName(),
				unitCategory = unitCategoryTable[event.initiator:getDesc().category],
				targetName = targetName,
				targetType = targetType,
				targetCategory = targetCategory,
				targetSide = targetSide,
				targetUnitName = targetUnitName,
				weapon = weapon.displayName,
				weaponCategory = weaponCategory[weapon.category],
				weaponMissileCategory = weaponMissileCategory[weapon.missileCategory] or "none",
				weaponGuidance = weapon.guidance or "none",
				timestamp = event.time,-- TODO
				side = coalitionTable[event.initiator:getCoalition()],
				playerName = playerName,
				playerUCID = playerUCID,
			}
			koScoreBoard.insertScoreForPlayer(playerName, newScore)
			
			koScoreBoard.recentShots[playerUnitName] = koScoreBoard.recentShots[playerUnitName] or {}
			koScoreBoard.recentShots[playerUnitName][event.time] = newScore
			
			return
		end
		
		--------------------------------------
		--	CRASH event
		if event.id == world.event.S_EVENT_CRASH then
			env.info("S_EVENT_CRASH")
			
			--trigger.action.outText("crash time: "..event.time)
			
			--env.info("event = "..KI.Toolbox.SerializeTable(event))
			
			local newScore = {
				achievment = "crashed",
				unitGroupID = getGroupId(event.initiator),
				unitCategory = unitCategoryTable[event.initiator:getDesc().category],
				unitType = event.initiator:getTypeName(),
				unitName = playerUnitName,
				timestamp = event.time,
				side = coalitionTable[event.initiator:getCoalition()],
				playerName = playerName,
				playerUCID = KI.MP.GetPlayerUCID(playerName),
			}
			koScoreBoard.insertScoreForPlayer(playerName, newScore)
			koScoreBoard.eventInfo(playerName.." crashed ...")
			
			-- close the sortie
			-- koScoreBoard.closeSortie(playerName, "crashed") -- dont close sortie yet
		end
		
		--------------------------------------
		--	EJECT event
		if event.id == world.event.S_EVENT_EJECTION then
			env.info("S_EVENT_EJECTION")
			--env.info("event = "..KI.Toolbox.SerializeTable(event))
			
			local newScore = {
				unitGroupID = getGroupId(event.initiator),
				unitCategory = unitCategoryTable[event.initiator:getDesc().category],
				unitType = event.initiator:getTypeName(),
				unitName = playerUnitName,
				timestamp = event.time,
				achievment = "ejected",
				side = coalitionTable[event.initiator:getCoalition()],
			}
			koScoreBoard.insertScoreForPlayer(playerName, newScore)
			--koScoreBoard.eventInfo(playerName.." ejected!")
			
			-- koScoreBoard.closeSortie(playerName, "ejected") -- don't close sortie yet
		end
		
		--------------------------------------
		--	PILOT_DEAD event 
		if event.id == world.event.S_EVENT_PILOT_DEAD then
			--env.info("S_EVENT_PILOT_DEAD")
			--env.info("event = "..KI.Toolbox.SerializeTable(event))
			--env.info("unitName = "..event.initiator:getName())
			--env.info(":gePlayerName() = "..event.initiator:getPlayerName())
			--env.info(":geTypeName() = "..event.initiator:getTypeName())
			
			-- normal died event
			local newScore = {
				unitGroupID = getGroupId(event.initiator),
				unitCategory = unitCategoryTable[event.initiator:getDesc().category],
				unitType = event.initiator:getTypeName(),
				unitName = playerUnitName,
				timestamp = event.time,
				achievment = "died",
				side = coalitionTable[event.initiator:getCoalition()],
			}
			koScoreBoard.insertScoreForPlayer(playerName, newScore)
			koScoreBoard.eventInfo(playerName.." died ...")
			
			--koScoreBoard.closeSortie(playerName, "died")	-- don't close sortie yet
		end
		
	-- DEBUGGING STUFF
	else
		if not event.initiator then
			env.info("no iniator event: "..KI.Toolbox.SerializeTable(event))
			if event.weapon then
				env.info("weapon = "..event.weapon:getName())
			end
			if event.target then
				env.info("target:getName = "..event.target:getName())
			end
		end
	end
	
	--------------------------------------
	--	DEAD event
	--	Initiator : The unit that was destroyed.
	if event.id == world.event.S_EVENT_DEAD then
	end
end


function koScoreBoard.eventInfo(text)
	env.info("koScoreBoard.eventInfo: "..text)
	trigger.action.outText(text, koScoreBoard.eventInfoDisplayTime, false)
end



env.info("ko_ScoreBoard.lua loaded")