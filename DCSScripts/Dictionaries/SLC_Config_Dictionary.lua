if not ConfigChecker then
  ConfigChecker = {}
end

ConfigChecker.SLCConfigDictionary = 
{
  { 
    Name = "SLC.Config.CrateQueryDistance", Default = 50,
    Rules = { ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive },
    Warnings =
    {
      function(x)
        return x < 35, "Low value - this will cause problems for players trying to unpack items that require multiple crates and can negatively effect the player experience - recommend values greater than 35"
      end,
      function(x)
        return x > 150, "High values can cause lag and stuttering, as well as unintended side effects by unpacking remote crates - recommend values less than 150"
      end
    },    
  },
  { 
    Name = "SLC.Config.ObjectSpawnDistance", Default = 25,
    Rules = { ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive },
    Warnings =
    {
      function(x)
        return x < 10, "Low values may cause crates to crash into player airframe and negatively effect player experience - recommend values greater than 10"
      end,
      function(x)
        return x > 75, "High values can cause crates to spawn outside of depot and players range and negatively effect player experience - recommend values less than 75"
      end
    }
  },
  { 
    Name = "SLC.Config.SpawnID", Default = 0,
    Rules = { 
      ConfigChecker.IsNumber, 
      function(x)
        return x == 0, "Value must be set to 0!"
      end
    } 
  },
  {
    Name = "SLC.Config.CargoTypes",
    Rules = 
    {
      ConfigChecker.IsTable,
      function(x)
        local msg = ""
        local result = true
        
        for key, t in pairs(x) do
          if not ConfigChecker.IsString(key) then
            msg = msg .. "\n" .. "SLC.Config.CargoTypes hash key must be type string!"
            result = false
          end
          
          if t.Name == nil then
            msg = msg .. "\n" .. "SLC.Config.CargoTypes property 'Name' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsString(t.Name) then
            msg = msg .. "\n" .. "SLC.Config.CargoTypes property 'Name' must be type string!"
            result = false
          end
        end
        
        return result, msg
      end 
    }
  },
  {
    Name = "SLC.Config.ComponentTypes",
    Rules = 
    {
      ConfigChecker.IsTable,
      function(x)
        local msg = ""
        local result = true
        
        local function IsCargoType(x)
          if SLC.Config.CargoTypes == nil then
            return false
          else
            return SLC.Config.CargoTypes[x] ~= nil
          end
        end
        
        local function IsAssemblerType(x)
          if SLC.Config.Assembler == nil then
            return false
          else
            return SLC.Config.Assembler[x] ~= nil
          end
        end
        
        for key, t in pairs(x) do
        
          if not ConfigChecker.IsString(key) then
            msg = msg .. "\n" .. "ComponentTypes hash key must be type string!"
            result = false
          end
          
          if t.KeyName == nil then
            msg = msg .. "\n" .. "ComponentTypes property 'KeyName' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsString(t.KeyName) then
            msg = msg .. "\n" .. "ComponentTypes property 'KeyName' must be type string!"
            result = false
          elseif not (t.KeyName == key) then
            msg = msg .. "\n" .. "ComponentTypes property 'KeyName' must be the same as hash key! (hash key: " .. tostring(key) .. ", KeyName: " .. tostring(t.KeyName)
            result = false
          end
          
          if t.MenuName == nil then
            msg = msg .. "\n" .. "ComponentTypes property 'MenuName' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsString(t.MenuName) then
            msg = msg .. "\n" .. "ComponentTypes property 'MenuName' must be type string!"
            result = false
          end
          
          if t.SpawnName == nil then
            msg = msg .. "\n" .. "ComponentTypes property 'SpawnName' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsString(t.SpawnName) then
            msg = msg .. "\n" .. "ComponentTypes property 'SpawnName' must be type string!"
            result = false
          end
          
          if t.ParentMenu == nil then

          elseif not ConfigChecker.IsString(t.ParentMenu) then
            msg = msg .. "\n" .. "ComponentTypes property 'ParentMenu' must be type string!"
            result = false
          end
          
          if t.Type == nil then
            msg = msg .. "\n" .. "ComponentTypes property 'Type' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsString(t.Type) then
            msg = msg .. "\n" .. "ComponentTypes property 'Type' must be type string!"
            result = false
          elseif not IsCargoType(t.Type) then
            msg = msg .. "\n" .. "ComponentTypes property 'Type' - cannot find '" .. t.Type .. "' in SLC.Config.CargoTypes!"
            result = false
          end
          
          if t.Assembler == nil then
            msg = msg .. "\n" .. "ComponentTypes property 'Assembler' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsString(t.Assembler) then
            msg = msg .. "\n" .. "ComponentTypes property 'Assembler' must be type string!"
            result = false
          elseif not IsAssemblerType(t.Assembler) then
            msg = msg .. "\n" .. "ComponentTypes property 'Assembler' - cannot find '" .. t.Assembler .. "' in SLC.Config.Assembler!"
            result = false
          end
          
          if t.Weight == nil then
            msg = msg .. "\n" .. "ComponentTypes property 'Weight' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsNumber(t.Weight) then
            msg = msg .. "\n" .. "ComponentTypes property 'Weight' must be type number!"
            result = false
          elseif not ConfigChecker.IsNumberPositive(t.Weight) then
            msg = msg .. "\n" .. "ComponentTypes property 'Weight' must be positive number!"
            result = false
          end
        end
        
        return result, msg
      end 
    }
  },
  {
    Name = "SLC.Config.ComponentTypesOrder",
    Rules = 
    {
      ConfigChecker.IsTable,
      function(x)
        return SLC.Config.ComponentTypes ~= nil, "SLC.Config.ComponentTypes cannot be nil!"
      end,
      function(x)
        local msg = ""
        local result = true
        
        for _, k in pairs(x) do
          if SLC.Config.ComponentTypes[k] == nil then
            msg = msg .. "\n" .. "SLC.Config.ComponentTypesOrder is out of sync with SLC.Config.ComponentTypes! (item: " .. tostring(k) .. " not found in SLC.Config.ComponentTypes)"
            result = false
          end   
        end
        
        for k, _ in pairs(SLC.Config.ComponentTypes) do
          if not ConfigChecker.ValueInArray(x, k) then
            msg = msg .. "\n" .. "SLC.Config.ComponentTypesOrder is out of sync with SLC.Config.ComponentTypes! (item: " .. tostring(k) .. " not found in SLC.Config.ComponentTypesOrder)"
          end
        end
        
        return result, msg
      end
    }
  },
  {
    Name = "SLC.Config.Assembler",
    Rules = 
    {
      ConfigChecker.IsTable,
      function(x)
        local msg = ""
        local result = true
        
        local function IsComponentType(x)
          if SLC.Config.ComponentTypes == nil then
            return false
          else
            return SLC.Config.ComponentTypes[x] ~= nil
          end
        end
        
        local function CountHash(x)
          local c = 0
          for _, _ in pairs(x) do
            c = c + 1
          end
          return c
        end
        
        
        
        for key, t in pairs(x) do
        
          if not ConfigChecker.IsString(key) then
            msg = msg .. "\n" .. "Assembler hash key must be type string!"
            result = false
          end
          
          if t.SpawnName == nil then
            msg = msg .. "\n" .. "Assembler property 'SpawnName' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsString(t.SpawnName) then
            msg = msg .. "\n" .. "Assembler property 'SpawnName' must be type string!"
            result = false
          end
          
          if t.SpawnTemplate == nil then
            msg = msg .. "\n" .. "Assembler property 'SpawnTemplate' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsString(t.SpawnTemplate) then
            msg = msg .. "\n" .. "Assembler property 'SpawnTemplate' must be type string!"
            result = false
          elseif not ConfigChecker.IsGroup(t.SpawnTemplate) then
            msg = msg .. "\n" .. "Assembler property 'SpawnTemplate' group '" .. tostring(t.SpawnTemplate) .. "' does not exist!"
            result = false
          end
      
          if t.Components == nil then
            msg = msg .. "\n" .. "Assembler property 'Components' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsTable(t.Components) then
            msg = msg .. "\n" .. "Assembler property 'Components' must be type table!"
            result = false
          else
            for comp_key, comp in pairs(t.Components) do
              if not IsComponentType(comp_key) then
                msg = msg .. "\n" .. "Assembler property 'Components' hash key not found in SLC.Config.ComponentTypes! (key: " .. tostring(comp_key) .. ")"
                result = false
              elseif comp ~= SLC.Config.ComponentTypes[comp_key] then
                msg = msg .. "\n" .. "Assembler property 'Components' object does not equal object defined in SLC.Config.ComponentTypes! (key: " .. tostring(comp_key) .. ")"
                result = false
              end
            end
          end
          
          if t.Count == nil then
            msg = msg .. "\n" .. "Assembler property 'Count' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsNumber(t.Count) then
            msg = msg .. "\n" .. "Assembler property 'Count' must be type number!"
            result = false
          else
            if t.Components == nil or CountHash(t.Components) ~= t.Count then
              msg = msg .. "\n" .. "Assembler property 'Count' must equal the number of items defined in property 'Components'!"
              result = false
            end
          end
        end
        
        return result, msg
      end 
    }
  }
}