if not ConfigChecker then
  ConfigChecker = {}
end

ConfigChecker.CSCIConfigDictionary = 
{
  { Name = "CSCI.Config.RestrictToCSCIPilot", Default = false, Rules = {ConfigChecker.IsBoolean}},
  {
    Name = "CSCI.Config.AirdropTypes",
    Rules =
    {
      ConfigChecker.IsTable,
      function(x)
        local msg = ""
        local result = true
        
        for key, t in pairs(x) do
          
          if not ConfigChecker.IsString(key) then
            msg = msg .. "\n" .. "AirdropTypes hash key must be type string!"
            result = false
          end
          
          if t.MenuName == nil then
            msg = msg .. "\n" .. "AirdropTypes property 'MenuName' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsString(t.MenuName) then
            msg = msg .. "\n" .. "AirdropTypes property 'MenuName' must be type string!"
            result = false
          elseif not (t.MenuName == key) then
            msg = msg .. "\n" .. "AirdropTypes property 'MenuName' must be the same as hash key! (hash key: " .. tostring(key) .. ", KeyName: " .. tostring(t.MenuName) .. ")"
            result = false
          end
          
          if t.SpawnTemplate == nil then
            msg = msg .. "\n" .. "AirdropTypes property 'SpawnTemplate' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsString(t.SpawnTemplate) then
            msg = msg .. "\n" .. "AirdropTypes property 'SpawnTemplate' must be type string!"
            result = false
          elseif not ConfigChecker.IsGroup(t.SpawnTemplate) then
            msg = msg .. "\n" .. "AirdropTypes property 'SpawnTemplate' group '" .. tostring(t.SpawnTemplate) .. "' does not exist!"
            result = false
          end
          
          if t.Cooldown == nil then
            msg = msg .. "\n" .. "AirdropTypes property 'Cooldown' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsNumber(t.Cooldown) then
            msg = msg .. "\n" .. "AirdropTypes property 'Cooldown' must be type number!"
            result = false
          end
          
          if t.MaxCallsPerCooldown == nil then
            msg = msg .. "\n" .. "AirdropTypes property 'MaxCallsPerCooldown' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsNumber(t.MaxCallsPerCooldown) then
            msg = msg .. "\n" .. "AirdropTypes property 'MaxCallsPerCooldown' must be type number!"
            result = false
          end
          
          if t.MaxCallsPerSession == nil then
            msg = msg .. "\n" .. "AirdropTypes property 'MaxCallsPerSession' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsNumber(t.MaxCallsPerSession) then
            msg = msg .. "\n" .. "AirdropTypes property 'MaxCallsPerSession' must be type number!"
            result = false
          end
          
          if t.PlaneCruisingSpeed == nil then
            msg = msg .. "\n" .. "AirdropTypes property 'PlaneCruisingSpeed' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsNumber(t.PlaneCruisingSpeed) then
            msg = msg .. "\n" .. "AirdropTypes property 'PlaneCruisingSpeed' must be type number!"
            result = false
          end
          
          if t.PlaneCruisingAltitude == nil then
            msg = msg .. "\n" .. "AirdropTypes property 'PlaneCruisingAltitude' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsNumber(t.PlaneCruisingAltitude) then
            msg = msg .. "\n" .. "AirdropTypes property 'PlaneCruisingAltitude' must be type number!"
            result = false
          end
          
          if t.AirdropDistance == nil then
            msg = msg .. "\n" .. "AirdropTypes property 'AirdropDistance' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsNumber(t.AirdropDistance) then
            msg = msg .. "\n" .. "AirdropTypes property 'AirdropDistance' must be type number!"
            result = false
          end
          
          if t.ParachuteTime == nil then
            msg = msg .. "\n" .. "AirdropTypes property 'ParachuteTime' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsNumber(t.ParachuteTime) then
            msg = msg .. "\n" .. "AirdropTypes property 'ParachuteTime' must be type number!"
            result = false
          end
          
          if t.CargoTemplate == nil then
            msg = msg .. "\n" .. "AirdropTypes property 'CargoTemplate' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsTable(t.CargoTemplate) then
            msg = msg .. "\n" .. "AirdropTypes property 'CargoTemplate' must be type table!"
            result = false
          else
            for _, grp in pairs(t.CargoTemplate) do
              if not ConfigChecker.IsGroup(grp) then
                msg = msg .. "\n" .. "AirdropTypes property 'CargoTemplate' group '" .. tostring(grp) .. "' does not exist!"
                result = false
              end
            end
          end
        end
        
        return result, msg
      end 
    }
  }
}