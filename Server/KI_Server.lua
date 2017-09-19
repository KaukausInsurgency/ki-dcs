-- KI Server
-- Server Side Mod that manages certain game events in Kaukasus Insurgency
net.log("KI Server Invoked - Starting KI Server Tools...")

package.path  = package.path..";.\\LuaSocket\\?.lua;"
package.cpath = package.cpath..";.\\LuaSocket\\?.dll;"

local JSON = loadfile("Scripts\\JSON.lua")()
local socket = require("socket")

KIServer = {}
KIServer.OnlinePlayers = {} 
KIServer.PlayerLog = {}
KIServer.JSON = JSON


local function InitKIServerConfig()
  local UseDefaultConfig = false
  net.log("InitKIServerConfig() called")
  
  local _file, _error = loadfile(lfs.writedir() .. [[Missions\\Kaukasus Insurgency\\Server\\KIServerConfig.lua]])
  if _file then
    local _success, _config = xpcall(_file, function(err) end)
    if _success and _config then
      KIServer.MissionName = _config["MissionName"]
      KIServer.DataRefreshRate = _config["DataRefreshRate"]
      KIServer.ServerPlayerID = _config["ServerPlayerID"]
      
      KIServer.ConfigDirectory = _config["ConfigDirectory"]
      KIServer.LogDirectory = _config["LogDirectory"]
      KIServer.BannedPlayerFileDirectory = _config["BannedPlayerFileDirectory"]
      
      KIServer.GAMEGUI_SEND_TO_PORT = tonumber(_config["GAMEGUI_SEND_TO_PORT"])
      KIServer.GAMEGUI_RECEIVE_PORT = tonumber(_config["GAMEGUI_RECEIVE_PORT"])	
      KIServer.SAVEGAME_RECEIVE_PORT = tonumber(_config["SAVEGAME_RECEIVE_PORT"])
      
      KIServer.WelcomeMessages = _config["WelcomeMessages"]
      
      
    else
      net.log("InitKIServerConfig() - ERROR - Configuration is empty or corrupt")
      UseDefaultConfig = true
    end
  else
    net.log("InitKIServerConfig() - ERROR opening Config file (reason: " .. _error .. ")")
    UseDefaultConfig = true
  end
  
  if UseDefaultConfig then
    net.log("InitKIServerConfig() - There was a problem reading from an existing config - using default settings")
    KIServer.MissionName = "Kaukasus Insurgency"
    KIServer.DataRefreshRate = 30   -- how often should the server check the UDP Socket to update its data in memory
    KIServer.ServerPlayerID = 1     -- The player ID of the server that is hosting the mission (host will always be 1)
    
    KIServer.ConfigDirectory = lfs.writedir() .. [[Missions\\Kaukasus Insurgency\\Server\\]]
    KIServer.LogDirectory = KIServer.ConfigDirectory .. [[KIServerLog.log]]
    KIServer.BannedPlayerFileDirectory = KIServer.ConfigDirectory .. [[KIBannedPlayers.lua]]
    
    KIServer.GAMEGUI_SEND_TO_PORT = 6005
    KIServer.GAMEGUI_RECEIVE_PORT = 6006	
    KIServer.SAVEGAME_RECEIVE_PORT = 6007
    
    KIServer.WelcomeMessages =
    {
      "Welcome to Kaukasus Insurgency - We hope you enjoy your time here",
      "Please check the briefing and the F10 Map for information about active missions, objectives, and enemies",
      "Our website is www.examplewebsite.com - please visit us for more info",
      "PLEASE UPDATE YOUR SIMPLE RADIO TO 1.2.8.1"
    }
  end
end

InitKIServerConfig()

-- Initialize Sockets
koServer.UDPSendSocket = socket.udp()
koServer.UDPSavegameReceiveSocket = socket.udp()
koServer.UDPSavegameReceiveSocket:setsockname("*", koServer.SAVEGAME_RECEIVE_PORT)
koServer.UDPSavegameReceiveSocket:settimeout(.0001) --receive timer
koServer.UDPGameGuiReceiveSocket = socket.udp()
koServer.UDPGameGuiReceiveSocket:setsockname("*", koServer.GAMEGUI_RECEIVE_PORT)
koServer.UDPGameGuiReceiveSocket:settimeout(.0001) --receive timer


-- Checks whether the KI Server is running, by checking if the current game session is Multiplayer + Server Side
-- And if the mission name contains 'Kaukasus Insurgency'
KIServer.IsRunning = function()
  net.log("KIServer.IsRunning() called")
  if not DCS.isServer() and not DCS.isMultiplayer() then
		return false
	end
	
  net.log("KIServer.IsRunning() - Current Running Mission : " .. DCS.getMissionName())
	local missionName = DCS.getMissionName()
	if string.match(DCS.getMissionName(), KIServer.MissionName) then
    net.log("KIServer.IsRunning() - Kaukasus Insurgency Is ON")
		return true
	end
	
	net.log("KIServer.IsRunning() - Kaukasus Insurgency Is OFF")
	return false
end

-- MOCK UP
KIServer.IsPlayerBanned = function(ucid)
  return false
end


-- Used to get around issues with player names having invalid characters
function KIServer.getPlayerNameFix(playerName)
	if not playerName then 
		return nil
	end
	
	local playerFixedName = playerName:gsub("'"," ")
	playerFixedName = playerFixedName:gsub('"',' ')
	playerFixedName = playerFixedName:gsub('=','-')
	
	return playerFixedName
end


















-- DCS SERVER EVENT HOOKS
KIHooks = {}


