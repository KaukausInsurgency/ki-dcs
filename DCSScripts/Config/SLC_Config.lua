if not SLC then
  SLC = {}
end
-- SLC CONFIG SECTION
SLC.Config = {}

-- call back function for when a radio action is performed (but no physical action taken)
-- Callback is passed these parameters (actionName, transportGroup, pilotname, comp{ComponentTypes / InfantryTypes})
SLC.Config.PreOnRadioAction = nil
-- call back function for when a radio action is completed (after the action was performed)
-- call back is passed these parameters(actionName, actionResult, transportGroup, pilotname, comp{ComponentTypes / InfantryTypes})
SLC.Config.PostOnRadioAction = nil

-- maximum distance to get all nearby crates for player/helicopter
-- any crates further than this distance are ignored
SLC.Config.CrateQueryDistance = 50
-- distance at which objects will be spawned 12 Oclock from helicopter
SLC.Config.ObjectSpawnDistance = 25

-- do not touch!
SLC.Config.SpawnID = 0

SLC.Config.InfantryTransportingHelicopters =
{
  "Mi-8MT",
  "UH-1H"
}

-- static definitions of base cargo types
-- recommend not touching these as these values are specific to DCS internal crate logic to work
SLC.Config.CargoTypes = 
{
  Ammo = { Name = "ammo_cargo", MinWeight = 1000, MaxWeight = 2000, Category = "supplies"},
  Barrels = { Name = "barrels_cargo", MinWeight = 100, MaxWeight = 480, Category = "supplies" },
  SquareContainer = { Name = "container_cargo", MinWeight = 100, MaxWeight = 4000, Category = "supplies" },
  FuelTank = { Name = "fueltank_cargo", MinWeight = 800, MaxWeight = 5000, Category = "supplies" },
  
  LargeContainer = { Name = "iso_container", MinWeight = 3800, MaxWeight = 10000, Category = "unit" },
  SmallContainer = { Name = "iso_container_small", MinWeight = 2200, MaxWeight = 10000, Category = "unit" },
  
  LargePipes = { Name = "pipes_big_cargo", MinWeight = 4815, MaxWeight = 4815, Category = "static" },
  SmallPipes = { Name = "pipes_small_cargo", MinWeight = 4350, MaxWeight = 4350, Category = "static" },
  WoodTrunks = { Name = "trunks_long_cargo", MinWeight = 4747, MaxWeight = 4747, Category = "static" },
  Wood = { Name = "trunks_small_cargo", MinWeight = 5000, MaxWeight = 5000, Category = "static" },
  Supplies = { Name = "uh1h_cargo", MinWeight = 100, MaxWeight = 10000, Category = "static" }
}

-- Component definitions for building units/statics
SLC.Config.ComponentTypes =
{
  FuelTruckCrate = 
  { 
    KeyName = "FuelTruckCrate",
    ParentMenu = "FARP Crates",
    MenuName = "Fuel Truck Crate", 
    SpawnName = "SLC FuelTruckCrate", 
    Type = "SmallContainer", 
    Weight = 3000, 
    Assembler = "FuelTruck"
  },
  CommandTruckCrate = 
  { 
    KeyName = "CommandTruckCrate",
    ParentMenu = "FARP Crates",
    MenuName = "Command Truck Crate", 
    SpawnName = "SLC CommandTruckCrate", 
    Type = "SmallContainer", 
    Weight = 2800,
    Assembler = "CommandTruck"
  },
  AmmoTruckCrate = 
  { 
    KeyName = "AmmoTruckCrate",
    ParentMenu = "FARP Crates",
    MenuName = "Ammo Truck Crate", 
    SpawnName = "SLC AmmoTruckCrate", 
    Type = "SmallContainer", 
    Weight = 3200,
    Assembler = "AmmoTruck"
  },
  PowerTruckCrate = 
  { 
    KeyName = "PowerTruckCrate",
    ParentMenu = "FARP Crates",
    MenuName = "Power Truck Crate", 
    SpawnName = "SLC PowerTruckCrate", 
    Type = "SmallContainer", 
    Weight = 3500,
    Assembler = "PowerTruck"
  },
  MechBTRCrate = 
  { 
    KeyName = "MechBTRCrate",
    MenuName = "BTR 80 Crate", 
    SpawnName = "SLC BTRCrate", 
    Type = "SmallContainer", 
    Weight = 3400,
    Assembler = "MechBTR"
  },
  TankCrate = 
  { 
    KeyName = "TankCrate",
    ParentMenu = "Tank Crates",
    MenuName = "T-72 Crate", 
    SpawnName = "SLC TankCrate", 
    Type = "SmallContainer", 
    Weight = 4500,
    Assembler = "TankT72"
  },
  TankCrate2 = 
  { 
    KeyName = "TankCrate2",
    ParentMenu = "Tank Crates",
    MenuName = "T-90 Crate", 
    SpawnName = "SLC Tank2Crate", 
    Type = "SmallContainer", 
    Weight = 4500,
    Assembler = "TankT90"
  },
  
  WatchTowerWoodCrate = 
  { 
    KeyName = "WatchTowerWoodCrate",
    MenuName = "Watch Tower Wood", 
    SpawnName = "SLC WTWood", 
    Type = "WoodTrunks", 
    Weight = 4747,
    Assembler = "WatchTower"
  },
  WatchTowerSupplyCrate = 
  { 
    KeyName = "WatchTowerSupplyCrate",
    MenuName = "Watch Tower Supply Crate", 
    SpawnName = "SLC WTCrate", 
    Type = "Supplies", 
    Weight = 3020,
    Assembler = "WatchTower"
  },
  
  OutpostPipeCrate = 
  { 
    KeyName = "OutpostPipeCrate",
    MenuName = "Outpost Pipes", 
    SpawnName = "SLC OPPipe", 
    Type = "SmallPipes", 
    Weight = 4350,
    Assembler = "OutPost"
  },
  OutpostSupplyCrate = 
  { 
    KeyName = "OutpostSupplyCrate",
    MenuName = "Outpost Supply Crate", 
    SpawnName = "SLC OPCrate", 
    Type = "Supplies", 
    Weight = 3900,
    Assembler = "OutPost" 
  },
  OutpostWoodCrate = 
  { 
    KeyName = "OutpostWoodCrate",
    MenuName = "Outpost Wood", 
    SpawnName = "SLC OPWood", 
    Type = "WoodTrunks", 
    Weight = 4747,
    Assembler = "OutPost" 
  }
}

