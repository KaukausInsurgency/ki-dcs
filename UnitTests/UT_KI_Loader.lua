UT.TestCase("KI_Loader", 
function()
    local groupObj = coalition.getGroup("TestGroup")
    local unitObj = groupObj.Units[1]
    local staticObj = coalition.getStatic("TestStatic")
    local cargoObj = coalition.getStatic("TestCargo")
    local componentObj = SLC.Config.Components["SomeComponent"]
    
    
    -- GenerateUnitsTable tests
    local unitTable = KI.Loader.GenerateUnitsTable(groupObj.Units)
    
    -- Basic checks
    UT.TestCompare(function() return unitTable ~= nil end)
    UT.TestCompare(function() return #unitTable == 1 end)
    
    -- Test the schema of the table
    UT.TestCompare(function() return unitTable[1]["type"] == unitObj.Type end)
    UT.TestCompare(function() return unitTable[1]["unitId"] == unitObj.ID end)
    UT.TestCompare(function() return unitTable[1]["y"] == unitObj.Position.p.z end)
    UT.TestCompare(function() return unitTable[1]["x"] == unitObj.Position.p.x end)
    UT.TestCompare(function() return unitTable[1]["name"] == unitObj.Name end)
    UT.TestCompare(function() return unitTable[1]["heading"] == unitObj.Heading end)
    
    
    -- GenerateGroupTable tests
    local groupTable = KI.Loader.GenerateGroupTable(groupObj)
    
    -- Basic checks
    UT.TestCompare(function() return groupTable ~= nil end)
    
    -- Test the schema of the table
    UT.TestCompare(function() return groupTable["groupId"] == groupObj.ID end)
    UT.TestCompare(function() return groupTable["hidden"] == true end)
    UT.TestCompare(function() return groupTable["units"] == unitTable end)
    UT.TestCompare(function() return groupTable["y"] == unitObj.Position.p.z end)
    UT.TestCompare(function() return groupTable["x"] == unitObj.Position.p.x end)
    UT.TestCompare(function() return groupTable["name"] == groupObj.Name end)
    
    
    -- KI.Loader.GenerateStaticTable tests
    
    
    -- first test - static object that is non cargo
    local staticTable = KI.Loader.GenerateStaticTable(staticObj, "Category", componentObj, false)
    
    -- Basic checks
    UT.TestCompare(function() return staticTable ~= nil end)
    
    -- Test the schema of the table
    UT.TestCompare(function() return staticTable["Coalition"] == staticObj:getCoalition() end)
    UT.TestCompare(function() return staticTable["Country"] == "Russia" end)
    UT.TestCompare(function() return staticTable["CountryID"] == staticObj:getCountry() end)
    UT.TestCompare(function() return staticTable["Category"] == "Category" end)
    UT.TestCompare(function() return staticTable["Type"] == staticObj:getTypeName() end)
    UT.TestCompare(function() return staticTable["Name"] == staticObj:getName() end)
    UT.TestCompare(function() return staticTable["ID"] == staticObj:getID() end)
    UT.TestCompare(function() return staticTable["CanCargo"] == false end)
    UT.TestCompare(function() return staticTable["Heading"] == mist.getHeading(staticObj, true) end)
    UT.TestCompare(function() return staticTable["y"] == staticObj:getPosition().p.z end)
    UT.TestCompare(function() return staticTable["x"] == staticObj:getPosition().p.x end)
    UT.TestCompare(function() return staticTable["Component"] == componentObj end)
    UT.TestCompare(function() return staticTable["mass"] == nil end)
    
    
    -- second test - static object that is cargo
    local cargoTable = KI.Loader.GenerateStaticTable(cargoObj, "Category", componentObj, true)
    
    -- Basic checks
    UT.TestCompare(function() return cargoTable ~= nil end)
    
    -- Test the schema of the table
    UT.TestCompare(function() return cargoTable["Coalition"] == cargoObj:getCoalition() end)
    UT.TestCompare(function() return cargoTable["Country"] == "Russia" end)
    UT.TestCompare(function() return cargoTable["CountryID"] == cargoObj:getCountry() end)
    UT.TestCompare(function() return cargoTable["Category"] == "Category" end)
    UT.TestCompare(function() return cargoTable["Type"] == cargoObj:getTypeName() end)
    UT.TestCompare(function() return cargoTable["Name"] == cargoObj:getName() end)
    UT.TestCompare(function() return cargoTable["ID"] == cargoObj:getID() end)
    UT.TestCompare(function() return cargoTable["CanCargo"] == true end)
    UT.TestCompare(function() return cargoTable["Heading"] == mist.getHeading(cargoObj, true) end)
    UT.TestCompare(function() return cargoTable["y"] == cargoObj:getPosition().p.z end)
    UT.TestCompare(function() return cargoTable["x"] == cargoObj:getPosition().p.x end)
    UT.TestCompare(function() return cargoTable["Component"] == componentObj end)
    UT.TestCompare(function() return cargoTable["mass"] == cargoObj:getCargoWeight() end)
    
    
    
end)