-- Mock objects for debugging outside of DCS

local JSONPath = "\\Scripts\\JSON.lua"
local IsMockTest = DCS == nil
--net.log("KI_Server - IsMockTest Running: " .. tostring(IsMockTest))

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
    elseif id == 6 then
      playerObj =
      {
        ucid = "EEEEE",
        name = "New callsign",
        id = 6,
        ipaddr = "127.0.0.1:9999",
        slot = 1
        
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
  net.dostring_in = function(who, msg)
    if string.match(msg, "getUserFlag") then
      return "1", nil
    else
      return true, nil
    end
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
  DCS.getMissionName = function() return "KaukasusInsurgency" end
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

  --[[
    local request1 = KIServer.TCPSocket.CreateMessage(KIServer.Actions.UpdatePlayer, false, { UCID = "" })
    local request2 = KIServer.TCPSocket.CreateMessage(KIServer.Actions.GetOrAddPlayer, false, { UCID = "" })
    local request3 = KIServer.TCPSocket.CreateMessage(KIServer.Actions.GetOrAddPlayer, false, { UCID = "B" })
    local request4 = KIServer.TCPSocket.CreateMessage(KIServer.Actions.GetOrAddPlayer, false, { UCID = "C" })
    local request5 = KIServer.TCPSocket.CreateMessage(KIServer.Actions.GetOrAddPlayer, false, { UCID = "D" })
    
    if not KIServer.TCPSocket.IsConnected then
      if KIServer.TCPSocket.Connect() then
        KIServer.TCPSocket.SendUntilComplete(request1)
        KIServer.TCPSocket.SendUntilComplete(request2)
        local msg = KIServer.TCPSocket.ReceiveUntilComplete()
        KIServer.TCPSocket.SendUntilComplete(request3)
        KIServer.TCPSocket.SendUntilComplete(request4)
        KIServer.TCPSocket.SendUntilComplete(request5)
        
      end
    end
    ]]--
    
    -- Server start up - Server Player joins
    DCS.onPlayerConnect(1)

    DCS.onSimulationFrame() -- nothing should happen this time around
    
    DCS.onPlayerConnect(2) -- Player AAA Igneous01 connects

    sleep(4.5)
    DCS.onSimulationFrame() -- should hopefully receive a request here
    
    -- BBB DemoPlayer connects, but soon after should be banned once we process his player record
    DCS.onPlayerConnect(3)
    DCS.onPlayerTryChangeSlot(3, 1, 2)    -- try him changing slot - should tell him server is waiting to get his data
    
    
    sleep(4.5)
    DCS.onSimulationFrame()               -- player BBB should be kicked by this point
    DCS.onPlayerDisconnect(3, "Disconnected")
    
    -- simulate playerID 2 changing slots twice
    DCS.onPlayerTryChangeSlot(2, 1, 1)    -- (playerID, side, slotID
    DCS.onSimulationFrame()
    DCS.onPlayerTryChangeSlot(2, 1, 2)
    
    DCS.onSimulationFrame()
    DCS.onPlayerDisconnect(2, "Disconnected")
    DCS.onSimulationFrame()
    
    -- try having fourth player connect (Jon Snow has no lives)
    DCS.onPlayerConnect(4)
    sleep(1)
    DCS.onPlayerTryChangeSlot(4, 1, 2)    -- should fail
    sleep(5.5)
    DCS.onSimulationFrame()
    DCS.onPlayerTryChangeSlot(4, 1, 2)    -- should fail
    DCS.onSimulationFrame()
    
    -- try invalid player connecting
    DCS.onPlayerConnect(22)
    DCS.onSimulationFrame()
    
    -- add 5th player connecting
    DCS.onPlayerConnect(5)
    sleep(4.5)
    -- should receive updated player list with DDD being banned just after getting into the game
    DCS.onSimulationFrame() -- second run updates that player banned status to true
    
    DCS.onPlayerDisconnect(4, "Disconnected")
    DCS.onPlayerDisconnect(5, "Disconnected")
    DCS.onPlayerDisconnect(1, "Disconnected")
    sleep(7.5)
    DCS.onSimulationFrame()
    
  end
  
  
  -- runs with main KI mission so we can test out the whole thing
  function Main2()
    sleep(1)
    DCS.onSimulationFrame()
    sleep(2)
    -- Server start up - Server Player joins
    DCS.onPlayerConnect(1)
    DCS.onPlayerConnect(6)
    
    local loop_count = 3000
    while loop_count > 0 do
      sleep(5)
      DCS.onSimulationFrame()
      loop_count = loop_count - 1
    end
  
    DCS.onPlayerDisconnect(1, "Disconnected")
    DCS.onPlayerDisconnect(6, "Disconnected")
  end
  
  JSONPath = "S:\\Eagle Dynamics\\DCS World\\DCS World\\Scripts\\JSON.lua"
end 
-- END TEST MOCKUP DATA













JSONPath = "S:\\Eagle Dynamics\\DCS World\\DCS World\\Scripts\\JSON.lua"




-- KI Server
-- Server Side Mod that manages certain game events in Kaukasus Insurgency
net.log("KI Server Invoked - Starting KI Server Tools...")

package.path  = package.path..";.\\LuaSocket\\?.lua;"
package.cpath = package.cpath..";.\\LuaSocket\\?.dll;"

local _errormsg = ""
net.log("JSON File Path: " .. JSONPath)
local _JSONsuccess, JSON = xpcall(function() return loadfile(JSONPath)() end, function(err) _errormsg = err end)
if _JSONsuccess and JSON then
  net.log("KI Server Tools - JSON Loaded")
else
  net.log("KI Server Tools - ERROR Loading JSON: " .. _errormsg)
end
local _socket = require("socket")

net.log("KI Server Tools - Frameworks loaded")

KIServer = {}

KIServer.SocketDelimiter = "\n"	  -- delimiter used to segment messages (not needed for UDP)
KIServer.JSON = JSON
KIServer.LastOnFrameTime = 0
KIServer.ConfigFileDirectory = lfs.writedir() .. "Missions\\Kaukasus Insurgency\\Server\\KIServerConfig.lua"
KIServer.Null = -9999             -- nil placeholder - we need this because JSON requests require all parameters be passed in (including nils) otherwise the database call will fail
KIServer.Flag = 9000              -- this flag is set when the GAME is ready to receive SessionID and ServerID
KIServer.Config = {}
KIServer.Actions = {}
KIServer.Actions.UpdatePlayer = "UpdatePlayer"                -- updates player table with life count, online_player with role
KIServer.Actions.GetOrAddPlayer = "GetOrAddPlayer"            -- adds or gets existing player record
KIServer.Actions.AddConnectEvent = "AddConnectionEvent"       -- adds connect / disconnect events and adds player to online_players table
KIServer.Actions.AddGameEvent = "AddGameEvent"
KIServer.Actions.RequestSession = "CreateSession"
KIServer.Actions.RequestServer = "GetOrAddServer"

KIServer.Data = {}
KIServer.Data.ServerID = KIServer.Null 
KIServer.Data.SessionID = KIServer.Null 
KIServer.Data.PendingPlayerInfoQueue = {}   -- array of UCIDs, players that we are still waiting to receive data from DB
KIServer.Data.OnlinePlayers = {} -- hash of current online players format [PlayerId] = { UCID, Name, Role, Lives }
KIServer.Data.OnlinePlayersUCIDHash = {} -- hash that holds references to OnlinePlayers using UCID as key

KIServer.Backup = {}
KIServer.Backup.TCPQueue = {}  -- list of failed TCP Requests that failed to send - will write to file and try to resend when possible

KIServer.Config.BanListRefreshRate = 60   -- retrieve a new banlist every 60 seconds
KIServer.Config.TCPCheckReceiveRate = 60  -- check the TCP buffer every 60 seconds and attempt to read
           
function KIServer.RequestServerID()
  net.log("KIServer.RequestServerID called")
  
  
  if not KIServer.TCPSocket.IsConnected then
    if not KIServer.TCPSocket.Connect() then
      net.log("KIServer.RequestServerID - ERROR - Failed to Connect Socket to Server")
      return false
    end
  end
  
  KIServer.TCPSocket.Object:settimeout(10)  -- need to modify the timeout to 10 seconds as it's important we receive this right away
  
  local request = KIServer.TCPSocket.CreateMessage("GetOrAddServer", false, { ServerName = KIServer.Config.ServerName })
  local result = false
  
  if KIServer.TCPSocket.SendUntilComplete(request) then
    local response = KIServer.TCPSocket.DecodeMessage(KIServer.TCPSocket.ReceiveUntilComplete())
    if response and response.Result then
      KIServer.Data.ServerID = response.Data[1]
      result = true
    elseif response and response.Error then
      net.log("KIServer.RequestNewSession - TRANSACTION ERROR - " .. response.Error)
      result = false
    else
      net.log("KIServer.RequestNewSession - FATAL ERROR - NO RESPONSE RECEIVED FROM DATABASE")
      result = false
    end
  else
    net.log("KIServer.RequestNewSession - FATAL ERROR - FAILED TO SEND REQUEST TO DATABASE")
    result = false
  end
  
  KIServer.TCPSocket.Object:settimeout(.0001) -- set it back to what it was
  return result
end

-- sends message to database asking for a new session to be generated - SessionID is returned from DB
function KIServer.RequestNewSession()
  net.log("KIServer.RequestNewSession called")
  
  if not KIServer.TCPSocket.IsConnected then
    if not KIServer.TCPSocket.Connect() then
      net.log("KIServer.RequestNewSession - ERROR - Failed to Connect Socket to Server")
      return false
    end
  end
  
  KIServer.TCPSocket.Object:settimeout(10)  -- need to modify the timeout here as we need to wait for this result
  
  local request = KIServer.TCPSocket.CreateMessage("CreateSession", false, { ServerID = KIServer.Data.ServerID })
  local result = false
  
  if KIServer.TCPSocket.SendUntilComplete(request) then
    local response = KIServer.TCPSocket.DecodeMessage(KIServer.TCPSocket.ReceiveUntilComplete())
    if response and response.Result then
      KIServer.Data.SessionID = response.Data[1]
      result = true
    elseif response and response.Error then
      net.log("KIServer.RequestNewSession - TRANSACTION ERROR - " .. response.Error)
      result = false
    else
      net.log("KIServer.RequestNewSession - FATAL ERROR - NO RESPONSE RECEIVED FROM DATABASE")
      result = false
    end
  else
    net.log("KIServer.RequestNewSession - FATAL ERROR - FAILED TO SEND REQUEST TO DATABASE")
    result = false
  end
  
  KIServer.TCPSocket.Object:settimeout(.0001) -- turn it back to the the original time out (non-blocking)
  return result
end
           

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

function KIServer.GetFlagValue(_flag)
  local _status,_error  = net.dostring_in('server', " return trigger.misc.getUserFlag(\"".._flag.."\"); ")

  if not _status and _error then
    net.log("KIServer.GetFlagValue - error getting flag: ".._error)
    return nil
  else
    return tonumber(_status)
  end
end

function KIServer.SetFlagValue(_flag, _number) -- Added by FlightControl

  local _status,_error  = net.dostring_in('server', " return trigger.action.setUserFlag(\"".._flag.."\", " .. _number .. "); ")

  if not _status and _error then
    net.log("KIServer.SetFlagValue - error setting flag: ".._error)
    return false
  end
  return true
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
    KIServer.Config.ServerName = _config["ServerName"]
    KIServer.Config.ConfigDirectory = _config["ConfigDirectory"]
    KIServer.Config.LogDirectory = _config["LogDirectory"]
    
    KIServer.Config.GAMEGUI_SEND_TO_PORT = tonumber(_config["GAMEGUI_SEND_TO_PORT"])
    KIServer.Config.SERVER_SESSION_SEND_TO_PORT = tonumber(_config["SERVER_SESSION_SEND_TO_PORT"])
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
    KIServer.Config.ServerName = "Dev Kaukasus Insurgency Server"
    KIServer.Config.ConfigDirectory = lfs.writedir() .. [[Missions\\Kaukasus Insurgency\\Server\\]]
    KIServer.Config.LogDirectory = KIServer.Config.ConfigDirectory .. [[net.log.log]]
    
    KIServer.Config.GAMEGUI_SEND_TO_PORT = 6005
    KIServer.Config.SERVER_SESSION_SEND_TO_PORT = 6007
    KIServer.Config.GAMEGUI_RECEIVE_PORT = 6006	
    KIServer.Config.TCP_SERVER_PORT = 9983
    KIServer.Config.TCP_SERVER_IP = "127.0.0.1"
    
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
-- And if the mission name contains Config.MissionName
KIServer.IsRunning = function()
	if not DCS.isServer() and not DCS.isMultiplayer() then
		return false
	end
	
	local missionName = DCS.getMissionName()
	if string.match(DCS.getMissionName(), KIServer.Config.MissionName) then
		return true
	end
	return false
end


KIServer.IsPlayerOutOfLives = function(ucid)
  net.log("KIServer.IsPlayerOutOfLives called")
  local pid = KIServer.Data.OnlinePlayersUCIDHash[ucid]
  if pid then
    local pinfo = KIServer.Data.OnlinePlayers[tostring(pid)]
    if pinfo then
      if pinfo.Lives == KIServer.Null then
        return true, "You can't slot in yet - We are still loading your player record - please try again in a moment"
      else
        return pinfo.Lives < 1, string.format("*** %s - You have run out of lives and can no longer slot into an airframe! Player Lives return once every hour! ***", pinfo.Name)
      end
    else
      return false
    end
  end
  return false
end


KIServer.UpdatePlayerLives = function(data)
  net.log("KIServer.UpdatePlayerLives called")
  
  -- loop through the data, and only update the number of Lives in the server mod
  -- we dont care about anything else from the Mission Script layer but these 2 fields (everything else is managed by server mod)
  
  for _, dop in pairs(data) do
    net.log("KIServer.UpdatePlayerLives iter dop.UCID :" .. tostring(dop.UCID))
    local pid = KIServer.Data.OnlinePlayersUCIDHash[dop.UCID]
    if pid then
      net.log("KIServer.UpdatePlayerLives iter pid :" .. tostring(pid))
      if KIServer.Data.OnlinePlayers[tostring(pid)] then
        net.log("Updating pid " .. tostring(pid) .. " Lives (ServerMod Lives - " .. tostring(KIServer.Data.OnlinePlayers[tostring(pid)].Lives) .. ", Mission Lives - " .. tostring(dop.Lives))
        
        -- there is a chance the mission will still have the null life count while the server just received it from the db
        -- in this case DO NOT update the life count 
        if dop.Lives ~= KIServer.Null then
          KIServer.Data.OnlinePlayers[tostring(pid)].Lives = dop.Lives
        end
      end
    end
  end
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
    if _error == "closed" then
      KIServer.TCPSocket.Disconnect()   -- disconnect the socket if the server closed the connection
    end
    return nil
  end
end

-- end Server TCP Socket
-- ========================================================================================================== --


















-- DCS SERVER EVENT HOOKS
KIHooks = {}
KIHooks.Initialized = false

-- Main Loop for KIServer - data transmissions to TCP / DB, UDP / Mission Script, etc
KIHooks.onSimulationFrame = function()
	if not KIServer.IsRunning() then 
    KIHooks.Initialized = false
    return 
  end
  
  -- If the DCS model clock is reset to 0, assume that the mission was stopped, so require everything to be initialized again on next mission start
  --if DCS.getModelTime() <= 0 then
  --  net.log("KIServer - Detected Mission Stop - Require new initalization")
  --  requires_init = true
  --end
  
  
  -- onetime call to get serverID and SessionID from DB
  -- if we successfully receive both - send immediate UDP response to Mission Server to notify 
  if DCS.getModelTime() > 0 and not KIHooks.Initialized then
    if KIServer.GetFlagValue(KIServer.Flag) == 1 then
      net.log("KIServer Init - Requesting Session Data")
      if KIServer.RequestServerID() then
        if KIServer.RequestNewSession() then
          net.log("KIServer Init - Successful retreive of ServerID and SessionID from Database")
          KIHooks.Initialized = true
          local msgdata = KIServer.JSON:encode({ ServerID = KIServer.Data.ServerID, SessionID = KIServer.Data.SessionID}) .. KIServer.SocketDelimiter
          socket.try(KIServer.UDPSendSocket:sendto(msgdata, "127.0.0.1", KIServer.Config.SERVER_SESSION_SEND_TO_PORT))
          net.log("KIServer Init - Send UDP message to Game")
          -- This is a poor mans CriticalSection / Lock to prevent the game from attempting to read from the socket before the server has finished sending it
          KIServer.SetFlagValue(KIServer.Flag, 2) -- notify the Game that the server has sent the data and it can attempt to receive it
          net.log("KIServer Init - Set Flag to '2'")
        end
      end
    end
  end
	
  local ElapsedTime = DCS.getModelTime() - KIServer.LastOnFrameTime
    
  if ElapsedTime >= KIServer.Config.DataRefreshRate and KIHooks.Initialized then
    KIServer.LastOnFrameTime = DCS.getModelTime()
    
    
    --========================================================--
    -- Try Receive Player Life count from Mission Script
    if true then
      net.log("KIServer - Try Receive Player Life Count / GameEvents")
      -- loop the UDP receive messages and process all of them
      while true do
        local received = KIServer.UDPReceiveSocket:receive()
        if received then
          net.log("KIServer - UDP Data stream received")
          local Success, Data = xpcall(function() return KIServer.JSON:decode(received) end, KIServer.ErrorHandler)
          
          if Success and Data then
            KIServer.UpdatePlayerLives(Data.OnlinePlayers)
            
            if Data.GameEventQueue and #Data.GameEventQueue > 0 then
              net.log("KIHooks.onSimulationFrame - got GameEvent data from Mission - sending to TCP Server")
              local request = KIServer.TCPSocket.CreateMessage(KIServer.Actions.AddGameEvent, true, Data.GameEventQueue)
      
              if not KIServer.TCPSocket.IsConnected then
                if not KIServer.TCPSocket.Connect() then
                  net.log("KIHooks.onSimulationFrame - FATAL ERROR - Failed to connect to TCP Server - Backing up request")
                  table.insert(KIServer.Backup.TCPQueue, request)
                end
              end
              
              if not KIServer.TCPSocket.SendUntilComplete(request) then
                net.log("KIHooks.onPlayerConnect() - FATAL ERROR - Failed to send to TCP Server - Backing up request")
                table.insert(KIServer.Backup.TCPQueue, request)
              end
            end
            
          end
        else
          net.log("KIHooks.onSimulationFrame - Breaking from UDP Receive Loop")
          break
        end
      end
      
    end
    
    
    
    --========================================================--
    -- now send back to Mission Script the updated OnlinePlayer list (of lives remaining) + any new players we received since last time
    -- send this info to the TCP Server as well
    if true then
      net.log("KIServer - Try Send OnlinePlayers to Mission Script")
      KIServer.Data.OnlinePlayers = KIServer.SanitizeArray(KIServer.Data.OnlinePlayers)
      -- send Online Player list to UI
      socket.try(KIServer.UDPSendSocket:sendto(KIServer.JSON:encode(KIServer.Data.OnlinePlayers) .. KIServer.SocketDelimiter, "127.0.0.1", KIServer.Config.GAMEGUI_SEND_TO_PORT))
      
      net.log("Sent JSON UDP to Mission (OnlinePlayers)")
      
    end
    
    
    --========================================================--
    -- Try Receive TCP DB Data
    if true then
      net.log("KIServer - Try Receive TCP DB Data")
      while( true ) do
        local response_string = KIServer.TCPSocket.ReceiveUntilComplete()
        if not response_string then
          break
        end
        local response = KIServer.TCPSocket.DecodeMessage(response_string)
        
        if response.Error ~= "" then
          net.log("KIServer - TCP/DB Error in response - " .. response.Error)
        else
          if response.Action == KIServer.Actions.GetOrAddPlayer then
          
            -- GetOrAddPlayer returns array as [ UCID, Name, Lives ]
            local ucid = response.Data[1]
            local pid = KIServer.Data.PendingPlayerInfoQueue[ucid]
            if pid then
              -- there is a possibility the player may disconnect before we have had a chance to process their player record
              -- in which case just ignore any updates
              local pinfo = KIServer.Data.OnlinePlayers[tostring(pid)]
              if pinfo then
                pinfo.Lives = response.Data[3]  -- got this fresh players life count
                pinfo.Banned = response.Data[4] == 1
                KIServer.Data.OnlinePlayers[tostring(pid)] = pinfo  -- update the array record
                
                if pinfo.Banned then
                  net.log("KIServer - Pending Player Info Received - Player '" .. pinfo.Name .. "' is banned - kicking")
                  net.kick(pid, pinfo.Name .. ": You are banned")
                end
              end
            end
            
            -- remove from pending player queue
            KIServer.Data.PendingPlayerInfoQueue[ucid] = nil
            
            net.log("KIServer - Successfully received and processed GetOrAddPlayer")
            
          elseif response.Action == KIServer.Actions.AddConnectEvent then
            net.log("KIServer - Successfully received and processed AddConnectEvent")
          else
            net.log("KIServer - Successfully received and processed " .. response.Action)
          end
        end
      end
      
    end
          
	end
end




-- This handler is here to block players from joining the server, before the server has finished loading (and receiving session data from the database)
KIHooks.onPlayerTryConnect = function(addr, name, ucid, playerID) --> true | false, "disconnect reason"
	-- do not block if KI is not running
  if not KIServer.IsRunning() then return true end
  
  -- if KI has not finished initializing (waiting for session and server from DB)
  -- and the playerID is not the server player itself
  -- block the connection with the message that the mission is still loading
  if not KIHooks.Initialized and playerID ~= KIServer.Config.ServerPlayerID then 
    net.log("KIHooks.onPlayerTryConnect - a player attempted to connect to the server before data was received from the database - dropping connection")
    return false, "The mission has not finished loading" 
  end
  
  -- if there has not been enough time passed in the simulation to complete some loading
  -- block the connection with the message
  if not DCS.getModelTime() or DCS.getModelTime() < 20 then
		net.log("KIHooks.onPlayerTryConnect - a player attempted to connect to the server before the mission has finished loading - dropping connection")
		return false, "The mission has not finished loading"
	end 
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
	if not KIServer.IsRunning() or not KIHooks.Initialized then return end
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
	
  
  -- Try to send the connection event to the Database, or backup the request if it fails
  if true then
    local ServerEvent = 
    {
      ServerID = KIServer.Data.ServerID,
      Type = "CONNECTED",
      Name = player.name,
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
        table.insert(KIServer.Backup.TCPQueue, request)
      end
    end
    
    if not KIServer.TCPSocket.SendUntilComplete(request) then
      net.log("KIHooks.onPlayerConnect() - FATAL ERROR - Failed to send to TCP Server - Backing up request")
      table.insert(KIServer.Backup.TCPQueue, request)
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
    Lives = KIServer.Null,        -- intentially setting this to nil here - will be updated once we get player record back from db
    Banned = false,
    SortieID = -1
  }
  KIServer.Data.OnlinePlayersUCIDHash[player.ucid] = player.id
  
  -- add this player into the pending player list so that we can obtain the results from DB later
  KIServer.Data.PendingPlayerInfoQueue[player.ucid] = player.id
  
  -- Lets pre-emptively invoke a TCP Send request to the database now, and pick up the results later in the main loop
  -- this should prevent any blocking on our end and keep the server from lagging out
  if true then
    local request = KIServer.TCPSocket.CreateMessage(KIServer.Actions.GetOrAddPlayer, false, { UCID = player.ucid, Name = player.name })
    
    if not KIServer.TCPSocket.IsConnected then
      if not KIServer.TCPSocket.Connect() then
        net.log("KIHooks.onPlayerConnect() - FATAL ERROR - Failed to connect to TCP Server - Backing up request")
        table.insert(KIServer.Backup.TCPQueue, request)
      end
    end
    
    if not KIServer.TCPSocket.SendUntilComplete(request) then
      net.log("KIHooks.onPlayerConnect() - FATAL ERROR - Failed to send to TCP Server - Backing up request")
      table.insert(KIServer.Backup.TCPQueue, request)
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
	if not KIServer.IsRunning() or not KIHooks.Initialized then return true end
  if playerID == KIServer.Config.ServerPlayerID then return end -- if the server is disconnecting there is no action required

	net.log("KIHooks.onPlayerDisconnect called (playerID = '" .. playerID .. "', reason = '" .. reason .. "')")
	
  --local player = net.get_player_info(playerID)    -- apparently we cant get this information once a player disconnects
  local pinfo = KIServer.Data.OnlinePlayers[tostring(playerID)]
  
	if pinfo then
		net.log("disconnecting player '" .. pinfo.Name .. "'")
    
		local ServerEvent = 
		{
      ServerID = KIServer.Data.ServerID,
			Type = "DISCONNECTED",
			Name = pinfo.Name,
			UCID = pinfo.UCID,
			ID = playerID,
			IP = "",
			GameTime = DCS.getModelTime(),
			RealTime = DCS.getRealTime(),
		}
		
    -- Lets pre-emptively invoke a TCP Send request to the database now, and pick up the results later in the main loop
    -- this should prevent any blocking on our end and keep the server from lagging out
    local request1 = KIServer.TCPSocket.CreateMessage(KIServer.Actions.AddConnectEvent, false, ServerEvent)
    
    local UpdatePlayerReq =
    {
      ServerID = KIServer.Data.ServerID,
      UCID = pinfo.UCID,
      Name = pinfo.Name,
			Role = "",
      Lives = pinfo.Lives,
      Banned = pinfo.Banned,
      Side = 0
    }
    local request2 = KIServer.TCPSocket.CreateMessage(KIServer.Actions.UpdatePlayer, false, UpdatePlayerReq)
    
    if not KIServer.TCPSocket.IsConnected then
      if not KIServer.TCPSocket.Connect() then
        net.log("KIHooks.onPlayerConnect() - FATAL ERROR - Failed to connect to TCP Server - Backing up request")
        table.insert(KIServer.Backup.TCPQueue, request1)
        table.insert(KIServer.Backup.TCPQueue, request2)
      end
    else
      if not KIServer.TCPSocket.SendUntilComplete(request1) then
        net.log("KIHooks.onPlayerConnect() - FATAL ERROR - Failed to send to TCP Server - Backing up request")
        table.insert(KIServer.Backup.TCPQueue, request1)
      end
      if not KIServer.TCPSocket.SendUntilComplete(request2) then
        net.log("KIHooks.onPlayerConnect() - FATAL ERROR - Failed to send to TCP Server - Backing up request")
        table.insert(KIServer.Backup.TCPQueue, request2)
      end
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
  if (KIServer.IsRunning() and KIHooks.Initialized) and (side ~= 0 and slotID ~= '' and slotID ~= nil) then
    
    -- ignore when the server is changing slots
    if playerID == KIServer.Config.ServerPlayerID then
      net.log("KIHooks.onPlayerTryChangeSlot() - ignoring - the server is changing slots")
      return true
    end
    
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
      local IsNoLives, PlayerMsg = KIServer.IsPlayerOutOfLives(player.ucid)
      if IsNoLives then
        net.log("KIHooks.onPlayerTryChangeSlot - Player '" .. _playerName .. "' has no lives, or still waiting to get record from database")
        net.send_chat_to(PlayerMsg, playerID)
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
  Main2()
  --Main()
end