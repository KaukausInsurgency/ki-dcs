if not ConfigChecker then
  ConfigChecker = {}
end

ConfigChecker.DWMConfigDictionary = 
{
  { Name = "DWM.Config.ConvoyGroupTemplates", Rules = { ConfigChecker.IsTable, ConfigChecker.AreGroups, ConfigChecker.AreGroupsAllySide } },
  {
    Name = "DWM.Config.Contents", 
    Rules = 
    { 
      ConfigChecker.IsTable,
      function(t)
        local msg = ""
        local result = true
        
        for i = 1, #t do      
          local tt = t[i]
          
          if tt.Name == nil then
            msg = msg .. "\n" .. "DWM.Config.Contents property 'Name' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsString(tt.Name) then
            msg = msg .. "\n" .. "DWM.Config.Contents property 'Name' must be type string!"
            result = false
          end
          
          if tt.InitialStock == nil then
            msg = msg .. "\n" .. "DWM.Config.Contents property 'InitialStock' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsNumber(tt.InitialStock) then
            msg = msg .. "\n" .. "DWM.Config.Contents property 'InitialStock' must be type number!"
            result = false
          elseif not ConfigChecker.IsNumberPositive(tt.InitialStock) then
            msg = msg .. "\n" .. "DWM.Config.Contents property 'InitialStock' must be positive number!"
            result = false
          end
          
          if tt.StockMultiplier == nil then
            msg = msg .. "\n" .. "DWM.Config.Contents property 'StockMultiplier' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsNumber(tt.StockMultiplier) then
            msg = msg .. "\n" .. "DWM.Config.Contents property 'StockMultiplier' must be type number!"
            result = false
          elseif not ConfigChecker.IsNumberPositive(tt.StockMultiplier) then
            msg = msg .. "\n" .. "DWM.Config.Contents property 'StockMultiplier' must be positive number!"
            result = false
          end
        end
        
        return result, msg
      end
    }
  }
}