-- Used to handle banned players, server not being up, invalid connect attempt, 
-- should return > true | false, "disconnect reason"
KIHooks.onPlayerTryConnect = function(addr, name, ucid, playerID) 
  -- ignore this handler if KI is not the mission being run, we dont want to interfere with other missions
  -- the server may be hosting
	if not KIServer.IsRunning() then return true end
	net.log("KIHooks.onPlayerTryConnect() called")
	
  -- If the game simulation time has not started, or has not reached a certain period of time
  -- Deny the connection
	if not DCS.getModelTime() or DCS.getModelTime() < 20 then
		net.log("KIHooks.onPlayerTryConnect() - refused connection due to mission not being loaded (addr: "
            .. tostring(addr) .. ", name: " .. tostring(name) 
            .. " ucid: " .. tostring(ucid) .. " playerID: " ..tostring(playerID) .. ")")
		return false, "connection denied, server is still loading mission!"
	end 

	if not addr or not name or name == '' or name == ' ' or not ucid or not playerID then
		net.log("KIHooks.onPlayerTryConnect() - WARNING - Player connection denied due to invalid parameters: addr: " 
            .. tostring(addr) .. ", name: " .. tostring(name) .. " ucid: " .. tostring(ucid) .. " playerID: " .. tostring(playerID))
		return false, "connection denied for invalid connection parameters"
	end
	
	if KIServer.IsPlayerBanned(ucid) then
		net.log("KIHooks.onPlayerTryConnect() - Banned player" .. name .. " tried to connect! Kicking him")
		--net.log("KIHooks.onPlayerTryConnect() - Banned player: " .. koServer.TableSerialization(playerData,0))
		--playerData.numKicks = tonumber(playerData.numKicks) + 1
		
		return false, "Player " .. playerData.name .. " is blacklisted from playing on this server!"
	end
	
	return true
end


KIHooks.onPlayerConnect = function(playerID)
	-- ignore this handler if KI is not the mission being run, we dont want to interfere with other missions
  -- the server may be hosting
	if not KIServer.IsRunning() then return end
  
	net.log("KIHooks.onPlayerConnect() called")
  
  
  
  
  -- Validate the player object
	if playerID == KIServer.ServerPlayerID then return end -- if the server is changing slot there is no action required
	local player = net.get_player_info(playerID)
	if not player then
		net.log("no player, aborting")
		return
	elseif player.ucid == nil then
		net.log("KIHooks.onPlayerConnect() ERROR - player ucid is nil!")
		return
	end
	
	net.log("KIHooks.onPlayerConnect(player: " .. player.name .. ", id: " .. playerID .. ") Time: " .. DCS.getRealTime() .. ")")
	
  
  
  
  -- either update the existing player record from the current log, or create a new one
  local PlayerStatObject = nil
  if KIServer.PlayerLog[player.ucid] then
    PlayerStatObject = KIServer.PlayerLog[player.ucid]
    -- update this information
    PlayerStatObject.Name = KIServer.getPlayerNameFix(player.name)
    PlayerStatObject.ConnectTime = DCS.getRealTime()
    PlayerStatObject.ID = player.id
  else
    PlayerStatObject = 
    {
      Name = KIServer.getPlayerNameFix(player.name),
      ConnectTime = DCS.getRealTime(),
      DisconnectTime = -1,
      ID = player.id,
      UCID = player.ucid
      NumKicks = 0
    }
  end

	if KIServer.IsPlayerBanned(PlayerStatObject.UCID) then
		net.log("WARN: banned player made it to onConnect() should be intercepted by onTryConnect!")
		net.log("Banned player" .. PlayerStatObject.Name .. " tried to connect! Kicking him")
		net.kick(playerID, PlayerStatObject.Name .. ": You are banned")
		PlayerStatObject.NumKicks = PlayerStatObject.NumKicks or 0
		PlayerStatObject.NumKicks = tonumber(PlayerStatObject.NumKicks) + 1
	end
  
  -- Update the two items in the collections
  KIServer.OnlinePlayers[PlayerStatObject.UCID] = PlayerStatObject
	KIServer.PlayerLog[PlayerStatObject.UCID] = PlayerStatObject
	
  
  
  
  
	-- send connection message to mission side
	net.log("Preparing UDP Send of connected event")
	local Event = {
		Type = "CONNECTED",
		Name = PlayerStatObject.Name,
		UCID = PlayerStatObject.UCID,
		IP = player.ipaddr:sub(1, player.ipaddr:find(":")-1),	-- unit collects ip adress
		GameTime = DCS.getModelTime(),
		RealTime = DCS.getRealTime(),
	}
	net.log("sending connect message to mission-side")
	socket.try(KIServer.UDPSendSocket:sendto(KIServer.JSON:encode(Event) .. " \n", "127.0.0.1", KIServer.GAMEGUI_SEND_TO_PORT))
	
  
  
  
  
  -- send welcome messages
  local _chatMessage = string.format("Hello %s! Welcome to  Kaukasus Insurgency!", playerData.name)
	net.send_chat_to(_chatMessage, playerID, KIServer.ServerPlayerID)
  if KIServer.WelcomeMessages then
    for i = 1, #KIServer.WelcomeMessages do
      net.send_chat_to(tostring(KIServer.WelcomeMessages[i]), playerID, KIServer.ServerPlayerID)
    end
	end
end



function KIHooks.onPlayerDisconnect(id, reason)
	-- ignore this handler if KI is not the mission being run, we dont want to interfere with other missions
  -- the server may be hosting
	if not KIServer.IsRunning() then return true end
	net.log("KIHooks.onPlayerDisconnect called (id = '" ..id .. "', reason = '" .. reason .. "')")
	
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
			Type = "DISCONNECTED",
			Name = playerData.name,
			UCID = "disconnected",
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


DCS.setUserCallbacks(KIHooks)
net.log("KI Server Tools Initialization Complete")