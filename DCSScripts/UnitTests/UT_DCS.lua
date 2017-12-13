UT.TestCase("DCS", 
function() 
  UT.ValidateSetup(function() return Unit.getByName("DCSPlane") ~= nil end)
  UT.ValidateSetup(function() return Unit.getByName("DCSGroundUnit") ~= nil end) 
  UT.ValidateSetup(function() return Unit.getByName("DCSHelo") ~= nil end) 
  UT.ValidateSetup(function() return Unit.getByName("DCSStructure") ~= nil end) 
  UT.ValidateSetup(function() return StaticObject.getByName("DCSCargo") ~= nil end) 
end, nil,
function()

  -- test that Unit:getCategory() works
  UT.TestCompare(function() return Unit.getByName("DCSPlane"):getCategory() == Unit.Category.AIRPLANE end)
  UT.TestCompare(function() return Unit.getByName("DCSGroundUnit"):getCategory() == Unit.Category.GROUND_UNIT end)
  UT.TestCompare(function() return Unit.getByName("DCSHelo"):getCategory() == Unit.Category.HELICOPTER end)
  UT.TestCompare(function() return Unit.getByName("DCSStructure"):getCategory() == Unit.Category.STRUCTURE end)
  
  -- test airbase getByName works
  UT.TestCompare(function() return Airbase.getByName("Batumi") ~= nil end)
  
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
    UT.TestCompare(function() return obj:isExist() end)
    obj:destroy()
    UT.TestCompare(function() return not obj:isExist() end)
    UT.TestCompare(function() return obj:getLife() < 1 end)
  end
end)