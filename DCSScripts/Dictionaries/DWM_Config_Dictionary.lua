if not ConfigChecker then
  ConfigChecker = {}
end

ConfigChecker.DWMConfigDictionary = 
{
  { Name = "DWM.Config.ConvoyGroupTemplates", Rules = { ConfigChecker.IsTable, ConfigChecker.AreGroups } }
}