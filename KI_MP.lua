if not KI then
  KI = {}
end

KI.MP = {}

function KI.MP.GetPlayerNameFix(playerName)
	if not playerName then 
		return nil
	end
	
	local playerName = playerName:gsub("'"," ")
	playerName = playerName:gsub('"',' ')
	playerName = playerName:gsub('=','-')
	
	return playerName
end