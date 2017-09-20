-- Mock objects for debugging outside of DCS

net = {}
net.log = function(m) print(m) end
net.get_player_info = function(id, param)
  local playerObj = {}
  if id == 2 then
    playerObj =
    {
      ucid = "AAA",
      name = "Igneous",
      id = 2,
      ipaddr = "127.0.0.1:9999",
      slot = 1
    }
  elseif id == 3 then
    playerObj =
    {
      ucid = "BBB",
      name = "DemoPlayer",
      id = 3,
      ipaddr = "127.0.0.2:9999",
      slot = 2
    }
  end
  
  if param then
    if param == "ucid" then
      return playerObj.ucid
    elseif param == "name" then
      return playerObj.name
    end
  else
    return playerObj
  end
end
net.send_chat_to = function(msg, toId, fromID)
  print("to: " .. tostring(toId) .. " - " .. msg)
end
lfs = {}
lfs.writedir = function() return "C:\\Users\\Sapphire\\Saved Games\\DCS\\" end
DCS = {}
DCS.Clock = 20
DCS.getUnitType = function(slotID)
  if slotID == 1 then
    return "KA50"
  else
    return "observer"
  end
end
DCS.getMissionName = function() return "Kaukasus Insurgency" end
DCS.setUserCallbacks = function(obj) 
  DCS.onSimulationFrame = obj.onSimulationFrame
  DCS.onPlayerTryConnect = obj.onPlayerTryConnect
  DCS.onPlayerTryChangeSlot = obj.onPlayerTryChangeSlot
  DCS.onGameEvent = obj.onGameEvent
  DCS.onPlayerDisconnect = obj.onPlayerDisconnect
  DCS.onPlayerConnect = obj.onPlayerConnect
  DCS.onShowPool = obj.onShowPool
end
DCS.getUnitType = function(slotID) return "KA50" end
DCS.isServer = function() return true end
DCS.isMultiplayer = function() return true end
DCS.getModelTime = function() 
  local _t = DCS.Clock 
  DCS.Clock = DCS.Clock + 5
  return _t
end
DCS.getRealTime = function() 
  local _t = DCS.Clock 
  DCS.Clock = DCS.Clock + 5
  return _t
end

local function sleep(n)
  if n > 0 then os.execute("ping -n " .. tonumber(n+1) .. " localhost > NUL") end
end

local function Main()
  while true do
    
    sleep(1)
    DCS.onSimulationFrame()
    DCS.onShowPool()
    sleep(1)
    DCS.onPlayerTryConnect("127.0.0.1:9999", "Igneous", "AAA", 1)
    DCS.onPlayerConnect(2)
    sleep(1)
    DCS.onPlayerTryChangeSlot(2, 1, 1)
    DCS.onGameEvent("self_kill",2,nil,nil,nil)
    DCS.onSimulationFrame()
    sleep(1)
    DCS.onGameEvent("self_kill",2,nil,nil,nil)
    DCS.onPlayerTryChangeSlot(2, 1, 1)
    DCS.onGameEvent("shot",2,nil,nil,nil)
    DCS.onSimulationFrame()
    sleep(1)
    DCS.onPlayerTryConnect("127.0.0.2:9999", "DemoPlayer", "BBB", 3)
    DCS.onPlayerConnect(3)
    DCS.onSimulationFrame()
    DCS.onPlayerDisconnect(2, "Disconnected")
    DCS.onPlayerDisconnect(3, "Disconnected")
  end
end








-- KI Server
-- Server Side Mod that manages certain game events in Kaukasus Insurgency
net.log("KI Server Invoked - Starting KI Server Tools...")

package.path  = package.path..";.\\LuaSocket\\?.lua;"
package.cpath = package.cpath..";.\\LuaSocket\\?.dll;"

local JSON = loadfile("S:\\Eagle Dynamics\\DCS World\\DCS World\\Scripts\\JSON.lua")()
local socket = require("socket")

KIServer = {}
KIServer.OnlinePlayers = {} 			-- hash of current online players (using PlayerID as key)
KIServer.BannedPlayers = {}				-- array of banned players (ucid, ucid, ucid, etc...)
KIServer.NoLivesPlayers = {}      -- hash of players that have no more lives (using UCID as key)
KIServer.SocketDelimiter = "\n\n\n\n\n"	-- delimiter used to segment messages
KIServer.JSON = JSON
KIServer.LastOnFrameTime = 0

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
KIServer.UDPSendSocket = socket.udp()
KIServer.UDPReceiveSocket = socket.udp()
KIServer.UDPReceiveSocket:setsockname("*", KIServer.GAMEGUI_RECEIVE_PORT)
KIServer.UDPReceiveSocket:settimeout(.0001) --receive timer


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



