if not DWM then
  DWM = {}
end

-- DWM CONFIG SECTION
DWM.Config = {}

-- The convoy template groups to use when spawning a logistics convoy from a supplier depot
DWM.Config.ConvoyGroupTemplates = 
{
  [1] = "LogisticConvoyTemplate1",
  [2] = "LogisticConvoyTemplate2",
  [3] = "LogisticConvoyTemplate3"
}

DWM.Config.OnSpawnGroup = nil