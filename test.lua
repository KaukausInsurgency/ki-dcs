--print(string.format("%-25s|%-5s|%-5s", "Defense", "Count", "limit") .. "\n")
--print(string.format("%-25s|%-5d|%-5d", "T-90", 15, 30) .. "\n")

env.info("Creating StaticObject Instance 'TESTCARGO'")
local function PositionAt12Oclock(_unit, _offset)
    local _position = _unit:getPosition()
    local _angle = math.atan2(_position.x.z, _position.x.x)
    local _xOffset = math.cos(_angle) * _offset
    local _yOffset = math.sin(_angle) * _offset

    local _point = _unit:getPoint()
    return { x = _point.x + _xOffset, z = _point.z + _yOffset, y = _point.y }
end

local pos = PositionAt12Oclock(Unit.getByName("SLCPilot1"), 30)
local test_cargo_obj = coalition.addStaticObject(country.id.RUSSIA, {
		country = "Russia",
		category = "Cargos",
		x = pos.x,
		y = pos.z,
		type = "ammo_cargo",
		name = "TESTCARGO",
		mass = 1000,
		canCargo = true
	})
env.info("TESTCARGO - Is ALIVE? (StaticObject.getByName():isExist()) : " .. tostring(StaticObject.getByName("TESTCARGO"):isExist()))
env.info("TESTCARGO - Is ALIVE? (test_cargo_obj:isExist()) : " .. tostring(test_cargo_obj:isExist()))
env.info("Destroying Crate TESTCARGO (using obj:destroy())")
test_cargo_obj:destroy()
env.info("TESTCARGO - Is ALIVE? (test_cargo_obj:isExist()) : " .. tostring(test_cargo_obj:isExist()))
env.info("TESTCARGO - Is ALIVE? (StaticObject.getByName():isExist()) : " .. tostring(StaticObject.getByName("TESTCARGO"):isExist()))
--env.info("Destroying Crate TESTCARGO (StaticObject.getByName():destroy()")
--StaticObject.getByName("TESTCARGO"):destroy()
--env.info("TESTCARGO - Is ALIVE? (test_cargo_obj:isExist()) : " .. tostring(test_cargo_obj:isExist()))
--env.info("TESTCARGO - Is ALIVE? (StaticObject.getByName():isExist()) : " .. tostring(StaticObject.getByName("TESTCARGO"):isExist()))

env.info("Unit.getType NIL? : " .. tostring(Unit.getByName("SLCPilot1").getType == nil))
env.info("TestKIScoreEnemyAir1 TYPE : " .. Unit.getByName("TestKIScoreEnemyAir1"):getTypeName())


