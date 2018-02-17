UT.TestCase("SLC_Callbacks", 
function()
  UT.ValidateSetup(function() return GROUP:FindByName("KA50 SLC") ~= nil end)
  UT.ValidateSetup(function() return GROUP:FindByName("TestHelicopterGroundSLC") ~= nil end)
end,
function()
  UT.TestData.PlayerGroup = GROUP:FindByName("KA50 SLC")
  UT.TestData.AIGroup = GROUP:FindByName("TestHelicopterGroundSLC")
  
  -- create a CP that will be used to test different unpacking checks
  -- Need to insert this into KI.Data.CapturePoints because Hook callback will search this array to see if crate is in zone
  local _cp = CP:New("SLCHookZone", "SLCHookZone", CP.Enum.CAPTUREPOINT)
  _cp.MaxCapacity = 1
  KI.Data.CapturePoints = {}
  table.insert(KI.Data.CapturePoints, _cp)
  
  -- Need to set SLC Transport Instances to mock the data that both helicopters are transporting infantry
  SLC.TransportInstances[UT.TestData.PlayerGroup:GetUnit(1):Name()] = { Size = 1 }
  SLC.TransportInstances[UT.TestData.AIGroup:GetUnit(1):Name()] = { Size = 1 }
  
  -- Set the PreOnRadioAction callback
  SLC.Config.PreOnRadioAction = KI.Hooks.SLCPreOnRadioAction             
end,
function()

  -- Test SLC.Unpack for cargo that is inside zone
  -- SLC.Config.AllowCrateUnpackInWild is turned on
  -- Should return true and fortify CP
  if true then
    SLC.Config.AllowCrateUnpackInWild = true     
    local result = SLC.Config.PreOnRadioAction("Unpack Nearest", "Crate Management", UT.TestData.PlayerGroup, "SLCPilot1", nil)                                              
    UT.TestCompare(function() return result end, "Unpack in zone must return true") -- must return true
  end
  
  -- Test SLC.Unpack for cargo that is inside zone
  -- SLC.Config.AllowCrateUnpackInWild is turned off
  -- Should return true and fortify CP
  if true then
    SLC.Config.AllowCrateUnpackInWild = false     
    local result = SLC.Config.PreOnRadioAction("Unpack Nearest", "Crate Management", UT.TestData.PlayerGroup, "SLCPilot1", nil)                                             
    UT.TestCompare(function() return result end, "Unpack in zone must return true") -- must return true
  end
  
  -- Test SLC.Unpack for cargo that is inside zone but zone is at max capacity
  -- Should return false
  if true then
    SLC.Config.AllowCrateUnpackInWild = true
    KI.Data.CapturePoints[1].RedUnits = 1   
    -- CP should have 1 at start
    UT.TestCompare(function() return KI.Data.CapturePoints[1].RedUnits == 1 end, "CP Must have 1 RedUnits")  
    local result = SLC.Config.PreOnRadioAction("Unpack Nearest", "Crate Management", UT.TestData.PlayerGroup, "SLCPilot1", nil)                                             
    UT.TestCompare(function() return not result end, "Unpack in zone at max capacity must return false") -- must return false
  end
  
  -- Test SLC.Unpack for cargo that is in wild
  -- SLC.Config.AllowCrateUnpackInWild is turned off
  -- Should return false
  if true then
    SLC.Config.AllowCrateUnpackInWild = false    
    local result = SLC.Config.PreOnRadioAction("Unpack Nearest", "Crate Management", UT.TestData.AIGroup, "Pilot #002", nil)                                             
    UT.TestCompare(function() return not result end, "Unpack in wild with setting off must return false") -- must return false
  end
  
  -- Test SLC.Unpack for cargo that is in wild
  -- SLC.Config.AllowCrateUnpackInWild is turned on
  -- Should return true
  if true then
    SLC.Config.AllowCrateUnpackInWild = true    
    local result = SLC.Config.PreOnRadioAction("Unpack Nearest", "Crate Management", UT.TestData.AIGroup, "Pilot #002", nil)                                             
    UT.TestCompare(function() return result end, "Unpack in wild with setting turned on must return true") -- must return true
  end
  
  -- Test SLC.LoadUnload for infantry that is in wild
  -- SLC.Config.AllowInfantryUnloadInWild is turned on
  -- Should return true
  if true then
    SLC.Config.AllowInfantryUnloadInWild = true    
    local result = SLC.Config.PreOnRadioAction("Load/Unload Troops", "Deploy Management", UT.TestData.AIGroup, "Pilot #002", nil)                                             
    UT.TestCompare(function() return result end, "Infantry Unload in wild with setting turned on must return true") -- must return true
  end
  
  -- Test SLC.LoadUnload for infantry that is in zone
  -- SLC.Config.AllowInfantryUnloadInWild is turned on
  -- Should return true
  if true then
    SLC.Config.AllowInfantryUnloadInWild = true   
    KI.Data.CapturePoints[1].RedUnits = 0 
    local result = SLC.Config.PreOnRadioAction("Load/Unload Troops", "Deploy Management", UT.TestData.PlayerGroup, "SLCPilot1", nil)                                             
    UT.TestCompare(function() return result end, "Infantry Unload in zone with setting turned on must return true") -- must return true
  end
  
  -- Test SLC.LoadUnload for infantry that is in zone
  -- SLC.Config.AllowInfantryUnloadInWild is turned off
  -- Should return true
  if true then
    SLC.Config.AllowInfantryUnloadInWild = false    
    KI.Data.CapturePoints[1].RedUnits = 0
    local result = SLC.Config.PreOnRadioAction("Load/Unload Troops", "Deploy Management", UT.TestData.PlayerGroup, "SLCPilot1", nil)                                             
    UT.TestCompare(function() return result end, "Infantry Unload in zone with setting turned off must return true") -- must return true
  end
  
  -- Test SLC.LoadUnload for infantry that is in zone but zone is at max capacity
  -- SLC.Config.AllowInfantryUnloadInWild is turned on
  -- Should return false
  if true then
    SLC.Config.AllowInfantryUnloadInWild = true    
    KI.Data.CapturePoints[1].RedUnits = 1
    local result = SLC.Config.PreOnRadioAction("Load/Unload Troops", "Deploy Management", UT.TestData.PlayerGroup, "SLCPilot1", nil)                                             
    UT.TestCompare(function() return not result end, "Infantry Unload in zone with max capacity must return false") -- must return true
  end
  
  -- Test SLC.LoadUnload for infantry that is in zone but zone is at max capacity
  -- SLC.Config.AllowInfantryUnloadInWild is turned off
  -- Should return false
  if true then
    SLC.Config.AllowInfantryUnloadInWild = false    
    KI.Data.CapturePoints[1].RedUnits = 1
    local result = SLC.Config.PreOnRadioAction("Load/Unload Troops", "Deploy Management", UT.TestData.PlayerGroup, "SLCPilot1", nil)                                             
    UT.TestCompare(function() return not result end, "Infantry Unload in zone with max capacity must return false") -- must return true
  end
  
  -- Test SLC.LoadUnload for infantry that is in zone
  -- SLC.Config.AllowInfantryUnloadInWild is turned off
  -- Should return true
  if true then
    SLC.Config.AllowInfantryUnloadInWild = false    
    local result = SLC.Config.PreOnRadioAction("Load/Unload Troops", "Deploy Management", UT.TestData.AIGroup, "Pilot #002", nil)                                             
    UT.TestCompare(function() return not result end, "Infantry Unload in wild with setting turned off must return false") -- must return true
  end
end,
function()
  SLC.TransportInstances[UT.TestData.PlayerGroup:GetUnit(1):Name()] = nil
  SLC.TransportInstances[UT.TestData.AIGroup:GetUnit(1):Name()] = nil
  KI.Data.CapturePoints = {}
  SLC.Config.PreOnRadioAction = nil
end)