if not ConfigChecker then
  ConfigChecker = {}
end

ConfigChecker.JTACConfigDictionary = 
{
  { Name = "JTAC_maxDistance", Default = 5000, Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive} },
  { Name = "JTAC_laserCode", Default = 1688, Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive} },
  { Name = "JTAC_smokeOn", Default = true, Rules = {ConfigChecker.IsBoolean} },
  { 
    Name = "JTAC_smokeColour", Default = 1, 
    Rules = 
    {
      ConfigChecker.IsNumber, 
      function(x)
        return ConfigChecker.ValueInArray({0, 1, 2, 3, 4}, x)
      end
    }
  },
  { Name = "JTAC_jtacStatusF10", Default = true, Rules = {ConfigChecker.IsBoolean} },
  { Name = "JTAC_location", Default = true, Rules = {ConfigChecker.IsBoolean} },
  { 
    Name = "JTAC_lock", Default = true, 
    Rules = 
    {
      ConfigChecker.IsString,
      function(x)
        return ConfigChecker.ValueInArray({"all", "vehicle", "troop"}, x)
      end
    } 
  },
  { 
    Name = "JTAC_AllySide", Default = KI.Config.AllySide, 
    Rules = 
    {
      ConfigChecker.IsNumber,
      function(x)
        return x == 1 or x == 2, "Invalid value - must be 1 or 2!"
      end,
      function(x)
        if JTAC_EnemySide ~= nil then
          return JTAC_EnemySide ~= x, "Invalid value - you cannot use the same side value for both JTAC_AllySide and JTAC_EnemySide!"
        else
          return true
        end      
      end
    } 
  },
  { 
    Name = "JTAC_EnemySide", Default = KI.Config.InsurgentSide, 
    Rules = 
    {
      ConfigChecker.IsNumber,
      function(x)
        return x == 1 or x == 2, "Invalid value - must be 1 or 2!"
      end,
      function(x)
        if JTAC_AllySide ~= nil then
          return JTAC_AllySide ~= x, "Invalid value - you cannot use the same side value for both JTAC_AllySide and JTAC_EnemySide!"
        else
          return true
        end      
      end
    } 
  },
}