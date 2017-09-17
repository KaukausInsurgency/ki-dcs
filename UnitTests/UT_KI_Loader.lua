UT.TestCase("KI_Loader", 
function()
  UT.ValidateSetup(function() return GROUP:FindByName("TestGroupKILoader") ~= nil end)
  UT.ValidateSetup(function() return StaticObject.getByName("TestStaticKILoader") ~= nil end)
  UT.ValidateSetup(function() return StaticObject.getByName("TestCargoKILoader") ~= nil end)
end,
function()
  -- NOTE - GenerateUnitsTable takes the file data object, not DCS Group or MOOSE GROUP
  UT.TestData.groupExtract =
  {
    ['Coalition'] = 1,
    ['Name'] = 'MANPADSSquadTemplate',
    ['Category'] = 2,
    ['ID'] = 36,
    ['Country'] = 0,
    ['Units'] = {
      [1] = {
        ['Type'] = 'SA-18 Igla-S manpad',
        ['Name'] = 'Unit #040',
        ['Position'] = {
          ['y'] = {
            ['y'] = 1,
            ['x'] = 0,
            ['z'] = 0,
          },
          ['x'] = {
            ['y'] = -0,
            ['x'] = 1,
            ['z'] = 0,
          },
          ['p'] = {
            ['y'] = 491.50051879883,
            ['x'] = -138875.71875,
            ['z'] = 829949.125,
          },
          ['z'] = {
            ['y'] = 0,
            ['x'] = -0,
            ['z'] = 1,
          },
        },
        ['ID'] = '74',
        ['Heading'] = 0,
      },
      [2] = {
        ['Type'] = 'SA-18 Igla-S manpad',
        ['Name'] = 'Unit #041',
        ['Position'] = {
          ['y'] = {
            ['y'] = 1,
            ['x'] = 0,
            ['z'] = 0,
          },
          ['x'] = {
            ['y'] = -0,
            ['x'] = 1,
            ['z'] = 0,
          },
          ['p'] = {
            ['y'] = 491.49337768555,
            ['x'] = -138878.28125,
            ['z'] = 829944,
          },
          ['z'] = {
            ['y'] = 0,
            ['x'] = -0,
            ['z'] = 1,
          },
        },
        ['ID'] = '75',
        ['Heading'] = 0,
      },
      [3] = {
        ['Type'] = 'SA-18 Igla-S comm',
        ['Name'] = 'Unit #042',
        ['Position'] = {
          ['y'] = {
            ['y'] = 1,
            ['x'] = 0,
            ['z'] = 0,
          },
          ['x'] = {
            ['y'] = -0,
            ['x'] = 1,
            ['z'] = 0,
          },
          ['p'] = {
            ['y'] = 491.52261352539,
            ['x'] = -138878.28125,
            ['z'] = 829953.6875,
          },
          ['z'] = {
            ['y'] = 0,
            ['x'] = -0,
            ['z'] = 1,
          },
        },
        ['ID'] = '76',
        ['Heading'] = 0,
      },
    },
    ['Size'] = 3
  }
  UT.TestData.unitExtract = UT.TestData.groupExtract.Units[1]
  UT.TestData.staticObj = StaticObject.getByName("TestStaticKILoader")
  UT.TestData.cargoObj = StaticObject.getByName("TestCargoKILoader")
end,
function()
    -- GenerateUnitsTable tests
    local unitTable = KI.Loader.GenerateUnitsTable(UT.TestData.groupExtract.Units)
    
    -- Basic checks
    UT.TestCompare(function() return unitTable ~= nil end)
    UT.TestCompare(function() return #unitTable == 3 end)
    
    -- Test the schema of the table
    UT.TestCompare(function() return unitTable[1]["type"] == UT.TestData.unitExtract.Type end)
    UT.TestCompare(function() return unitTable[1]["unitId"] == UT.TestData.unitExtract.ID end)
    UT.TestCompare(function() return unitTable[1]["y"] == UT.TestData.unitExtract.Position.p.z end)
    UT.TestCompare(function() return unitTable[1]["x"] == UT.TestData.unitExtract.Position.p.x end)
    UT.TestCompare(function() return unitTable[1]["name"] == UT.TestData.unitExtract.Name end)
    UT.TestCompare(function() return unitTable[1]["heading"] == UT.TestData.unitExtract.Heading end)
    
    
    -- GenerateGroupTable tests
    local groupTable = KI.Loader.GenerateGroupTable(UT.TestData.groupExtract)
    
    -- Basic checks
    UT.TestCompare(function() return groupTable ~= nil end)
    
    -- Test the schema of the table
    UT.TestCompare(function() return groupTable["groupId"] == UT.TestData.groupExtract.ID end)
    UT.TestCompare(function() return groupTable["hidden"] == true end)
    --UT.TestCompare(function() return groupTable["units"] == unitTable end)
    UT.TestCompare(function() return groupTable["y"] == UT.TestData.unitExtract.Position.p.z end)
    UT.TestCompare(function() return groupTable["x"] == UT.TestData.unitExtract.Position.p.x end)
    UT.TestCompare(function() return groupTable["name"] == UT.TestData.groupExtract.Name end)
    
    
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