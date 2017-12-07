--log.set_output('ko_net', 'LuaNET', log.INFO, log.MESSAGE + log.TIME)

net.log("\n----------------------------------------------\nKaukasus Offensive Server Tools\n\t- initializing ..\n")

local koServer = {}

-- holds data that is received back from either a saved file, or from the Mission Script layer via udp socket (JSON Format)
-- only is used for checking that:
-- A) you can slot in (fighter, striker, helicopter slots not fully occupied)
-- B) you have lives remaining to slot in
koServer.MissionData = {}		
koServer.PlayerData = nil

-- Holds information about banned players - read from file but also returned from udp socket (JSON Format)
koServer.VipPlayerData = nil
koServer.missionDataLastUpdate = 0
koServer.ConfigDirectory = lfs.writedir() .. [[Missions\The Kaukasus Offensive\]]
koServer.PlayerDataFile = koServer.ConfigDirectory .. [[ko_PlayerData.lua]]				-- ko_PlayerData.
koServer.VipPlayerDataFile = koServer.ConfigDirectory .. [[ko_vipPlayerData.lua]]		-- file that keeps banned players
koServer.PlayerListFile = koServer.ConfigDirectory .. [[ko_PlayersOnline.lua]]			-- Used for PHP CRON job, no other function
koServer.MissionDataFile = koServer.ConfigDirectory .. [[ko_Savegame.lua]]				-- ko_Savegame.lua
koServer.eventFileName = koServer.ConfigDirectory .. [[ko_EventBuffer.lua]]				-- ko_EventBuffer.lua

koServer.slotLimit = 30
koServer.redPlayersOnline = 0
koServer.bluePlayersOnline = 0
koServer.maxFighters = 4
koServer.maxStrikers = 4
koServer.maxHelicopter = 4
koServer.serverID = 1			-- Server ID for sending Message from. gets updated in onPlayerConnect
koServer.spawnAttempts = {}		-- keep track of players attempting to spawn, if they try too often its save to assume they dont have chat open. if they try too often in 5 seconds, kick them
koServer.playersOnline = {} 
koServer.playerList = {}
koServer.bannedList = {}

koServer.webAdress = "http://tawdcs.net"

------------------------------
-- upd definitions
package.path  = package.path..";.\\LuaSocket\\?.lua;"
package.cpath = package.cpath..";.\\LuaSocket\\?.dll;"

local JSON = loadfile("Scripts\\JSON.lua")()
local socket = require("socket")

-- UDP Declaration
koServer.JSON = JSON
koServer.GAMEGUI_SEND_TO_PORT = 6005
koServer.GAMEGUI_RECEIVE_PORT = 6006	
koServer.SAVEGAME_RECEIVE_PORT = 6007
koServer.UDPSendSocket = socket.udp()
koServer.UDPSavegameReceiveSocket = socket.udp()
koServer.UDPSavegameReceiveSocket:setsockname("*", koServer.SAVEGAME_RECEIVE_PORT)
koServer.UDPSavegameReceiveSocket:settimeout(.0001) --receive timer
koServer.UDPGameGuiReceiveSocket = socket.udp()
koServer.UDPGameGuiReceiveSocket:setsockname("*", koServer.GAMEGUI_RECEIVE_PORT)
koServer.UDPGameGuiReceiveSocket:settimeout(.0001) --receive timer

koServer.slotTable = {
	[1] = { 			-- red units
		Fighter = {},
		Striker = {},	
		Helicopter = {},
	},
	[2] = { 			-- blue units
		Fighter = {},
		Striker = {},
		Helicopter = {},
	}, 
}


local coaTable = 
{
	[0] = 'neutral',
	[1] = 'red',
	[2] = 'blue',
}




function koServer.getUnitId(_slotID)
	local _unitId = tostring(_slotID)
	if string.find(tostring(_unitId),"_",1,true) then
		--extract substring
		_unitId = string.sub(_unitId,1,string.find(_unitId,"_",1,true)-1)
		
		-- hotfix observer slots by deadbeef
		if _unitId == "forward" then 
			_unitId = "-1"	-- 
		elseif
			_unitId == "instructor" then 
			_unitId = "-2"	-- hotfix forward observer
		elseif
			_unitId == "observer" then 
			_unitId = "-3"	-- hotfix forward observer
		end
		--net.log("Unit ID Substr ".._unitId)
	end

	return tonumber(_unitId)
end

function koServer.getPlayerNameFix(playerName)
	if not playerName then 
		return nil
	end
	
	local playerName = playerName:gsub("'"," ")
	playerName = playerName:gsub('"',' ')
	playerName = playerName:gsub('=','-')
	
	return playerName
end

function koServer.loadDataFile(filename)
	local dataLoader = loadfile(filename)
	local data = nil
	if dataLoader then 
		net.log("successfully loaded: "..filename)
		data = dataLoader() 
	else
		net.log("could not load: "..filename)
		--data = {} 
	end
	
	return data
end

function koServer.loadMissionData()
	if not koServer.MissionData or not koServer.MissionData.properties or (DCS.getRealTime() - koServer.missionDataLastUpdate) > 30 then
		net.log("loading MissionData: "..tostring(koServer.MissionData)..", properties: "..tostring(koServer.MissionData.properties)..", timeSinceLastLoad: "..tostring(DCS.getRealTime() - koServer.missionDataLastUpdate))
		koServer.missionDataLastUpdate = DCS.getRealTime()
		local data = koServer.loadDataFile(koServer.MissionDataFile)
		if data and data.properties then
			koServer.MissionData = data
		end
	else
		net.log("not loading MissionData: "..tostring(koServer.MissionData)..", properties: "..tostring(koServer.MissionData.properties)..", timeSinceLastLoad: "..tostring(DCS.getRealTime() - koServer.missionDataLastUpdate))
	end
	
end

function koServer.loadPlayerData()
	return koServer.loadDataFile(koServer.PlayerDataFile)
end

function koServer.loadVipPlayerData()
	return koServer.loadDataFile(koServer.VipPlayerDataFile)
end

