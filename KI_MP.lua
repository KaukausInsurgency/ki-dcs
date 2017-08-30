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


function KI.MP.GetPlayerUCID(playerName)
	local playerNameFix = KI.MP.GetPlayerNameFix(playerName)
	local playerUcid = 0
	if playerNameFix ~= "AI" then
		for ucid, playerData in pairs(PlayerList) do
			if KI.MP.GetPlayerNameFix(playerData.name) == playerNameFix then
				env.info("found player ucid in PlayerList!")
				playerUcid = ucid
			end
		end
		
		if playerUcid == 0 then
			env.info("Did not find player in playerlist! looking it up in playerdata")
			
			-- load dynamic mission data:
			KI.MP.LoadPlayerData()
			if KI.MP.PlayerData ~= nil then		
						
				for ucid, playerData in pairs(KI.MP.PlayerData) do
					if not playerData.name then
						env.info("this player has no name: ucid="..ucid..", table: "..KI.Toolbox.SerializeTable(playerData))
					elseif KI.MP.GetPlayerNameFix(playerData.name) == playerNameFix then
						env.info("found player ucid in PlayerData!")
						playerUcid = ucid
					end
				end
			else
				env.info("Unable to load Player Data, using playerNameFix")
				playerUcid = playerNameFix
			end
			
			if playerUcid == 0 then
				playerUcid = playerNameFix
			end
		end
	else
		playerUcid = playerNameFix	-- AI does not have ucid, so dont even look for it
	end
	
	env.info("UCID = "..playerUcid)
	return playerUcid
end



function KI.MP.LoadPlayerData()
	--env.info("loading player list")
	local DataLoader = loadfile(KI.Config.PlayerListFileName)
	if DataLoader ~= nil then		-- File open?
		PlayerList = DataLoader()
	else
		env.info("FATAL ERROR: could not load playerlist")
	end
	
	local DataLoader = loadfile(KI.Config.PlayerDataFileName)
	if DataLoader ~= nil then		-- File open?
		env.info("Loading from '"..KI.Config.PlayerDataFileName.."' ... successful\n")
		KI.MP.PlayerData = DataLoader()
	else
		env.info("FATAL ERROR: Unable to load Player Data!")
	end
end