-- ComponentTypesOrder - is used to maintain order of menu items when iterating with ipairs
-- move the values around in the way you would like to see them displayed in the F10 menu
-- if you change SLC.Config.ComponentTypes, YOU MUST UPDATE THIS LIST AS WELL!
SLC.Config.ComponentTypesOrder =
{
    "FuelTruckCrate",
    "CommandTruckCrate",
    "AmmoTruckCrate",
    "PowerTruckCrate",
    "MechBTRCrate",
    "TankCrate",
    "TankCrate2",
    "WatchTowerWoodCrate",
    "WatchTowerSupplyCrate",
    "OutpostPipeCrate",
    "OutpostSupplyCrate",
    "OutpostWoodCrate"
}


-- Assembler configuration - instructs SLC how to assemble an object
SLC.Config.Assembler =
{
  FuelTruck = 
  { 
    SpawnTemplate = "Spawn FuelTruck Template",
    SpawnName = "SLC FuelTruck", 
    Components = { FuelTruckCrate = SLC.Config.ComponentTypes.FuelTruckCrate },
    Count = 1
  },
  CommandTruck = 
  { 
    SpawnTemplate = "Spawn CommandTruck Template",
    SpawnName = "SLC CommandTruck", 
    Components = { CommandTruckCrate = SLC.Config.ComponentTypes.CommandTruckCrate },
    Count = 1
  },
  AmmoTruck = 
  { 
    SpawnTemplate = "Spawn AmmoTruck Template",
    SpawnName = "SLC AmmoTruck", 
    Components = { AmmoTruckCrate = SLC.Config.ComponentTypes.AmmoTruckCrate },
    Count = 1
  },
  PowerTruck = 
  { 
    SpawnTemplate = "Spawn PowerTruck Template",
    SpawnName = "SLC PowerTruck", 
    Components = { PowerTruckCrate = SLC.Config.ComponentTypes.PowerTruckCrate },
    Count = 1
  },
  MechBTR = 
  { 
    SpawnTemplate = "Spawn MechBTR Template",
    SpawnName = "SLC MechBTR", 
    Components = { MechBTRCrate = SLC.Config.ComponentTypes.MechBTRCrate },
    Count = 1
  },
  TankT72 = 
  { 
    SpawnTemplate = "Spawn TankT72 Template",
    SpawnName = "SLC TankT72", 
    Components = { TankCrate = SLC.Config.ComponentTypes.TankCrate },
    Count = 1
  },
  TankT90 = 
  { 
    SpawnTemplate = "Spawn TankT72 Template",
    SpawnName = "SLC TankT90", 
    Components = { TankCrate2 = SLC.Config.ComponentTypes.TankCrate2 },
    Count = 1
  },
  
  WatchTower = 
  { 
    SpawnTemplate = "Spawn WatchTower Template",
    SpawnName = "SLC WatchTower", 
    Components = 
    { 
      WatchTowerWoodCrate = SLC.Config.ComponentTypes.WatchTowerWoodCrate, 
      WatchTowerSupplyCrate = SLC.Config.ComponentTypes.WatchTowerSupplyCrate 
    },
    Count = 2
  },
  OutPost = 
  { 
    SpawnTemplate = "Spawn Outpost Template",
    SpawnName = "SLC OutPost", 
    Components = 
    { 
      OutpostPipeCrate = SLC.Config.ComponentTypes.OutpostPipeCrate,
      OutpostSupplyCrate = SLC.Config.ComponentTypes.OutpostSupplyCrate,
      OutpostWoodCrate = SLC.Config.ComponentTypes.OutpostWoodCrate 
    },
    Count = 3
  }
}

SLC.Config.InfantryTypes =
{
  InfantrySquad = 
  { 
    KeyName = "InfantrySquad",
    MenuName = "Infantry Squad", 
    SpawnTemplate = "InfantrySquadTemplate",
    SpawnName = "SLC Infantry",
    Size = 10
  },
  ATSquad = 
  {  
    KeyName = "ATSquad",
    MenuName = "Anti Tank Squad", 
    SpawnTemplate = "ATSquadTemplate",
    SpawnName = "SLC ATInfantry",
    Size = 6
  },
  MANPADSquad = 
  {
    KeyName = "MANPADSquad",
    MenuName = "MANPADS Squad", 
    SpawnTemplate = "MANPADSSquadTemplate",
    SpawnName = "SLC MANPADS",
    Size = 3
  }
}

SLC.Config.InfantryTypesOrder =
{
  "InfantrySquad",
  "ATSquad",
  "MANPADSquad"
}
--========================================================================================================
