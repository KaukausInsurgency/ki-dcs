-- Mock objects for debugging outside of DCS

local JSONPath = "\\Scripts\\JSON.lua"
local IsMockTest = true

if IsMockTest then
  net = {}
  net.log = function(m) print(m) end
  net.get_player_info = function(id, param)
    local playerObj = {}
    if id == 1 then
      playerObj =
      {
        ucid = "SERVERUCID",
        name = "Server",
        id = 1,
        ipaddr = "127.0.0.0:9999",
        slot = 100
      }
    elseif id == 2 then
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
    elseif id == 4 then
      playerObj =
      {
        ucid = "CCC",
        name = "Jon Snow",
        id = 4,
        ipaddr = "127.0.0.3:9999",
        slot = 3
      }
    elseif id == 5 then
      playerObj =
      {
        ucid = "DDD",
        name = "Shady Guy",
        id = 5,
        ipaddr = "127.0.0.4:9999",
        slot = 4
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
  net.kick = function(pid, msg)
    print("KICKED PLAYERID: " .. tostring(pid) .. " - " .. msg)
  end
  lfs = {}
  lfs.writedir = function() return "C:\\Users\\Sapphire\\Saved Games\\DCS\\" end
  DCS = {}
  DCS.Clock = 20
  DCS.getUnitType = function(slotID)
    if slotID == 1 then
      return "KA50"
    elseif slotID == 2 then
      return "A10C"
    elseif slotID == 3 then
      return "F15C"
    elseif slotID == 4 then
      return "SU25T"
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
  DCS.isServer = function() return true end
  DCS.isMultiplayer = function() return true end
  DCS.getModelTime = function() 
    local _t = DCS.Clock 
    DCS.Clock = DCS.Clock + 30
    return _t
  end
  DCS.getRealTime = function() 
    local _t = DCS.Clock 
    DCS.Clock = DCS.Clock + 30
    return _t
  end

  function sleep(n)
    if n > 0 then os.execute("ping -n " .. tonumber(n+1) .. " localhost > NUL") end
  end

  function Main()
    local result, msg = DCS.onPlayerTryConnect("127.0.0.0:9999", "Server", "SERVERUCID", 1)
    if result then
      DCS.onPlayerConnect(1)
    else
      print("SERVER MESSAGE : " .. msg)
    end
    DCS.onSimulationFrame()
    DCS.onShowPool()
    
    -- simulate 2 players connecting
    if DCS.onPlayerTryConnect("127.0.0.1:9999", "Igneous", "AAA", 2) then
      DCS.onPlayerConnect(2)
    else
      DCS.onPlayerDisconnect(2, "Banned")
    end
    
    -- should fail because BBB is banned in database
    if DCS.onPlayerTryConnect("127.0.0.2:9999", "DemoPlayer", "BBB", 3) then
      DCS.onPlayerConnect(3)
    else
      DCS.onPlayerDisconnect(3, "Banned")
    end
    
    -- simulate playerID 2 changing slots twice
    DCS.onPlayerTryChangeSlot(2, 1, 1)    -- (playerID, side, slotID
    DCS.onPlayerTryChangeSlot(2, 1, 2)
    
    DCS.onSimulationFrame()
    DCS.onPlayerDisconnect(2, "Disconnected")
    
    -- try having fourth player connect
    if DCS.onPlayerTryConnect("127.0.0.3:9999", "Jon Snow", "CCC", 4) then
      DCS.onPlayerConnect(4)
    end
    
    -- PlayerID 4 (Jon Snow) out of lives in DB
    DCS.onPlayerTryChangeSlot(4, 1, 2)    -- should fail
    
    -- try invalid player connecting
    if DCS.onPlayerTryConnect("127.0.0.1:9999", nil, nil, 22) then
      DCS.onPlayerConnect(22)
    end
    
    DCS.onSimulationFrame()
    
    -- add 5th player connecting
    if DCS.onPlayerTryConnect("127.0.0.4:9999", "Shady Guy", "DDD", 5) then
      DCS.onPlayerConnect(5)
    end
    
    -- should receive updated player list with DDD being banned just after getting into the game
    DCS.onSimulationFrame() -- first run syncs up the online list on the mission script side
    DCS.onSimulationFrame() -- second run updates that player banned status to true
  end
  
  JSONPath = "S:\\Eagle Dynamics\\DCS World\\DCS World\\Scripts\\JSON.lua"
end 
-- END TEST MOCKUP DATA


















-- KI Server
-- Server Side Mod that manages certain game events in Kaukasus Insurgency
net.log("KI Server Invoked - Starting KI Server Tools...")

package.path  = package.path..";.\\LuaSocket\\?.lua;"
package.cpath = package.cpath..";.\\LuaSocket\\?.dll;"

local JSON = loadfile(JSONPath)()
local socket = require("socket")

KIServer = {}

KIServer.SocketDelimiter = "\n"	  -- delimiter used to segment messages (not needed for UDP)
KIServer.JSON = JSON
KIServer.LastOnFrameTime = 0
KIServer.ConfigFileDirectory = lfs.writedir() .. "Missions\\Kaukasus Insurgency\\Server\\KIServerConfig.lua"

KIServer.Config = {}
KIServer.Actions = {}
KIServer.Actions.GetBanList = "GetBanList"
KIServer.Actions.GetOrAddPlayer = "GetOrAddPlayer"
KIServer.Actions.AddConnectEvent = "AddConnectionEvent"

KIServer.Data = {}
KIServer.Data.PendingPlayerInfoQueue = {}   -- array of UCIDs, players that we are still waiting to receive data from DB
KIServer.Data.OnlinePlayers = {} -- hash of current online players format [PlayerId] = { UCID, Name, Role, Lives }
KIServer.Data.OnlinePlayersUCIDHash = {} -- hash that holds references to OnlinePlayers using UCID as key
KIServer.Data.BanList = {}               -- stores banlist information in format [UCID] = { true }

KIServer.Backup = {}
KIServer.Backup.TCPQueue = {}  -- list of failed TCP Requests that failed to send - will write to file and try to resend when possible

KIServer.Config.BanListRefreshRate = 60   -- retrieve a new banlist every 60 seconds
KIServer.Config.TCPCheckReceiveRate = 60  -- check the TCP buffer every 60 seconds and attempt to read
                      
KIServer.WriteToFileJSON = function(path, data)
  net.log("KIServer.WriteToFile called for path: " .. path)
  local _exportData = KIServer.JSON:encode(data)
	net.log("KIServer.WriteToFile - Data serialized")
	local _filehandle, _err = io.open(path, "w")
  if _filehandle then
    _filehandle:write(_exportData)
    _filehandle:flush()
    _filehandle:close()
    _filehandle = nil
    return true
  else
    net.log("KIServer.WriteToFile ERROR: " .. _err)
    return false
  end
end

KIServer.ReadFileJSON = function(path)
  net.log("KIServer.ReadFileJSON called for path: " .. path)
	local _filehandle, _err = io.open(path, "r")
  if _filehandle then
    local _rawdata = _filehandle:read("*a")
    _filehandle:close()
    _filehandle = nil
    if _rawdata then
      local _error = ""
      local _success, _data = xpcall(function() return KIServer.JSON:decode(_rawdata) end, 
                                     function(err) _error = err end)
      if _success and _data then
        return _data
      else
        return nil, _error
      end
    else
      return nil, "File Contents Empty"
    end
  else
    return nil, _err
  end
end

local function InitKIServerConfig()
  local UseDefaultConfig = false
  net.log("InitKIServerConfig() called")
  
  local _config, _error = KIServer.ReadFileJSON(KIServer.ConfigFileDirectory)
  if _config then
    net.log("InitKIServerConfig() - Reading From Config File")
    KIServer.Config.MissionName = _config["MissionName"]
    KIServer.Config.DataRefreshRate = _config["DataRefreshRate"]
    KIServer.Config.ServerPlayerID = _config["ServerPlayerID"]
    
    KIServer.Config.ConfigDirectory = _config["ConfigDirectory"]
    KIServer.Config.LogDirectory = _config["LogDirectory"]
    KIServer.Config.BannedPlayerFileDirectory = _config["BannedPlayerFileDirectory"]
    
    KIServer.Config.GAMEGUI_SEND_TO_PORT = tonumber(_config["GAMEGUI_SEND_TO_PORT"])
    KIServer.Config.GAMEGUI_RECEIVE_PORT = tonumber(_config["GAMEGUI_RECEIVE_PORT"])	
    KIServer.Config.TCP_SERVER_PORT = tonumber(_config["TCP_SERVER_PORT"])
    KIServer.Config.TCP_SERVER_IP = _config["TCP_SERVER_IP"]
    
    KIServer.Config.WelcomeMessages = _config["WelcomeMessages"]
  else
    net.log("InitKIServerConfig() - ERROR opening Config file (reason: " .. _error .. ")")
    UseDefaultConfig = true
  end
  
  if UseDefaultConfig then
    net.log("InitKIServerConfig() - There was a problem reading from an existing config - using default settings")
    KIServer.Config.MissionName = "Kaukasus Insurgency"
    KIServer.Config.DataRefreshRate = 30   -- how often should the server check the UDP Socket to update its data in memory
    KIServer.Config.ServerPlayerID = 1     -- The player ID of the server that is hosting the mission (host will always be 1)
    
    KIServer.Config.ConfigDirectory = lfs.writedir() .. [[Missions\\Kaukasus Insurgency\\Server\\]]
    KIServer.Config.LogDirectory = KIServer.Config.ConfigDirectory .. [[KIServerLog.log]]
    KIServer.Config.BannedPlayerFileDirectory = KIServer.Config.ConfigDirectory .. [[KIBannedPlayers.lua]]
    
    KIServer.Config.GAMEGUI_SEND_TO_PORT = 6005
    KIServer.Config.GAMEGUI_RECEIVE_PORT = 6006	
    KIServer.Config.TCP_SERVER_PORT = 9983
    KIServer.Config.TCP_SERVER_IP = "192.168.1.255"
    
    KIServer.Config.WelcomeMessages =
    {
      "Welcome to Kaukasus Insurgency - We hope you enjoy your time here",
      "Please check the briefing and the F10 Map for information about active missions, objectives, and enemies",
      "Our website is www.examplewebsite.com - please visit us for more info",
      "PLEASE UPDATE YOUR SIMPLE RADIO TO 1.2.8.1"
    }
    
    net.log("InitKIServerConfig() - Generating New Config file")
    KIServer.WriteToFileJSON(KIServer.ConfigFileDirectory, KIServer.Config)
  end
end

InitKIServerConfig()

-- Initialize Sockets
KIServer.UDPSendSocket = socket.udp()
KIServer.UDPReceiveSocket = socket.udp()
KIServer.UDPReceiveSocket:setsockname("*", KIServer.Config.GAMEGUI_RECEIVE_PORT)
KIServer.UDPReceiveSocket:settimeout(.0001) --receive timer


KIServer.ErrorHandler = function(err)
  net.log("KIServer - Caught Error - " .. err)
end

-- Checks whether the KI Server is running, by checking if the current game session is Multiplayer + Server Side
-- And if the mission name contains 'Kaukasus Insurgency'
KIServer.IsRunning = function()
	net.log("KIServer.IsRunning() called")
	if not DCS.isServer() and not DCS.isMultiplayer() then
		return false
	end
	
	net.log("KIServer.IsRunning() - Current Running Mission : " .. DCS.getMissionName())
	local missionName = DCS.getMissionName()
	if string.match(DCS.getMissionName(), KIServer.Config.MissionName) then
		net.log("KIServer.IsRunning() - Kaukasus Insurgency Is ON")
		return true
	end
	
	net.log("KIServer.IsRunning() - Kaukasus Insurgency Is OFF")
	return false
end


KIServer.RequestPlayerInfo = function(p_ucid, p_name)
  net.log("KIServer.RequestPlayerInfo called")
  
  if not KIServer.TCPSocket.IsConnected then
    if not KIServer.TCPSocket.Connect() then
      return nil
    end
  end
  local request = KIServer.TCPSocket.CreateMessage("GetOrAddPlayer", false, { UCID = p_ucid, Name = p_name })
  if not KIServer.TCPSocket.SendUntilComplete(request) then
    return nil
  else
    local response = KIServer.TCPSocket.DecodeMessage(KIServer.TCPSocket.ReceiveUntilComplete())
    if response and response.Result then
      local pinfo =
      {
        UCID = response.Data[1],
        Name = response.Data[2],
        Lives = response.Data[3],
        Banned = response.Data[4] == 1
      }
      return pinfo
    elseif response and response.Error then
      net.log("KIServer.RequestPlayerInfo ERROR - " .. response.Error)
      return nil
    else
      net.log("KIServer.RequestPlayerInfo ERROR - UNKNOWN ERROR")
      return nil
    end
  end
end


KIServer.IsPlayerBanned = function(ucid)
  net.log("KIServer.IsPlayerBanned called")
  for i = 1, #KIServer.Data.Banlist do
    if ucid == KIServer.Data.Banlist[i] then
      return true
    end
  end
  return false
end


KIServer.IsPlayerOutOfLives = function(ucid)
  net.log("KIServer.IsPlayerOutOfLives called")
  local pid = KIServer.Data.OnlinePlayersUCIDHash[ucid]
  if pid then
    local pinfo = KIServer.Data.OnlinePlayers[pid]
    if pinfo then
      return pinfo.Lives < 1
    else
      return false
    end
  end
  return false
end


KIServer.UpdateOnlinePlayers = function(data)
  net.log("KIServer.UpdateOnlinePlayers called")
  
  -- loop through the data, and only update the number of Lives and the Banned status in the server mod
  -- we dont care about anything else from the Mission Script layer but these 2 fields (everything else is managed by server mod)
  for _, dop in pairs(data) do
    local pid = KIServer.Data.OnlinePlayersUCIDHash[dop.UCID]
    if pid then
      if KIServer.Data.OnlinePlayers[pid] then
        KIServer.Data.OnlinePlayers[pid].Lives = dop.Lives
      end
    end
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










--=============================================================================--
-- TCPSocket INIT

KIServer.TCPSocket = 
{
  Object = nil,
  IsConnected = false
}


function KIServer.TCPSocket.Connect()
	net.log("KIServer.TCPSocket.Connect called")
	-- start connection
	KIServer.TCPSocket.Object = socket.tcp()
	KIServer.TCPSocket.Object:settimeout(.0001)
  KIServer.TCPSocket.IsConnected = false
	local _r, _err = KIServer.TCPSocket.Object:connect(KIServer.Config.TCP_SERVER_IP, KIServer.Config.TCP_SERVER_PORT)
  
  if _r ~= 1 or _err then
    net.log("KIServer.TCPSocket.Connect - ERROR - Failed to connect to TCP Server (Reason: " .. _err .. ")")
    KIServer.TCPSocket.IsConnected = false
    return false
  else
    KIServer.TCPSocket.IsConnected = true
    return true
  end
end

function KIServer.TCPSocket.Disconnect()
  net.log("KIServer.TCPSocket.Disconnect called")
  KIServer.TCPSocket.Object:close()
  KIServer.TCPSocket.IsConnected = false
end


-- Creates the message in the correct format the server expects
-- Encodes into JSON, and appends size of message in first 6 characters of string
function KIServer.TCPSocket.CreateMessage(action_name, is_bulk_query, data)
  net.log("KIServer.TCPSocket.CreateMessage called")
  local _msg = 
  {
    Action = action_name,
    BulkQuery = is_bulk_query,
    Data = data,
  }
  local _jsonmsg = KIServer.JSON:encode(_msg)
  -- sending 6 char header that is size of msg string
  local _m = string.format("%06d", string.len(_jsonmsg)) .. _jsonmsg
  net.log("KIServer.TCPSocket.CreateMessage - dumping message")
  net.log(_m)
  return _m
end


-- Decodes message from JSON string into LUA Table Object
function KIServer.TCPSocket.DecodeMessage(msg)
  net.log("KIServer.TCPSocket.DecodeMessage called")
  local _err = ""
  local _result, _luaObject = xpcall(function() return KIServer.JSON:decode(msg) end, function(err) _err = err end)
  if _result and _luaObject ~= nil then
    return _luaObject
  elseif _err ~= "" then
    net.log("KIServer.TCPSocket.DecodeMessage ERROR - " .. _err)
    return nil
  else
    net.log("KIServer.TCPSocket.DecodeMessage ERROR - UNKNOWN ERROR")
    return nil
  end
end



function KIServer.TCPSocket.SendUntilComplete(msg)
  net.log("KIServer.TCPSocket.SendUntilComplete called")
  if not KIServer.TCPSocket.IsConnected then
    net.log("KIServer.TCPSocket.SendUntilComplete - ERROR - Socket is not connected to DB server")
    return false
  end
  local bytes_sent = 0
  local msg_size = string.len(msg)
  -- copy the original msg parameter as we want to manipulate the copy without changing the original (but if strings are not by ref - why bother?)
  local _msgCopy = msg 
  while bytes_sent ~= msg_size do
    local _indexSent, _error, _lastIndexSent = KIServer.TCPSocket.Object:send(_msgCopy)
    
    -- successful send
    if _indexSent then
      bytes_sent = bytes_sent + _indexSent
    else
      -- error encountered - check third parameter to see if at least some data was sent and retry
      if _lastIndexSent ~= 0 then
        net.log("KIServer.TCPSocket.SendUntilComplete - partial send occurred (reason: " .. _error .. ") - Continuing")
        bytes_sent = bytes_sent + _lastIndexSent
      else
        -- complete failure - log
        net.log("KIServer.TCPSocket.SendUntilComplete - ERROR in sending data (reason: " .. _error .. ")")
        KIServer.TCPSocket.Disconnect()
        return false
      end
    end
    net.log("KIServer.TCPSocket.SendUntilComplete - bytes sent: "..tostring(bytes_sent))
    net.log("KIServer.TCPSocket.SendUntilComplete - sent string: '" .. _msgCopy:sub(1, bytes_sent).."'")
    _msgCopy = _msgCopy:sub(bytes_sent + 1) -- shrink the msg down to what has not been sent
    net.log("KIServer.TCPSocket.SendUntilComplete - Remaining buffer length: " 
              .. tostring(string.len(_msgCopy)) .. " data : '" .. _msgCopy .. "'")
  end
  
  return true
end


function KIServer.TCPSocket.ReceiveUntilComplete()
  local header, _error = KIServer.TCPSocket.Object:receive(6)
  
	if header and header:len() == 6 then
    local msg_size = tonumber(header)
    local msg, _error = KIServer.TCPSocket.Object:receive(msg_size)
    
    if msg and msg:len() == msg_size then
      net.log("KIServer.TCPSocket.ReceiveUntilComplete - received data transmission")
      return msg
    elseif msg and msg:len() < msg_size then
      net.log("KIServer.TCPSocket.ReceiveUntilComplete - partial data received (Reason: " .. _error .. ")")
      net.log("KIServer.TCPSocket.ReceiveUntilComplete - trying again")
      local partmsg, _error = KIServer.TCPSocket.Object:receive(msg_size - msg:len())
      -- check if the partial message came through and is the size we are expecting it to be
      if partmsg and partmsg:len() == (msg_size - msg:len()) then
        msg = msg .. partmsg
        return msg
      else
        net.log("KIServer.TCPSocket.ReceiveUntilComplete - second try failed to receive (Reason: " .. _error .. ")")
        KIServer.TCPSocket.Disconnect()
        return nil
      end
    else
      net.log("KIServer.TCPSocket.ReceiveUntilComplete - ERROR in receiving body data (Reason: " .. _error .. ")")
      KIServer.TCPSocket.Disconnect()
      return nil
    end
  else
    net.log("KIServer.TCPSocket.ReceiveUntilComplete - ERROR in receiving header data (reason: " .. _error .. ")")
    KIServer.TCPSocket.Disconnect()
    return nil
  end
end

-- end Server TCP Socket
-- ========================================================================================================== --


















-- DCS SERVER EVENT HOOKS
KIHooks = {}

-- Main Loop for KIServer - tries to receive updated Banned List and Player Life List from Mission Side socket
KIHooks.onSimulationFrame = function()
	if not KIServer.IsRunning() then return end
	
  local ElapsedTime = DCS.getModelTime() - KIServer.LastOnFrameTime
    
  if ElapsedTime >= KIServer.Config.DataRefreshRate then
    KIServer.LastOnFrameTime = DCS.getModelTime()
    
    
    --========================================================--
    -- Try Receive Player Life count from Mission Script
    if true then
      
      local received = KIServer.UDPReceiveSocket:receive()
      if received then
        net.log("KIServer - UDP Data stream received")
        local Success, Data = xpcall(function() return KIServer.JSON:decode(received) end, KIServer.ErrorHandler)
        if Success and Data then
          net.log("Data received!")
          KIServer.UpdateOnlinePlayers(Data.OnlinePlayers)
        end
      end
    end
    
    
    
    --=======================================================--
    -- Try Send Requests for New Banlist
    if true then
      
      if not KIServer.TCPSocket.IsConnected then
        if not KIServer.TCPSocket.Connect() then
          net.log("Failed to Get Banlist - TCP Socket is not connected")
        end
      end
      
      local request = KIServer.TCPSocket.CreateMessage(KIServer.Actions.GetBanList, false, {})
      
      if not KIServer.TCPSocket.SendUntilComplete(request) then
        net.log("Failed to Get Banlist - TCP Socket failed to send")
      end

    end
    
    --========================================================--
    -- now send back to Mission Script the updated OnlinePlayer list (of lives remaining) + any new connections we received since last time
    if true then
    
      KIServer.Data.OnlinePlayers = KIServer.SanitizeArray(KIServer.Data.OnlinePlayers)
      -- send Online Player list to UI
      socket.try(
        KIServer.UDPSendSocket:sendto(KIServer.JSON:encode(KIServer.Data.OnlinePlayers) .. KIServer.SocketDelimiter, 
                                      "127.0.0.1", KIServer.Config.GAMEGUI_SEND_TO_PORT)
      )
           
    end
    
    --========================================================--
    -- Try Receive TCP DB Data
    if true then
      
      while( local response = KIServer.Socket.ReceiveUntilComplete() ) do
        if response.Action = KIServer.Actions.GetOrAddPlayer then
          
          -- GetOrAddPlayer returns array as [ UCID, Name, Lives ]
          local ucid = response.Data[1]
          local pid = KIServer.Data.PendingPlayerInfoQueue[ucid]
          if pid then
            KIServer.Data.OnlinePlayers[pid].Lives = response.Data[3]  -- got this fresh players life count
          end
          
          -- remove from pending player queue
          KIServer.Data.PendingPlayerInfoQueue[ucid] = nil
          
          net.log("KIServer - Successfully received and processed GetOrAddPlayer")
          
        elseif response.Action = KIServer.Actions.GetBanList then
          
          KIServer.Data.Banlist = response.Data -- get the array of UCIDs
          
          -- check if any of the current online players have been banned while in game and kick them
          for pid, op in pairs(KIServer.Data.OnlinePlayers) do
            if KIServer.IsPlayerBanned(op.UCID) then
              net.kick(pid, KIServer.GetPlayerNameFix(op.Name) .. ": You are banned")
            end
          end
        
          net.log("KIServer - Successfully received and processed GetBanList")
          
        elseif response.Action = KIServer.Actions.AddConnectEvent then
          net.log("KIServer - Successfully received and processed AddConnectEvent")
        else
          net.log("KIServer - Successfully received and processed " .. response.Action)
        end
        
      end
      
    end
           
	end
end



KIHooks.onShowPool = function()
	--if not KIServer.IsRunning() then return end
	
	-- stub for potential future handler message
end






-- This handler is responsible for 5 things
-- 1) Kicking a player if they are banned
-- 2) Sending to DB Connection Event
-- 3) Adding to OnlinePlayer list
-- 4) Sending to DB PlayerInfo (get or add)
-- 5) Sending welcome messages
KIHooks.onPlayerConnect = function(playerID)
	-- ignore this handler if KI is not the mission being run, we dont want to interfere with other missions
	-- the server may be hosting
	if not KIServer.IsRunning() then return end
	net.log("KIHooks.onPlayerConnect() called")
  
  
	-- Validate the player object
	if playerID == KIServer.Config.ServerPlayerID then return end -- if the server is changing slot there is no action required
	local player = net.get_player_info(playerID)
	if not player then
		net.log("no player, aborting")
		return
	elseif player.ucid == nil then
		net.log("KIHooks.onPlayerConnect() ERROR - player ucid is nil!")
		return
	end
	
	net.log("KIHooks.onPlayerConnect(player: " .. player.name .. ", id: " .. playerID .. ")")
	
  
	if KIServer.IsPlayerBanned(player.ucid) then
		net.log("Banned player" .. player.name .. " tried to connect! Kicking him")
		net.kick(playerID, KIServer.GetPlayerNameFix(player.name) .. ": You are banned")
    return
	end
  
  -- Try to send the connection event to the Database, or backup the request if it fails
  if true then
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
    
    -- Lets pre-emptively invoke a TCP Send request to the database now, and pick up the results later in the main loop
    -- this should prevent any blocking on our end and keep the server from lagging out
    local request = KIServer.TCPSocket.CreateMessage(KIServer.Actions.AddConnectEvent, false, ServerEvent)
    
    if not KIServer.TCPSocket.IsConnected then
      if not KIServer.TCPSocket.Connect() then
        net.log("KIHooks.onPlayerConnect() - FATAL ERROR - Failed to connect to TCP Server - Backing up request")
        table.insert(KI.Backup.TCPQueue, request)
      end
    end
    
    if not KIServer.TCPSocket.SendUntilComplete(request) then
      net.log("KIHooks.onPlayerConnect() - FATAL ERROR - Failed to send to TCP Server - Backing up request")
      table.insert(KI.Backup.TCPQueue, request)
    end
  end
	--net.log("sending connect message to mission-side")
	--socket.try(KIServer.UDPSendSocket:sendto(KIServer.JSON:encode(ServerEvent) .. KIServer.SocketDelimiter, 
  --                                        "127.0.0.1", KIServer.Config.GAMEGUI_SEND_TO_PORT))
	
  
  -- add an entry into OnlinePlayers 
  -- since we're not sure how many lives this player has, we will set the value to -1 to indicate we are waiting to fetch data from database
  KIServer.Data.OnlinePlayers[tostring(player.id)] = 
  { 
    UCID = player.ucid, 
    Name = player.name, 
    Role = "", 
    Lives = -1
  }
  
  -- add this player into the pending player list so that we can obtain the results from DB later
  KIServer.Data.PendingPlayerInfoQueue[player.ucid] = player.id
  
  -- Lets pre-emptively invoke a TCP Send request to the database now, and pick up the results later in the main loop
  -- this should prevent any blocking on our end and keep the server from lagging out
  if true then
    local request = KIServer.TCPSocket.CreateMessage(KIServer.Actions.GetOrAddPlayer, false, { UCID = p_ucid, Name = p_name })
    
    if not KIServer.TCPSocket.IsConnected then
      if not KIServer.TCPSocket.Connect() then
        net.log("KIHooks.onPlayerConnect() - FATAL ERROR - Failed to connect to TCP Server - Backing up request")
        table.insert(KI.Backup.TCPQueue, request)
      end
    end
    
    if not KIServer.TCPSocket.SendUntilComplete(request) then
      net.log("KIHooks.onPlayerConnect() - FATAL ERROR - Failed to send to TCP Server - Backing up request")
      table.insert(KI.Backup.TCPQueue, request)
    end
  end
  
	-- send welcome messages
	local _chatMessage = string.format("Hello %s! Welcome to  Kaukasus Insurgency!", player.name)
	net.send_chat_to(_chatMessage, playerID, KIServer.Config.ServerPlayerID)
	if KIServer.Config.WelcomeMessages then
		for i = 1, #KIServer.Config.WelcomeMessages do
		  net.send_chat_to(tostring(KIServer.Config.WelcomeMessages[i]), playerID, KIServer.Config.ServerPlayerID)
		end
	end
  
