if not KI then
  KI = {}
end

local require = require
local loadfile = loadfile

package.path = package.path..";.\\LuaSocket\\?.lua"
package.cpath = package.cpath..";.\\LuaSocket\\?.dll"

local JSON = loadfile("Scripts\\JSON.lua")()
local socket = require("socket")

KI.Socket = 
{
  Object = nil,
  IsConnected = false
}


function KI.Socket.Connect()
	env.info("KI.Socket.Connect called")
	-- start connection
	KI.Socket.Object = socket.tcp()
	KI.Socket.Object:settimeout(.0001)
  KI.Socket.IsConnected = false
	local _r, _err = KI.Socket.Object:connect(KI.Config.DBServerIP, KI.Config.DBServerPort)
  
  if _r ~= 1 or _err then
    env.info("KI.Socket.Connect - ERROR - Failed to connect to Database Server (Reason: " .. _err .. ")")
    KI.Socket.IsConnected = false
    return false
  else
    KI.Socket.IsConnected = true
    return true
  end
end


-- Creates the message in the correct format the server expects
-- Encodes into JSON, and appends size of message in first 6 characters of string
function KI.Socket.CreateMessage(message_type, data)
  env.info("KI.Socket.CreateMessage called")
  local _msg = 
  {
    GameServer = KI.Config.ServerName,
    Time = time.Now(),
    Type = message_type,
    Data = data,
  }
  local _jsonmsg = JSON:encode(_msg)
  
  local _m = string.format("%06d", string.len(_jsonmsg)) .. _jsonmsg
  env.info("KI.Socket.CreateMessage - dumping message")
  env.info(_m)
  return _m
end


function KI.Socket.SendUntilComplete(msg)
  env.info("KI.Socket.SendUntilComplete called")
  if not KI.Socket.IsConnected then
    env.info("KI.Socket.SendUntilComplete - ERROR - Socket is not connected to DB server")
    return false
  end
  local bytes_sent = 0
  local msg_size = string.len(msg)
  -- copy the original msg parameter as we want to manipulate the copy without changing the original (but if strings are not by ref - why bother?)
  local _msgCopy = msg 
  while bytes_sent ~= msg_size do
    local _indexSent, _error, _lastIndexSent = KI.Socket.Object:send(_msgCopy)
    
    -- successful send
    if _indexSent then
      bytes_sent = bytes_sent + _indexSent
    else
      -- error encountered - check third parameter to see if at least some data was sent and retry
      if _lastIndexSent ~= 0 then
        env.info("KI.Socket.SendUntilComplete - partial send occurred (reason: " .. _error .. ") - Continuing")
        bytes_sent = bytes_sent + _lastIndexSent
      else
        -- complete failure - log
        env.info("KI.Socket.SendUntilComplete - ERROR in sending data (reason: " .. _error .. ")")
        return false
      end
    end
    env.info("KI.Socket.SendUntilComplete - bytes sent: "..tostring(bytes_sent))
    env.info("KI.Socket.SendUntilComplete - sent string: '" .. _msgCopy:sub(1, bytes_sent).."'")
    _msgCopy = _msgCopy:sub(bytes_sent + 1) -- shrink the msg down to what has not been sent
    env.info("KI.Socket.SendUntilComplete - Remaining buffer length: " 
              .. tostring(string.len(_msgCopy)) .. " data : '" .. _msgCopy .. "'")
  end
  
  return true
end
