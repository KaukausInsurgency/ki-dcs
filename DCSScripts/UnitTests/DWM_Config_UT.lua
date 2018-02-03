if not DWM then
  DWM = {}
end

-- DWM CONFIG SECTION
DWM.Config = {}

-- The convoy template groups to use when spawning a logistics convoy from a supplier depot
DWM.Config.ConvoyGroupTemplates = 
{
  [1] = "LogisticConvoyTemplate"
}

DWM.Config.OnSpawnGroup = nil       -- parameters (spawnedGroup, spawnZone, WPZone)
DWM.Config.OnDepotResupplied = nil  -- parameters (depot)


DWM.Config.Contents =
{
    { Name = "Fuel Truck Crate", InitialStock = 2, StockMultiplier = 1 },
    { Name = "Command Truck Crate", InitialStock = 2, StockMultiplier = 1 },
    { Name = "Ammo Truck Crate", InitialStock = 2, StockMultiplier = 1 },
    { Name = "Power Truck Crate", InitialStock = 2, StockMultiplier = 1 },
    { Name = "BTR 80 Crate", InitialStock = 2, StockMultiplier = 1 },
    { Name = "T-72 Crate", InitialStock = 2, StockMultiplier = 2 },
    { Name = "T-90 Crate", InitialStock = 2, StockMultiplier = 3 },
    { Name = "Watch Tower Wood", InitialStock = 2, StockMultiplier = 4 },
    { Name = "Watch Tower Supply Crate", InitialStock = 4, StockMultiplier = 2 },
    { Name = "Outpost Pipes", InitialStock = 2, StockMultiplier = 4 },
    { Name = "Outpost Supply Crate", InitialStock = 4, StockMultiplier = 2 },
    { Name = "Outpost Wood", InitialStock = 2, StockMultiplier = 4 },
    { Name = "Infantry Squad", InitialStock = 3, StockMultiplier = 10 },
    { Name = "Anti Tank Squad", InitialStock = 2, StockMultiplier = 6 },
    { Name = "MANPADS Squad", InitialStock = 3, StockMultiplier = 3 },
}