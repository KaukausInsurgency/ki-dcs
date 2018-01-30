if not ConfigChecker then
  ConfigChecker = {}
end

ConfigChecker.AICOMConfigDictionary = 
{
  { 
    Name = "AICOM.Config.TurnRate", Default = 3600, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive},
    Warnings = 
    {
      function(x) return x < 900, "Low values will make the AI Spawn units more frequently, which can lead to performance issues. Recommend using values greater than 15 minutes." end,
    }
  },
  { Name = "AICOM.Config.InitMoves", Default = 3, Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive} },
  { Name = "AICOM.Config.InitResource", Default = 125, Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive} },
  { 
    Name = "AICOM.Config.PopulationCap", Default = 150, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive},
    Warnings = 
    {
      function(x) return x < 80, "Low values may cause the AI Commander to skip turns more frequently. Use discretion when using low values." end
    }
  },
  { Name = "AICOM.Config.Random", Default = math.random, Rules = {ConfigChecker.IsFunction} },
  { 
    Name = "AICOM.Config.AmbushProbability", Default = 25, 
    Rules = 
    {
      ConfigChecker.IsNumber, 
      function(x)
        return x >= 0 and x <= 100, "Value must be within 0 to 100"
      end
    },
    Warnings =
    {
      function(x) return x > 90, "High values will cause more ambush moves to occur and less attack / reinforce moves. Use discretion when setting high values." end
    }
  },
  { Name = "AICOM.Config.AmbushZones", Rules = {ConfigChecker.IsTable, ConfigChecker.AreZones} },
  { Name = "AICOM.Config.AmbushCost", Default = 30, Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive} },
  { 
    Name = "AICOM.Config.AmbushTime", Default = 1800, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive},
    Warnings = 
    {
      function(x) return x < 1800, "Low values will cause units to despawn quickly and have little effect on players in game." end
    } 
  },
  { 
    Name = "AICOM.Config.Forces", 
    Rules = 
    {
      ConfigChecker.IsTable, 
      function(t)
        local msg = ""
        local result = true
        
        for i = 1, #t do
        
          local tt = t[i]
          
          if tt.Name == nil then
            msg = msg .. "\n" .. "AICOM.Config.Forces property 'Name' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsString(tt.Name) then
            msg = msg .. "\n" .. "AICOM.Config.Forces property 'Name' must be type string!"
            result = false
          end
          
          if true then
            if tt.Templates == nil then
              msg = msg .. "\n" .. "AICOM.Config.Forces property 'Templates' cannot be nil!"
              result = false
            elseif not ConfigChecker.IsTable(tt.Templates) then
              msg = msg .. "\n" .. "AICOM.Config.Forces property 'Templates' must be type table!"
              result = false
            else
              local _result, _innerMsg = ConfigChecker.AreGroups(tt.Templates)
              if not _result then
                msg = msg .. "\n" .. "AICOM.Config.Forces property 'Templates' - " .. _innerMsg
                result = false
              end
            end
          end
          
          if tt.Cost == nil then
            msg = msg .. "\n" .. "AICOM.Config.Forces property 'Cost' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsNumber(tt.Cost) then
            msg = msg .. "\n" .. "AICOM.Config.Forces property 'Cost' must be type number!"
            result = false
          elseif not ConfigChecker.IsNumberPositive(tt.Cost) then
            msg = msg .. "\n" .. "AICOM.Config.Forces property 'Cost' must be positive number!"
            result = false
          end
          
          if tt.AAEffectiveness == nil then
            msg = msg .. "\n" .. "AICOM.Config.Forces property 'AAEffectiveness' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsNumber(tt.AAEffectiveness) then
            msg = msg .. "\n" .. "AICOM.Config.Forces property 'AAEffectiveness' must be type number!"
            result = false
          elseif not ConfigChecker.IsNumberPositive(tt.AAEffectiveness) then
            msg = msg .. "\n" .. "AICOM.Config.Forces property 'AAEffectiveness' must be positive number!"
            result = false
          end
          
          if tt.GNDEffectiveness == nil then
            msg = msg .. "\n" .. "AICOM.Config.Forces property 'GNDEffectiveness' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsNumber(tt.GNDEffectiveness) then
            msg = msg .. "\n" .. "AICOM.Config.Forces property 'GNDEffectiveness' must be type number!"
            result = false
          elseif not ConfigChecker.IsNumberPositive(tt.GNDEffectiveness) then
            msg = msg .. "\n" .. "AICOM.Config.Forces property 'GNDEffectiveness' must be positive number!"
            result = false
          end
          
          if tt.Speed == nil then
            msg = msg .. "\n" .. "AICOM.Config.Forces property 'Speed' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsNumber(tt.Speed) then
            msg = msg .. "\n" .. "AICOM.Config.Forces property 'Speed' must be type number!"
            result = false
          elseif not ConfigChecker.IsNumberPositive(tt.Speed) then
            msg = msg .. "\n" .. "AICOM.Config.Forces property 'Speed' must be positive number!"
            result = false
          end
          
          if tt.SpawnZone == nil then
            msg = msg .. "\n" .. "AICOM.Config.Forces property 'Cost' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsNumber(tt.SpawnZone) then
            msg = msg .. "\n" .. "AICOM.Config.Forces property 'Cost' must be type number!"
            result = false
          elseif tt.SpawnZone ~= 1 and tt.SpawnZone ~= 2 then
            msg = msg .. "\n" .. "AICOM.Config.Forces property 'SpawnZone' invalid value! - must be 1 or 2"
            result = false
          end
          
          if tt.Formation == nil then
            msg = msg .. "\n" .. "AICOM.Config.Forces property 'Formation' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsString(tt.Formation) then
            msg = msg .. "\n" .. "AICOM.Config.Forces property 'Formation' must be type string!"
            result = false
          end
          
        end -- end for
        
        return result, msg
      end
    } 
  },
}