------------------------------------------------
--[[ string koServer.TableSerialization(table)
--
-- makes string from table
-- taken from XComs blueflag
------------------------------------------------]]
function koServer.TableSerialization(t, i)	 --function to turn a table into a string (works to transmutate strings, numbers and sub-tables)
	i = i or 0
	
	if not t then return "nil" end
	
	local text = "{\n"
	local tab = ""
	for n = 1, i + 1 do	 --	controls the indent for the current text line
		tab = tab .. "\t"
	end
	for k,v in pairs(t) do
		if type(k) == "string" then
			text = text .. tab .. "['" .. k .. "']" .. " = "
			if type(v) == "string" then
				text = text .. "'" .. v .. "',\n"
			elseif type(v) == "number" then
				text = text .. v .. ",\n"
			elseif type(v) == "table" then
				text = text .. koServer.TableSerialization(v, i + 1)
			elseif type(v) == "boolean" then
				text = text .. tostring(v) .. ",\n"
			end
		elseif type(k) == "number" then
			text = text .. tab .. "[" .. k .. "] = "
			if type(v) == "string" then
				text = text .. "'" .. v .. "',\n"
			elseif type(v) == "number" then
				text = text .. v .. ",\n"
			elseif type(v) == "table" then
				text = text .. koServer.TableSerialization(v, i + 1)
			elseif type(v) == "boolean" then
				text = text .. tostring(v) .. ",\n"
			end 
		end
	end
	tab = ""
	for n = 1, i do		--indent for closing bracket is one less then previous text line
		tab = tab .. "\t"
	end
	if i == 0 then
		text = text .. tab .. "}\n" --the last bracket should not be followed by an comma
	else
		text = text .. tab .. "},\n"	 --all brackets with indent higher than 0 are followed by a comma
	end
	return text
end

----------------------------------------------
--[[ koServer.savePlayerData()
--
-- Saves the current game-state to ko_data_dyn.lua
-- (requires io,lfs to be sanitized)
-- derived from XComs blueflag
--------------------------------------------]]
function koServer.savePlayerData()
	if not koServer.isValid() then return end
	if io == nil then 
		net.log("io sanitized, cannot save player Data!")
		return
	end
	
	net.log("koServer.savePlayerData()")
	
	local exportData = "local t = " .. koServer.TableSerialization(koServer.PlayerData, 0) .. "return t"	 --The second argument is the indent for the initial code line (which is zero)
 
	--net.log("koServer.savePlayerData("..koServer.PlayerDataFile..")") --: writing savegame to: '" .. exportDir .. "'")
			
	local exportFile = assert(io.open(koServer.PlayerDataFile, 'w'))
	exportFile:write(exportData)
	exportFile:flush()
	exportFile:close()
	exportFile = nil
	
	--net.log("saving player list to "..koServer.PlayerListFile)
	local playerTable = koServer.deepCopy(koServer.playerList)
	playerTable.slotTable = koServer.slotTable;
	exportData = "local t = " .. koServer.TableSerialization(playerTable) .. "return t"	 --The second argument is the indent for the initial code line (which is zero)
 	exportFile = assert(io.open(koServer.PlayerListFile, 'w'))
	exportFile:write(exportData)
	exportFile:flush()
	exportFile:close()
	exportFile = nil
end

----------------------------------------------
--[[ koServer.saveVipPlayerData()
--
-- Saves the current game-state to ko_data_dyn.lua
-- (requires io,lfs to be sanitized)
-- derived from XComs blueflag
--------------------------------------------]]
function koServer.saveVipPlayerData()
	
	if not koServer.isValid() then return end
	if io == nil then 
		net.log("io sanitized, cannot save player Data!")
		return
	end
	
	net.log("koServer.saveVipPlayerData()")
	
	local exportData = "local t = " .. koServer.TableSerialization(koServer.VipPlayerData, 0) .. "return t"	 --The second argument is the indent for the initial code line (which is zero)
 
	--net.log("koServer.savePlayerData("..koServer.PlayerDataFile..")") --: writing savegame to: '" .. exportDir .. "'")
			
	local exportFile = assert(io.open(koServer.VipPlayerDataFile, 'w'))
	exportFile:write(exportData)
	exportFile:flush()
	exportFile:close()
	exportFile = nil
end