end




-- This handler is responsible for the following
-- 1) Sending a disconnect event to DB
-- 2) Removing from online players
-- 3) Sending to DB players life count
function KIHooks.onPlayerDisconnect(playerID, reason)
	-- ignore this handler if KI is not the mission being run, we dont want to interfere with other missions
  -- the server may be hosting
	if not KIServer.IsRunning() then return true end
	net.log("KIHooks.onPlayerDisconnect called (playerID = '" .. playerID .. "', reason = '" .. reason .. "')")
	
  local player = net.get_player_info(playerID)
  
	if player then
		net.log("disconnecting player '" .. KIServer.GetPlayerNameFix(player.name) .. "'")
    
    local pinfo = KIServer.Data.OnlinePlayers[tostring(playerID)]
    
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
		
    -- Lets pre-emptively invoke a TCP Send request to the database now, and pick up the results later in the main loop
    -- this should prevent any blocking on our end and keep the server from lagging out
    local request1 = KIServer.TCPSocket.CreateMessage(KIServer.Actions.AddConnectEvent, false, ServerEvent)
    local request2 = KIServer.TCPSocket.CreateMessage(KIServer.Actions.UpdatePlayer, false, pinfo)
    
    if not KIServer.TCPSocket.IsConnected then
      if not KIServer.TCPSocket.Connect() then
        net.log("KIHooks.onPlayerConnect() - FATAL ERROR - Failed to connect to TCP Server - Backing up request")
        table.insert(KI.Backup.TCPQueue, request1)
        table.insert(KI.Backup.TCPQueue, request2)
      end
    end
    
    if not KIServer.TCPSocket.SendUntilComplete(request1) then
      net.log("KIHooks.onPlayerConnect() - FATAL ERROR - Failed to send to TCP Server - Backing up request")
      table.insert(KI.Backup.TCPQueue, request1)
    end
    if not KIServer.TCPSocket.SendUntilComplete(request2) then
      net.log("KIHooks.onPlayerConnect() - FATAL ERROR - Failed to send to TCP Server - Backing up request")
      table.insert(KI.Backup.TCPQueue, request2)
    end


		--net.log("sending disconnect message to mission-side")
		--socket.try(KIServer.UDPSendSocket:sendto(KIServer.JSON:encode(ServerEvent) .. KIServer.SocketDelimiter, 
    --                                         "127.0.0.1", KIServer.Config.GAMEGUI_SEND_TO_PORT))	

    -- Remove person from the OnlinePlayers list
    KIServer.Data.OnlinePlayersUCIDHash[player.ucid] = nil
    KIServer.Data.OnlinePlayers[tostring(playerID)] = nil
	end