KIServer.IsPlayerBanned = function(ucid)
	if KIServer.BannedPlayers[ucid] ~= nil then
		return true
	else
		return false
	end
end



KIServer.IsPlayerOutOfLives = function(ucid)
  if KIServer.NoLivesPlayers[ucid] ~= nil then
		return true
	else
		return false
	end
end


-- Used to get around issues with player names having invalid characters
function KIServer.GetPlayerNameFix(playerName)
	if not playerName then 
		return nil
	end
	
	local playerFixedName = playerName:gsub("'"," ")
	playerFixedName = playerFixedName:gsub('"',' ')
	playerFixedName = playerFixedName:gsub('=','-')
	
	return playerFixedName
end


function KIServer.SanitizeArray(array)
    local tbl = {}
    for _, item in pairs(array) do
        if(item ~= nil) then
            tbl[tostring(_)] = item
        end
    end
    return tbl
end















-- DCS SERVER EVENT HOOKS
KIHooks = {}



-- Main Loop for KIServer - tries to receive updated Banned List and Player Life List from Mission Side socket
KIHooks.onSimulationFrame = function()
	if not KIServer.IsRunning() then return end
	
  local ElapsedTime = DCS.getModelTime() - KIServer.LastOnFrameTime
  if ElapsedTime >= KIServer.DataRefreshRate then
    
    -- Receive updated Banned and No Lives Players list
    local received = KIServer.UDPReceiveSocket:receive()
    if received then
      net.log("KIServer - UDP Data stream received")
      local Data = KIServer.JSON:decode(received)
      if Data then
        net.log("Data received!")
        KIServer.BannedPlayers = Data["BannedPlayers"]
        KIServer.NoLivesPlayers = Data["NoLivesPlayers"]
      end
    end
    
    KIServer.OnlinePlayers = KIServer.SanitizeArray(KIServer.OnlinePlayers)
    -- send Online Player list to UI
    socket.try(KIServer.UDPSendSocket:sendto(KIServer.JSON:encode(KIServer.OnlinePlayers) .. KIServer.SocketDelimiter, 
               "127.0.0.1", KIServer.GAMEGUI_SEND_TO_PORT))
	end
end



KIHooks.onShowPool = function()
	if not KIServer.IsRunning() then return end
	
	-- stub for potential future handler message
end



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
		net.log("KIHooks.onPlayerTryConnect() - Banned player " .. name .. " tried to connect! Kicking him")
		return false, "Player " .. name .. " is blacklisted from playing on this server!"
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
	KIServer.OnlinePlayers[tostring(player.id)] = player.ucid
	local IsBanned = KIServer.IsPlayerBanned(player.ucid)

	if IsBanned then
		net.log("WARN: banned player made it to onConnect() should be intercepted by onTryConnect!")
		net.log("Banned player" .. player.name .. " tried to connect! Kicking him")
		net.kick(playerID, KIServer.GetPlayerNameFix(player.name) .. ": You are banned")
	end
  
	-- send connection message to mission side
	net.log("Preparing UDP Send of connected event")
	local ServerEvent = 
	{
		Type = "CONNECTED",
		Name = KIServer.GetPlayerNameFix(player.name),
		UCID = player.ucid,
		ID = player.id,
		IP = player.ipaddr:sub(1, player.ipaddr:find(":")-1),
		GameTime = DCS.getModelTime(),
		RealTime = DCS.getRealTime()
	}
	net.log("sending connect message to mission-side")
	socket.try(KIServer.UDPSendSocket:sendto(KIServer.JSON:encode(ServerEvent) .. KIServer.SocketDelimiter, 
                                           "127.0.0.1", KIServer.GAMEGUI_SEND_TO_PORT))
	
	-- send welcome messages
	local _chatMessage = string.format("Hello %s! Welcome to  Kaukasus Insurgency!", player.name)
	net.send_chat_to(_chatMessage, playerID, KIServer.ServerPlayerID)
	if KIServer.WelcomeMessages then
		for i = 1, #KIServer.WelcomeMessages do
		  net.send_chat_to(tostring(KIServer.WelcomeMessages[i]), playerID, KIServer.ServerPlayerID)
		end
	end
end



