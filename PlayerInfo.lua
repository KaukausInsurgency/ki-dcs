--[[
PlayerInfo class
Manages information about a player - their UCID, name, current role, number of lives, current sortie, etc

Author: Igneous01
]]--
PlayerInfo = 
{
  UCID = "",
  Name = "",
  Role = "",
  Lives = 0,
  SortieID = 0,
}

function PlayerInfo:New(UCID, Name, Role, Lives, Sortie)
  env.info("PlayerInfo:New called")
  local self = KI.Toolbox.DeepCopy(PlayerInfo)

	if self ~= nil then
		setmetatable( self, PlayerInfo )
		self.__index = self	
	end
  
  self.UCID = UCID
  self.Name = Name
  self.Role = Role
  self.Lives = Lives or -1
  self.SortieID = Sortie or -1
  return self
end


PlayerInfoList = 
{
  OnlinePlayers = {}
}

function PlayerInfoList.AddPlayer(UCID, Name, Role, Lives)
  env.info("PlayerInfo:AddPlayer called")
  local p = PlayerInfo:New(UCID, Name, Role, Lives)
  table.insert(PlayerInfoList.OnlinePlayers, p)
end

function PlayerInfoList.RemovePlayer(UCID)
  env.info("PlayerInfo:RemovePlayer called")
  for i = 1, #PlayerInfoList.OnlinePlayers do
    if PlayerInfoList.OnlinePlayers[i].UCID == UCID then
      table.remove(PlayerInfoList.OnlinePlayers, i)
      return true
    end
  end
  return false
end

-- Updates player information using PlayerInfo object as parameter
function PlayerInfoList.UpdatePlayer(PInfo)
  env.info("PlayerInfo:UpdatePlayer called")
  for _, p in pairs(PlayerInfoList.OnlinePlayers) do
    if p.UCID == PInfo.UCID then
      -- perform update
      p.Name = PInfo.Name
      p.Role = PInfo.Role
      p.Lives = PInfo.Lives
      p.SortieID = PInfo.SortieID
      return true
    end
  end
  return false
end

function PlayerInfoList.FindPlayer(Name)
  env.info("PlayerInfo:FindPlayer called")
  for _, p in pairs(PlayerInfoList.OnlinePlayers) do
    if p.Name == Name then
      return p
    end
  end
  return nil
end