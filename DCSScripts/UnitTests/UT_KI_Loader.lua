UT.TestCase("KI_Loader", 
function()
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
  UT.TestData.depotExtract = 
  {
    ['Depots'] = {
      [1] = {
        ['Zone'] = {
          ['Zone'] = {
            ['point'] = {
              ['y'] = 0,
              ['x'] = -150813.71875,
              ['z'] = 840108.3125,
            },
            ['radius'] = 300,
          },
          ['ClassName'] = 'ZONE',
        },
        ['__index'] = 'table',
        ['CurrentCapacity'] = 133,
        ['SupplyCheckRate'] = 7200,
        ['Object'] = {
          ['id_'] = 8000995,
        },
        ['Capacity'] = 150,
        ['Resources'] = {
          ['Infantry'] = {
            ['cap'] = 1,
            ['qty'] = 30,
          },
          ['Watchtower Wood'] = {
            ['cap'] = 2,
            ['qty'] = 3,
          },
          ['Fuel Tanks'] = {
            ['cap'] = 1,
            ['qty'] = 4,
          },
          ['Outpost Wood'] = {
            ['cap'] = 2,
            ['qty'] = 4,
          },
          ['Outpost Pipes'] = {
            ['cap'] = 3,
            ['qty'] = 4,
          },
          ['Power Truck'] = {
            ['cap'] = 1,
            ['qty'] = 4,
          },
          ['Fuel Truck'] = {
            ['cap'] = 1,
            ['qty'] = 4,
          },
          ['Cargo Crates'] = {
            ['cap'] = 1,
            ['qty'] = 8,
          },
          ['Watchtower Supplies'] = {
            ['cap'] = 1,
            ['qty'] = 4,
          },
          ['Command Truck'] = {
            ['cap'] = 1,
            ['qty'] = 4,
          },
          ['Tank'] = {
            ['cap'] = 3,
            ['qty'] = 8,
          },
          ['Outpost Supplies'] = {
            ['cap'] = 1,
            ['qty'] = 4,
          },
          ['Ammo Truck'] = {
            ['cap'] = 1,
            ['qty'] = 4,
          },
          ['APC'] = {
            ['cap'] = 2,
            ['qty'] = 8,
          },
        },
        ['Suppliers'] = {
        },
        ['Y'] = -150813.71875,
        ['X'] = 840108.3125,
        ['Name'] = 'Test Depot',
        ['IsSupplier'] = true,
        ['MGRS'] = '38T MN 64175 82063',
        ['LatLong'] = '43 11.430\'N   44 33.547\'E',
      }
    }
  }
  UT.TestData.Depot = DWM:New("Test Depot", "Test Depot Zone")
  UT.TestData.CapturePoint = CP:New("Test CP", "TestCPZone", "TestCPZone")
  table.insert(KI.Data.Depots, UT.TestData.Depot)
  table.insert(KI.Data.CapturePoints, UT.TestData.CapturePoint)
  UT.TestData.cpExtract =
  {
    ['CapturePoints'] = {
      [1] = {
        ['Name'] = 'Test CP',
        ['Defenses'] = {
          ['Infantry'] = { ['cap'] = 10, ['qty'] = 1},
          ['Vehicles'] = { ['cap'] = 4, ['qty'] = 2}
        },
        ['RedUnits'] = 10,
        ['BlueUnits'] = 0,
        ['Owner'] = "Red"
      }
    }
  }
  UT.TestData.coalitionExtract =
  {
    ['GroundGroups'] =
    {
      [1] = {
        ['Coalition'] = 1,
        ['Name'] = 'New Vehicle Group #002',
        ['Category'] = 2,
        ['ID'] = 49,
        ['Units'] = {
        },
        ['Size'] = 0,
      },
      [2] = {
        ['Coalition'] = 1,
        ['Name'] = 'WP_Group_Far',
        ['Category'] = 2,
        ['ID'] = 48,
        ['Country'] = 0,
        ['Units'] = {
          [1] = {
            ['Type'] = 'BTR-80',
            ['Name'] = 'Unit #067',
            ['Position'] = {
              ['y'] = {
                ['y'] = 1,
                ['x'] = 0,
                ['z'] = 0,
              },
              ['x'] = {
                ['y'] = 0,
                ['x'] = -0.28104224801064,
                ['z'] = 0.95969539880753,
              },
              ['p'] = {
                ['y'] = 430,
                ['x'] = -124175.84375,
                ['z'] = 759919.5625,
              },
              ['z'] = {
                ['y'] = 0,
                ['x'] = -0.95969539880753,
                ['z'] = -0.28104224801064,
              },
            },
            ['ID'] = '137',
            ['Heading'] = 1.8556762826387,
          },
        },
        ['Size'] = 1,
      },
      [3] = {
        ['Coalition'] = 1,
        ['Name'] = 'WP_Group_Close',
        ['Category'] = 2,
        ['ID'] = 48,
        ['Country'] = 0,
        ['Units'] = {
          [1] = {
            ['Type'] = 'BTR-80',
            ['Name'] = 'Unit #067',
            ['Position'] = {
              ['y'] = {
                ['y'] = 1,
                ['x'] = 0,
                ['z'] = 0,
              },
              ['x'] = {
                ['y'] = 0,
                ['x'] = -0.28104224801064,
                ['z'] = 0.95969539880753,
              },
              ['p'] = {
                ['y'] = 430,
                ['x'] = -124175.84375,
                ['z'] = 759919.5625,
              },
              ['z'] = {
                ['y'] = 0,
                ['x'] = -0.95969539880753,
                ['z'] = -0.28104224801064,
              },
            },
            ['ID'] = '137',
            ['Heading'] = 1.8556762826387,
          },
        },
        ['Size'] = 1,
      },
    }
  }
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
    
    
    -- test DWM Import
    if true then     
      KI.Loader.ImportDWM(UT.TestData.depotExtract)
      UT.TestCompare(function() return UT.TestData.Depot.CurrentCapacity == 133 end)
      UT.TestCompare(function() return UT.TestData.Depot.Resources["Infantry"].qty == 30 end)
      UT.TestCompare(function() return UT.TestData.Depot.Resources["Watchtower Wood"].qty == 3 end)
      UT.TestCompare(function() return UT.TestData.Depot.Resources["Fuel Tanks"].qty == 4 end)
      UT.TestCompare(function() return UT.TestData.Depot.Resources["Outpost Wood"].qty == 4 end)
      UT.TestCompare(function() return UT.TestData.Depot.Resources["Outpost Pipes"].qty == 4 end)    
    end
    
    
    -- test CP Import
    if true then
      KI.Loader.ImportCapturePoints(UT.TestData.cpExtract)
      UT.TestCompare(function() return UT.TestData.CapturePoint.RedUnits == 10 end)
      UT.TestCompare(function() return UT.TestData.CapturePoint.BlueUnits == 0 end)
      UT.TestCompare(function() return UT.TestData.CapturePoint.Owner == "Red" end)
      UT.TestCompare(function() return UT.TestData.CapturePoint.Defenses["Infantry"].qty == 1 end)
      UT.TestCompare(function() return UT.TestData.CapturePoint.Defenses["Infantry"].cap == 10 end)
      UT.TestCompare(function() return UT.TestData.CapturePoint.Defenses["Vehicles"].qty == 2 end)
      UT.TestCompare(function() return UT.TestData.CapturePoint.Defenses["Vehicles"].cap == 4 end)    
    end
    
    -- test KI.Loader.ImportCoalitionGroups
    if true then
      local v3 = ZONE:New("TestCPZone"):GetVec3()
      KI.Data.Waypoints["WP_Group_Far"] = { x = v3.x, y = v3.y, z = v3.z }
      KI.Data.Waypoints["WP_Group_Close"] = {x = -124175.84375, y = 400, z = 759919.5625}  -- setting this to be the same position that the unit is in
      UT.TestFunction(KI.Loader.ImportCoalitionGroups, UT.TestData.coalitionExtract)
      UT.TestCompare(function() return KI.Data.Waypoints["WP_Group_Close"] == nil end)  -- The function should remove this group from the hash
      UT.TestCompare(function() return KI.Data.Waypoints["WP_Group_Far"] ~= nil end)  -- This group should still be in the hash
    end
    
end,
function()
  KI.Data.Depots = {}
end)