function KIHooks.onPlayerDisconnect(playerID, reason)
	-- ignore this handler if KI is not the mission being run, we dont want to interfere with other missions
  -- the server may be hosting
	if not KIServer.IsRunning() then return true end
	net.log("KIHooks.onPlayerDisconnect called (playerID = '" .. playerID .. "', reason = '" .. reason .. "')")
	
	-- Remove person from the OnlinePlayers list
	KIServer.OnlinePlayers[tostring(playerID)] = nil
	local player = net.get_player_info(playerID)
	if player then
		net.log("disconnecting player '" .. KIServer.GetPlayerNameFix(player.name) .. "'")
		local ServerEvent = 
		{
			Type = "DISCONNECTED",
			Name = KIServer.GetPlayerNameFix(player.name),
			UCID = player.ucid,
			ID = player.id,
			IP = player.ipaddr:sub(1, player.ipaddr:find(":")-1),
			GameTime = DCS.getModelTime(),
			RealTime = DCS.getRealTime()
		}
		
		net.log("sending disconnect message to mission-side")
		socket.try(KIServer.UDPSendSocket:sendto(KIServer.JSON:encode(ServerEvent) .. KIServer.SocketDelimiter, 
                                             "127.0.0.1", KIServer.GAMEGUI_SEND_TO_PORT))	
	else
		net.log("KIHooks.onPlayerDisconnect() - ERROR - disconnect unsuccessful, get_player_info returned nil")
	end
end



--DOC
-- onGameEvent(eventName,arg1,arg2,arg3,arg4)
--"friendly_fire", playerID, weaponName, victimPlayerID
--"mission_end", winner, msg
--"kill", killerPlayerID, killerUnitType, killerSide, victimPlayerID, victimUnitType, victimSide, weaponName
--"self_kill", playerID
--"change_slot", playerID, slotID, prevSide
--"connect", id, name
--"disconnect", ID_, name, playerSide
--"crash", playerID, unit_missionID
--"eject", playerID, unit_missionID
--"takeoff", playerID, unit_missionID, airdromeName
--"landing", playerID, unit_missionID, airdromeName
--"pilot_death", playerID, unit_missionID
KIHooks.onGameEvent = function(eventName,playerID,arg2,arg3,arg4)
  -- must check this to prevent a possible CTD 
  -- by using a_do_script before the game is ready to use a_do_script. -- Source GRIMES :)
  if DCS.isServer() and DCS.isMultiplayer() and DCS.getModelTime() > 1 then
    
    if eventName == "self_kill"
    or eventName == "crash"
    or eventName == "eject"
    or eventName == "pilot_death" then
      -- obtain player information
      local player = net.get_player_info(playerID)
      if player ~= nil and player.side ~= 0 and player.slot ~= "" and player.slot ~= nil then
        
        -- check if the slot was a non flyable spot, ignore any events for those slots
        local _unitRole = DCS.getUnitType(player.slot)
        if _unitRole ~= nil and
          ( _unitRole == "forward_observer"
            or _unitRole == "instructor"
            or _unitRole == "artillery_commander"
            or _unitRole == "observer"
          )
        then 
          return true 
        end

        local ServerEvent = 
        {
          Type = "DEATH",
          Name = KIServer.GetPlayerNameFix(player.name),
          UCID = player.ucid,
          ID = player.id,
          IP = player.ipaddr:sub(1, player.ipaddr:find(":")-1),
          GameTime = DCS.getModelTime(),
          RealTime = DCS.getRealTime()
        }
        
        net.log("sending player death message to mission-side")
        socket.try(KIServer.UDPSendSocket:sendto(KIServer.JSON:encode(ServerEvent) .. KIServer.SocketDelimiter, 
                                                "127.0.0.1", KIServer.GAMEGUI_SEND_TO_PORT))	

      end  
    end
  end
end



KIHooks.onPlayerTryChangeSlot = function(playerID, side, slotID)
  net.log("KIHooks.onPlayerTryChangeSlot() called")
  if DCS.isServer() and DCS.isMultiplayer() and (side ~= 0 and slotID ~= '' and slotID ~= nil) then
    local _ucid = net.get_player_info(playerID, 'ucid')
    local _playerName = net.get_player_info(playerID, 'name')
    if _playerName == nil then return true end

    net.log("KIHooks.onPlayerTryChangeSlot - Player Selected slot - player: " 
            .. _playerName .. " side:" .. side .. " slot: " .. slotID .. " ucid: " .. _ucid)

    local _unitRole = DCS.getUnitType(slotID)

    if _unitRole ~= nil and
      (
        _unitRole == "forward_observer"
        or _unitRole == "instructor"
        or _unitRole == "artillery_commander"
        or _unitRole == "observer"
      )
    then
      return true   -- ignore attempts to slot into non airframe roles
    else
      
      if KIServer.IsPlayerOutOfLives(_ucid) then
        net.log("KIHooks.onPlayerTryChangeSlot - Player '" .. _playerName .. "' has run out of lives")
        local _chatMessage = string.format("*** %s - You have run out of lives and can no longer slot into an airframe! Player Lives return once every hour! ***",_playerName)
        net.send_chat_to(_chatMessage, playerID)
        return false
      else
        return true
      end
      
    end
  else
    return true
  end
end


















DCS.setUserCallbacks(KIHooks)
net.log("KI Server Tools Initialization Complete")

Main()