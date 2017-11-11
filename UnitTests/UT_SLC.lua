-- THERE ARE FAILURES IN THIS TEST CASE
-- THESE ARE RELATED TO DCS BUG - When a StaticObject invokes :destroy(), 
-- the :isExist() and :isAlive() still return true even though the object is dead 
-- this causes duplicate unpacking of existing crates and fails test cases

UT.TestCase("SLC INTERNAL", 
function()
  UT.ValidateSetup(function() return GROUP:FindByName("KA50 SLC") ~= nil end)
  UT.ValidateSetup(function() return GROUP:FindByName("TestHelicopterAirSLC") ~= nil end)
  UT.ValidateSetup(function() return GROUP:FindByName("TestHelicopterGroundSLC") ~= nil end)
  UT.ValidateSetup(function() return StaticObject.getByName("TestCargoSLC") ~= nil end)
  UT.ValidateSetup(function() return SLC.Config.ComponentTypes ~= nil end)
  UT.ValidateSetup(function() return SLC.Config.ComponentTypes.AmmoTruckCrate ~= nil end)
  UT.ValidateSetup(function() return SLC.Config.Assembler ~= nil end)
  UT.ValidateSetup(function() return SLC.Config.Assembler.WatchTower ~= nil end)
end, 
function()
  UT.TestData.Player = GROUP:FindByName("KA50 SLC"):GetDCSUnit(1)
  UT.TestData.AirHelo = GROUP:FindByName("TestHelicopterAirSLC"):GetDCSUnit(1)
  UT.TestData.GroundHelo = GROUP:FindByName("TestHelicopterGroundSLC"):GetDCSUnit(1)
  UT.TestData.StaticObject = StaticObject.getByName("TestCargoSLC")
  -- Mockup data
  UT.TestData.ValidCargoObject = 
  { 
    Object = UT.TestData.StaticObject, 
    Component = SLC.Config.ComponentTypes.AmmoTruckCrate
  }
  UT.TestData.InvalidCargoObject = 
  { 
    Object = 
    {
      isExist = function(obj) return false end
    },
    Component = SLC.Config.ComponentTypes.AmmoTruckCrate
  }
  UT.TestData.AmmoTruckCrate =
    { Object = {}, Component = SLC.Config.ComponentTypes.AmmoTruckCrate, Distance = 5 }
  UT.TestData.FuelTruckCrate =
    { Object = {}, Component = SLC.Config.ComponentTypes.FuelTruckCrate, Distance = 5 }
  UT.TestData.WatchTowerWoodCrate =
    { Object = {}, Component = SLC.Config.ComponentTypes.WatchTowerWoodCrate, Distance = 5 }
  UT.TestData.WatchTowerSupplyCrate =
    { Object = {}, Component = SLC.Config.ComponentTypes.WatchTowerSupplyCrate, Distance = 5 }
  UT.TestData.OutpostPipeCrate =
    { Object = {}, Component = SLC.Config.ComponentTypes.OutpostPipeCrate, Distance = 5 }
  UT.TestData.OutpostWoodCrate =
    { Object = {}, Component = SLC.Config.ComponentTypes.OutpostWoodCrate, Distance = 5 }
  UT.TestData.OutpostSupplyCrate =
    { Object = {}, Component = SLC.Config.ComponentTypes.OutpostSupplyCrate, Distance = 5 }
end,
function()

  -- SLC.InAir(obj)
  UT.TestCompare(function() return SLC.InAir(UT.TestData.Player) == false end)
  UT.TestCompare(function() return SLC.InAir(UT.TestData.AirHelo) end)
  UT.TestCompare(function() return SLC.InAir(UT.TestData.GroundHelo) == false end)
  
  
  
  -- SLC.IsCargoValid(cargo)
  UT.TestCompare(function() return not SLC.IsCargoValid(nil) end)
  UT.TestCompare(function() return not SLC.IsCargoValid(UT.TestData.Player) end)
  UT.TestCompare(function() return not SLC.IsCargoValid(UT.TestData.InvalidCargoObject) end)
  UT.TestCompare(function() return not SLC.IsCargoValid(UT.TestData.AirHelo) end)
  UT.TestCompare(function() return not SLC.IsCargoValid(UT.TestData.StaticObject) end)
  UT.TestCompare(function() return SLC.IsCargoValid(UT.TestData.ValidCargoObject) end)
      
      
      
  -- SLC.IsAssemblyValid(assembler, crates)
  UT.TestCompare(function() return not SLC.IsAssemblyValid(SLC.Config.Assembler.WatchTower, {}).result end)
  UT.TestCompare(function() return not SLC.IsAssemblyValid(SLC.Config.Assembler.FuelTruck, 
                {
                  UT.TestData.AmmoTruckCrate
                }).result end)
  UT.TestCompare(function() return SLC.IsAssemblyValid(SLC.Config.Assembler.FuelTruck, 
                {
                  UT.TestData.FuelTruckCrate
                }).result end)
  UT.TestCompare(function() return 
    not SLC.IsAssemblyValid(SLC.Config.Assembler.WatchTower, 
                            {
                              UT.TestData.AmmoTruckCrate
                            }).result end)
  UT.TestCompare(function() return 
    not SLC.IsAssemblyValid(SLC.Config.Assembler.WatchTower, 
                            {
                              UT.TestData.AmmoTruckCrate, 
                              UT.TestData.WatchTowerWoodCrate
                            }).result end)
  UT.TestCompare(function() return 
    not SLC.IsAssemblyValid(SLC.Config.Assembler.WatchTower, 
                       {
                         UT.TestData.AmmoTruckCrate, 
                         UT.TestData.WatchTowerSupplyCrate, 
                         UT.TestData.WatchTowerSupplyCrate 
                       }).result end)
  UT.TestCompare(function() return 
    not SLC.IsAssemblyValid(SLC.Config.Assembler.WatchTower, 
                       {
                         UT.TestData.WatchTowerWoodCrate, 
                         UT.TestData.WatchTowerWoodCrate 
                       }).result end)
  UT.TestCompare(function() return 
    SLC.IsAssemblyValid(SLC.Config.Assembler.WatchTower, 
                       {
                         UT.TestData.AmmoTruckCrate, 
                         UT.TestData.WatchTowerWoodCrate, 
                         UT.TestData.WatchTowerSupplyCrate 
                       }).result end)
  UT.TestCompare(function() return 
    SLC.IsAssemblyValid(SLC.Config.Assembler.WatchTower, 
                       {
                         UT.TestData.WatchTowerWoodCrate, 
                         UT.TestData.WatchTowerSupplyCrate 
                       }).result end)
  
  -- Testing Assembler with 3 components
  UT.TestCompare(function() return 
    SLC.IsAssemblyValid(SLC.Config.Assembler.OutPost, 
                       {
                         UT.TestData.OutpostPipeCrate, 
                         UT.TestData.OutpostSupplyCrate,
                         UT.TestData.OutpostWoodCrate 
                       }).result end)
  UT.TestCompare(function() return 
    not SLC.IsAssemblyValid(SLC.Config.Assembler.OutPost, 
                       {
                         UT.TestData.OutpostPipeCrate, 
                         UT.TestData.OutpostPipeCrate,
                         UT.TestData.OutpostWoodCrate 
                       }).result end)
  UT.TestCompare(function() return 
    not SLC.IsAssemblyValid(SLC.Config.Assembler.OutPost, 
                       {
                         UT.TestData.WatchTowerWoodCrate, 
                         UT.TestData.OutpostPipeCrate,
                         UT.TestData.OutpostWoodCrate 
                       }).result end)
       
       
       
  -- SLC.GetAssemblers(crates)
  
  -- test case 1 - Only AmmoTruck assembler should be returned, as it's the only valid one that can be built
  if true then
    local AssemblyList = SLC.GetAssemblers(
                        {
                          UT.TestData.WatchTowerWoodCrate, 
                          UT.TestData.OutpostPipeCrate, 
                          UT.TestData.AmmoTruckCrate,
                        })
    
    UT.TestCompare(function() return AssemblyList ~= nil end)
    UT.TestCompare(function() return #AssemblyList == 1 end)
    UT.TestCompare(function() return 
        KI.Toolbox.TablesEqual(AssemblyList[1].assembler, SLC.Config.Assembler.AmmoTruck) end)
  end
  
  -- test case 2 - no assemblers should be returned
  if true then
    local AssemblyList = SLC.GetAssemblers({})
    
    UT.TestCompare(function() return AssemblyList ~= nil end)
    UT.TestCompare(function() return #AssemblyList == 0 end)
  end
  
  -- test case 3 - all assemblers should be returned
  if true then
    local AssemblyList = SLC.GetAssemblers(
                        {
                          UT.TestData.WatchTowerWoodCrate, 
                          UT.TestData.WatchTowerSupplyCrate,
                          UT.TestData.OutpostPipeCrate, 
                          UT.TestData.OutpostWoodCrate,
                          UT.TestData.OutpostSupplyCrate,
                          UT.TestData.AmmoTruckCrate,
                        })
    
    UT.TestCompare(function() return AssemblyList ~= nil end)
    UT.TestCompare(function() return #AssemblyList == 3 end)
    UT.TestCompare(function() return 
        KI.Toolbox.TablesEqual(AssemblyList[1].assembler, SLC.Config.Assembler.WatchTower) end)
    UT.TestCompare(function() return 
        KI.Toolbox.TablesEqual(AssemblyList[2].assembler, SLC.Config.Assembler.OutPost) end)
    UT.TestCompare(function() return 
        KI.Toolbox.TablesEqual(AssemblyList[3].assembler, SLC.Config.Assembler.AmmoTruck) end)
  end
  
  -- SLC.GenerateName(n)
  if true then
    SLC.Config.SpawnID = 1
    UT.TestCompare(function() return SLC.GenerateName("Test") == "Test 2" end)
    UT.TestCompare(function() return SLC.GenerateName("Test") == "Test 3" end)
    UT.TestCompare(function() return SLC.GenerateName("Test") == "Test 4" end)
  end
  
end)




UT.TestCase("SLC CRATES", 
function()
  UT.ValidateSetup(function() return GROUP:FindByName("KA50 SLC") ~= nil end)
  UT.ValidateSetup(function() return GROUP:FindByName("TestHelicopterGroundSLC") ~= nil end)
  UT.ValidateSetup(function() return SLC.Config.ComponentTypes ~= nil end)
  UT.ValidateSetup(function() return SLC.Config.Assembler ~= nil end)
end,
function()
  UT.TestData.PlayerGroup = GROUP:FindByName("KA50 SLC")
  UT.TestData.AIGroup = GROUP:FindByName("TestHelicopterGroundSLC")
  
  -- Spawn some crates near the player that will be tested
  UT.TestData.FuelTruckCrateObject = SLC.SpawnCrate(UT.TestData.PlayerGroup, 
                                                    "SLCPilot1", SLC.Config.ComponentTypes.FuelTruckCrate)
                                                                                                  
  UT.TestData.OutpostPipeCrateObject = SLC.SpawnCrate(UT.TestData.PlayerGroup, 
                                              "SLCPilot1", SLC.Config.ComponentTypes.OutpostPipeCrate)                                                
  UT.TestData.OutpostSupplyCrateObject = SLC.SpawnCrate(UT.TestData.PlayerGroup, 
                                              "SLCPilot1", SLC.Config.ComponentTypes.OutpostSupplyCrate)                                                
  UT.TestData.OutpostWoodCrateObject = SLC.SpawnCrate(UT.TestData.PlayerGroup, 
                                              "SLCPilot1", SLC.Config.ComponentTypes.OutpostWoodCrate)                   
              
  -- Spawn some crates far away from the player so that we can test invalid actions
  UT.TestData.TankCrateObject = SLC.SpawnCrate(UT.TestData.AIGroup, 
                                              "SLCPilot2", SLC.Config.ComponentTypes.TankCrate)   
end,
function()
  -- Test that SLC.SpawnCrate returned appropriate names
  UT.TestCompare(function() return string.match(UT.TestData.FuelTruckCrateObject:getName(), "SLC FuelTruckCrate") end)
  UT.TestCompare(function() return string.match(UT.TestData.OutpostPipeCrateObject:getName(), "SLC OPPipe") end)
  UT.TestCompare(function() return string.match(UT.TestData.OutpostSupplyCrateObject:getName(), "SLC OPCrate") end)
  UT.TestCompare(function() return string.match(UT.TestData.OutpostWoodCrateObject:getName(), "SLC OPWood") end)
  UT.TestCompare(function() return string.match(UT.TestData.TankCrateObject:getName(), "SLC TankCrate") end)
  
  -- Test SLC.GetNearbyCargo(groupTransport) - should return a list of 4 results
  if true then
    
    local CargoList = SLC.GetNearbyCargo(UT.TestData.PlayerGroup)
    UT.TestCompare(function() return CargoList ~= nil end)
    UT.TestCompare(function() return #CargoList == 4 end)
    -- The 4 cargo objects must be returned in this list
    UT.TestCompare(function() 
      for i = 1, #CargoList do
        if CargoList[i].Object:getName() == UT.TestData.FuelTruckCrateObject:getName() then
          return true
        end
      end
      return false
    end)
    UT.TestCompare(function() 
      for i = 1, #CargoList do
        if CargoList[i].Object:getName() == UT.TestData.OutpostPipeCrateObject:getName() then
          return true
        end
      end
      return false
    end)
    UT.TestCompare(function() 
      for i = 1, #CargoList do
        if CargoList[i].Object:getName() == UT.TestData.OutpostSupplyCrateObject:getName() then
          return true
        end
      end
      return false
    end)
    UT.TestCompare(function() 
      for i = 1, #CargoList do
        if CargoList[i].Object:getName() == UT.TestData.OutpostWoodCrateObject:getName() then
          return true
        end
      end
      return false
    end)
  
  end

  -- Test SLC.Unpack(transportGroup, pilotname) 
  -- Result should be : 2 first successful unpacks, and unsuccessful unpacks after that
  -- Since we're not sure in what order the unpacks will happen (based on DCS distance calculations which can vary)
  -- We will first unpack everything, then test afterwards for expected results and side effects
  if true then
    UT.TestData.SpawnedGroupA = SLC.Unpack(UT.TestData.PlayerGroup, "SLCPilot1")
    UT.TestData.SpawnedGroupB = SLC.Unpack(UT.TestData.PlayerGroup, "SLCPilot1")
    local InvalidSpawn = SLC.Unpack(UT.TestData.PlayerGroup, "SLCPilot1")
    
    -- groups should exist
    UT.TestCompare(function() return UT.TestData.SpawnedGroupA ~= nil end)
    UT.TestCompare(function() return UT.TestData.SpawnedGroupB ~= nil end)
    UT.TestCompare(function() return InvalidSpawn == nil end)  -- should be nil
    
    -- groups should have this part in their name
    UT.TestCompare(function() return
                            string.match(UT.TestData.SpawnedGroupA.GroupName, "SLC OutPost") or 
                            string.match(UT.TestData.SpawnedGroupA.GroupName, "SLC FuelTruck") end)
    UT.TestCompare(function() return
                            string.match(UT.TestData.SpawnedGroupB.GroupName, "SLC OutPost") or 
                            string.match(UT.TestData.SpawnedGroupB.GroupName, "SLC FuelTruck") end)
      
    -- crates should be destroyed
    UT.TestCompare(function() return not UT.TestData.FuelTruckCrateObject:isExist() end)
    UT.TestCompare(function() return not UT.TestData.OutpostPipeCrateObject:isExist() end)
    UT.TestCompare(function() return not UT.TestData.OutpostSupplyCrateObject:isExist() end)
    UT.TestCompare(function() return not UT.TestData.OutpostWoodCrateObject:isExist() end)
  end
  
  -- next test for SLC.Unpack - this time where there is cargo around the player, but no valid assemblies to spawn
  if true then
    UT.TestData.OutpostPipeCrateObject2 = SLC.SpawnCrate(UT.TestData.PlayerGroup, 
                                              "SLCPilot1", SLC.Config.ComponentTypes.OutpostPipeCrate)                                                
    UT.TestData.OutpostSupplyCrateObject2 = SLC.SpawnCrate(UT.TestData.PlayerGroup, 
                                              "SLCPilot1", SLC.Config.ComponentTypes.OutpostSupplyCrate)
    
    UT.TestCompare(function() return SLC.Unpack(UT.TestData.PlayerGroup, "SLCPilot1") == nil end)
  end
  
  
  
  -- SLC.RelinkCargo(cargo)

end,
function()
  UT.TestData.SpawnedGroupA:Destroy()
  UT.TestData.SpawnedGroupB:Destroy()
  
  UT.TestData.FuelTruckCrateObject:destroy()
  
  UT.TestData.OutpostPipeCrateObject:destroy()
  UT.TestData.OutpostSupplyCrateObject:destroy()
  UT.TestData.OutpostWoodCrateObject:destroy()
  
  UT.TestData.OutpostPipeCrateObject2:destroy()
  UT.TestData.OutpostSupplyCrateObject2:destroy()
end)











-- SLC INFANTRY TRANSPORT TEST CASE

UT.TestCase("SLC TRANSPORT", 
function()
  UT.ValidateSetup(function() return GROUP:FindByName("KA50 SLC") ~= nil end)
  UT.ValidateSetup(function() return GROUP:FindByName("TestHelicopterGroundSLC") ~= nil end)
  UT.ValidateSetup(function() return SLC.Config.ComponentTypes ~= nil end)
  UT.ValidateSetup(function() return SLC.Config.Assembler ~= nil end)
end,
function()
  UT.TestData.PlayerGroup = GROUP:FindByName("KA50 SLC")
  UT.TestData.AIGroup = GROUP:FindByName("TestHelicopterGroundSLC")
                                            
  -- Spawn some infantry groups around the player to test
  UT.TestData.MANPADSquad = SLC.SpawnGroup(UT.TestData.PlayerGroup, "SLCPilot1", SLC.Config.InfantryTypes.MANPADSquad)
  UT.TestData.ATSquad = SLC.SpawnGroup(UT.TestData.PlayerGroup, "SLCPilot1", SLC.Config.InfantryTypes.ATSquad)
  UT.TestData.FarAwaySquad = SLC.SpawnGroup(UT.TestData.AIGroup, "SLCPilot2", SLC.Config.InfantryTypes.MANPADSquad)
end,
function()
  -- SLC.GetNearbyInfantryGroups(groupTransport)
  if true then
    
    local InfantryList = SLC.GetNearbyInfantryGroups(UT.TestData.PlayerGroup)
    UT.TestCompare(function() return InfantryList ~= nil end)
    UT.TestCompare(function() return #InfantryList == 2 end)
    -- The 2 infantry objects must be returned in this list
    UT.TestCompare(function() 
      for i = 1, #InfantryList do
        if InfantryList[i].Group.GroupName == UT.TestData.MANPADSquad.GroupName then
          return true
        end
      end
      return false
    end)
    UT.TestCompare(function() 
      for i = 1, #InfantryList do
        if InfantryList[i].Group.GroupName == UT.TestData.ATSquad.GroupName then
          return true
        end
      end
      return false
    end)
  
  end

  -- Test loading and unloading troops
  if true then
    
    -- First time loading it should succeed, then subsequent attempts should fail
    UT.TestCompare(function() return SLC.LoadTroops(UT.TestData.PlayerGroup, "SLCPilot1") end)
    UT.TestCompare(function() return not SLC.LoadTroops(UT.TestData.PlayerGroup, "SLCPilot1") end)
    UT.TestCompare(function() return not SLC.LoadTroops(UT.TestData.PlayerGroup, "SLCPilot1") end)
    UT.TestCompare(function() return not SLC.LoadTroops(UT.TestData.PlayerGroup, "SLCPilot1") end)
    UT.TestCompare(function() return not SLC.LoadTroops(UT.TestData.PlayerGroup, "SLCPilot1") end)
    
    -- Only 1 of the groups should be destroyed and nil, not both 
    -- (since we're not sure which based on dcs runtime, use xor
    UT.TestCompare(function() return 
          (UT.TestData.MANPADSquad:IsAlive() or UT.TestData.ATSquad:IsAlive()) and 
          (not (UT.TestData.MANPADSquad:IsAlive() and UT.TestData.ATSquad:IsAlive())) end)
            
    -- Check that SLC is storing the reference properly
    UT.TestCompare(function() return SLC.TransportInstances["SLCPilot1"] ~= nil end)
    UT.TestCompare(function() return 
        string.match(SLC.TransportInstances["SLCPilot1"].SpawnName, "SLC ATInfantry") or
        string.match(SLC.TransportInstances["SLCPilot1"].SpawnName, "SLC MANPADS") end)
      
    -- Now unload troops - first time should succeed, subsequent attempts should fail
    UT.TestData.UnloadedSquad = SLC.UnloadTroops(UT.TestData.PlayerGroup, "SLCPilot1")
    UT.TestCompare(function() return UT.TestData.UnloadedSquad ~= nil end)
    -- check that the newly spawned squad matches an existing template name from this test
    UT.TestCompare(function() return 
        string.match(UT.TestData.UnloadedSquad.GroupName, "SLC ATInfantry") or
        string.match(UT.TestData.UnloadedSquad.GroupName, "SLC MANPADS") end)
      
    -- all of these attempts should fail
    UT.TestCompare(function() return SLC.UnloadTroops(UT.TestData.PlayerGroup, "SLCPilot1") == nil end)
    UT.TestCompare(function() return SLC.UnloadTroops(UT.TestData.PlayerGroup, "SLCPilot1") == nil end)
    UT.TestCompare(function() return SLC.UnloadTroops(UT.TestData.PlayerGroup, "SLCPilot1") == nil end)

    -- testing LoadUnload - we just unloaded a squad so we should receive a "MOUNT" with Result = true
    local a = SLC.LoadUnload(UT.TestData.PlayerGroup, "SLCPilot1") 
    UT.TestCompare(function() return a.Action == "MOUNT" end)
    UT.TestCompare(function() return a.Result == true end)
    
    -- now calling LoadUnload should unload and spawn a new group
   
    local b = SLC.LoadUnload(UT.TestData.PlayerGroup, "SLCPilot1")
    UT.TestCompare(function() return b.Action == "DISMOUNT" end)
    UT.TestCompare(function() return b.Result ~= nil end)
    UT.TestData.UnloadedSquad = b.Result  -- the spawned group is returned in the Result property - reassign it back to this TestData member so that it gets destroyed at the end of the test cleanly
  end
  
end,
function()
  UT.TestData.MANPADSquad:Destroy()
  UT.TestData.FarAwaySquad:Destroy()
  UT.TestData.ATSquad:Destroy()
  UT.TestData.UnloadedSquad:Destroy()
end)
