UT.TestCase("KI_Loader", 
function()
  UT.ValidateSetup(function() return StaticObject.getByName("TestStaticKILoader") ~= nil end)
  UT.ValidateSetup(function() return StaticObject.getByName("TestCargoKILoader") ~= nil end)
  UT.ValidateSetup(function() return Group.getByName("TestGroupNoWaypointsKILoader") ~= nil end)
  UT.ValidateSetup(function() return Group.getByName("TestGroupActiveWaypointKILoader") ~= nil end)
  UT.ValidateSetup(function() return Group.getByName("TestGroupCompletedWaypointKILoader") ~= nil end)
  UT.ValidateSetup(function() return Group.getByName("TestGroupDeadKILoader") ~= nil end)
  UT.ValidateSetup(function() return Group.getByName("TestGroupInactiveKILoader") ~= nil end)
  UT.ValidateSetup(function() return Group.getByName("TestGroupIgnorePrefixKILoader") ~= nil end)
  UT.ValidateSetup(function() return ZONE:New("TestCPZone") ~= nil end)
end,
function()
  UT.TestData.TestGroupNoWaypointsKILoader = Group.getByName("TestGroupNoWaypointsKILoader")
  UT.TestData.TestGroupActiveWaypointKILoader = Group.getByName("TestGroupActiveWaypointKILoader")
  UT.TestData.TestGroupCompletedWaypointKILoader = Group.getByName("TestGroupCompletedWaypointKILoader")
  UT.TestData.TestGroupDeadKILoader = Group.getByName("TestGroupDeadKILoader")
  UT.TestData.TestGroupInactiveKILoader = Group.getByName("TestGroupInactiveKILoader")
  UT.TestData.TestGroupIgnorePrefixKILoader = Group.getByName("TestGroupIgnorePrefixKILoader") 
  UT.TestData.TestCPZone = ZONE:New("TestCPZone")
  
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
  UT.TestData.CapturePoint = CP:New("Test CP", "TestCPZone", CP.Enum.CAPTUREPOINT, "TestCPZone")
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
    ['SideMissionGroundObjects'] = { "SMObject" },
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
        ['ID'] = 50,
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
      [4] = {
        ['Coalition'] = 1,
        ['Name'] = 'SMObject',
        ['Category'] = 2,
        ['ID'] = 51,
        ['Units'] = {
          [1] = {
            ['Type'] = 'BTR-80',
            ['Name'] = 'Should not be spawned',
            ['Position'] = {},
            ['ID'] = '400',
            ['Heading'] = 0,
          },
        },
        ['Size'] = 1,
      }
    }
  }
