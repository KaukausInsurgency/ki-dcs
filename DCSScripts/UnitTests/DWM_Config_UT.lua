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