UT.TestCase("AICOM_CORE", 
function()
  UT.ValidateSetup(function() return Group.getByName("AICOMBlueGroup") ~= nil end)
  UT.ValidateSetup(function() return Group.getByName("AICOMBlueGroup2") ~= nil end)
  UT.ValidateSetup(function() return Group.getByName("TestTemplate") ~= nil end)
  UT.ValidateSetup(function() return ZONE:New("NeutralCP") ~= nil end)
  UT.ValidateSetup(function() return ZONE:New("RedCP10") ~= nil end)
  UT.ValidateSetup(function() return ZONE:New("BlueCP10") ~= nil end)
  UT.ValidateSetup(function() return ZONE:New("ContestedCP10") ~= nil end)
  UT.ValidateSetup(function() return ZONE:New("RedCP20") ~= nil end)
  UT.ValidateSetup(function() return ZONE:New("BlueCP20") ~= nil end)
end, 
-- Setup 
function()
  -- Creating a deterministic Random Function Mockup
  UT.TestData.RandomMockUp = function(l1, l2)
    if l2 ~= nil then
      return l1
    else
      return l1
    end
  end
  
  UT.TestData.MockCapturePoints = {}
  
  -- Creating Mockup Capture Points
  local MockUpCapturePoint_NoSpawnZone = {}
  if true then
    local cp1 = CP:New("NeutralCP", "NeutralCP", CP.Enum.CAPTUREPOINT, "NeutralCP", "NeutralCP")
    cp1:SetCoalitionCounts(0, 0)
    table.insert(UT.TestData.MockCapturePoints, cp1)
    
    local cp2 = CP:New("RedCP10", "RedCP10", CP.Enum.CAPTUREPOINT, "RedCP10", "RedCP10")
    cp2:SetCoalitionCounts(10, 0)
    table.insert(UT.TestData.MockCapturePoints, cp2)
    
    local cp3 = CP:New("BlueCP10", "BlueCP10", CP.Enum.CAPTUREPOINT, "BlueCP10", "BlueCP10")
    cp3:SetCoalitionCounts(0, 10)
    table.insert(UT.TestData.MockCapturePoints, cp3)
    
    local cp4 = CP:New("ContestedCP10", "ContestedCP10", CP.Enum.CAPTUREPOINT, "ContestedCP10", "ContestedCP10")
    cp4:SetCoalitionCounts(10, 10)
    table.insert(UT.TestData.MockCapturePoints, cp4)
    
    local cp5 = CP:New("RedCP20", "RedCP20", CP.Enum.CAPTUREPOINT, "RedCP20", "RedCP20")
    cp5:SetCoalitionCounts(20, 0)
    table.insert(UT.TestData.MockCapturePoints, cp5)
    
    local cp6 = CP:New("BlueCP20", "BlueCP20", CP.Enum.CAPTUREPOINT, "BlueCP20", "BlueCP20")
    cp6:SetCoalitionCounts(0, 20)
    table.insert(UT.TestData.MockCapturePoints, cp6)
  end
  
  UT.TestData.MockCapturePoint_NoSpawnZones = CP:New("BlueCP20", "BlueCP20", CP.Enum.CAPTUREPOINT)
  UT.TestData.SpawnedGroups = {}
  
  -- modifying the values here for test purposes
  AICOM.Config.TurnRate = 1       -- the rate at which the AI Commander can make moves/actions
  AICOM.Config.InitMoves = 3      -- the number of moves the AI Commander can make a turn
  AICOM.Config.InitResource = 100 -- the number of units/resources the AI Commander has access to per turn
  AICOM.Config.AmbushProbability = 10 -- the probability of the AI doing an ambush action on it's third turn
  AICOM.Config.Random = UT.TestData.RandomMockUp  -- inject the random mockup 
  AICOM.CurrentMoney = AICOM.Config.InitResource
  AICOM.MovesRemaining = AICOM.Config.InitMoves
  AICOM.Config.Forces =
  {
    {
      Name = "TestForceA",
      Templates = { "TestTemplate" }, -- group templates to use
      Cost = 5,               -- cost to play / use
      Strength = 40,          -- Strength in number of units generated
      AAEffectiveness = 25,   -- Effectiveness against air units
      GNDEffectiveness = 100, -- Effectiveness against ground units
      SpawnZone = 1,          -- Which spawn zone will be selected (values are either 1 or 2) - these link to CP.SpawnZone1 and CP.SpawnZone2
      Formation = "Off Road", -- When spawned, the waypoint formation to use
      Speed = 30     
    },
    {
      Name = "TestForceB",
      Templates = { "TestTemplate", "TestTemplate" },
      Cost = 10,
      Strength = 40,
      AAEffectiveness = 50,
      GNDEffectiveness = 75,
      SpawnZone = 1,
      Formation = "Off Road",
      Speed = 30
    },
    {
      Name = "TestForceC",
      Templates = { "TestTemplate", "TestTemplate", "TestTemplate" },
      Cost = 15,
      Strength = 40,
      AAEffectiveness = 75,
      GNDEffectiveness = 50,
      SpawnZone = 1,
      Formation = "Off Road",
      Speed = 30
    },
    {
      Name = "TestForceD",
      Templates = { "TestTemplate", "TestTemplate" },
      Cost = 20,
      Strength = 40,
      AAEffectiveness = 100,
      GNDEffectiveness = 25,
      SpawnZone = 1,
      Formation = "Off Road",
      Speed = 30
    },
    {
      Name = "TestForceE",
      Templates = { "TestTemplate", "TestTemplate" },
      Cost = 15,
      Strength = 40,
      AAEffectiveness = 100,
      GNDEffectiveness = 0,
      SpawnZone = 1,
      Formation = "Off Road",
      Speed = 30
    },
  }
  
end,
function()     
  -- First Test - check that the config forces are sorting properly by cost and effectiveness
  AICOM.Init()
     
  -- Test that the forces sorted by AA Effectiveness and cost are correct
  UT.TestCompare(function() return AICOM.ForcesAACostSorted[1].Name == "TestForceE" end)
  UT.TestCompare(function() return AICOM.ForcesAACostSorted[2].Name == "TestForceD" end)
  UT.TestCompare(function() return AICOM.ForcesAACostSorted[3].Name == "TestForceC" end)
  UT.TestCompare(function() return AICOM.ForcesAACostSorted[4].Name == "TestForceB" end)
  UT.TestCompare(function() return AICOM.ForcesAACostSorted[5].Name == "TestForceA" end)


  -- Test that the forces sorted by GND Effectiveness and cost are correct
  UT.TestCompare(function() return AICOM.ForcesGNDCostSorted[1].Name == "TestForceA" end)
  UT.TestCompare(function() return AICOM.ForcesGNDCostSorted[2].Name == "TestForceB" end)
  UT.TestCompare(function() return AICOM.ForcesGNDCostSorted[3].Name == "TestForceC" end)
  UT.TestCompare(function() return AICOM.ForcesGNDCostSorted[4].Name == "TestForceD" end)
  UT.TestCompare(function() return AICOM.ForcesGNDCostSorted[5].Name == "TestForceE" end)

  
  
  -- TEST 2 - ANALYZE
  -- Capture points will only be of action Attack or Reinforce
  -- Ambush is a special third action that is triggered randomly and excludes capture points
  local AnalyzedCapturePoints = AICOM.Analyze(UT.TestData.MockCapturePoints)
  
  UT.TestCompare(function() return AnalyzedCapturePoints[1].CapturePoint.Name == "NeutralCP" end)
  UT.TestCompare(function() return AnalyzedCapturePoints[1].Cost == 1 end)
  UT.TestCompare(function() return AnalyzedCapturePoints[1].Action == AICOM.Enum.Actions.Attack end)
  
  UT.TestCompare(function() return AnalyzedCapturePoints[2].CapturePoint.Name == "RedCP10" end)
  UT.TestCompare(function() return AnalyzedCapturePoints[2].Cost == 12 end)
  UT.TestCompare(function() return AnalyzedCapturePoints[2].Action == AICOM.Enum.Actions.Reinforce end)
  
  UT.TestCompare(function() return AnalyzedCapturePoints[3].CapturePoint.Name == "BlueCP10" end)
  UT.TestCompare(function() return AnalyzedCapturePoints[3].Cost == 15 end)
  UT.TestCompare(function() return AnalyzedCapturePoints[3].Action == AICOM.Enum.Actions.Attack end)
  
  UT.TestCompare(function() return AnalyzedCapturePoints[4].CapturePoint.Name == "ContestedCP10" end)
  UT.TestCompare(function() return AnalyzedCapturePoints[4].Cost == 18 end)
  UT.TestCompare(function() return AnalyzedCapturePoints[4].Action == AICOM.Enum.Actions.Reinforce end)
  
  UT.TestCompare(function() return AnalyzedCapturePoints[5].CapturePoint.Name == "RedCP20" end)
  UT.TestCompare(function() return AnalyzedCapturePoints[5].Cost == 17 end)
  UT.TestCompare(function() return AnalyzedCapturePoints[5].Action == AICOM.Enum.Actions.Reinforce end)
  
  UT.TestCompare(function() return AnalyzedCapturePoints[6].CapturePoint.Name == "BlueCP20" end)
  UT.TestCompare(function() return AnalyzedCapturePoints[6].Cost == 25 end)
  UT.TestCompare(function() return AnalyzedCapturePoints[6].Action == AICOM.Enum.Actions.Attack end)
  
  -- Test that capture points with no spawn zone are ignored in analysis - this should return 0 results
  local AnalysisResults = AICOM.Analyze({ [1] = UT.TestData.MockCapturePoint_NoSpawnZones })
  UT.TestCompare(function() return AnalysisResults ~= nil end)
  UT.TestCompare(function() return #AnalysisResults == 0 end)
  
  -- Test that when passing in a nil argument, an empty table is returned
  local EmptyResults = AICOM.Analyze(nil)
  UT.TestCompare(function() return EmptyResults ~= nil end)
  UT.TestCompare(function() return next(EmptyResults) == nil end)
  
  -- Test 3 - ANALYZE PAY

  -- Scenario 1 - All 3 turns are attack turns
  AICOM.CurrentMoney = 90
  AICOM.MovesRemaining = 3
  UT.TestCompare(function() return AICOM.AnalyzePay(AICOM.Enum.Actions.Attack).AA == 5 end)
  UT.TestCompare(function() return AICOM.AnalyzePay(AICOM.Enum.Actions.Attack).GND == 35 end)
  
  AICOM.CurrentMoney = 50
  AICOM.MovesRemaining = 2
  UT.TestCompare(function() return AICOM.AnalyzePay(AICOM.Enum.Actions.Attack).AA == 2.5 end)
  UT.TestCompare(function() return AICOM.AnalyzePay(AICOM.Enum.Actions.Attack).GND == 32.5 end)
  
  AICOM.CurrentMoney = 15
  AICOM.MovesRemaining = 1
  UT.TestCompare(function() return AICOM.AnalyzePay(AICOM.Enum.Actions.Attack).AA == -2.5 end)
  UT.TestCompare(function() return AICOM.AnalyzePay(AICOM.Enum.Actions.Attack).GND == 27.5 end)
  
  
  -- Scenario 2 - All 3 turns are Reinforcement turns
  AICOM.CurrentMoney = 90
  AICOM.MovesRemaining = 3
  UT.TestCompare(function() return AICOM.AnalyzePay(AICOM.Enum.Actions.Reinforce).AA == 35 end)
  UT.TestCompare(function() return AICOM.AnalyzePay(AICOM.Enum.Actions.Reinforce).GND == 10 end)
  
  AICOM.CurrentMoney = 50
  AICOM.MovesRemaining = 2
  UT.TestCompare(function() return AICOM.AnalyzePay(AICOM.Enum.Actions.Reinforce).AA == 32.5 end)
  UT.TestCompare(function() return AICOM.AnalyzePay(AICOM.Enum.Actions.Reinforce).GND == 7.5 end)
  
  AICOM.CurrentMoney = 15
  AICOM.MovesRemaining = 1
  UT.TestCompare(function() return AICOM.AnalyzePay(AICOM.Enum.Actions.Reinforce).AA == 27.5 end)
  UT.TestCompare(function() return AICOM.AnalyzePay(AICOM.Enum.Actions.Reinforce).GND == 2.5 end)
  
  
  -- Scenario 3 - All 3 turns are Ambush turns
  AICOM.CurrentMoney = 90
  AICOM.MovesRemaining = 3
  UT.TestCompare(function() return AICOM.AnalyzePay(AICOM.Enum.Actions.Ambush).AA == -5 end)
  UT.TestCompare(function() return AICOM.AnalyzePay(AICOM.Enum.Actions.Ambush).GND == 20 end)
  
  AICOM.CurrentMoney = 50
  AICOM.MovesRemaining = 2
  UT.TestCompare(function() return AICOM.AnalyzePay(AICOM.Enum.Actions.Ambush).AA == -7.5 end)
  UT.TestCompare(function() return AICOM.AnalyzePay(AICOM.Enum.Actions.Ambush).GND == 17.5 end)
  
  AICOM.CurrentMoney = 15
  AICOM.MovesRemaining = 1
  UT.TestCompare(function() return AICOM.AnalyzePay(AICOM.Enum.Actions.Ambush).AA == -12.5 end)
  UT.TestCompare(function() return AICOM.AnalyzePay(AICOM.Enum.Actions.Ambush).GND == 12.5 end)
  
  
  -- Scenario 4 - First Turn is attack, second turn is reinforcement, third turn is ambush
  AICOM.CurrentMoney = 120
  AICOM.MovesRemaining = 3
  UT.TestCompare(function() return AICOM.AnalyzePay(AICOM.Enum.Actions.Attack).AA == 10 end)
  UT.TestCompare(function() return AICOM.AnalyzePay(AICOM.Enum.Actions.Attack).GND == 40 end)
  
  AICOM.CurrentMoney = 30
  AICOM.MovesRemaining = 2
  UT.TestCompare(function() return AICOM.AnalyzePay(AICOM.Enum.Actions.Reinforce).AA == 27.5 end)
  UT.TestCompare(function() return AICOM.AnalyzePay(AICOM.Enum.Actions.Reinforce).GND == 2.5 end)
  
  AICOM.CurrentMoney = 10
  AICOM.MovesRemaining = 1
  UT.TestCompare(function() return AICOM.AnalyzePay(AICOM.Enum.Actions.Ambush).AA == -15 end)
  UT.TestCompare(function() return AICOM.AnalyzePay(AICOM.Enum.Actions.Ambush).GND == 10 end)
  
  -- Test 4 - Try Buy AA
  
  if true then
    -- Scenario 1 - Attempt to buy AA units with a budget of 40
    -- Expected results
    -- 2x TestForceE (15 points x 2 = 30 points)
    -- 1x TestForceB (10 points)
    -- all 40 points spent
  
    local AACart = AICOM.TryBuyAA(40)
    UT.TestCompare(function() return #AACart == 3 end)  -- the size should be 3
    UT.TestCompare(function() return AACart[1].Name == "TestForceE" end)
    UT.TestCompare(function() return AACart[2].Name == "TestForceE" end)
    UT.TestCompare(function() return AACart[3].Name == "TestForceB" end)
  end
  
  if true then
    -- Scenario 2 - Attempt to buy AA units with a budget of 60
    -- Expected results
    -- 2x TestForceE (15 points x 2 = 30 points)
    -- 1x TestForceD (20 points)
    -- 1x TestForceB (10 points)
    -- all 60 points spent
  
    local AACart = AICOM.TryBuyAA(60)
    UT.TestCompare(function() return #AACart == 4 end)  -- the size should be 4
    UT.TestCompare(function() return AACart[1].Name == "TestForceE" end)
    UT.TestCompare(function() return AACart[2].Name == "TestForceE" end)
    UT.TestCompare(function() return AACart[3].Name == "TestForceD" end)
    UT.TestCompare(function() return AACart[4].Name == "TestForceB" end)
  end
  
  if true then
    -- Scenario 3 - Attempt to buy AA units with a budget of 30
    -- Expected results
    -- 2x TestForceE (15 points x 2 = 30 points)
    -- all 30 points spent
  
    local AACart = AICOM.TryBuyAA(30)
    UT.TestCompare(function() return #AACart == 2 end)  -- the size should be 2
    UT.TestCompare(function() return AACart[1].Name == "TestForceE" end)
    UT.TestCompare(function() return AACart[2].Name == "TestForceE" end)
  end
  
  if true then
    -- Scenario 4 - Attempt to buy AA units with a budget of 22
    -- Expected results
    -- 1x TestForceE (15 points)
    -- 1x TestForceA (5 points)
    -- 20 points spent
  
    local AACart = AICOM.TryBuyAA(22)
    UT.TestCompare(function() return #AACart == 2 end)  -- the size should be 2
    UT.TestCompare(function() return AACart[1].Name == "TestForceE" end)
    UT.TestCompare(function() return AACart[2].Name == "TestForceA" end)
  end
  
  if true then
    -- Scenario 5 - Attempt to buy AA units with a budget of 13
    -- Expected results
    -- 1x TestForceB (10 points)
    -- 10 points spent
  
    local AACart = AICOM.TryBuyAA(13)
    UT.TestCompare(function() return #AACart == 1 end)  -- the size should be 2
    UT.TestCompare(function() return AACart[1].Name == "TestForceB" end)
  end
  
  if true then
    -- Scenario 6 - Attempt to buy AA units with a budget of 0
    -- Expected results
    -- empty cart
  
    local AACart = AICOM.TryBuyAA(0)
    UT.TestCompare(function() return #AACart == 0 end)  -- the size should be 0
  end
  
  if true then
    -- Scenario 7 - Attempt to buy AA units with a budget of 3
    -- Expected results
    -- empty cart
  
    local AACart = AICOM.TryBuyAA(3)
    UT.TestCompare(function() return #AACart == 0 end)  -- the size should be 0
  end
  
  
  
  -- Test 5 - Try Buy GND
  
  if true then
    -- Scenario 1 - Attempt to buy GND units with a budget of 40
    -- Expected results
    -- 3x TestForceA (5 points x 3 = 15 points)
    -- 2x TestForceB (10 points x 2 = 20 points)
    -- 35 points spent
  
    local GNDCart = AICOM.TryBuyGND(40)
    UT.TestCompare(function() return #GNDCart == 5 end) 
    UT.TestCompare(function() return GNDCart[1].Name == "TestForceA" end)
    UT.TestCompare(function() return GNDCart[2].Name == "TestForceA" end)
    UT.TestCompare(function() return GNDCart[3].Name == "TestForceA" end)
    UT.TestCompare(function() return GNDCart[4].Name == "TestForceB" end)
    UT.TestCompare(function() return GNDCart[5].Name == "TestForceB" end)
  end
  
  if true then
    -- Scenario 2 - Attempt to buy GND units with a budget of 100
    -- Expected results
    -- 3x TestForceA (5 points x 3 = 15 points)
    -- 3x TestForceB (10 points x 3 = 30 points)
    -- 3x TestForceC (15 points x 3 = 45 points)
    -- 90 points spent
  
    local GNDCart = AICOM.TryBuyGND(100)
    UT.TestCompare(function() return #GNDCart == 9 end)  -- the size should be 9
    UT.TestCompare(function() return GNDCart[1].Name == "TestForceA" end)
    UT.TestCompare(function() return GNDCart[2].Name == "TestForceA" end)
    UT.TestCompare(function() return GNDCart[3].Name == "TestForceA" end)
    UT.TestCompare(function() return GNDCart[4].Name == "TestForceB" end)
    UT.TestCompare(function() return GNDCart[5].Name == "TestForceB" end)
    UT.TestCompare(function() return GNDCart[6].Name == "TestForceB" end)
    UT.TestCompare(function() return GNDCart[7].Name == "TestForceC" end)
    UT.TestCompare(function() return GNDCart[8].Name == "TestForceC" end)
    UT.TestCompare(function() return GNDCart[9].Name == "TestForceC" end)
  end
  
  if true then
    -- Scenario 3 - Attempt to buy GND units with a budget of 30
    -- Expected results
    -- 3x TestForceA (5 points x 3 = 15 points)
    -- 1x TestForceB (10 points)
    -- 25 points spent
  
    local GNDCart = AICOM.TryBuyGND(30)
    env.info(KI.Toolbox.Dump(GNDCart))
    UT.TestCompare(function() return #GNDCart == 4 end)  -- the size should be 4
    UT.TestCompare(function() return GNDCart[1].Name == "TestForceA" end)
    UT.TestCompare(function() return GNDCart[2].Name == "TestForceA" end)
    UT.TestCompare(function() return GNDCart[3].Name == "TestForceA" end)
    UT.TestCompare(function() return GNDCart[4].Name == "TestForceB" end)
  end
  
  if true then
    -- Scenario 4 - Attempt to buy GND units with a budget of 22
    -- Expected results
    -- 3x TestForceA (5 points x 3 = 15 points)
    -- 15 points spent
  
    local GNDCart = AICOM.TryBuyGND(22)
    UT.TestCompare(function() return #GNDCart == 3 end)  -- the size should be 2
    UT.TestCompare(function() return GNDCart[1].Name == "TestForceA" end)
    UT.TestCompare(function() return GNDCart[2].Name == "TestForceA" end)
    UT.TestCompare(function() return GNDCart[3].Name == "TestForceA" end)
  end
  
  if true then
    -- Scenario 5 - Attempt to buy GND units with a budget of 13
    -- Expected results
    -- 2x TestForceA (5 points x 2 = 10 points)
    -- 10 points spent
  
    local GNDCart = AICOM.TryBuyGND(13)
    UT.TestCompare(function() return #GNDCart == 2 end)  -- the size should be 2
    UT.TestCompare(function() return GNDCart[1].Name == "TestForceA" end)
    UT.TestCompare(function() return GNDCart[2].Name == "TestForceA" end)
  end
  
  if true then
    -- Scenario 6 - Attempt to buy GND units with a budget of 0
    -- Expected results
    -- empty cart
  
    local GNDCart = AICOM.TryBuyGND(0)
    UT.TestCompare(function() return #GNDCart == 0 end)  -- the size should be 0
  end
  
  if true then
    -- Scenario 7 - Attempt to buy GND units with a budget of 3
    -- Expected results
    -- empty cart
  
    local GNDCart = AICOM.TryBuyGND(3)
    UT.TestCompare(function() return #GNDCart == 0 end)  -- the size should be 0
  end
  
  if true then   
    -- SegmentAnalysis tests
    -- Invalid parameters
    UT.TestCompare(function() return AICOM.SegmentAnalysis(nil, nil) == nil end)        -- parameters nil
    UT.TestCompare(function() return AICOM.SegmentAnalysis({}, nil) == nil end)
    UT.TestCompare(function() return AICOM.SegmentAnalysis({}, 1) == nil end)           -- movelist is empty
    UT.TestCompare(function() return AICOM.SegmentAnalysis({ 1, 2, 3 }, 0) == nil end)  -- segments is 0
    UT.TestCompare(function() return AICOM.SegmentAnalysis({ 1, 2, 3 }, 4) == nil end)  -- length is less than segments
    
    if true then
      local res = AICOM.SegmentAnalysis({1}, 1)
      UT.TestCompare(function() return res ~= nil end)
      UT.TestCompare(function() return #res == 1 end)
      UT.TestCompare(function() return res[1] == 1 end)
    end
    
    if true then
      local res = AICOM.SegmentAnalysis({1, 2}, 1)
      UT.TestCompare(function() return res ~= nil end)
      UT.TestCompare(function() return #res == 1 end)
      UT.TestCompare(function() return res[1] == 1 end)
    end
    
    if true then
      local res = AICOM.SegmentAnalysis({1, 2, 3}, 1)
      UT.TestCompare(function() return res ~= nil end)
      UT.TestCompare(function() return #res == 1 end)
      UT.TestCompare(function() return res[1] == 1 end)
    end
    
    if true then
      local res = AICOM.SegmentAnalysis({1, 2, 3}, 2)
      UT.TestCompare(function() return res ~= nil end)
      UT.TestCompare(function() return #res == 2 end)
      UT.TestCompare(function() return res[1] == 1 end)
      UT.TestCompare(function() return res[2].Min == 2 end)
      UT.TestCompare(function() return res[2].Max == 3 end)
    end
    
    if true then
      local res = AICOM.SegmentAnalysis({1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}, 3)
      UT.TestCompare(function() return res ~= nil end)
      UT.TestCompare(function() return #res == 3 end)
      UT.TestCompare(function() return res[1] == 1 end)
      UT.TestCompare(function() return res[2].Min == 2 end)
      UT.TestCompare(function() return res[2].Max == 6 end)
      UT.TestCompare(function() return res[3].Min == 7 end)
      UT.TestCompare(function() return res[3].Max == 11 end)
    end
    
    if true then
      local res = AICOM.SegmentAnalysis({1, 2, 3, 4, 5, 6}, 6)
      UT.TestCompare(function() return res ~= nil end)
      UT.TestCompare(function() return #res == 6 end)
      UT.TestCompare(function() return res[1] == 1 end)
      UT.TestCompare(function() return res[2].Min == 2 end)
      UT.TestCompare(function() return res[2].Max == 2 end)
      UT.TestCompare(function() return res[3].Min == 3 end)
      UT.TestCompare(function() return res[3].Max == 3 end)
      UT.TestCompare(function() return res[4].Min == 4 end)
      UT.TestCompare(function() return res[4].Max == 4 end)
      UT.TestCompare(function() return res[5].Min == 5 end)
      UT.TestCompare(function() return res[5].Max == 5 end)
      UT.TestCompare(function() return res[6].Min == 6 end)
      UT.TestCompare(function() return res[6].Max == 6 end)
    end
    
    if true then
      local res = AICOM.SegmentAnalysis({1, 2, 3, 4, 5, 6}, 3)
      UT.TestCompare(function() return res ~= nil end)
      UT.TestCompare(function() return #res == 3 end)
      UT.TestCompare(function() return res[1] == 1 end)
      UT.TestCompare(function() return res[2].Min == 2 end)
      UT.TestCompare(function() return res[2].Max == 4 end)
      UT.TestCompare(function() return res[3].Min == 5 end)
      UT.TestCompare(function() return res[3].Max == 6 end)
    end
    
    if true then
      local res = AICOM.SegmentAnalysis({1, 2, 3, 4, 5, 6, 7, 8}, 3)
      UT.TestCompare(function() return res ~= nil end)
      UT.TestCompare(function() return #res == 3 end)
      UT.TestCompare(function() return res[1] == 1 end)
      UT.TestCompare(function() return res[2].Min == 2 end)
      UT.TestCompare(function() return res[2].Max == 5 end)
      UT.TestCompare(function() return res[3].Min == 6 end)
      UT.TestCompare(function() return res[3].Max == 8 end)
    end
  end
  
  -- CalculatePopulationCap Tests
  if true then
    UT.TestCompare(function() return AICOM.CalculatePopulationCap({}) == 0 end)
    UT.TestCompare(function() return AICOM.CalculatePopulationCap(nil) == 0 end)
    UT.TestCompare(function() return AICOM.CalculatePopulationCap({Group.getByName("TestTemplate")}) == 0 end)  -- this is an inactive template group
    UT.TestCompare(function() return AICOM.CalculatePopulationCap({Group.getByName("AICOMBlueGroup")}) == 4 end)
    UT.TestCompare(function() return AICOM.CalculatePopulationCap({Group.getByName("AICOMBlueGroup"), Group.getByName("AICOMBlueGroup2")}) == 9 end)
    AICOM.Config.PopulationCap = 0
    AICOM.DoTurn({}, 0) -- do turn should raise this flag KI.UTDATA.AICOM_POPCAP_REACHED when the pop cap has been reached
    UT.TestCompare(function() return KI.UTDATA.AICOM_POPCAP_REACHED end)
  end
end,
function()
  AICOM.Config.PopulationCap = 20
  AICOM.Config.Forces = {}
  AICOM.Config.AmbushZones = {}       
end)
  

  
  
  
  
  
  
  

UT.TestCase("AICOM_SPAWN", nil, 
function()
  -- Creating a deterministic Random Function Mockup
  UT.TestData.RandomMockUp = function(l1, l2)
    if l2 ~= nil then
      return l1
    else
      return l1
    end
  end
  
  UT.TestData.SpawnedGroups = {}
  
  -- modifying the values here for test purposes
  AICOM.Config.TurnRate = 1       -- the rate at which the AI Commander can make moves/actions
  AICOM.Config.InitMoves = 3      -- the number of moves the AI Commander can make a turn
  AICOM.Config.InitResource = 100 -- the number of units/resources the AI Commander has access to per turn
  AICOM.Config.AmbushProbability = 10 -- the probability of the AI doing an ambush action on it's third turn
  AICOM.Config.Random = UT.TestData.RandomMockUp  -- inject the random mockup 
  AICOM.CurrentMoney = AICOM.Config.InitResource
  AICOM.MovesRemaining = AICOM.Config.InitMoves
  AICOM.Config.Forces =
  {
    {
      Name = "TestForceA",
      Templates = { "TestTemplate" }, -- group templates to use
      Cost = 5,               -- cost to play / use
      Strength = 40,          -- Strength in number of units generated
      AAEffectiveness = 25,   -- Effectiveness against air units
      GNDEffectiveness = 100, -- Effectiveness against ground units
      SpawnZone = 2,          -- Which spawn zone will be selected (values are either 1 or 2) - these link to CP.SpawnZone1 and CP.SpawnZone2
      Formation = "Off Road", -- When spawned, the waypoint formation to use
      Speed = 30     
    },
    {
      Name = "TestForceB",
      Templates = { "TestTemplate", "TestTemplate" },
      Cost = 10,
      Strength = 40,
      AAEffectiveness = 50,
      GNDEffectiveness = 75,
      SpawnZone = 1,
      Formation = "Off Road",
      Speed = 30
    },
    {
      Name = "TestForceC",
      Templates = { "TestTemplate", "TestTemplate", "TestTemplate" },
      Cost = 15,
      Strength = 40,
      AAEffectiveness = 75,
      GNDEffectiveness = 50,
      SpawnZone = 1,
      Formation = "Off Road",
      Speed = 30
    },
    {
      Name = "TestForceD",
      Templates = { "TestTemplate", "TestTemplate" },
      Cost = 20,
      Strength = 40,
      AAEffectiveness = 100,
      GNDEffectiveness = 25,
      SpawnZone = 1,
      Formation = "Off Road",
      Speed = 30
    },
    {
      Name = "TestForceE",
      Templates = { "TestTemplate", "TestTemplate" },
      Cost = 15,
      Strength = 40,
      AAEffectiveness = 100,
      GNDEffectiveness = 0,
      SpawnZone = 1,
      Formation = "Off Road",
      Speed = 30
    },
  }
  
  UT.TestData.CountGroupsFunc = function(z)
    local _rcnt = 0
    local _bcnt = 0
    local _rGroups = coalition.getGroups(1, Group.Category.GROUND)
    local _bGroups = coalition.getGroups(2, Group.Category.GROUND)

    -- loop through red groups
    for j = 1, #_rGroups do
      local _runits = _rGroups[j]:getUnits()
      for k = 1, #_runits do
        local _rpos = _runits[k]:getPoint()
        if z:IsVec3InZone(_rpos) then
          _rcnt = _rcnt + 1 -- increment counter for red
          table.insert(UT.TestData.SpawnedGroups, _rGroups[j])
        end
      end
    end
    
    for j = 1, #_bGroups do
      local _bunits = _bGroups[j]:getUnits()
      for k = 1, #_bunits do
        local _bpos = _bunits[k]:getPoint()
        if z:IsVec3InZone(_bpos) then
          _bcnt = _bcnt + 1 -- increment counter for red
          table.insert(UT.TestData.SpawnedGroups, _bGroups[j])
        end
      end
    end
    
    return _rcnt, _bcnt
  end
end,
function()

  -- forces should spawn inside the CP Zone as a moving group
  if true then
    local _cp = CP:New("NeutralCP", "NeutralCP", CP.Enum.CAPTUREPOINT, "NeutralCP", "NeutralCP")
    local moneySpent = AICOM.Spawn(
          {AICOM.Config.Forces[1], AICOM.Config.Forces[1], AICOM.Config.Forces[2]}, 
          {AICOM.Config.Forces[3], AICOM.Config.Forces[4], AICOM.Config.Forces[5]}, 
          _cp)
    
    local _rcnt, _bcnt = UT.TestData.CountGroupsFunc(_cp.Zone)
    _cp:SetCoalitionCounts(_rcnt, _bcnt)
  
    UT.TestCompare(function() return moneySpent == 70 end)
    UT.TestCompare(function() return _rcnt == 0 end)
    UT.TestCompare(function() return _bcnt == 11 end) -- TestForceA(1) x 2 + TestForceB(2) + TestForceC(3) + TestForceD(2) + TestForceE(2)
    UT.TestCompare(function() return _cp:GetOwnership() == "Blue" end)
  end
  
  -- forces should spawn inside the CP SpawnZone1 and CP SpawnZone2 as a moving group
  if true then
    local _cp = CP:New("NeutralCP", "NeutralCP", CP.Enum.CAPTUREPOINT, "NeutralCPSpawn1", "NeutralCPSpawn2")
    local moneySpent = AICOM.Spawn(
          {AICOM.Config.Forces[1], AICOM.Config.Forces[1], AICOM.Config.Forces[2]}, 
          {AICOM.Config.Forces[3], AICOM.Config.Forces[4], AICOM.Config.Forces[5]}, 
          _cp)
    
    local _rcnt1, _bcnt1 = UT.TestData.CountGroupsFunc(_cp.SpawnZone1)
    local _rcnt2, _bcnt2 = UT.TestData.CountGroupsFunc(_cp.SpawnZone2)
    UT.TestCompare(function() return moneySpent == 70 end)
    UT.TestCompare(function() return _rcnt1 == 0 end)
    UT.TestCompare(function() return _bcnt1 == 9 end) -- TestForceB(2) + TestForceC(3) + TestForceD(2) + TestForceE(2)
    UT.TestCompare(function() return _rcnt2 == 0 end)
    UT.TestCompare(function() return _bcnt2 == 2 end) -- TestForceA(1) x 2 
  end
  
  -- test SpawnAmbush
  if true then
    local _z = ZONE:New("AmbushZone")
    local moneySpent = AICOM.SpawnAmbush({AICOM.Config.Forces[1], AICOM.Config.Forces[1], AICOM.Config.Forces[2]}, _z)
    moneySpent = moneySpent + AICOM.SpawnAmbush({AICOM.Config.Forces[3], AICOM.Config.Forces[4], AICOM.Config.Forces[5]}, _z)
    
    local _rcnt, _bcnt = UT.TestData.CountGroupsFunc(_z)
    UT.TestCompare(function() return moneySpent == 70 end)
    UT.TestCompare(function() return _rcnt == 0 end)
    UT.TestCompare(function() return _bcnt == 11 end) -- TestForceA(1) x 2 + TestForceB(2) + TestForceC(3) + TestForceD(2) + TestForceE(2)
  end
  
  
  
  -- This code cannot be tested
  -- the MOOSE:SPAWN:OnSpawnGroup handler is deferred execution
  -- This handler will be invoked after the unit tests have finished running, making it impossible to check here
  -- testing Custom Call back
  --[[
  if true then
    local _cp = CP:New("NeutralCP", "NeutralCP", CP.Enum.CAPTUREPOINT, "NeutralCP", "NeutralCP")
    UT.TestData.WAS_CALLBACK_CALLED = false
  
    AICOM.Config.OnSpawnGroup = function(moosegrp, spawntype, atkzone, grpconfig)
      env.info("UNIT TEST AICOM.Config.OnSpawnGroup called...")
      UT.TestData.WAS_CALLBACK_CALLED = true
      UT.TestData.CallBackGroup = moosegrp
      
      UT.TestCompare(function() return moosegrp ~= nil end)
      UT.TestCompare(function() return moosegrp.GroupName ~= nil end)
      UT.TestCompare(function() return spawntype == "MOVING" end)
      UT.TestCompare(function() return atkzone ~= nil end)
      UT.TestCompare(function() return grpconfig ~= nil end) 
    end
    
    local moneySpent = AICOM.Spawn({AICOM.Config.Forces[1]}, {}, _cp)     
    UT.TestCompare(function() return UT.TestData.WAS_CALLBACK_CALLED end)
  end   
  ]]--
  
  
end,
function()
  WAS_CALLBACK_CALLED = nil
  if UT.TestData.CallBackGroup then
    UT.TestData.CallBackGroup:Destroy()    
  end
  for i = 1, #UT.TestData.SpawnedGroups do
    if UT.TestData.SpawnedGroups[i] then
      UT.TestData.SpawnedGroups[i]:destroy()
    end
  end
  AICOM.Config.Forces = {}
  AICOM.Config.AmbushZones = {} 
end)









UT.TestCase("AICOM_PerformAction", nil, 
function()
  UT.TestData.SpawnedGroups = {}
  UT.TestData.CountGroupsFunc = function(z)
    local _rcnt = 0
    local _bcnt = 0
    local _rGroups = coalition.getGroups(1, Group.Category.GROUND)
    local _bGroups = coalition.getGroups(2, Group.Category.GROUND)

    -- loop through red groups
    for j = 1, #_rGroups do
      local _runits = _rGroups[j]:getUnits()
      for k = 1, #_runits do
        local _rpos = _runits[k]:getPoint()
        if z:IsVec3InZone(_rpos) then
          _rcnt = _rcnt + 1 -- increment counter for red
          table.insert(UT.TestData.SpawnedGroups, _rGroups[j])
        end
      end
    end
    
    for j = 1, #_bGroups do
      local _bunits = _bGroups[j]:getUnits()
      for k = 1, #_bunits do
        local _bpos = _bunits[k]:getPoint()
        if z:IsVec3InZone(_bpos) then
          _bcnt = _bcnt + 1 -- increment counter for red
          table.insert(UT.TestData.SpawnedGroups, _bGroups[j])
        end
      end
    end
    
    return _rcnt, _bcnt
  end
end,
function()
  if true then
    local _cp = CP:New("NeutralCP", "NeutralCP", CP.Enum.CAPTUREPOINT, "NeutralCP", "NeutralCP")
    -- Scenario 1 - Test Attack Action on ContestedCP with 90 Current Money
    AICOM.CurrentMoney = 90
    AICOM.MovesRemaining = 1
    AICOM.PerformAction(AICOM.Enum.Actions.Attack, 0, _cp)
    local rcount, bcount = UT.TestData.CountGroupsFunc(_cp.Zone)
    UT.TestCompare(function() return AICOM.MovesRemaining == 0 end)
    UT.TestCompare(function() return AICOM.CurrentMoney == -5 end)  -- 35 AA + 65 GND budget - about 95 points are spent
    UT.TestCompare(function() return rcount == 0 end)
    UT.TestCompare(function() return bcount > 0 end)
  end    
end,
function()
  for i = 1, #UT.TestData.SpawnedGroups do
    if UT.TestData.SpawnedGroups[i] then
      UT.TestData.SpawnedGroups[i]:destroy()
    end
  end
end)




