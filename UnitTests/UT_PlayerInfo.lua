UT.TestCase("PlayerInfo", 
nil, nil,
function()
  if true then
    local pinfo = PlayerInfo:New("AAA", "DemoPlayer", "Ka-50", 5, 1)
    UT.TestCompare(function() return pinfo.UCID == "AAA" end)
    UT.TestCompare(function() return pinfo.Name == "DemoPlayer" end)
    UT.TestCompare(function() return pinfo.Role == "Ka-50" end)
    UT.TestCompare(function() return pinfo.Lives == 5 end)
    UT.TestCompare(function() return pinfo.SortieID == 1 end)
    
    local pinfo2 = PlayerInfo:New("AAA", "DemoPlayer", "A10-C")
    UT.TestCompare(function() return pinfo2.UCID == "AAA" end)
    UT.TestCompare(function() return pinfo2.Name == "DemoPlayer" end)
    UT.TestCompare(function() return pinfo2.Role == "A10-C" end)
    UT.TestCompare(function() return pinfo2.Lives == -1 end)
    UT.TestCompare(function() return pinfo2.SortieID == -1 end)
  end 
  
  if true then
    
    -- add, then get from list and verify everything is correct
    PlayerInfoList.AddPlayer("AAA", "DemoPlayer", "Ka-50", 3)
    local pinfo = PlayerInfoList.FindPlayer("DemoPlayer")
    UT.TestCompare(function() return pinfo.UCID == "AAA" end)
    UT.TestCompare(function() return pinfo.Name == "DemoPlayer" end)
    UT.TestCompare(function() return pinfo.Role == "Ka-50" end)
    UT.TestCompare(function() return pinfo.Lives == 3 end)
    UT.TestCompare(function() return pinfo.SortieID == -1 end)
    
    -- now update the object and verify the changes persisted
    pinfo.Name = "NewPlayer"
    pinfo.Role = "A10-C"
    pinfo.Lives = 2
    pinfo.SortieID = 5
    
    UT.TestCompare(function() return PlayerInfoList.UpdatePlayer(pinfo) end)
    UT.TestCompare(function() return PlayerInfoList.OnlinePlayers[1].UCID == "AAA" end)
    UT.TestCompare(function() return PlayerInfoList.OnlinePlayers[1].Name == "NewPlayer" end)
    UT.TestCompare(function() return PlayerInfoList.OnlinePlayers[1].Role == "A10-C" end)
    UT.TestCompare(function() return PlayerInfoList.OnlinePlayers[1].Lives == 2 end)
    UT.TestCompare(function() return PlayerInfoList.OnlinePlayers[1].SortieID == 5 end)
    
    -- add another 3 players
    PlayerInfoList.AddPlayer("BBB", "SamplePlayer", "F15", 5)
    PlayerInfoList.AddPlayer("CCC", "Sample2Player2", "Su-25T", 4)
    PlayerInfoList.AddPlayer("DDD", "Sample3Player3", "F15", 5)
    
    UT.TestCompare(function() return PlayerInfoList.OnlinePlayers[2].UCID == "BBB" end)
    UT.TestCompare(function() return PlayerInfoList.OnlinePlayers[2].Name == "SamplePlayer" end)
    UT.TestCompare(function() return PlayerInfoList.OnlinePlayers[2].Role == "F15" end)
    UT.TestCompare(function() return PlayerInfoList.OnlinePlayers[2].Lives == 5 end)
    UT.TestCompare(function() return PlayerInfoList.OnlinePlayers[2].SortieID == -1 end)
    
    UT.TestCompare(function() return PlayerInfoList.OnlinePlayers[3].UCID == "CCC" end)
    UT.TestCompare(function() return PlayerInfoList.OnlinePlayers[3].Name == "Sample2Player2" end)
    UT.TestCompare(function() return PlayerInfoList.OnlinePlayers[3].Role == "Su-25T" end)
    UT.TestCompare(function() return PlayerInfoList.OnlinePlayers[3].Lives == 4 end)
    UT.TestCompare(function() return PlayerInfoList.OnlinePlayers[3].SortieID == -1 end)
    
    UT.TestCompare(function() return PlayerInfoList.OnlinePlayers[4].UCID == "DDD" end)
    UT.TestCompare(function() return PlayerInfoList.OnlinePlayers[4].Name == "Sample3Player3" end)
    UT.TestCompare(function() return PlayerInfoList.OnlinePlayers[4].Role == "F15" end)
    UT.TestCompare(function() return PlayerInfoList.OnlinePlayers[4].Lives == 5 end)
    UT.TestCompare(function() return PlayerInfoList.OnlinePlayers[4].SortieID == -1 end)
    
    UT.TestCompare(function() return PlayerInfoList.RemovePlayer("CCC") end)
    UT.TestCompare(function() return PlayerInfoList.FindPlayer("Sample2Player2") == nil end)
  end
end)