end,
function()

    -- PruneWaypoints tests
    if true then
      local _waypoints = {
        ["WP_Group_Far"] = { x = 1, y = 1, z = 1 },
        ["WP_Group_Close"] = { x = 1, y = 1, z = 1 },
        ["NoGroup"] = { x = 1, y = 1, z = 1 }
      }
      _waypoints = KI.Loader.PruneWaypoints(UT.TestData.coalitionExtract, _waypoints)
      UT.TestCompare(function() return _waypoints["NoGroup"] == nil end, "Expected PruneWaypoints to remove 'NoGroup'")
      UT.TestCompare(function() return _waypoints["WP_Group_Far"] ~= nil end, "PruneWaypoints removed group unexpectedly")
      UT.TestCompare(function() return _waypoints["WP_Group_Close"] ~= nil end, "PruneWaypoints removed group unexpectedly")
    end
    
    -- SyncWithMoose tests
    if true then
      local _groupTable = 
      {
        ["visible"] = false,
        ["taskSelected"] = true,
        ["route"] = {},
        ["tasks"] = {},
        ["hidden"] = false,
        ["units"] = {
          [1] = {
            ["type"] = 'BTR-80',
            ["transportable"] = 
            {
              ["randomTransportable"] = false,
            },
            ["unitId"] = '137',
            ["skill"] = "Average",
            ["y"] = 759919.5625,
            ["x"] = -124175.84375,
            ["name"] = 'UT_KI_Loader_Mock_Unit',
            ["playerCanDrive"] = true,
            ["heading"] = 1.8556762826387,
          }
        },
        ["y"] = 759919.5625,
        ["x"] = -124175.84375,
        ["name"] = 'UT_KI_Loader_Mock_Group',
        ["start_time"] = 0,
        ["task"] = "Ground Nothing",
      }
      local _countryId = 0 -- Russia
      local _categoryId = 2 -- vehicle
      local _dcsGroup = coalition.addGroup(_countryId, _categoryId, _groupTable)
      local _mooseGroup = KI.Loader.SyncWithMoose(_dcsGroup)
      UT.TestCompare(function() return _mooseGroup ~= nil end, "SyncWithMoose - expected Moose Group but got nil")
      UT.TestCompare(function() return _mooseGroup.ClassName == "GROUP" end, "SyncWithMoose - expected object to be type 'GROUP'")
      if _dcsGroup ~= nil then
        _dcsGroup:destroy()
      end
    end

    -- HandleWaypoints tests
    if true then
      local _mockFunctionWasCalled = false
      local _mockFunctionArgs = {}
      local _mockScheduleFunction = function(fnc, args, time)
        _mockFunctionWasCalled = true
        _mockFunctionArgs = args
      end
      
      local _reset = function()
        _mockFunctionWasCalled = false
        _mockFunctionArgs = {}
      end
      
      -- group has no waypoints assigned
      if true then
        local _dcsGroup = UT.TestData.TestGroupNoWaypointsKILoader
        KI.Data.Waypoints["TestGroupNoWaypointsKILoader"] = nil
        KI.Loader.HandleWaypoints(_dcsGroup, _mockScheduleFunction)
        
        UT.TestCompare(function() return not _mockFunctionWasCalled end, "HandleWaypoints - scheduled function was not supposed to be called")
        
        -- cleanup
        KI.Data.Waypoints["TestGroupNoWaypointsKILoader"] = nil
        _reset()
      end
      
      -- group has completed waypoint or is close by to destination
      if true then
        local _dcsGroup = UT.TestData.TestGroupCompletedWaypointKILoader
        local _dcsPosition = _dcsGroup:getUnit(1):getPosition().p
        local _wp = {
          x = _dcsPosition.x,
          y = _dcsPosition.z,
          z = _dcsPosition.y,
          speed = 20,
          formation = "column"
        }
        KI.Data.Waypoints["TestGroupCompletedWaypointKILoader"] = _wp
        KI.Loader.HandleWaypoints(_dcsGroup, _mockScheduleFunction)
        
        UT.TestCompare(function() return not _mockFunctionWasCalled end, "HandleWaypoints - scheduled function was not supposed to be called")
        UT.TestCompare(function() return KI.Data.Waypoints["TestGroupCompletedWaypointKILoader"] == nil end, "HandleWaypoints - Groups waypoint should have been removed from Waypoints hash")
        
        -- cleanup
        KI.Data.Waypoints["TestGroupCompletedWaypointKILoader"] = nil
        _reset()
      end
      
      -- group has active waypoint and needs to be tasked to go there
      if true then
        local _dcsGroup = UT.TestData.TestGroupActiveWaypointKILoader
        local _v3 = UT.TestData.TestCPZone:GetVec3()
        local _wp = { x = _v3.x, y = _v3.y, z = _v3.z, speed = 20, formation = "column" }
        KI.Data.Waypoints["TestGroupActiveWaypointKILoader"] = _wp
        KI.Loader.HandleWaypoints(_dcsGroup, _mockScheduleFunction)
        
        UT.TestCompare(function() return _mockFunctionWasCalled end, "HandleWaypoints - scheduled function was supposed to be called")
        UT.TestCompare(function() return _mockFunctionArgs.grp.GroupName == _dcsGroup:getName() end, "HandleWaypoints - invalid group passed to scheduled function as args")
        UT.TestCompare(function() return KI.Toolbox.TablesEqual(_mockFunctionArgs.pos, _wp, true) end, "HandleWaypoints - scheduled function args not equal")
        UT.TestCompare(function() return KI.Data.Waypoints["TestGroupActiveWaypointKILoader"] ~= nil end, "HandleWaypoints - Groups waypoint was removed from hash but should not have been")
        
        -- cleanup
        KI.Data.Waypoints["TestGroupActiveWaypointKILoader"] = nil
        _reset()
      end
    end
    
    -- GetGroundGroupsForImport tests
    if true then
      local _linqResults = KI.Loader.GetGroundGroupsForImport(UT.TestData.coalitionExtract)
      UT.TestCompare(function() return #_linqResults:toArray() == 2 end, "GetGroundGroupsForImport - expected 2 results")
      UT.TestCompare(function() return _linqResults:contains("WP_Group_Close", function(g, item) return g.Name == item end) end, "GetGroundGroupsForImport - result did not contain expected group")
      UT.TestCompare(function() return _linqResults:contains("WP_Group_Far", function(g, item) return g.Name == item end) end, "GetGroundGroupsForImport - result did not contain expected group")
    end
    
    -- GetGroupsForExtraction tests
    if true then
      local _defaultPrefixValue = KI.Config.IgnoreSaveGroupPrefix
      KI.Config.IgnoreSaveGroupPrefix = ""
      
      local _mockGroupFunction = function(side, category)
        return { 
          UT.TestData.TestGroupNoWaypointsKILoader, 
          UT.TestData.TestGroupCompletedWaypointKILoader, 
          UT.TestData.TestGroupCompletedWaypointKILoader,
          UT.TestData.TestGroupDeadKILoader,
          UT.TestData.TestGroupInactiveKILoader,
          UT.TestData.TestGroupIgnorePrefixKILoader 
        }
      end
      
      if true then
        local _linqResults = KI.Loader.GetGroupsForExtraction("", "", _mockGroupFunction)
        UT.TestCompare(function() return #_linqResults:toArray() == 4 end, "GetGroupsForExtraction - wrong number of results")
      end
      
      -- test to see if prefix ignoring works
      if true then
        KI.Config.IgnoreSaveGroupPrefix = "TestGroup"
        local _linqResults = KI.Loader.GetGroupsForExtraction("", "", _mockGroupFunction)
        UT.TestCompare(function() return #_linqResults:toArray() == 0 end, "GetGroupsForExtraction - Expected prefix groups to be ignored")
      end
      
      KI.Config.IgnoreSaveGroupPrefix = _defaultPrefixValue
    end

    -- GenerateUnitsTable tests
    if true then
      local _unitTable = KI.Loader.GenerateUnitsTable(UT.TestData.groupExtract.Units)
      local _unitExtract = UT.TestData.unitExtract
      
      -- Basic checks
      UT.TestCompare(function() return _unitTable ~= nil end)
      UT.TestCompare(function() return #_unitTable == 3 end)
      
      -- Test the schema of the table
      UT.TestCompare(function() return _unitTable[1]["type"] == _unitExtract.Type end)
      UT.TestCompare(function() return _unitTable[1]["unitId"] == _unitExtract.ID end)
      UT.TestCompare(function() return _unitTable[1]["y"] == _unitExtract.Position.p.z end)
      UT.TestCompare(function() return _unitTable[1]["x"] == _unitExtract.Position.p.x end)
      UT.TestCompare(function() return _unitTable[1]["name"] == _unitExtract.Name end)
      UT.TestCompare(function() return _unitTable[1]["heading"] == _unitExtract.Heading end)
    end
    
    -- GenerateGroupTable tests
    if true then
      local _groupTable = KI.Loader.GenerateGroupTable(UT.TestData.groupExtract)
      
      -- Basic checks
      UT.TestCompare(function() return _groupTable ~= nil end)
      
      -- Test the schema of the table
      --UT.TestCompare(function() return groupTable["groupId"] == UT.TestData.groupExtract.ID end)
      UT.TestCompare(function() return _groupTable["hidden"] == true end)
      --UT.TestCompare(function() return groupTable["units"] == unitTable end)
      UT.TestCompare(function() return _groupTable["y"] == UT.TestData.unitExtract.Position.p.z end)
      UT.TestCompare(function() return _groupTable["x"] == UT.TestData.unitExtract.Position.p.x end)
      UT.TestCompare(function() return _groupTable["name"] == UT.TestData.groupExtract.Name end)
    end
    
    -- KI.Loader.GenerateStaticTable tests
    if true then
    
      -- first test - static object that is non cargo
      if true then      
        local _staticExtract = UT.TestData.staticObj
        local _staticTable = KI.Loader.GenerateStaticTable(_staticExtract, "Fortifications", "DSMT", false)
        
        -- Basic checks
        UT.TestCompare(function() return _staticTable ~= nil end)
        
        -- Test the schema of the table
        UT.TestCompare(function() return _staticTable["Coalition"] == _staticExtract:getCoalition() end)
        UT.TestCompare(function() return _staticTable["Country"] == "Russia" end)
        UT.TestCompare(function() return _staticTable["CountryID"] == _staticExtract:getCountry() end)
        UT.TestCompare(function() return _staticTable["Category"] == "Fortifications" end)
        UT.TestCompare(function() return _staticTable["Type"] == _staticExtract:getTypeName() end)
        UT.TestCompare(function() return _staticTable["Name"] == _staticExtract:getName() end)
        UT.TestCompare(function() return _staticTable["ID"] == _staticExtract:getID() end)
        UT.TestCompare(function() return _staticTable["CanCargo"] == false end)
        UT.TestCompare(function() return _staticTable["Heading"] == mist.getHeading(_staticExtract, true) end)
        UT.TestCompare(function() return _staticTable["y"] == _staticExtract:getPosition().p.z end)
        UT.TestCompare(function() return _staticTable["x"] == _staticExtract:getPosition().p.x end)
        UT.TestCompare(function() return _staticTable["Component"] == "DSMT" end)
        UT.TestCompare(function() return _staticTable["mass"] == nil end)
      end
      
      -- second test - static object that is cargo
      if true then          
        local _cargoExtract = UT.TestData.cargoObj
        local _cargoTable = KI.Loader.GenerateStaticTable(_cargoExtract, "Cargo", "SLC", true)
        
        -- Basic checks
        UT.TestCompare(function() return _cargoTable ~= nil end)
        
        -- Test the schema of the table
        UT.TestCompare(function() return _cargoTable["Coalition"] == _cargoExtract:getCoalition() end)
        UT.TestCompare(function() return _cargoTable["Country"] == "Russia" end)
        UT.TestCompare(function() return _cargoTable["CountryID"] == _cargoExtract:getCountry() end)
        UT.TestCompare(function() return _cargoTable["Category"] == "Cargo" end)
        UT.TestCompare(function() return _cargoTable["Type"] == _cargoExtract:getTypeName() end)
        UT.TestCompare(function() return _cargoTable["Name"] == _cargoExtract:getName() end)
        UT.TestCompare(function() return _cargoTable["ID"] == _cargoExtract:getID() end)
        UT.TestCompare(function() return _cargoTable["CanCargo"] == true end)
        UT.TestCompare(function() return _cargoTable["Heading"] == mist.getHeading(_cargoExtract, true) end)
        UT.TestCompare(function() return _cargoTable["y"] == _cargoExtract:getPosition().p.z end)
        UT.TestCompare(function() return _cargoTable["x"] == _cargoExtract:getPosition().p.x end)
        UT.TestCompare(function() return _cargoTable["Component"] == "SLC" end)
        UT.TestCompare(function() return _cargoTable["mass"] == _cargoExtract:getCargoWeight() end)       
      end 
    end
    
    -- test DWM Import
    if true then     
      local _depot = UT.TestData.Depot
      KI.Loader.ImportDWM(UT.TestData.depotExtract)
      UT.TestCompare(function() return _depot.CurrentCapacity == 133 end)
      UT.TestCompare(function() return _depot.Resources["Infantry"].qty == 30 end)
      UT.TestCompare(function() return _depot.Resources["Watchtower Wood"].qty == 3 end)
      UT.TestCompare(function() return _depot.Resources["Fuel Tanks"].qty == 4 end)
      UT.TestCompare(function() return _depot.Resources["Outpost Wood"].qty == 4 end)
      UT.TestCompare(function() return _depot.Resources["Outpost Pipes"].qty == 4 end)    
    end
    
    
    -- test CP Import
    if true then
      local _capturePoint = UT.TestData.CapturePoint
      KI.Loader.ImportCapturePoints(UT.TestData.cpExtract)
      UT.TestCompare(function() return _capturePoint.RedUnits == 10 end)
      UT.TestCompare(function() return _capturePoint.BlueUnits == 0 end)
      UT.TestCompare(function() return _capturePoint.Owner == "Red" end)
      UT.TestCompare(function() return _capturePoint.Defenses["Infantry"].qty == 1 end)
      UT.TestCompare(function() return _capturePoint.Defenses["Infantry"].cap == 10 end)
      UT.TestCompare(function() return _capturePoint.Defenses["Vehicles"].qty == 2 end)
      UT.TestCompare(function() return _capturePoint.Defenses["Vehicles"].cap == 4 end)    
    end
    
    -- test KI.Loader.ImportCoalitionGroups
    if true then
      -- test to see if waypoints or dropped from data if the spawned unit is close enough to it
      -- only units that are a certain distance away from their wp after being spawned will be tasked to move there again
      -- this checks to see if this check is happening and the correct behaviour is observed
      --local _v3 = ZONE:New("TestCPZone"):GetVec3()
      --KI.Data.Waypoints["WP_Group_Far"] = { x = _v3.x, y = _v3.y, z = _v3.z }
      --KI.Data.Waypoints["WP_Group_Close"] = {x = -124175.84375, y = 759919.5625, z = 759919.5625}  -- setting this to be the same position that the unit is in
      --KI.Loader.ImportCoalitionGroups(UT.TestData.coalitionExtract)   
      --UT.TestCompare(function() return KI.Data.Waypoints["WP_Group_Close"] == nil end)  -- The function should remove this group from the hash
      --UT.TestCompare(function() return KI.Data.Waypoints["WP_Group_Far"] ~= nil end)  -- This group should still be in the hash
    end       
    
end,
function()
  KI.Data.Depots = {}
  KI.Data.CapturePoints = {}
end)