local t = {
	["CapturePoints"] = {
		[1] = {
			["RedUnits"] = 0,
			["BlueUnits"] = 0,
			["Zone"] = {
				["Zone"] = {
					["point"] = {
						["y"] = 0,
						["x"] = -150272,
						["z"] = 840233.6875,
					},
					["radius"] = 1000,
				},
				["ClassName"] = "ZONE",
			},
			["LatLong"] = "43 11.707'N   44 33.693'E",
			["MGRS"] = "38T MN 64375 82575",
			["Owner"] = "Neutral",
			["Defenses"] = {
				["Vehicle"] = {
					["cap"] = 8,
					["qty"] = 0,
				},
				["Infantry"] = {
					["cap"] = 4,
					["qty"] = 0,
				},
			},
			["Name"] = "Beslan City",
			["SpawnZone"] = {
				["Zone"] = {
					["point"] = {
						["y"] = 0,
						["x"] = -147162.984375,
						["z"] = 833540.1875,
					},
					["radius"] = 1000,
				},
				["ClassName"] = "ZONE",
			},
			["__index"] = "table",
		},
		[2] = {
			["RedUnits"] = 0,
			["BlueUnits"] = 5,
			["Zone"] = {
				["Zone"] = {
					["point"] = {
						["y"] = 0,
						["x"] = -148816.28125,
						["z"] = 843763.6875,
					},
					["radius"] = 2000,
				},
				["ClassName"] = "ZONE",
			},
			["LatLong"] = "43 12.216'N   44 36.394'E",
			["MGRS"] = "38T MN 68038 83498",
			["Owner"] = "Blue",
			["Defenses"] = {
				["Vehicle"] = {
					["cap"] = 8,
					["qty"] = 0,
				},
				["Infantry"] = {
					["cap"] = 4,
					["qty"] = 0,
				},
			},
			["Name"] = "Beslan Airport",
			["SpawnZone"] = {
				["Zone"] = {
					["point"] = {
						["y"] = 0,
						["x"] = -147841.59375,
						["z"] = 847474.625,
					},
					["radius"] = 1000,
				},
				["ClassName"] = "ZONE",
			},
			["__index"] = "table",
		},
		[3] = {
			["RedUnits"] = 0,
			["BlueUnits"] = 0,
			["Zone"] = {
				["Zone"] = {
					["point"] = {
						["y"] = 0,
						["x"] = -154460.578125,
						["z"] = 828232.3125,
					},
					["radius"] = 1000,
				},
				["ClassName"] = "ZONE",
			},
			["LatLong"] = "43 10.373'N   44 24.588'E",
			["MGRS"] = "38T MN 52028 80182",
			["Owner"] = "Neutral",
			["Defenses"] = {
				["Vehicle"] = {
					["cap"] = 8,
					["qty"] = 0,
				},
				["Infantry"] = {
					["cap"] = 4,
					["qty"] = 0,
				},
			},
			["Name"] = "Kirovo City",
			["SpawnZone"] = {
				["Zone"] = {
					["point"] = {
						["y"] = 0,
						["x"] = -157952.640625,
						["z"] = 828042.375,
					},
					["radius"] = 1000,
				},
				["ClassName"] = "ZONE",
			},
			["__index"] = "table",
		},
	},
	["SortieID"] = 0,
	["FARPZones"] = {
	},
	["GameEventQueue"] = {
	},
	["SideMissions"] = {
		[1] = {
			["CheckRate"] = 30,
			["Zones"] = {
				[1] = {
					["Zone"] = {
						["point"] = {
							["y"] = 0,
							["x"] = -151701.421875,
							["z"] = 840902.875,
						},
						["radius"] = 300,
					},
					["ClassName"] = "ZONE",
				},
				[2] = {
					["Zone"] = {
						["point"] = {
							["y"] = 0,
							["x"] = -151622.859375,
							["z"] = 842145.6875,
						},
						["radius"] = 300,
					},
					["ClassName"] = "ZONE",
				},
				[3] = {
					["Zone"] = {
						["point"] = {
							["y"] = 0,
							["x"] = -152601.421875,
							["z"] = 841067.125,
						},
						["radius"] = 300,
					},
					["ClassName"] = "ZONE",
				},
				[4] = {
					["Zone"] = {
						["point"] = {
							["y"] = 0,
							["x"] = -153480,
							["z"] = 841045.6875,
						},
						["radius"] = 300,
					},
					["ClassName"] = "ZONE",
				},
			},
			["Life"] = 0,
			["Expiry"] = 600,
			["DestroyTime"] = 300,
			["Done"] = false,
			["Name"] = "Destroy Insurgent Camp",
			["__index"] = "table",
		},
	},
	["SessionID"] = 38,
	["Sorties"] = {
	},
	["Templates"] = {
		[1] = "TemplateInsCamp",
		[2] = "InfantrySquadTemplate",
		[3] = "ATSquadTemplate",
		[4] = "MANPADSSquadTemplate",
		[5] = "Spawn FuelTruck Template",
		[6] = "Spawn CommandTruck Template",
		[7] = "Spawn AmmoTruck Template",
		[8] = "Spawn PowerTruck Template",
		[9] = "Spawn MechBTR Template",
		[10] = "Spawn TankT72 Template",
		[11] = "Spawn WatchTower Template",
		[12] = "Spawn Outpost Template",
	},
	["OnlinePlayers"] = {
	},
	["ActiveMissions"] = {
		[1] = {
			["Resource"] = {
				["Arguments"] = {
					["CampObject"] = {
						["id_"] = 8000999,
					},
				},
				["Groups"] = {
				},
				["Statics"] = {
					[1] = {
						[1] = {
							["id_"] = 8000999,
						},
						[2] = "Fortifications",
						[3] = "Insurgent Camp1",
					},
				},
				["Units"] = {
				},
				["__index"] = "table",
			},
			["CheckRate"] = 30,
			["CurrentZone"] = {
				["ClassName"] = "ZONE",
				["Zone"] = {
					["point"] = {
						["y"] = 0,
						["x"] = -152601.421875,
						["z"] = 841067.125,
					},
					["radius"] = 300,
				},
			},
			["__index"] = "table",
			["DestroyTime"] = 300,
			["Done"] = false,
			["Expiry"] = 600,
			["Life"] = 270,
			["Name"] = "Destroy Insurgent Camp",
			["Zones"] = {
				[1] = {
					["ClassName"] = "ZONE",
					["Zone"] = {
						["point"] = {
							["y"] = 0,
							["x"] = -151701.421875,
							["z"] = 840902.875,
						},
						["radius"] = 300,
					},
				},
				[2] = {
					["ClassName"] = "ZONE",
					["Zone"] = {
						["point"] = {
							["y"] = 0,
							["x"] = -151622.859375,
							["z"] = 842145.6875,
						},
						["radius"] = 300,
					},
				},
				[3] = {
					["ClassName"] = "ZONE",
					["Zone"] = {
						["point"] = {
							["y"] = 0,
							["x"] = -152601.421875,
							["z"] = 841067.125,
						},
						["radius"] = 300,
					},
				},
				[4] = {
					["ClassName"] = "ZONE",
					["Zone"] = {
						["point"] = {
							["y"] = 0,
							["x"] = -153480,
							["z"] = 841045.6875,
						},
						["radius"] = 300,
					},
				},
			},
		},
		[2] = {
			["Resource"] = {
				["Arguments"] = {
					["CampObject"] = {
						["id_"] = 8001000,
					},
				},
				["Groups"] = {
				},
				["Statics"] = {
					[1] = {
						[1] = {
							["id_"] = 8001000,
						},
						[2] = "Fortifications",
						[3] = "Insurgent Camp2",
					},
				},
				["Units"] = {
				},
				["__index"] = "table",
			},
			["CheckRate"] = 30,
			["CurrentZone"] = {
				["ClassName"] = "ZONE",
				["Zone"] = {
					["point"] = {
						["y"] = 0,
						["x"] = -151622.859375,
						["z"] = 842145.6875,
					},
					["radius"] = 300,
				},
			},
			["__index"] = "table",
			["DestroyTime"] = 300,
			["Done"] = false,
			["Expiry"] = 600,
			["Life"] = 240,
			["Name"] = "Destroy Insurgent Camp",
			["Zones"] = {
				[1] = {
					["ClassName"] = "ZONE",
					["Zone"] = {
						["point"] = {
							["y"] = 0,
							["x"] = -151701.421875,
							["z"] = 840902.875,
						},
						["radius"] = 300,
					},
				},
				[2] = {
					["ClassName"] = "ZONE",
					["Zone"] = {
						["point"] = {
							["y"] = 0,
							["x"] = -151622.859375,
							["z"] = 842145.6875,
						},
						["radius"] = 300,
					},
				},
				[3] = {
					["ClassName"] = "ZONE",
					["Zone"] = {
						["point"] = {
							["y"] = 0,
							["x"] = -152601.421875,
							["z"] = 841067.125,
						},
						["radius"] = 300,
					},
				},
				[4] = {
					["ClassName"] = "ZONE",
					["Zone"] = {
						["point"] = {
							["y"] = 0,
							["x"] = -153480,
							["z"] = 841045.6875,
						},
						["radius"] = 300,
					},
				},
			},
		},
		[3] = {
			["Resource"] = {
				["Arguments"] = {
					["CampObject"] = {
						["id_"] = 8001001,
					},
				},
				["Groups"] = {
				},
				["Statics"] = {
					[1] = {
						[1] = {
							["id_"] = 8001001,
						},
						[2] = "Fortifications",
						[3] = "Insurgent Camp3",
					},
				},
				["Units"] = {
				},
				["__index"] = "table",
			},
			["CheckRate"] = 30,
			["CurrentZone"] = {
				["ClassName"] = "ZONE",
				["Zone"] = {
					["point"] = {
						["y"] = 0,
						["x"] = -151701.421875,
						["z"] = 840902.875,
					},
					["radius"] = 300,
				},
			},
			["__index"] = "table",
			["DestroyTime"] = 300,
			["Done"] = false,
			["Expiry"] = 600,
			["Life"] = 180,
			["Name"] = "Destroy Insurgent Camp",
			["Zones"] = {
				[1] = {
					["ClassName"] = "ZONE",
					["Zone"] = {
						["point"] = {
							["y"] = 0,
							["x"] = -151701.421875,
							["z"] = 840902.875,
						},
						["radius"] = 300,
					},
				},
				[2] = {
					["ClassName"] = "ZONE",
					["Zone"] = {
						["point"] = {
							["y"] = 0,
							["x"] = -151622.859375,
							["z"] = 842145.6875,
						},
						["radius"] = 300,
					},
				},
				[3] = {
					["ClassName"] = "ZONE",
					["Zone"] = {
						["point"] = {
							["y"] = 0,
							["x"] = -152601.421875,
							["z"] = 841067.125,
						},
						["radius"] = 300,
					},
				},
				[4] = {
					["ClassName"] = "ZONE",
					["Zone"] = {
						["point"] = {
							["y"] = 0,
							["x"] = -153480,
							["z"] = 841045.6875,
						},
						["radius"] = 300,
					},
				},
			},
		},
	},
	["SpawnID"] = 3,
	["ServerID"] = 4,
	["FOBZones"] = {
	},
	["Depots"] = {
		[1] = {
			["Zone"] = {
				["Zone"] = {
					["point"] = {
						["y"] = 0,
						["x"] = -150813.71875,
						["z"] = 840108.3125,
					},
					["radius"] = 300,
				},
				["ClassName"] = "ZONE",
			},
			["IsSupplier"] = true,
			["__index"] = "table",
			["CurrentCapacity"] = 148,
			["SupplyCheckRate"] = 7200,
			["Suppliers"] = {
			},
			["Object"] = {
				["id_"] = 8000995,
			},
			["Name"] = "Beslan Depot",
			["MGRS"] = "38T MN 64175 82063",
			["Capacity"] = 150,
			["LatLong"] = "43 11.430'N   44 33.547'E",
			["Resources"] = {
				["Infantry"] = {
					["cap"] = 1,
					["qty"] = 40,
				},
				["Watchtower Wood"] = {
					["cap"] = 2,
					["qty"] = 4,
				},
				["Fuel Tanks"] = {
					["cap"] = 1,
					["qty"] = 8,
				},
				["Outpost Wood"] = {
					["cap"] = 2,
					["qty"] = 4,
				},
				["Outpost Pipes"] = {
					["cap"] = 3,
					["qty"] = 4,
				},
				["Power Truck"] = {
					["cap"] = 1,
					["qty"] = 4,
				},
				["Fuel Truck"] = {
					["cap"] = 1,
					["qty"] = 4,
				},
				["Cargo Crates"] = {
					["cap"] = 1,
					["qty"] = 8,
				},
				["Watchtower Supplies"] = {
					["cap"] = 1,
					["qty"] = 4,
				},
				["Command Truck"] = {
					["cap"] = 1,
					["qty"] = 4,
				},
				["Tank"] = {
					["cap"] = 3,
					["qty"] = 8,
				},
				["Outpost Supplies"] = {
					["cap"] = 1,
					["qty"] = 4,
				},
				["Ammo Truck"] = {
					["cap"] = 1,
					["qty"] = 4,
				},
				["APC"] = {
					["cap"] = 2,
					["qty"] = 8,
				},
			},
		},
		[2] = {
			["Zone"] = {
				["Zone"] = {
					["point"] = {
						["y"] = 0,
						["x"] = -153605.421875,
						["z"] = 829206.5625,
					},
					["radius"] = 300,
				},
				["ClassName"] = "ZONE",
			},
			["IsSupplier"] = true,
			["__index"] = "table",
			["CurrentCapacity"] = 148,
			["SupplyCheckRate"] = 7200,
			["Suppliers"] = {
			},
			["Object"] = {
				["id_"] = 8000996,
			},
			["Name"] = "Kirovo Depot",
			["MGRS"] = "38T MN 53104 80881",
			["Capacity"] = 150,
			["LatLong"] = "43 10.755'N   44 25.379'E",
			["Resources"] = {
				["Infantry"] = {
					["cap"] = 1,
					["qty"] = 40,
				},
				["Watchtower Wood"] = {
					["cap"] = 2,
					["qty"] = 4,
				},
				["Fuel Tanks"] = {
					["cap"] = 1,
					["qty"] = 8,
				},
				["Outpost Wood"] = {
					["cap"] = 2,
					["qty"] = 4,
				},
				["Outpost Pipes"] = {
					["cap"] = 3,
					["qty"] = 4,
				},
				["Power Truck"] = {
					["cap"] = 1,
					["qty"] = 4,
				},
				["Fuel Truck"] = {
					["cap"] = 1,
					["qty"] = 4,
				},
				["Cargo Crates"] = {
					["cap"] = 1,
					["qty"] = 8,
				},
				["Watchtower Supplies"] = {
					["cap"] = 1,
					["qty"] = 4,
				},
				["Command Truck"] = {
					["cap"] = 1,
					["qty"] = 4,
				},
				["Tank"] = {
					["cap"] = 3,
					["qty"] = 8,
				},
				["Outpost Supplies"] = {
					["cap"] = 1,
					["qty"] = 4,
				},
				["Ammo Truck"] = {
					["cap"] = 1,
					["qty"] = 4,
				},
				["APC"] = {
					["cap"] = 2,
					["qty"] = 8,
				},
			},
		},
		[3] = {
			["Zone"] = {
				["Zone"] = {
					["point"] = {
						["y"] = 0,
						["x"] = -150364,
						["z"] = 841868,
					},
					["radius"] = 400,
				},
				["ClassName"] = "ZONE",
			},
			["IsSupplier"] = true,
			["__index"] = "table",
			["CurrentCapacity"] = 148,
			["SupplyCheckRate"] = 7200,
			["Suppliers"] = {
			},
			["Object"] = {
				["id_"] = 8000997,
			},
			["Name"] = "Beslan Backup Depot",
			["MGRS"] = "38T MN 65962 82253",
			["Capacity"] = 150,
			["LatLong"] = "43 11.537'N   44 34.866'E",
			["Resources"] = {
				["Infantry"] = {
					["cap"] = 1,
					["qty"] = 40,
				},
				["Watchtower Wood"] = {
					["cap"] = 2,
					["qty"] = 4,
				},
				["Fuel Tanks"] = {
					["cap"] = 1,
					["qty"] = 8,
				},
				["Outpost Wood"] = {
					["cap"] = 2,
					["qty"] = 4,
				},
				["Outpost Pipes"] = {
					["cap"] = 3,
					["qty"] = 4,
				},
				["Power Truck"] = {
					["cap"] = 1,
					["qty"] = 4,
				},
				["Fuel Truck"] = {
					["cap"] = 1,
					["qty"] = 4,
				},
				["Cargo Crates"] = {
					["cap"] = 1,
					["qty"] = 8,
				},
				["Watchtower Supplies"] = {
					["cap"] = 1,
					["qty"] = 4,
				},
				["Command Truck"] = {
					["cap"] = 1,
					["qty"] = 4,
				},
				["Tank"] = {
					["cap"] = 3,
					["qty"] = 8,
				},
				["Outpost Supplies"] = {
					["cap"] = 1,
					["qty"] = 4,
				},
				["Ammo Truck"] = {
					["cap"] = 1,
					["qty"] = 4,
				},
				["APC"] = {
					["cap"] = 2,
					["qty"] = 8,
				},
			},
		},
	},
	["SLC"] = {
		["ZoneInstances"] = {
		},
		["InfantryInstances"] = {
		},
		["TransportInstances"] = {
		},
		["CargoInstances"] = {
		},
	},
	["StaticObjects"] = {
		[1] = {
			["CountryID"] = 2,
			["Country"] = "Insurgents",
			["Component"] = "DSMT",
			["y"] = 841233.25,
			["Coalition"] = 2,
			["x"] = -152645.984375,
			["Name"] = "Insurgent Camp1",
			["Category"] = "Fortifications",
			["ID"] = "Insurgent Camp1",
			["Heading"] = 4.380776344788,
			["CanCargo"] = false,
			["Type"] = "FARP Tent",
		},
		[2] = {
			["CountryID"] = 2,
			["Country"] = "Insurgents",
			["Component"] = "DSMT",
			["y"] = 841939,
			["Coalition"] = 2,
			["x"] = -151610.640625,
			["Name"] = "Insurgent Camp2",
			["Category"] = "Fortifications",
			["ID"] = "Insurgent Camp2",
			["Heading"] = 1.5184362555499,
			["CanCargo"] = false,
			["Type"] = "FARP Tent",
		},
		[3] = {
			["CountryID"] = 2,
			["Country"] = "Insurgents",
			["Component"] = "DSMT",
			["y"] = 841130.4375,
			["Coalition"] = 2,
			["x"] = -151697,
			["Name"] = "Insurgent Camp3",
			["Category"] = "Fortifications",
			["ID"] = "Insurgent Camp3",
			["Heading"] = 1.0122907464829,
			["CanCargo"] = false,
			["Type"] = "FARP Tent",
		},
	},
	["GarbageCollectionQueue"] = {
	},
	["GroundGroups"] = {
		[1] = {
			["Coalition"] = 1,
			["Name"] = "MANPADSSquadTemplate",
			["Category"] = 2,
			["ID"] = 36,
			["Country"] = 0,
			["Units"] = {
				[1] = {
					["Type"] = "SA-18 Igla-S manpad",
					["Name"] = "Unit #040",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 491.50051879883,
							["x"] = -138875.71875,
							["z"] = 829949.125,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "74",
					["Heading"] = 0,
				},
				[2] = {
					["Type"] = "SA-18 Igla-S manpad",
					["Name"] = "Unit #041",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 491.49337768555,
							["x"] = -138878.28125,
							["z"] = 829944,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "75",
					["Heading"] = 0,
				},
				[3] = {
					["Type"] = "SA-18 Igla-S comm",
					["Name"] = "Unit #042",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 491.52261352539,
							["x"] = -138878.28125,
							["z"] = 829953.6875,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "76",
					["Heading"] = 0,
				},
			},
			["Size"] = 3,
		},
		[2] = {
			["Coalition"] = 1,
			["Name"] = "ATSquadTemplate",
			["Category"] = 2,
			["ID"] = 35,
			["Country"] = 0,
			["Units"] = {
				[1] = {
					["Type"] = "Infantry AK",
					["Name"] = "Unit #004",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 491.27404785156,
							["x"] = -138877.140625,
							["z"] = 829872.5625,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "64",
					["Heading"] = 0,
				},
				[2] = {
					["Type"] = "Paratrooper RPG-16",
					["Name"] = "Unit #035",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 491.26696777344,
							["x"] = -138879.71875,
							["z"] = 829867.4375,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "65",
					["Heading"] = 0,
				},
				[3] = {
					["Type"] = "Infantry AK",
					["Name"] = "Unit #036",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 491.29266357422,
							["x"] = -138882.578125,
							["z"] = 829872.875,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "66",
					["Heading"] = 0,
				},
				[4] = {
					["Type"] = "Paratrooper RPG-16",
					["Name"] = "Unit #037",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 491.3115234375,
							["x"] = -138882.578125,
							["z"] = 829879.125,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "67",
					["Heading"] = 0,
				},
				[5] = {
					["Type"] = "Paratrooper RPG-16",
					["Name"] = "Unit #038",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 491.29544067383,
							["x"] = -138879.71875,
							["z"] = 829876.875,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "68",
					["Heading"] = 0,
				},
				[6] = {
					["Type"] = "Paratrooper RPG-16",
					["Name"] = "Unit #039",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 491.26928710938,
							["x"] = -138882.578125,
							["z"] = 829865.125,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "69",
					["Heading"] = 0,
				},
			},
			["Size"] = 6,
		},
		[3] = {
			["Coalition"] = 1,
			["Name"] = "Spawn Outpost Template",
			["Category"] = 2,
			["ID"] = 29,
			["Country"] = 0,
			["Units"] = {
				[1] = {
					["Type"] = "outpost",
					["Name"] = "Unit #024",
					["Position"] = {
						["y"] = {
							["y"] = 0.99999469518661,
							["x"] = -0.001418057247065,
							["z"] = -0.0029507258441299,
						},
						["x"] = {
							["y"] = 0,
							["x"] = 0.90131932497025,
							["z"] = -0.43315526843071,
						},
						["p"] = {
							["y"] = 494.21975708008,
							["x"] = -138201.71875,
							["z"] = 831416.5625,
						},
						["z"] = {
							["y"] = 0.0032737851142883,
							["x"] = 0.43315297365189,
							["z"] = 0.90131455659866,
						},
					},
					["ID"] = "50",
					["Heading"] = 5.8351947437829,
				},
			},
			["Size"] = 1,
		},
		[4] = {
			["Coalition"] = 1,
			["Name"] = "Spawn WatchTower Template",
			["Category"] = 2,
			["ID"] = 28,
			["Country"] = 0,
			["Units"] = {
				[1] = {
					["Type"] = "house2arm",
					["Name"] = "Unit #023",
					["Position"] = {
						["y"] = {
							["y"] = 0.99999469518661,
							["x"] = -0.001418057247065,
							["z"] = -0.0029507258441299,
						},
						["x"] = {
							["y"] = 0,
							["x"] = 0.90131932497025,
							["z"] = -0.43315526843071,
						},
						["p"] = {
							["y"] = 491.82269287109,
							["x"] = -138162.859375,
							["z"] = 830800,
						},
						["z"] = {
							["y"] = 0.0032737851142883,
							["x"] = 0.43315297365189,
							["z"] = 0.90131455659866,
						},
					},
					["ID"] = "49",
					["Heading"] = 5.8351947437829,
				},
			},
			["Size"] = 1,
		},
		[5] = {
			["Coalition"] = 1,
			["Name"] = "Spawn TankT72 Template",
			["Category"] = 2,
			["ID"] = 27,
			["Country"] = 0,
			["Units"] = {
				[1] = {
					["Type"] = "T-72B",
					["Name"] = "Unit #022",
					["Position"] = {
						["y"] = {
							["y"] = 0.99999034404755,
							["x"] = 0.0032510347664356,
							["z"] = -0.0030194194987416,
						},
						["x"] = {
							["y"] = -0.0042381077073514,
							["x"] = 0.90130931138992,
							["z"] = -0.43315562605858,
						},
						["p"] = {
							["y"] = 490.35369873047,
							["x"] = -138194.578125,
							["z"] = 830302.3125,
						},
						["z"] = {
							["y"] = 0.0013132266467437,
							["x"] = 0.43316411972046,
							["z"] = 0.90131413936615,
						},
					},
					["ID"] = "48",
					["Heading"] = 5.8351900839697,
				},
			},
			["Size"] = 1,
		},
		[6] = {
			["Coalition"] = 1,
			["Name"] = "Spawn MechBTR Template",
			["Category"] = 2,
			["ID"] = 26,
			["Country"] = 0,
			["Units"] = {
				[1] = {
					["Type"] = "BTR-80",
					["Name"] = "Unit #021",
					["Position"] = {
						["y"] = {
							["y"] = 0.99999016523361,
							["x"] = 0.0032535367645323,
							["z"] = -0.0030205738730729,
						},
						["x"] = {
							["y"] = -0.0042408625595272,
							["x"] = 0.90130919218063,
							["z"] = -0.43315553665161,
						},
						["p"] = {
							["y"] = 488.43161010742,
							["x"] = -138180.28125,
							["z"] = 829680.875,
						},
						["z"] = {
							["y"] = 0.0013131834566593,
							["x"] = 0.43316408991814,
							["z"] = 0.90131413936615,
						},
					},
					["ID"] = "47",
					["Heading"] = 5.8351901129173,
				},
			},
			["Size"] = 1,
		},
		[7] = {
			["Coalition"] = 1,
			["Name"] = "Spawn PowerTruck Template",
			["Category"] = 2,
			["ID"] = 25,
			["Country"] = 0,
			["Units"] = {
				[1] = {
					["Type"] = "Ural-4320 APA-5D",
					["Name"] = "Unit #020",
					["Position"] = {
						["y"] = {
							["y"] = 0.9999925494194,
							["x"] = 0.00047412875574082,
							["z"] = -0.0038600626867265,
						},
						["x"] = {
							["y"] = -0.0020993591751903,
							["x"] = 0.90131741762161,
							["z"] = -0.43315434455872,
						},
						["p"] = {
							["y"] = 493.85037231445,
							["x"] = -137708.859375,
							["z"] = 831380.875,
						},
						["z"] = {
							["y"] = 0.0032737702131271,
							["x"] = 0.43315914273262,
							["z"] = 0.90131151676178,
						},
					},
					["ID"] = "46",
					["Heading"] = 5.8351947503085,
				},
			},
			["Size"] = 1,
		},
		[8] = {
			["Coalition"] = 1,
			["Name"] = "Spawn CommandTruck Template",
			["Category"] = 2,
			["ID"] = 24,
			["Country"] = 0,
			["Units"] = {
				[1] = {
					["Type"] = "Ural-375 PBU",
					["Name"] = "Unit #019",
					["Position"] = {
						["y"] = {
							["y"] = 0.9999925494194,
							["x"] = 0.00046951358672231,
							["z"] = -0.0038578445091844,
						},
						["x"] = {
							["y"] = -0.0020942385308444,
							["x"] = 0.90131735801697,
							["z"] = -0.43315431475639,
						},
						["p"] = {
							["y"] = 491.88345336914,
							["x"] = -137687.421875,
							["z"] = 830873.6875,
						},
						["z"] = {
							["y"] = 0.0032737704459578,
							["x"] = 0.43315914273262,
							["z"] = 0.90131157636642,
						},
					},
					["ID"] = "45",
					["Heading"] = 5.8351947513519,
				},
			},
			["Size"] = 1,
		},
		[9] = {
			["Coalition"] = 1,
			["Name"] = "Spawn FuelTruck Template",
			["Category"] = 2,
			["ID"] = 23,
			["Country"] = 0,
			["Units"] = {
				[1] = {
					["Type"] = "ATMZ-5",
					["Name"] = "Unit #011",
					["Position"] = {
						["y"] = {
							["y"] = 0.99999010562897,
							["x"] = 0.0032478119246662,
							["z"] = -0.0030178702436388,
						},
						["x"] = {
							["y"] = -0.0042345318943262,
							["x"] = 0.90130919218063,
							["z"] = -0.43315559625626,
						},
						["p"] = {
							["y"] = 488.47897338867,
							["x"] = -137637.421875,
							["z"] = 830280.875,
						},
						["z"] = {
							["y"] = 0.0013132265303284,
							["x"] = 0.43316411972046,
							["z"] = 0.90131407976151,
						},
					},
					["ID"] = "44",
					["Heading"] = 5.8351900591942,
				},
			},
			["Size"] = 1,
		},
		[10] = {
			["Coalition"] = 1,
			["Name"] = "Spawn AmmoTruck Template",
			["Category"] = 2,
			["ID"] = 22,
			["Country"] = 0,
			["Units"] = {
				[1] = {
					["Type"] = "KAMAZ Truck",
					["Name"] = "Unit #010",
					["Position"] = {
						["y"] = {
							["y"] = 0.99998152256012,
							["x"] = 0.00041825626976788,
							["z"] = -0.006075588054955,
						},
						["x"] = {
							["y"] = -0.0030086748301983,
							["x"] = 0.90131705999374,
							["z"] = -0.43314951658249,
						},
						["p"] = {
							["y"] = 487.33923339844,
							["x"] = -137658.859375,
							["z"] = 829659.4375,
						},
						["z"] = {
							["y"] = 0.0052948636002839,
							["x"] = 0.43315979838371,
							["z"] = 0.90130168199539,
						},
					},
					["ID"] = "43",
					["Heading"] = 5.8351989469674,
				},
			},
			["Size"] = 1,
		},
		[11] = {
			["Coalition"] = 1,
			["Name"] = "InfantrySquadTemplate",
			["Category"] = 2,
			["ID"] = 13,
			["Country"] = 0,
			["Units"] = {
				[1] = {
					["Type"] = "Infantry AK",
					["Name"] = "Unit #001",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 490.73620605469,
							["x"] = -138881.71875,
							["z"] = 829689.4375,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "24",
					["Heading"] = 0,
				},
				[2] = {
					["Type"] = "Infantry AK",
					["Name"] = "Unit #002",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 490.73434448242,
							["x"] = -138888.578125,
							["z"] = 829681.4375,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "25",
					["Heading"] = 0,
				},
				[3] = {
					["Type"] = "Infantry AK",
					["Name"] = "Unit #003",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 490.79486083984,
							["x"] = -138889.140625,
							["z"] = 829700.875,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "26",
					["Heading"] = 0,
				},
				[4] = {
					["Type"] = "Infantry AK",
					["Name"] = "Unit #012",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 490.75061035156,
							["x"] = -138891.71875,
							["z"] = 829683.4375,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "27",
					["Heading"] = 0,
				},
				[5] = {
					["Type"] = "Infantry AK",
					["Name"] = "Unit #013",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 490.76095581055,
							["x"] = -138884.28125,
							["z"] = 829694.875,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "28",
					["Heading"] = 0,
				},
				[6] = {
					["Type"] = "Infantry AK",
					["Name"] = "Unit #014",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 490.77639770508,
							["x"] = -138888.28125,
							["z"] = 829695.6875,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "29",
					["Heading"] = 0,
				},
				[7] = {
					["Type"] = "Paratrooper RPG-16",
					["Name"] = "Unit #015",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 490.72476196289,
							["x"] = -138884.578125,
							["z"] = 829682.5625,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "30",
					["Heading"] = 0,
				},
				[8] = {
					["Type"] = "Paratrooper RPG-16",
					["Name"] = "Unit #016",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 490.76776123047,
							["x"] = -138891.71875,
							["z"] = 829689.125,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "31",
					["Heading"] = 0,
				},
				[9] = {
					["Type"] = "Infantry AK",
					["Name"] = "Unit #017",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 490.79034423828,
							["x"] = -138892.28125,
							["z"] = 829696,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "32",
					["Heading"] = 0,
				},
				[10] = {
					["Type"] = "Infantry AK",
					["Name"] = "Unit #018",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 490.75106811523,
							["x"] = -138886.578125,
							["z"] = 829689.125,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "33",
					["Heading"] = 0,
				},
			},
			["Size"] = 10,
		},
		[12] = {
			["Coalition"] = 2,
			["Name"] = "New Vehicle Group",
			["Category"] = 2,
			["ID"] = 46,
			["Country"] = 17,
			["Units"] = {
				[1] = {
					["Type"] = "T-55",
					["Name"] = "Unit #062",
					["Position"] = {
						["y"] = {
							["y"] = 0.99999856948853,
							["x"] = 0.001464614411816,
							["z"] = 0.00099587813019753,
						},
						["x"] = {
							["y"] = 0.0012786254519597,
							["x"] = -0.20791029930115,
							["z"] = -0.97814708948135,
						},
						["p"] = {
							["y"] = 543.49566650391,
							["x"] = -149591.15625,
							["z"] = 844828.25,
						},
						["z"] = {
							["y"] = -0.0012255549663678,
							["x"] = 0.97814691066742,
							["z"] = -0.20791186392307,
						},
					},
					["ID"] = "131",
					["Heading"] = 4.5029507249596,
				},
				[2] = {
					["Type"] = "BTR-80",
					["Name"] = "Unit #063",
					["Position"] = {
						["y"] = {
							["y"] = 0.99999856948853,
							["x"] = 0.0014653434045613,
							["z"] = 0.00099930772557855,
						},
						["x"] = {
							["y"] = 0.0012821318814531,
							["x"] = -0.20791032910347,
							["z"] = -0.978147149086,
						},
						["p"] = {
							["y"] = 543.44458007813,
							["x"] = -149582.84375,
							["z"] = 844867.375,
						},
						["z"] = {
							["y"] = -0.0012255548499525,
							["x"] = 0.97814685106277,
							["z"] = -0.20791186392307,
						},
					},
					["ID"] = "132",
					["Heading"] = 4.502950708201,
				},
				[3] = {
					["Type"] = "Infantry AK Ins",
					["Name"] = "Unit #064",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = 0,
							["x"] = -0.20791047811508,
							["z"] = -0.97814792394638,
						},
						["p"] = {
							["y"] = 543.39343261719,
							["x"] = -149574.53125,
							["z"] = 844906.5,
						},
						["z"] = {
							["y"] = 0,
							["x"] = 0.97814792394638,
							["z"] = -0.20791047811508,
						},
					},
					["ID"] = "133",
					["Heading"] = 4.5029507235472,
				},
				[4] = {
					["Type"] = "Soldier RPG",
					["Name"] = "Unit #065",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = 0,
							["x"] = -0.20791047811508,
							["z"] = -0.97814792394638,
						},
						["p"] = {
							["y"] = 543.34234619141,
							["x"] = -149566.21875,
							["z"] = 844945.625,
						},
						["z"] = {
							["y"] = 0,
							["x"] = 0.97814792394638,
							["z"] = -0.20791047811508,
						},
					},
					["ID"] = "134",
					["Heading"] = 4.5029507235472,
				},
				[5] = {
					["Type"] = "2B11 mortar",
					["Name"] = "Unit #066",
					["Position"] = {
						["y"] = {
							["y"] = 0.99999928474426,
							["x"] = 0.0011987758334726,
							["z"] = -0.00025480610202067,
						},
						["x"] = {
							["y"] = -1.8262219861342e-11,
							["x"] = -0.20791044831276,
							["z"] = -0.97814786434174,
						},
						["p"] = {
							["y"] = 543.29125976563,
							["x"] = -149557.890625,
							["z"] = 844984.75,
						},
						["z"] = {
							["y"] = -0.0012255568290129,
							["x"] = 0.978147149086,
							["z"] = -0.20791029930115,
						},
					},
					["ID"] = "135",
					["Heading"] = 4.5029507403058,
				},
			},
			["Size"] = 5,
		},
		[13] = {
			["Coalition"] = 2,
			["Name"] = "InsMechPlt2",
			["Category"] = 2,
			["ID"] = 43,
			["Country"] = 17,
			["Units"] = {
				[1] = {
					["Type"] = "BMP-1",
					["Name"] = "Unit #054",
					["Position"] = {
						["y"] = {
							["y"] = 0.9999902844429,
							["x"] = 0.0032512964680791,
							["z"] = -0.0030182485934347,
						},
						["x"] = {
							["y"] = -0.0032513111364096,
							["x"] = 0.9999948143959,
							["z"] = -9.0949069022489e-13,
						},
						["p"] = {
							["y"] = 495.60696411133,
							["x"] = -138798.171875,
							["z"] = 831393.125,
						},
						["z"] = {
							["y"] = 0.0030182322952896,
							["x"] = 9.8132632047054e-06,
							["z"] = 0.999995470047,
						},
					},
					["ID"] = "125",
					["Heading"] = 6.2831853071787,
				},
				[2] = {
					["Type"] = "BMP-1",
					["Name"] = "Unit #055",
					["Position"] = {
						["y"] = {
							["y"] = 0.9999902844429,
							["x"] = 0.0032512964680791,
							["z"] = -0.0030182485934347,
						},
						["x"] = {
							["y"] = -0.0032513111364096,
							["x"] = 0.9999948143959,
							["z"] = -9.0949069022489e-13,
						},
						["p"] = {
							["y"] = 495.67095947266,
							["x"] = -138816.9375,
							["z"] = 831394.125,
						},
						["z"] = {
							["y"] = 0.0030182322952896,
							["x"] = 9.8132632047054e-06,
							["z"] = 0.999995470047,
						},
					},
					["ID"] = "126",
					["Heading"] = 6.2831853071787,
				},
				[3] = {
					["Type"] = "BMP-1",
					["Name"] = "Unit #056",
					["Position"] = {
						["y"] = {
							["y"] = 0.9999902844429,
							["x"] = 0.003242980921641,
							["z"] = -0.003018248360604,
						},
						["x"] = {
							["y"] = -0.0032429953571409,
							["x"] = 0.99999475479126,
							["z"] = -9.0949063601478e-13,
						},
						["p"] = {
							["y"] = 495.73602294922,
							["x"] = -138837.484375,
							["z"] = 831393.5625,
						},
						["z"] = {
							["y"] = 0.0030182325281203,
							["x"] = 9.78816569841e-06,
							["z"] = 0.99999552965164,
						},
					},
					["ID"] = "127",
					["Heading"] = 6.2831853071787,
				},
				[4] = {
					["Type"] = "BMP-1",
					["Name"] = "Unit #057",
					["Position"] = {
						["y"] = {
							["y"] = 0.9999902844429,
							["x"] = 0.0032512964680791,
							["z"] = -0.0030182485934347,
						},
						["x"] = {
							["y"] = -0.0032513111364096,
							["x"] = 0.9999948143959,
							["z"] = -9.0949069022489e-13,
						},
						["p"] = {
							["y"] = 495.80633544922,
							["x"] = -138858.03125,
							["z"] = 831394.75,
						},
						["z"] = {
							["y"] = 0.0030182322952896,
							["x"] = 9.8132632047054e-06,
							["z"] = 0.999995470047,
						},
					},
					["ID"] = "128",
					["Heading"] = 6.2831853071787,
				},
			},
			["Size"] = 4,
		},
		[14] = {
			["Coalition"] = 2,
			["Name"] = "InsMechPlt1",
			["Category"] = 2,
			["ID"] = 42,
			["Country"] = 17,
			["Units"] = {
				[1] = {
					["Type"] = "BMP-2",
					["Name"] = "Unit #058",
					["Position"] = {
						["y"] = {
							["y"] = 0.9999902844429,
							["x"] = 0.0032496782951057,
							["z"] = -0.0030182485934347,
						},
						["x"] = {
							["y"] = -0.0032496929634362,
							["x"] = 0.9999948143959,
							["z"] = -9.0949069022489e-13,
						},
						["p"] = {
							["y"] = 495.48721313477,
							["x"] = -138794.0625,
							["z"] = 831357.875,
						},
						["z"] = {
							["y"] = 0.0030182322952896,
							["x"] = 9.8083792181569e-06,
							["z"] = 0.999995470047,
						},
					},
					["ID"] = "114",
					["Heading"] = 6.2831853071787,
				},
				[2] = {
					["Type"] = "BMP-2",
					["Name"] = "Unit #059",
					["Position"] = {
						["y"] = {
							["y"] = 0.9999902844429,
							["x"] = 0.0032496782951057,
							["z"] = -0.0030182485934347,
						},
						["x"] = {
							["y"] = -0.0032496929634362,
							["x"] = 0.9999948143959,
							["z"] = -9.0949069022489e-13,
						},
						["p"] = {
							["y"] = 495.55139160156,
							["x"] = -138812.828125,
							["z"] = 831358.9375,
						},
						["z"] = {
							["y"] = 0.0030182322952896,
							["x"] = 9.8083792181569e-06,
							["z"] = 0.999995470047,
						},
					},
					["ID"] = "115",
					["Heading"] = 6.2831853071787,
				},
				[3] = {
					["Type"] = "BMP-2",
					["Name"] = "Unit #060",
					["Position"] = {
						["y"] = {
							["y"] = 0.9999902844429,
							["x"] = 0.0032496782951057,
							["z"] = -0.0030182485934347,
						},
						["x"] = {
							["y"] = -0.0032496929634362,
							["x"] = 0.9999948143959,
							["z"] = -9.0949069022489e-13,
						},
						["p"] = {
							["y"] = 495.61624145508,
							["x"] = -138833.375,
							["z"] = 831358.3125,
						},
						["z"] = {
							["y"] = 0.0030182322952896,
							["x"] = 9.8083792181569e-06,
							["z"] = 0.999995470047,
						},
					},
					["ID"] = "116",
					["Heading"] = 6.2831853071787,
				},
				[4] = {
					["Type"] = "BMP-2",
					["Name"] = "Unit #061",
					["Position"] = {
						["y"] = {
							["y"] = 0.9999902844429,
							["x"] = 0.0032496782951057,
							["z"] = -0.0030182485934347,
						},
						["x"] = {
							["y"] = -0.0032496929634362,
							["x"] = 0.9999948143959,
							["z"] = -9.0949069022489e-13,
						},
						["p"] = {
							["y"] = 495.68658447266,
							["x"] = -138853.921875,
							["z"] = 831359.5,
						},
						["z"] = {
							["y"] = 0.0030182322952896,
							["x"] = 9.8083792181569e-06,
							["z"] = 0.999995470047,
						},
					},
					["ID"] = "117",
					["Heading"] = 6.2831853071787,
				},
			},
			["Size"] = 4,
		},
		[15] = {
			["Coalition"] = 2,
			["Name"] = "InsTankPlt1",
			["Category"] = 2,
			["ID"] = 41,
			["Country"] = 17,
			["Units"] = {
				[1] = {
					["Type"] = "T-55",
					["Name"] = "Unit #050",
					["Position"] = {
						["y"] = {
							["y"] = 0.9999902844429,
							["x"] = 0.0032504526898265,
							["z"] = -0.0030182485934347,
						},
						["x"] = {
							["y"] = -0.003250467358157,
							["x"] = 0.9999948143959,
							["z"] = -9.0949069022489e-13,
						},
						["p"] = {
							["y"] = 495.35272216797,
							["x"] = -138791.734375,
							["z"] = 831315.8125,
						},
						["z"] = {
							["y"] = 0.0030182322952896,
							["x"] = 9.8107166195405e-06,
							["z"] = 0.999995470047,
						},
					},
					["ID"] = "106",
					["Heading"] = 6.2831853071787,
				},
				[2] = {
					["Type"] = "T-55",
					["Name"] = "Unit #051",
					["Position"] = {
						["y"] = {
							["y"] = 0.9999902844429,
							["x"] = 0.0032427499536425,
							["z"] = -0.003018248360604,
						},
						["x"] = {
							["y"] = -0.0032427643891424,
							["x"] = 0.99999475479126,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 495.41668701172,
							["x"] = -138810.5,
							["z"] = 831316.8125,
						},
						["z"] = {
							["y"] = 0.0030182325281203,
							["x"] = 9.7874681159738e-06,
							["z"] = 0.99999552965164,
						},
					},
					["ID"] = "107",
					["Heading"] = 0,
				},
				[3] = {
					["Type"] = "T-55",
					["Name"] = "Unit #052",
					["Position"] = {
						["y"] = {
							["y"] = 0.9999902844429,
							["x"] = 0.0032504526898265,
							["z"] = -0.0030182485934347,
						},
						["x"] = {
							["y"] = -0.003250467358157,
							["x"] = 0.9999948143959,
							["z"] = -9.0949069022489e-13,
						},
						["p"] = {
							["y"] = 495.48156738281,
							["x"] = -138831.046875,
							["z"] = 831316.1875,
						},
						["z"] = {
							["y"] = 0.0030182322952896,
							["x"] = 9.8107166195405e-06,
							["z"] = 0.999995470047,
						},
					},
					["ID"] = "108",
					["Heading"] = 6.2831853071787,
				},
				[4] = {
					["Type"] = "T-55",
					["Name"] = "Unit #053",
					["Position"] = {
						["y"] = {
							["y"] = 0.9999902844429,
							["x"] = 0.0032504526898265,
							["z"] = -0.0030182485934347,
						},
						["x"] = {
							["y"] = -0.003250467358157,
							["x"] = 0.9999948143959,
							["z"] = -9.0949069022489e-13,
						},
						["p"] = {
							["y"] = 495.55194091797,
							["x"] = -138851.609375,
							["z"] = 831317.375,
						},
						["z"] = {
							["y"] = 0.0030182322952896,
							["x"] = 9.8107166195405e-06,
							["z"] = 0.999995470047,
						},
					},
					["ID"] = "109",
					["Heading"] = 6.2831853071787,
				},
			},
			["Size"] = 4,
		},
		[16] = {
			["Coalition"] = 2,
			["Name"] = "InsMANPADSqd",
			["Category"] = 2,
			["ID"] = 40,
			["Country"] = 17,
			["Units"] = {
				[1] = {
					["Type"] = "Igla manpad INS",
					["Name"] = "Unit #047",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 494.96231079102,
							["x"] = -138827.1875,
							["z"] = 831148.3125,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "103",
					["Heading"] = 0,
				},
				[2] = {
					["Type"] = "Igla manpad INS",
					["Name"] = "Unit #048",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 494.97131347656,
							["x"] = -138839.421875,
							["z"] = 831138.125,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "104",
					["Heading"] = 0,
				},
				[3] = {
					["Type"] = "Soldier AK",
					["Name"] = "Unit #049",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 495.02270507813,
							["x"] = -138837.703125,
							["z"] = 831157,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "105",
					["Heading"] = 0,
				},
			},
			["Size"] = 3,
		},
		[17] = {
			["Coalition"] = 2,
			["Name"] = "InsInfSqdB",
			["Category"] = 2,
			["ID"] = 39,
			["Country"] = 17,
			["Units"] = {
				[1] = {
					["Type"] = "Soldier AK",
					["Name"] = "Unit #029",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 494.76071166992,
							["x"] = -138827.03125,
							["z"] = 831081.6875,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "93",
					["Heading"] = 0,
				},
				[2] = {
					["Type"] = "Soldier AK",
					["Name"] = "Unit #030",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 494.75152587891,
							["x"] = -138830.9375,
							["z"] = 831074.4375,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "94",
					["Heading"] = 0,
				},
				[3] = {
					["Type"] = "Soldier RPG",
					["Name"] = "Unit #031",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 494.79489135742,
							["x"] = -138832.09375,
							["z"] = 831087.5625,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "95",
					["Heading"] = 0,
				},
				[4] = {
					["Type"] = "Soldier AK",
					["Name"] = "Unit #032",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 494.75622558594,
							["x"] = -138835.34375,
							["z"] = 831071.25,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "96",
					["Heading"] = 0,
				},
				[5] = {
					["Type"] = "Soldier RPG",
					["Name"] = "Unit #033",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 494.81811523438,
							["x"] = -138835.0625,
							["z"] = 831092.0625,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "97",
					["Heading"] = 0,
				},
				[6] = {
					["Type"] = "Soldier AK",
					["Name"] = "Unit #034",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 494.77352905273,
							["x"] = -138839.625,
							["z"] = 831072.375,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "98",
					["Heading"] = 0,
				},
				[7] = {
					["Type"] = "Soldier RPG",
					["Name"] = "Unit #043",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 494.83377075195,
							["x"] = -138839.0625,
							["z"] = 831092.9375,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "99",
					["Heading"] = 0,
				},
				[8] = {
					["Type"] = "Soldier AK",
					["Name"] = "Unit #044",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 494.80386352539,
							["x"] = -138836.765625,
							["z"] = 831085.5,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "100",
					["Heading"] = 0,
				},
				[9] = {
					["Type"] = "Soldier RPG",
					["Name"] = "Unit #045",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 494.77359008789,
							["x"] = -138831.921875,
							["z"] = 831080.6875,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "101",
					["Heading"] = 0,
				},
				[10] = {
					["Type"] = "Soldier AK",
					["Name"] = "Unit #046",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 494.78652954102,
							["x"] = -138836.484375,
							["z"] = 831080.0625,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "102",
					["Heading"] = 0,
				},
			},
			["Size"] = 10,
		},
		[18] = {
			["Coalition"] = 2,
			["Name"] = "InsInfSqdA",
			["Category"] = 2,
			["ID"] = 38,
			["Country"] = 17,
			["Units"] = {
				[1] = {
					["Type"] = "Soldier AK",
					["Name"] = "Unit #1",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 494.61526489258,
							["x"] = -138829,
							["z"] = 831031.375,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "78",
					["Heading"] = 0,
				},
				[2] = {
					["Type"] = "Infantry AK Ins",
					["Name"] = "Unit #005",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 494.60586547852,
							["x"] = -138832.90625,
							["z"] = 831024.0625,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "79",
					["Heading"] = 0,
				},
				[3] = {
					["Type"] = "Infantry AK Ins",
					["Name"] = "Unit #006",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 494.64926147461,
							["x"] = -138834.0625,
							["z"] = 831037.1875,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "80",
					["Heading"] = 0,
				},
				[4] = {
					["Type"] = "Infantry AK Ins",
					["Name"] = "Unit #007",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 494.61056518555,
							["x"] = -138837.3125,
							["z"] = 831020.875,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "81",
					["Heading"] = 0,
				},
				[5] = {
					["Type"] = "Infantry AK Ins",
					["Name"] = "Unit #008",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 494.67248535156,
							["x"] = -138837.03125,
							["z"] = 831041.6875,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "82",
					["Heading"] = 0,
				},
				[6] = {
					["Type"] = "Infantry AK Ins",
					["Name"] = "Unit #009",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 494.62786865234,
							["x"] = -138841.59375,
							["z"] = 831022,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "88",
					["Heading"] = 0,
				},
				[7] = {
					["Type"] = "Soldier RPG",
					["Name"] = "Unit #025",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 494.68811035156,
							["x"] = -138841.03125,
							["z"] = 831042.5625,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "89",
					["Heading"] = 0,
				},
				[8] = {
					["Type"] = "Infantry AK Ins",
					["Name"] = "Unit #026",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 494.65826416016,
							["x"] = -138838.75,
							["z"] = 831035.125,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "90",
					["Heading"] = 0,
				},
				[9] = {
					["Type"] = "Soldier RPG",
					["Name"] = "Unit #027",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 494.6279296875,
							["x"] = -138833.890625,
							["z"] = 831030.3125,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "91",
					["Heading"] = 0,
				},
				[10] = {
					["Type"] = "Infantry AK Ins",
					["Name"] = "Unit #028",
					["Position"] = {
						["y"] = {
							["y"] = 1,
							["x"] = 0,
							["z"] = 0,
						},
						["x"] = {
							["y"] = -0,
							["x"] = 1,
							["z"] = 0,
						},
						["p"] = {
							["y"] = 494.64086914063,
							["x"] = -138838.453125,
							["z"] = 831029.6875,
						},
						["z"] = {
							["y"] = 0,
							["x"] = -0,
							["z"] = 1,
						},
					},
					["ID"] = "92",
					["Heading"] = 0,
				},
			},
			["Size"] = 10,
		},
	},
}
return t




