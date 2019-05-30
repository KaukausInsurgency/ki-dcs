UT.TestCase("DCS", 
function() 
  UT.ValidateSetup(function() return Unit.getByName("DCSPlane") ~= nil end)
  UT.ValidateSetup(function() return Unit.getByName("DCSGroundUnit") ~= nil end) 
  UT.ValidateSetup(function() return Unit.getByName("DCSHelo") ~= nil end) 
  UT.ValidateSetup(function() return Unit.getByName("DCSStructure") ~= nil end) 
  UT.ValidateSetup(function() return StaticObject.getByName("DCSCargo") ~= nil end) 
  UT.ValidateSetup(function() return Unit.getByName("DCSLateActivationUnit") ~= nil end) 
  UT.ValidateSetup(function() return Group.getByName("DCSPartialDeadGroup") ~= nil end)
end, nil,
function()

  -- test that Unit:getCategory() works
  UT.TestCompare(function() return Unit.getByName("DCSPlane"):getCategory() == Unit.Category.AIRPLANE end)
  UT.TestCompare(function() return Unit.getByName("DCSGroundUnit"):getCategory() == Unit.Category.GROUND_UNIT end)
  UT.TestCompare(function() return Unit.getByName("DCSHelo"):getCategory() == Unit.Category.HELICOPTER end)
  UT.TestCompare(function() return Unit.getByName("DCSStructure"):getCategory() == Unit.Category.GROUND_UNIT end)
  
  -- test late activation and whether :isActive() works and the group is not nil
  UT.TestCompare(function() return not Unit.getByName("DCSLateActivationUnit"):isActive() end, "Late activation group should return false for :isActive()") 
  UT.TestCompare(function() return Group.getByName("DCSLateActivationUnit") ~= nil end, "Late activation group should be returned from Group.getByName")
  
  -- test that calling Group:getUnit(1):getLife() > 0 is true, even if the group lead is dead
  UT.TestCompare(function() return Group.getByName("DCSPartialDeadGroup"):getUnit(1):getLife() > 0 end, "Group with dead group leader returned false for :getUnit(1):getLife()")
  
  -- Client slots should be visible in Group.getByName
  UT.TestCompare(function() return Group.getByName("DCSClientSlot") ~= nil end, "Client slots should be visible in Group.getByName")
  
  if true then
    local found = false
    for i, gp in pairs(coalition.getGroups(2, 0)) do
      if gp:getName() == "DCSClientSlot" then
        found = true
        break
      end
    end
    
    UT.TestCompare(function() return found end, "Client slots should be visible in when iterating through coalition.getGroups")
  end 
  -- test airbase getByName works
  UT.TestCompare(function() return Airbase.getByName("Batumi") ~= nil end, "Airbase.getByName should return an airbase object for 'Batumi'")
  
  -- test that spawning, then calling :destroy() on a cargo object actually kills it
  if true then
    local pos = StaticObject.getByName("DCSCargo"):getPoint()
    local obj = coalition.addStaticObject(country.id.RUSSIA, {
      country = "Russia",
      category = "Cargos",
      x = pos.x,
      y = pos.z,
      type = "ammo_cargo",
      name = "DCSSpawnedCargo",
      mass = 1400,
      canCargo = true
    })
    UT.TestCompare(function() return obj:isExist() end, "Spawned static object should exist via :isExist()")
    obj:destroy()
    UT.TestCompare(function() return not obj:isExist() end, "Calling :isExist() on a destroyed object should return false")
    UT.TestCompare(function() return obj:getLife() < 1 end, "Calling :getLife() on a destroyed object should return < 1")
  end
end)