end




-- Responsible for two things
-- 1) Updating OnlinePlayers list with the new role
-- 2) Checking if player has enough lives to continue with the swap
KIHooks.onPlayerTryChangeSlot = function(playerID, side, slotID)
  net.log("KIHooks.onPlayerTryChangeSlot() called")
  if DCS.isServer() and DCS.isMultiplayer() and (side ~= 0 and slotID ~= '' and slotID ~= nil) then
    local player = net.get_player_info(playerID)
    local _playerName = player.name
    if _playerName == nil then return true end

    net.log("KIHooks.onPlayerTryChangeSlot - Player Selected slot - player: " 
            .. _playerName .. " side:" .. side .. " slot: " .. slotID .. " ucid: " .. player.ucid)

    local _unitRole = DCS.getUnitType(slotID)
    if _unitRole == nil then return true end
    
    if  _unitRole == "forward_observer"
        or _unitRole == "instructor"
        or _unitRole == "artillery_commander"
        or _unitRole == "observer"
    then
      KIServer.Data.OnlinePlayers[tostring(player.id)].Role = _unitRole
      return true   -- ignore attempts to slot into non airframe roles
    else
      
      if KIServer.IsPlayerOutOfLives(player.ucid) then
        net.log("KIHooks.onPlayerTryChangeSlot - Player '" .. _playerName .. "' has run out of lives")
        local _chatMessage = string.format("*** %s - You have run out of lives and can no longer slot into an airframe! Player Lives return once every hour! ***",_playerName)
        net.send_chat_to(_chatMessage, playerID)
        KIServer.Data.OnlinePlayers[tostring(player.id)].Role = ""
        return false
      else
        KIServer.Data.OnlinePlayers[tostring(player.id)].Role = _unitRole
        return true
      end
    end
  else
    return true
  end
end


DCS.setUserCallbacks(KIHooks)
net.log("KI Server Tools Initialization Complete")


if IsMockTest then
  Main()
end