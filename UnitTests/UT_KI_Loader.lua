UT.AddPreInitValidation(function() return GROUP.FindByName("TestGroupKILoader") ~= nil end)
UT.AddPreInitValidation(function() return StaticObject.getByName("TestStaticKILoader") ~= nil end)
UT.AddPreInitValidation(function() return StaticObject.getByName("TestCargoKILoader") ~= nil end)

UT.Setup = function()
  UT.TestData.groupObj = GROUP.FindByName("TestGroupKILoader")
  UT.TestData.unitObj = UT.TestData.groupObj.Units[1]
  UT.TestData.staticObj = StaticObject.getByName("TestStaticKILoader")
  UT.TestData.cargoObj = StaticObject.getByName("TestCargoKILoader")
end

UT.TestCase("KI_Loader", 
function()
    -- GenerateUnitsTable tests
    local unitTable = KI.Loader.GenerateUnitsTable(UT.TestData.groupObj.Units)
    
    -- Basic checks
    UT.TestCompare(function() return unitTable ~= nil end)
    UT.TestCompare(function() return #unitTable == 1 end)
    
    -- Test the schema of the table
    UT.TestCompare(function() return unitTable[1]["type"] == UT.TestData.unitObj.Type end)
    UT.TestCompare(function() return unitTable[1]["unitId"] == UT.TestData.unitObj.ID end)
    UT.TestCompare(function() return unitTable[1]["y"] == UT.TestData.unitObj.Position.p.z end)
    UT.TestCompare(function() return unitTable[1]["x"] == UT.TestData.unitObj.Position.p.x end)
    UT.TestCompare(function() return unitTable[1]["name"] == UT.TestData.unitObj.Name end)
    UT.TestCompare(function() return unitTable[1]["heading"] == UT.TestData.unitObj.Heading end)
    
    
    -- GenerateGroupTable tests
    local groupTable = KI.Loader.GenerateGroupTable(UT.TestData.groupObj)
    
    -- Basic checks
    UT.TestCompare(function() return groupTable ~= nil end)
    
    -- Test the schema of the table
    UT.TestCompare(function() return groupTable["groupId"] == UT.TestData.groupObj.ID end)
    UT.TestCompare(function() return groupTable["hidden"] == true end)
    UT.TestCompare(function() return groupTable["units"] == UT.TestData.unitTable end)
    UT.TestCompare(function() return groupTable["y"] == UT.TestData.unitObj.Position.p.z end)
    UT.TestCompare(function() return groupTable["x"] == UT.TestData.unitObj.Position.p.x end)
    UT.TestCompare(function() return groupTable["name"] == UT.TestData.groupObj.Name end)
    
    
    -- KI.Loader.GenerateStaticTable tests
    
    -- first test - static object that is non cargo
    local staticTable = KI.Loader.GenerateStaticTable(UT.TestData.staticObj, "Fortifications", "DSMT", false)
    
    -- Basic checks
    UT.TestCompare(function() return staticTable ~= nil end)
    
    -- Test the schema of the table
    UT.TestCompare(function() return staticTable["Coalition"] == UT.TestData.staticObj:getCoalition() end)
    UT.TestCompare(function() return staticTable["Country"] == "Russia" end)
    UT.TestCompare(function() return staticTable["CountryID"] == UT.TestData.staticObj:getCountry() end)
    UT.TestCompare(function() return staticTable["Category"] == "Fortifications" end)
    UT.TestCompare(function() return staticTable["Type"] == UT.TestData.staticObj:getTypeName() end)
    UT.TestCompare(function() return staticTable["Name"] == UT.TestData.staticObj:getName() end)
    UT.TestCompare(function() return staticTable["ID"] == UT.TestData.staticObj:getID() end)
    UT.TestCompare(function() return staticTable["CanCargo"] == false end)
    UT.TestCompare(function() return staticTable["Heading"] == mist.getHeading(UT.TestData.staticObj, true) end)
    UT.TestCompare(function() return staticTable["y"] == UT.TestData.staticObj:getPosition().p.z end)
    UT.TestCompare(function() return staticTable["x"] == UT.TestData.staticObj:getPosition().p.x end)
    UT.TestCompare(function() return staticTable["Component"] == "DSMT" end)
    UT.TestCompare(function() return staticTable["mass"] == nil end)
    
    -- second test - static object that is cargo
    local cargoTable = KI.Loader.GenerateStaticTable(UT.TestData.cargoObj, "Cargo", "SLC", true)
    
    -- Basic checks
    UT.TestCompare(function() return cargoTable ~= nil end)
    
    -- Test the schema of the table
    UT.TestCompare(function() return cargoTable["Coalition"] == UT.TestData.cargoObj:getCoalition() end)
    UT.TestCompare(function() return cargoTable["Country"] == "Russia" end)
    UT.TestCompare(function() return cargoTable["CountryID"] == UT.TestData.cargoObj:getCountry() end)
    UT.TestCompare(function() return cargoTable["Category"] == "Cargo" end)
    UT.TestCompare(function() return cargoTable["Type"] == UT.TestData.cargoObj:getTypeName() end)
    UT.TestCompare(function() return cargoTable["Name"] == UT.TestData.cargoObj:getName() end)
    UT.TestCompare(function() return cargoTable["ID"] == UT.TestData.cargoObj:getID() end)
    UT.TestCompare(function() return cargoTable["CanCargo"] == true end)
    UT.TestCompare(function() return cargoTable["Heading"] == mist.getHeading(UT.TestData.cargoObj, true) end)
    UT.TestCompare(function() return cargoTable["y"] == UT.TestData.cargoObj:getPosition().p.z end)
    UT.TestCompare(function() return cargoTable["x"] == UT.TestData.cargoObj:getPosition().p.x end)
    UT.TestCompare(function() return cargoTable["Component"] == "SLC" end)
    UT.TestCompare(function() return cargoTable["mass"] == UT.TestData.cargoObj:getCargoWeight() end)
end)