koServer.onShowPool = function(a, b, c)
	-- not working :(
	net.log("onShowPool:("..tostring(a)..", "..b..", "..c..")")
end

-- code by xcom
koServer.onPlayerChangeSlot = function(id)
	if not koServer.isValid() then	return 	end
	
	if id == koServer.serverID then 
		return	-- if the server is changing slot there is no action required.
	end
	
	-- TODO
	-- check number of spawn-attempts within the last 5 seconds, if it's more than 5 he's not checking the chat, kick him
	if koServer.spawnAttempts[net.get_player_info(id, "ucid")] and koServer.spawnAttempts[net.get_player_info(id, "ucid")] > 3 then
		net.log("Player spawn-spammed without looking into chat, kicking!")
		koServer.spawnAttempts[net.get_player_info(id, "ucid")] = nil
		net.kick(id, net.get_player_info(id, "name")..": You should really open the chat and read instead of clicking everywhere!\n - check the livemap at "..koServer.webAdress.." to find out which slot is available!\n - also check the slotlist below the map. Your category of choice may be full!\n\nPlease please select slots conciously, clicking every slot in fast repetition causes lag!")
	end 
	
	local oldSlot = koServer.isIdInSlotTable(id) -- keep track if the player was in a valid slot before, if he was and went to spectators, we send a message to mission side
	koServer.removeIdFromSlotTable(id) -- make sure this player gets removed from the slot table since he selected a new slot anyway
	local _playerName = net.get_player_info(id, "name" )
	
	if _playerName then
		net.log("koServer.onPlayerChangeSlot(".._playerName.."), id = "..id..", Slot = "..net.get_player_info(id,'slot'))
	else
		net.log("koServer.onPlayerChangeSlot(id = "..id..") - Player Name == nil, returning")
		return
	end
	
	
	koServer.loadMissionData()
	if not koServer.MissionData or (koServer.MissionData and not koServer.MissionData.properties) then
		net.log("FATAL ERROR: there's a problem with MissionData, cannot check slot!")
		net.send_chat_to("sorry, there was a problem checking the slot, please try again!", id, koServer.serverID)
		net.force_player_slot(id, 0, '')
		return 
	end
	
	--net.log("player_info = "..koServer.TableSerialization(net.get_player_info(id)))
	
	local _playerNameFix = ""
	local _playerSlotID = net.get_player_info(id,'slot')
	local _playerSide = net.get_player_info(id,'side')
	if _playerName then _playerNameFix = koServer.getPlayerNameFix(_playerName) end
	
	--net.log("["..id.."][".._playerName.."]["..coaTable[_playerSide].."] Player Changed Slot")

	-- if not a spectators slot
	if _playerSide ~= 0 and _playerSlotID and _playerSlotID ~= '' then

		--net.log("["..id.."][".._playerSlotID.."][".._playerName.."]["..coaTable[_playerSide].."] Unit ID retrieved")
		
		-- check blue/red playerbalance
		local playerList = net.get_player_list()
		koServer.redPlayersOnline = -1
		koServer.bluePlayersOnline = 0
		for pID, pName in pairs(playerList) do
			local side = net.get_player_info(pID,'side') 
			if side  == 1 then	
				koServer.redPlayersOnline = koServer.redPlayersOnline + 1
			elseif side == 2 then	
				koServer.bluePlayersOnline = koServer.bluePlayersOnline + 1			
			end
		end
		
		net.log("Red/Blue Players: "..koServer.redPlayersOnline.."/"..koServer.bluePlayersOnline)
		if _playerSlotID == "instructor_red_1" then
			local _chatMessage = string.format("- Hey %s! Sorry MATE, The Game-Master slot is reserved for the Server ;)",_playerName)
			net.send_chat_to(_chatMessage, id, koServer.serverID)
			net.force_player_slot(id, 0, '')
			net.log(_playerName.." tried to occupy game-master")
			return
		elseif _playerSide == 1 and koServer.redPlayersOnline > (koServer.slotLimit/2) then
			local _chatMessage = string.format("- Hey %s! Sorry MATE, red side is strong enough! Feel free to support blue for a moment",_playerName)
			net.send_chat_to(_chatMessage, id, koServer.serverID)
			net.force_player_slot(id, 0, '')
			net.log("red serverlimit reached")
			return
		elseif _playerSide == 2 and koServer.bluePlayersOnline > (koServer.slotLimit/2) then
			local _chatMessage = string.format("- Hey %s! Sorry MATE, blue side is strong enough! Feel free to support red for a moment",_playerName)
			net.send_chat_to(_chatMessage, id, koServer.serverID)
			net.force_player_slot(id, 0, '')
			net.log("blue serverlimit reached")
			return
		elseif string.find(_playerSlotID, "forward") then
			net.log(_playerName.." chose forward observer, allowing")
			return
		end
		
		
		-- get the slot ID Number value
		local uid = koServer.getUnitId(_playerSlotID)
		
		net.log("checking live limit")
		-----------------------------------------------
		--check if player limit exceeded
		local pLimitTest = false
		if uid > 0 then	-- forward observer id is < 0 (-1), dont limit forward observer abilities if player is out of lives
			for pName,limit in pairs(koServer.MissionData['properties']['playerLimit']) do
				if pName == _playerNameFix then
					pLimitTest = true
					if limit >= koServer.MissionData['properties']['lifeLimit'] then
						net.send_chat_to(string.format("- %s, You have used all your lives and returned to spectators! Server lives are reset every 5hrs",_playerName), id, koServer.serverID)
						net.log(_playerName.." has run out of lives")
						net.force_player_slot(id, 0, '')
						return 
					end
				end
			end
		end
		
		net.log("live-limit ok, checking owned airbase")
		-----------------------------------------------
		-- Check if unit is in an owned airbase.
		-- loop through the Objectives and check if the players unit spawns there
		local slotAccepted = false
		
		for categoryName, categoryTable in pairs(koServer.MissionData) do
			if type(categoryTable)=="table" then
				for objectiveName, objectiveTable in pairs(categoryTable) do
					if type(objectiveTable)=="table" and objectiveName ~= "properties" then
						if objectiveTable['slotIDs'] then
							for unitID,unitData in pairs(objectiveTable['slotIDs']) do
								if uid==tonumber(unitID) then
									net.log(objectiveTable.coa.." Player ".._playerName.." chose slot "..unitData.name)
									if objectiveTable.coa == "neutral" then
											koServer.sendPlayerToSpectators(id, string.format("- %s, you are trying to spawn on a neutral base!", _playerName))
											net.send_chat_to("check the livemap at "..koServer.webAdress.." to find out which slot is available!", id, koServer.serverID)
											return 
									elseif objectiveTable.status == 'open' then
										if objectiveTable.coa ~= coaTable[_playerSide] and objectiveTable.coa ~= "contested" then	
											koServer.sendPlayerToSpectators(id, "- ".._playerName..", the "..string.upper(categoryName).." you selected is hostile!")
											net.send_chat_to("check the livemap at "..koServer.webAdress.." to find out which slot is available!", id, koServer.serverID)
											return 
										end
									else
										koServer.sendPlayerToSpectators(id, string.format("- %s, this slot is on a closed %s", _playerName, string.upper(categoryName)), id, koServer.serverID)
										net.send_chat_to("check the livemap at "..koServer.webAdress.." to find out which slot is available!", id, koServer.serverID)
										return 
									end
									
									net.log("slot is valid, checking balance")
									
									-- user joined a fighter plane
									if unitData.name:find("CAP") or unitData.name:find("Intercept") or unitData.name:find("Escort") then 
										net.log("player chose Fighter Slot, there are '"..#koServer.slotTable[_playerSide].Fighter.."' fighter slots already used")
										
										if #koServer.slotTable[_playerSide].Fighter >= koServer.maxFighters then
											local _chatMessage = string.format("- SORRY %s, There are already enough Fighters in your coalition! There are %d Striker and %d Helicopter Slots left!",_playerName, koServer.maxStrikers - #koServer.slotTable[_playerSide].Striker, koServer.maxHelicopter - #koServer.slotTable[_playerSide].Helicopter)
											koServer.sendPlayerToSpectators(id, _chatMessage)
										else
											table.insert(koServer.slotTable[_playerSide].Fighter, id)
										end
									-- user joined a Striker or Attack chopper
									elseif unitData.name:find("CAS") or unitData.name:find("SEAD") then 
										net.log("player chose Striker Slot, there are '"..#koServer.slotTable[_playerSide].Striker.."' striker slots already used")
										
										if #koServer.slotTable[_playerSide].Striker >= koServer.maxStrikers then
											local _chatMessage = string.format("- SORRY %s, There are already enough Strikers in your coalition! There are %d Fighter and %d Helicopter Slots left!",_playerName, koServer.maxFighters - #koServer.slotTable[_playerSide].Fighter, koServer.maxHelicopter - #koServer.slotTable[_playerSide].Helicopter)
											koServer.sendPlayerToSpectators(id, _chatMessage)
										else
											table.insert(koServer.slotTable[_playerSide].Striker, id)
										end
									-- user joined a Helicopter  	
									elseif unitData.name:find("Transport") or unitData.name:find("Attack") then
										net.log("player chose Helicopter Slot, there are '"..#koServer.slotTable[_playerSide].Helicopter.."' Helicopter slots already used")
										
										if #koServer.slotTable[_playerSide].Helicopter >= koServer.maxHelicopter then
											local _chatMessage = string.format("- SORRY %s, There are already enough Choppers in your coalition! There are %d Striker and %d Fighter Slots left!",_playerName, koServer.maxStrikers - #koServer.slotTable[_playerSide].Striker, koServer.maxFighters - #koServer.slotTable[_playerSide].Fighter)
											koServer.sendPlayerToSpectators(id, _chatMessage)
										else
											table.insert(koServer.slotTable[_playerSide].Helicopter, id)
										end
									end
									
									slotAccepted = true
									net.log("player slot accepted")
									--net.log("slot table = "..koServer.TableSerialization(koServer.slotTable))
									
									return
								end
							end
						end
					end
				end
			end
		end
		
		if not slotAccepted then
			net.log("player slot acceptance failed")
			net.send_chat_to("sorry, there was a problem checking the slot, please try again!", id, koServer.serverID)
			net.force_player_slot(id, 0, '')
		end
	else
		net.log("["..id.."][".._playerName.."]["..coaTable[_playerSide].."] Player returned to spectators")
		
		-- send went to spectators message to mission side
		if oldSlot then
			local event = {
				achievment = "returned_to_specators",
				playerName = _playerNameFix,
				playerUnit = "spectator",
				playerSide = coaTable[_playerSide],
				modelTime = DCS.getModelTime(),
				realTime = DCS.getRealTime(),
			}
			net.log("player went to spectators after being in a slot")
			
			net.log("sending return-to-spectators message to mission-side")
			socket.try(koServer.UDPSendSocket:sendto(koServer.JSON:encode(event).." \n", "127.0.0.1", koServer.GAMEGUI_SEND_TO_PORT))
			
			--[[local eventTable = {}
			local DataLoader = loadfile(koServer.eventFileName)
			if DataLoader ~= nil then		-- File open?
				net.log("Loading from '"..koServer.eventFileName.."' successful")
				eventTable = DataLoader() or {}
			end
			
			table.insert(eventTable, event)
			--net.log(koServer.TableSerialization(eventTable))
			local exportFile = assert(io.open(koServer.eventFileName, 'w'))
			local exportString = "local t = " .. koServer.TableSerialization(eventTable, 0) .. "return t"
			exportFile:write(exportString)
			exportFile:flush()
			exportFile:close()
			exportFile = nil
			net.log("end filehandling")--]]
		end
	end
	
	koServer.updatePlayerList()
	
	return 
end

function koServer.sendPlayerToSpectators(id, message)
	if message then
		net.send_chat_to(message, id, koServer.serverID)
	end

	-- save the fact we sent him to specators for in case he spawn-spams
	local ucid = net.get_player_info(id, "ucid")
	if koServer.spawnAttempts[ucid] then
		koServer.spawnAttempts[ucid] = koServer.spawnAttempts[ucid] + 1
	else
		koServer.spawnAttempts[ucid] = 1
	end
	 
	
	net.force_player_slot(id, 0, '')
	net.log("player returned to spectators: '"..tostring(message).."'")
end

function koServer.removeIdFromSlotTable(id)
	for coalition, slotTypes in pairs(koServer.slotTable) do
		for slotType, playerIDs in pairs(slotTypes) do
			for i, playerID in pairs(playerIDs) do
				if playerID == id then
					table.remove(playerIDs,i)
					net.log("player ID "..id.." was removed from slottracker")
				end
			end
		end
	end
end

function koServer.isIdInSlotTable(id)
	for coalition, slotTypes in pairs(koServer.slotTable) do
		for slotType, playerIDs in pairs(slotTypes) do
			for i, playerID in pairs(playerIDs) do
				if playerID == id then
					return true
				end
			end
		end
	end
	
	return false
end

-- code by xcom
koServer.onGameEvent = function(eventName,playerID,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8) -- This stops the user flying again after crashing or other events
	if not koServer.isValid() then	return	end
	
	net.log("koServer.onGameEvent("..eventName..")")
	
	if DCS.isServer() and DCS.isMultiplayer() then
		if DCS.getRealTime() > 1 then	-- must check this to prevent a possible CTD by using a_do_script before the game is ready to use a_do_script. -- Source GRIMES :)
			if eventName == "self_kill"
					or eventName == "crash"
					--or eventName == "eject"
					or eventName == "pilot_death" then

				-- is player in a slot and valid?
				local _playerDetails = net.get_player_info(playerID)

				if _playerDetails ~= nil and _playerDetails.side ~= 0 and _playerDetails.slot ~= "" and _playerDetails.slot ~= nil then

					if _playerDetails.name ~= nil then
						--Disable chat message to user
						local _chatMessage = string.format("*** %s, YOU HAVE BEEN RETURNED TO SPECTATORS, PLEASE SELECT A NEW SLOT ***",_playerDetails.name)
						net.send_chat_to(_chatMessage, _playerDetails.id, koServer.serverID)
					end
					net.log("[".._playerDetails.id.."][".._playerDetails.name.."][".._playerDetails.side.."] Removed from slot - Returned to spectators after death")
					net.force_player_slot(playerID, 0, '')
					return
				end
			
			-------------------------------------------------------
			-- KILL event
			elseif eventName == "kill" then
				net.log("killevent")
				net.log("playerID = "..playerID..", arg1 = "..arg1..", arg2 = "..arg2..", arg3 = "..arg3..", arg4 = "..arg4..", arg5 = "..arg5..", arg6 = "..arg6..", arg7 = "..tostring(arg7)..", arg8 = "..tostring(arg8))
				
				local killerPlayerName = net.get_player_info(playerID, 'name') or "AI"
				local killerUnitType = arg1
				local killerSide = coaTable[arg2]
				local victimPlayerName = net.get_player_info(arg3, 'name') or "AI"
				local victimUnitType = arg4
				local victimSide = coaTable[arg5]
				local weaponName = arg6
				local achievment = "kill"
				
				koServer.loadMissionData()
				
				-- if the killer is AI, check if a player owned sam has killed!
				if killerPlayerName == "AI" then
					--for i, sam in pairs(koServer.MissionData.properties.droppedSAMs) do
						
					--end
				end
				
				local messageString = killerSide
				if killerPlayerName == "AI" then
					messageString = messageString.." '"
				else
					messageString = messageString.." Player '"
				end
				messageString = messageString..killerPlayerName.."' in "..killerUnitType.." has killed "..victimSide
				if victimPlayerName == "AI" then
					messageString = messageString.." '"
				else
					messageString = messageString.." Player '"
				end
				messageString = messageString..victimPlayerName.."' in "..victimUnitType.." with "..weaponName
				
				--net.dostring_in('server', 'trigger.action.outText("'..messageString..'", 15)') -- works!
				--net.dostring_in('server', 'env.info("KILL! from Server:'..messageString..'")') -- works!
				--net.log("Killmessage: "..messageString)
				
				local killEvent = {
					achievment = achievment,
					killerName = koServer.getPlayerNameFix(killerPlayerName),
					killerUnit = killerUnitType,
					killerSide = killerSide,
					victimName = koServer.getPlayerNameFix(victimPlayerName),
					victimUnit = victimUnitType,
					victimSide = victimSide,
					weaponName = weaponName,
					modelTime = DCS.getModelTime(),
					realTime = DCS.getRealTime(),
				}
				net.log("start filehandling")
				
				-------
				--[[
				DCS.getModelTime() -> number
				    returns current DCS simulation time in seconds.
				
				DCS.getRealTime() -> number
				    returns current DCS real time in seconds relative to the DCS start time.
				    --]]
				
				-- send UDP message to mission side to inform it about the kill:
				socket.try(koServer.UDPSendSocket:sendto(koServer.JSON:encode(killEvent).." \n", "127.0.0.1", koServer.GAMEGUI_SEND_TO_PORT))
				
				-- save to file
				--[[local eventTable = {}
				local DataLoader = loadfile(koServer.eventFileName)
				if DataLoader ~= nil then		-- File open?
					net.log("Loading from '"..koServer.eventFileName.."' successful")
					eventTable = DataLoader() or {}
				end
				
				table.insert(eventTable, killEvent)
				net.log(koServer.TableSerialization(eventTable))
				local exportFile = assert(io.open(koServer.eventFileName, 'w'))
				local exportString = "local t = " .. koServer.TableSerialization(eventTable, 0) .. "return t"
				exportFile:write(exportString)
				exportFile:flush()
				exportFile:close()
				exportFile = nil
				net.log("end filehandling")--]]
			end
		end
	end
end

koServer.onChatMessage = function(message, playerID)
	if not koServer.isValid()then return end
end

koServer.onPlayerTrySendChat = function(playerID, message, all) -- -> filteredMessage | "" - empty string drops the message
	if not koServer.isValid() then	return message	end
	
	-- sanitize string to check for string-errors
	-- borrowed from slmod
	local fullComm = message
	fullComm = fullComm:lower()  -- convert to lower case
	fullComm = fullComm:gsub('\n', ' ') --remove any newlines (not likely to be there)
	local num_rep
	repeat  -- reduce all spaces to single space
		fullComm, num_rep = fullComm:gsub('  ', ' ')
	until num_rep == 0
	if fullComm:sub(1,1) == ' ' then --remove any leading space
		fullComm = fullComm:sub(2, fullComm:len())
	end
	if fullComm:sub(fullComm:len(), fullComm:len()) == ' ' then  --remove any trailing space
		fullComm = fullComm:sub(1, fullComm:len() - 1)
	end --]]
	-- now s definitely begins and ends with a non-space char
	
	--net.log("onPlayerTrySendChat("..playerID..",'"..fullComm.."')")
	
	local playerInfo = net.get_player_info(playerID)
	if not playerInfo then return message end
	
	--net.log("playerInfo = "..koServer.TableSerialization(playerInfo,0))
	
	-- check if admin command is called ("-admin")
	local curSpace = 1
	local nextSpace = fullComm:find(' ', 0) or 0
	nextSpace = nextSpace -1
		
	local command = string.sub(fullComm, curSpace, nextSpace)
	
	--net.log("command = "..tostring(command))
	
	if command ~= nil and command == "-admin" then
		net.log("-admin called")
		koServer.serverID = net.get_server_id()
		
		-- check if player is admin
		local player = koServer.getVipPlayerData(playerInfo.ucid)
		
		if playerID == koServer.serverID then
			player = {}
			player.name = net.get_player_info(playerID, "name")
			player.status = "Admin"
		end
		
		net.log("player = "..koServer.TableSerialization(player,0))
		
		if player and player.status == "Admin" or playerID == koServer.serverID then
			net.log(player.name.." is Admin!")
			
			
			-- check what's the task.
			if not nextSpace then
				net.send_chat_to("Hello "..player.name.."! What can I do for you? Type '-admin help' if you are lost.", playerID, koServer.serverID)
				return ""	-- no task specified
			end
			
			net.send_chat_to("Hello "..player.name.."!", playerID, koServer.serverID)
			
			local task = string.sub(fullComm, nextSpace+2)
			net.log("task = "..task)
			-- check the task
			curSpace = 1
			nextSpace = task:find(" ", curSpace) or 0
			nextSpace = nextSpace -1
			
			local taskCommand = string.sub(task, curSpace, nextSpace)
			net.log("taskCommand = "..taskCommand) 
			
			-- kick
			if taskCommand == "kick" or taskCommand == "tospec" or taskCommand == "ban" then
			
				-- check what's the task.
				if nextSpace == -1 then
					net.send_chat_to("who shalt I "..taskCommand.." for you?", playerID, koServer.serverID)
					return ""	-- no task specified
				end
				
				--kick who?
				curSpace = nextSpace+2
				local playerToKickID = tonumber(string.sub(task, curSpace))
				
				--find the players name
				local playerToKickName = net.get_player_info(playerToKickID, "name")
				local playerToKickUCID = net.get_player_info(playerToKickID, "ucid")
				local playerToKick = koServer.getVipPlayerData(playerToKickUCID) or koServer.insertToVipPlayerData(playerToKickUCID)
				
				
				net.log("trying to "..taskCommand.." "..playerToKickName.."("..playerToKickID..")")
				
				if playerToKick then				
					if playerToKickID == playerID then
						net.send_chat_to("wait! you cant "..taskCommand.." yourself!", playerID, koServer.serverID)
						return ""
					end
					
					if taskCommand == "tospec" then
						net.send_chat_to("sending player "..playerToKickName.."("..playerToKickID..") back to spectators", playerID, koServer.serverID)
						net.send_chat_to("You have been returned to spectators by the Admin", playerToKickID, koServer.serverID)
						net.force_player_slot(playerToKickID, 0, '')
					elseif taskCommand == "ban" then
						-- execute the Ban
						net.send_chat_to("I have swung the banhammer on "..playerToKickName.." for you! playerID: "..playerToKickID, playerID, koServer.serverID)
						net.kick(playerToKickID, playerToKickName..": You have been banned by the Admin!")
						playerToKick.name = playerToKickName
						playerToKick.numKicks = playerToKick.numKicks or 0
						playerToKick.numKicks = playerToKick.numKicks + 1
						playerToKick.status = "banned"
						-- TODO
					else
						net.send_chat_to("Kicked player: "..playerToKickName..", playerID: "..playerToKickID, playerID, koServer.serverID)
						net.kick(playerToKickID, playerToKickName..": You have been kicked by the Admin!")
						playerToKick.name = playerToKickName
						playerToKick.numKicks = playerToKick.numKicks or 0
						playerToKick.numKicks = playerToKick.numKicks + 1
					end
					
					koServer.saveVipPlayerData()
	
					return ""
				else
					net.send_chat_to("Sorry, we could not identify the player", playerID, koServer.serverID)
				end
	
				net.send_chat_to("invalid Player ID, unable to Kick: "..playerToKickID.."("..tostring(playerToKickName)..")", playerID, koServer.serverID)		
				
				return ""
				
			-- kick
			elseif taskCommand == "unban" then
				-- check what's the task.
				if nextSpace == -1 then
					net.send_chat_to("who shalt I "..taskCommand.." for you?", playerID, koServer.serverID)
					return ""	-- no task specified
				end
				
				--kick who?
				curSpace = nextSpace+2
				local playerToUnbanID = tonumber(string.sub(task, curSpace))
				local playerToUnbanUCID = koServer.bannedList[playerToUnbanID]
				local playerToUnban = koServer.getVipPlayerData(playerToUnbanUCID)
				local playerToUnbanName = playerToUnban.name
				
				net.log("trying to "..taskCommand.." "..playerToUnbanName.."("..playerToUnbanID..")")
				
				if playerToUnban then
					playerToUnban.status = "Ok"
					
					net.send_chat_to("Player "..playerToUnbanName.." has been unbanned", playerID, koServer.serverID)
				end
				
				koServer.saveVipPlayerData()
				
				
			-- ban ucid
			elseif taskCommand == "banucid" then
				if nextSpace == -1 then
					net.send_chat_to("who shalt I "..taskCommand.." for you?", playerID, koServer.serverID)
					return ""	-- no task specified
				end
				
				--kick who?
				curSpace = nextSpace+2
				local playerToBanUCID = tostring(string.sub(task, curSpace))
				local playerToBan = koServer.insertToVipPlayerData(playerToBanUCID)
				if playerToBan then
					playerToBan.status = "banned"
					net.send_chat_to("Player UCID"..playerToBanUCID.." has been banned", playerID, koServer.serverID)
					koServer.saveVipPlayerData()		
				end	
			
				
			-- list players
			elseif taskCommand == "plist" or taskCommand == "playerlist" or string.lower(taskCommand) == "listplayers" then
				net.log("list players")
								
				-- check if the playerID is valid
				local playerList = net.get_player_list()
				local messageString = "List of Players on the Server:\n\n"
				--net.log("playerList = " ..koServer.TableSerialization(playerList))
				for i, clientID in pairs(playerList) do
					--find the players name
					local curPlayerName = net.get_player_info(clientID, "name") or "nil"
					messageString = messageString.." | "..clientID..": "..curPlayerName
				end
				
				net.send_chat_to(messageString, playerID, koServer.serverID)
				net.log("ServerMessage: "..messageString)
				return ""
				
			-- list banned
			elseif taskCommand == "blist" or taskCommand == "banlist" or string.lower(taskCommand) == "listbanned" then
				net.log("list banned players")
								
				-- check if the playerID is valid
				local messageString = "List of banned Playersr: "
				--net.log("playerList = " ..koServer.TableSerialization(playerList))
				koServer.VipPlayerData = koServer.VipPlayerData or koServer.loadVipPlayerData()
				koServer.bannedList = {} -- reset the list
				
				for ucid, playerData in pairs(koServer.VipPlayerData) do
					if playerData.status == "banned" then
						table.insert(koServer.bannedList,ucid)
						messageString = messageString.." | "..playerData.name..": "..#koServer.bannedList
					end
				end
				
				net.send_chat_to(messageString, playerID, koServer.serverID)
				net.log("ServerMessage: "..messageString)
				return ""
				
			-- debugmenu
			elseif taskCommand == "makeadmin" then
				curSpace = nextSpace+2
				local newAdminID = tonumber(string.sub(task, curSpace))
				
				--find the players name
				local newAdminName = net.get_player_info(newAdminID, "name")
				local newAdminUCID = net.get_player_info(newAdminID, "ucid")
				local newAdmin = koServer.getVipPlayerData(newAdminUCID) or koServer.insertToVipPlayerData(newAdminUCID)
				newAdmin.status = "Admin"
				newAdmin.name = newAdminName
				net.send_chat_to("You have been promoted to Admin", newAdminID, koServer.serverID)
				net.send_chat_to(newAdminName.." has been promoted to Admin", playerID, koServer.serverID)
				
				koServer.saveVipPlayerData()
				
			elseif taskCommand == "debug" then	
				net.dostring_in('server', 'env.info("DEBUG TEXT FROM CLIENT SIDE CAllED!!!"')
				net.dostring_in('server', 'env.info("name = '..playerInfo.name..'")')
				net.dostring_in('mission', 	'koEngine.makeDebugMenu("'..playerInfo.name..'")')
				
			elseif taskCommand == "debug1" then	
				net.dostring_in('server', 	[[
											env.info("mission was called from client!!! []") 
											if koEngine then
												env.info("koEngine exists")
											else
												env.info("koEngine does not exist")
											end
											koEngine = koEngine or {}	
											koEngine.makeDebugMenu()
											]])
			
			elseif taskCommand == "reload" then
				net.log("reload called by admin: "..playerInfo.name)
				net.log(DCS.getMissionName())
				local msg = "reloading Mission '"..DCS.getMissionName().."'"
				net.send_chat_to(msg, playerID, koServer.serverID)
				net.load_mission(koServer.ConfigDirectory .. DCS.getMissionName()..".miz")
			elseif taskCommand == "help" or taskCommand == "?" then
				local msg = "Admin Commands at your disposal: kick 'id': kick player | ban 'id': ban player | tospec 'id': send player to spectators | unban: 'name': unban player | plist: list players to get player IDs | blist: list all banned players | reload: reload mission"
				net.send_chat_to(msg, playerID, koServer.serverID)
			end
			return ""
						
		end
		
		net.send_chat_to("Admin here", playerID, koServer.serverID)
		return ""
	end
	
	--net.log("onPlayerTrySendChat("..playerID..", '"..message.."', all="..tostring(all))
	--[[if all == -2 then
		net.log("converting to teammessage")
		return "TEAM: "..message 
	end---]]
	
	return message
end


koServer.onMissionLoadEnd = function()
	if not koServer.isValid() then return end
	-- put the Server into red game-master slot
	net.log("mission loaded, forcing server into Game Master slot, resetting slotlist")
	net.force_player_slot(1, 1, 'instructor_red_1')
	
	-- reset slotlist, because nobody is in a slot at mission start, and client IDs may have shifted!
	koServer.slotTable = {	
		[1] = { 			-- red units
			Fighter = {},	Striker = {},	Helicopter = {},		},
		[2] = { 			-- blue units
			Fighter = {},	Striker = {},	Helicopter = {},		}
	}
	
	koServer.lastFrameCheck = DCS.getModelTime()
end

koServer.onSimulationStart = function()
	if not koServer.isValid() then return end
	net.log("onSimulationStart()")
	koServer.serverID = net.get_server_id()
end

koServer.onSimulationEnd = function()
	if not koServer.isValid() then return end
	net.log("onSimulationEnd()")
	
	koServer.slotTable = {	
		[1] = { 			-- red units
			Fighter = {},	Striker = {},	Helicopter = {},		},
		[2] = { 			-- blue units
			Fighter = {},	Striker = {},	Helicopter = {},		}
	}
	
	koServer.savePlayerData()
end

koServer.lastFrameCheck = 0
koServer.frameCheckInterval = 5 		-- run the loop every 5 seconds, not every frame to save performance
koServer.onSimulationFrame = function()
	if not koServer.isValid() then return end
	
	local received = koServer.UDPSavegameReceiveSocket:receive()
	
	if received then
		net.log("Savegame received")
		local MissionData = koServer.JSON:decode(received)
	    if MissionData then
	    	net.log("MissionData received!")
	    	koServer.MissionData = MissionData
		end
	end
	
	-- check if we receive testmessage from mission
	--[[local received = koServer.UDPGameGuiReceiveSocket:receive()
	
	if received then
		net.log("client list received")
		local test = koServer.JSON:decode(received)
	    if test then
	    	net.log("test received: "..koServer.TableSerialization(test))
		end
	end
	
	local testMsg = {
		test2 = "test2",
	}
	socket.try(koServer.UDPSendSocket:sendto(koServer.JSON:encode(testMsg).." \n", "127.0.0.1", koServer.GAMEGUI_SEND_TO_PORT))--]]
	
	--net.log("modelTime = "..DCS.getModelTime()..", lastFramecheck = "..koServer.lastFrameCheck..", diff = "..(DCS.getModelTime() - koServer.lastFrameCheck))
	if DCS.getModelTime() > 1 and (DCS.getModelTime() - koServer.lastFrameCheck) > koServer.frameCheckInterval then
		koServer.spawnAttempts = {}	-- reset spawn-attempts every 5 seconds
		koServer.updatePlayerList()
		koServer.lastFrameCheck = DCS.getModelTime()
		
		--net.dostring_in('server', 'trigger.action.outText("'..tostring(DCS.getModelTime())..'", 15)')
		--net.log(tostring(DCS.getModelTime()))
	end
end

koServer.onShowPool = function()
	if not koServer.isValid() then return end
	
	-- implement message for external scoreboard on taw.net/tko (if the function would be called after all)
end


-- Used to handle banned players, server not being up, invalid connect attempt, 
koServer.onPlayerTryConnect = function(addr, name, ucid, playerID) --> true | false, "disconnect reason"
	if not koServer.isValid() then return true end
	net.log("onPlayerTryConnect()")
	
	if not DCS.getModelTime() or DCS.getModelTime() < 20 then
		net.log("refused connection due to mission not ready: addr: "..tostring(addr)..", name: "..tostring(name).." ucid: "..tostring(ucid).." playerID: "..tostring(playerID))
		return false, "connection denied, server not ready!"
	end 
	
	if not addr or not name or name == '' or name == ' ' or not ucid or not playerID then
		net.log("WARN: Player connection denied for invalid parameters: addr: "..tostring(addr)..", name: "..tostring(name).." ucid: "..tostring(ucid).." playerID: "..tostring(playerID))
		return false, "connection denied for invalid connection parameters"
	end
	
	-- check if the player was banned
	local playerData = koServer.getVipPlayerData(ucid)
	if playerData and playerData.status == "banned" then
		net.log("Banned player"..name.." tried to connect! Kicking him")
		net.log("banned player: "..koServer.TableSerialization(playerData,0))
		
		playerData.numKicks = tonumber(playerData.numKicks) + 1
		
		return false, "Player "..playerData.name.." is blacklisted"
	end
	
	return true
end

koServer.onPlayerConnect = function(playerID)
	if not koServer.isValid() then return end
	
	if playerID == koServer.serverID then 
		return	-- if the server is changing slot there is no action required.
	end
	
	local player = net.get_player_info(playerID)
	
	if not player then
		net.log("no player, aborting")
		return
	elseif player.ucid == nil then
		net.log("FATAL ERROR: onPlayerConnect() - player ucid is nil!")
		return
	end
	
	net.log("onPlayerConnect("..player.name..", id = "..playerID..") Time = "..DCS.getModelTime())
	
	player.name = koServer.getPlayerNameFix(player.name)
	player.connectTime = DCS.getRealTime()
	
	local playerData = koServer.getPlayerData(player.ucid)
	
	--net.log("playerData = "..koServer.TableSerialization(playerData))
	
	playerData.id = player.id
	--playerData.ping = player.ping
	playerData.name = koServer.getPlayerNameFix(player.name)
	player.connectTime = DCS.getRealTime()
	
	koServer.playersOnline[player.id] = player.ucid
	koServer.playerList[player.ucid] = player
		
	--net.log("koServer.playerList = "..koServer.TableSerialization(koServer.playerList))

	-- TODO: Implement vipPlayerData
	-- check if the player was banned
	local vipPlayerData = koServer.getVipPlayerData(player.ucid)
	if vipPlayerData and vipPlayerData.status == "banned" then
		net.log("WARN: banned player made it to onConnect() should be intercepted by onTryConnect!")
		net.log("Banned player"..player.name.." tried to connect! Kicking him")
		net.log("banned player: "..koServer.TableSerialization(playerData,0))
		net.kick(playerID, playerData.name..": You are banned")
		playerData.numKicks = playerData.numKicks or 0
		playerData.numKicks = tonumber(playerData.numKicks) + 1
	end
	
	-- send connection message to mission side
	net.log("saving connection to mission side")
	local event = {
		achievment = "connected",
		playerName = playerData.name,
		playerUCID = player.ucid,
		playerUnit = player.ipaddr:sub(1, player.ipaddr:find(":")-1),	-- unit collects ip adress
		playerSide = "neutral",
		modelTime = DCS.getModelTime(),
		realTime = DCS.getRealTime(),
	}
	net.log("start filehandling")
	
	net.log("sending connect message to mission-side")
	socket.try(koServer.UDPSendSocket:sendto(koServer.JSON:encode(event).." \n", "127.0.0.1", koServer.GAMEGUI_SEND_TO_PORT))
	
		-- send welcome message
	local _chatMessage = string.format("Hello %s! Welcome to - The Kaukasus Offensive! Please have a look at the online map at: "..koServer.webAdress.."! Have fun!",playerData.name)
	net.send_chat_to(_chatMessage, playerID, koServer.serverID)
	net.send_chat_to("PLEASE UPDATE YOUR SIMPLE RADIO TO 1.2.8.1", playerID, koServer.serverID)
	
	--net.log("player = "..koServer.TableSerialization(player,0))
	koServer.savePlayerData()
	
	-- if player connects with a new name, add it to the list!
	--[[local hasChangedName = true
	for i, name in pairs(playerData.names) do
		if name and name == player.name then	
			hasChangedName = false -- not a new name
		end
	end
	if hasChangedName then	
		table.insert(playerData.names, koServer.getPlayerNameFix(player.name))  
	end 
	
	-- if player connects from a new ip, add it to the list!
	if player.ipaddr then
		playerData.ipaddress = player.ipaddr:sub(1, player.ipaddr:find(":")-1)
		local hasNewIP = true
		for i, ip in pairs(playerData.ipaddresses) do
			if ip and ip == playerData.ipaddress then	
				hasNewIP = false -- not a new name
				break
			end
		end
		if hasNewIP then	
			table.insert(playerData.ipaddresses, playerData.ipaddress)  
		end
	end--]]
end


function koServer.onPlayerDisconnect(id, reason)
	if not koServer.isValid() then return end
	net.log("onPlayerDisconnect(id = '"..id.."', reason = '"..reason.."')")
	
	--net.log("playersOnline = "..koServer.TableSerialization(koServer.playersOnline))
	local ucid = koServer.playersOnline[id]
	net.log("ucid = "..tostring(ucid))
	local playerData = koServer.getPlayerData(ucid)
	if playerData then
		net.log("disconnecting player '"..playerData.name.."'")
		
		--net.log("koSever.playerList: "..koServer.TableSerialization(koServer.playerList))
		--net.log("playerData: "..koServer.TableSerialization(playerData))
		local onlineTime = DCS.getRealTime() - koServer.playerList[ucid].connectTime
		-- send went to spectators message to mission side
		local event = {
			achievment = "disconnected",
			playerName = playerData.name,
			playerUnit = "disconnected",
			playerSide = "neutral",
			modelTime = DCS.getModelTime(),
			realTime = DCS.getRealTime(),
			onlineTime = onlineTime,
		}
		
		net.log("sending disconnect message to mission-side")
		socket.try(koServer.UDPSendSocket:sendto(koServer.JSON:encode(event).." \n", "127.0.0.1", koServer.GAMEGUI_SEND_TO_PORT))
		
	else
		net.log("disconnect unsuccessful, playerData invalid, playersOnline: "..koServer.TableSerialization(koServer.playersOnline))
	end
	
	
	koServer.playersOnline[id] = nil
	koServer.playerList[ucid] = nil
	
	koServer.removeIdFromSlotTable(id)
	koServer.updatePlayerList()
end

koServer.updatePlayerList = function()
	--update the player list
	net.log("updating playerList")
	
	--net.log("net.get_player_list(): "..koServer.TableSerialization(playerList))
	for ucid, player in pairs(koServer.playerList) do
		local playerInfo = net.get_player_info(player.id)
		
		if playerInfo and player.id ~= koServer.serverID then
			player.name = koServer.getPlayerNameFix(player.name)
			player.ping = playerInfo.ping
			player.side = playerInfo.side
			player.slot = playerInfo.slot
			koServer.playerList[ucid] = player
			koServer.playersOnline[player.id] = player.ucid
		else
			net.log("playerInfo for player "..player.name..", id "..player.id.." is invalid, probably disconnected already?")
			--koServer.playerList[ucid] = nil
			--koServer.playersOnline[player.id] = nil
		end
	end
	
	koServer.savePlayerData()
end

function koServer.getPlayerData(playerUCID)
	if not playerUCID then
		net.log("ERROR: playerUCID = nil")
		return
	end
	
	if not koServer.PlayerData then
		net.log("koServer.getPlayerData() - not PlayerData, loading")
		koServer.PlayerData = koServer.loadPlayerData()
	end

	if koServer.PlayerData[playerUCID] == nil then
		net.log("koServer.getPlayerData() - not PlayerData["..tostring(playerUCID).."] - creating new {}")
		koServer.PlayerData[playerUCID] = {} -- get a new reference to the now created table
	end

	return koServer.PlayerData[playerUCID]
end

function koServer.getVipPlayerData(playerUCID)
	if not playerUCID then
		net.log("ERROR: playerUCID = nil")
		return
	end
	
	if not koServer.VipPlayerData then
		net.log("koServer.getVipPlayerData() - not vipPlayerData, loading")
		koServer.VipPlayerData = koServer.loadVipPlayerData()
	end

	return koServer.VipPlayerData[playerUCID]
end

function koServer.insertToVipPlayerData(playerUCID)
	if not playerUCID then
		net.log("ERROR: playerUCID = nil")
		return
	end
	
	if not koServer.VipPlayerData then
		net.log("koServer.getPlayerData() - not vipPlayerData, loading")
		koServer.VipPlayerData = koServer.loadVipPlayerData()
	end
	
	koServer.VipPlayerData[playerUCID] = koServer.VipPlayerData[playerUCID] or {}
	
	return koServer.VipPlayerData[playerUCID]
end

-- returns false if the wrong mission is loaded
function koServer.isValid()
	if not DCS.isServer() and not DCS.isMultiplayer() then
		return false
	end
	
	--[[local missionName = string.sub(DCS.getMissionName(),1,22)
	if missionName ~= "The Kaukasus Offensive" then
		return false
	end--]]
	
	--net.log("koServer.isValid() failed, '"..DCS.getMissionName().."' is not known to require KO-Server Tools!")
	return true
end

--from http://lua-users.org/wiki/CopyTable
koServer.deepCopy = function(object)
	local lookup_table = {}
	local function _copy(object)
		if type(object) ~= "table" then
			return object
		elseif lookup_table[object] then
			return lookup_table[object]
		end
		local new_table = {}
		lookup_table[object] = new_table
		for index, value in pairs(object) do
			new_table[_copy(index)] = _copy(value)
		end
		return setmetatable(new_table, getmetatable(object))
	end
	return _copy(object)
end


DCS.setUserCallbacks(koServer)
koServer.PlayerData = koServer.loadPlayerData()

--[[if koServer.PlayerData then
	net.log("playerData is valid")
	for ucid, player in pairs(koServer.PlayerData) do
		koServer.PlayerData[ucid] = {
			id = player.id,
			name = player.name,
		}
	end
else
	net.log("no playerdata")
end

koServer.savePlayerData()--]]
net.log("\nKaukasus Offensive Server Tools ready\n----------------------------------------------") 
