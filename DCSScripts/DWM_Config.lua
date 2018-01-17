if not DWM then
  DWM = {}
end

-- DWM CONFIG SECTION
DWM.Config = {}

-- The convoy template groups to use when spawning a logistics convoy from a supplier depot
DWM.Config.ConvoyGroupTemplates = 
{
  [1] = "LogisticConvoyTemplate1",
  [2] = "LogisticConvoyTemplate2"
}

DWM.Config.OnSpawnGroup = nil       -- passes arguments (moosegrp, fromDepot, toDepot)
DWM.Config.OnDepotResupplied = nil  -- passes argument depot 