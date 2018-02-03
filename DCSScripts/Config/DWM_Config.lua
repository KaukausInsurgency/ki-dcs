if not DWM then
  DWM = {}
end

-- DWM CONFIG SECTION
DWM.Config = {}

-- The convoy template groups to use when spawning a logistics convoy from a supplier depot
-- These are randomly selected when a convoy resupply is requested
DWM.Config.ConvoyGroupTemplates = 
{
  [1] = "LogisticConvoyTemplate1",
  [2] = "LogisticConvoyTemplate2"
}

DWM.Config.OnSpawnGroup = nil       -- passes arguments (moosegrp, fromDepot, toDepot)
DWM.Config.OnDepotResupplied = nil  -- passes argument depot 

DWM.Config.Contents =
{
    { Name = "Fuel Truck Crate", InitialStock = 4, StockMultiplier = 1 },
    { Name = "Command Truck Crate", InitialStock = 4, StockMultiplier = 1 },
    { Name = "Ammo Truck Crate", InitialStock = 4, StockMultiplier = 1 },
    { Name = "Power Truck Crate", InitialStock = 4, StockMultiplier = 1 },
    { Name = "BTR 80 Crate", InitialStock = 8, StockMultiplier = 1 },
    { Name = "T-72 Crate", InitialStock = 8, StockMultiplier = 2 },
    { Name = "T-90 Crate", InitialStock = 4, StockMultiplier = 3 },
    { Name = "Watch Tower Wood", InitialStock = 4, StockMultiplier = 4 },
    { Name = "Watch Tower Supply Crate", InitialStock = 4, StockMultiplier = 2 },
    { Name = "Outpost Pipes", InitialStock = 4, StockMultiplier = 4 },
    { Name = "Outpost Supply Crate", InitialStock = 4, StockMultiplier = 2 },
    { Name = "Outpost Wood", InitialStock = 4, StockMultiplier = 4 },
    { Name = "Infantry Squad", InitialStock = 4, StockMultiplier = 10 },
    { Name = "Anti Tank Squad", InitialStock = 2, StockMultiplier = 6 },
    { Name = "MANPADS Squad", InitialStock = 4, StockMultiplier = 3 },
}
