if not ConfigChecker then
  ConfigChecker = {}
end

ConfigChecker.KIConfigDictionary = 
{
  { 
    Name = "KI.Config.DataTransmissionPlayerUpdateRate", Default = 5, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive},
    Warnings = 
    {
      function(x) return x < 3, "Low values can have a large impact on game and network performance." end,
      function(x) return x > 10, "High values can have a large impact on player experience and waiting time to slot in." end
    }
  },
  { 
    Name = "KI.Config.DataTransmissionGameEventsUpdateRate", Default = 30, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive},
    Warnings =
    {
      function(x) return x < 5, "Low values can have a large impact on game and network performance." end
    }
  },
  { 
    Name = "KI.Config.DataTransmissionGeneralUpdateRate", Default = 15, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive},
    Warnings =
    {
      function(x) return x < 8, "Low values can have a large impact on game and network performance." end,
      function(x) return x > 30, "High values cause significant delay between live map and in game status." end
    }
  },
  { 
    Name = "KI.Config.SaveMissionRate", Default = 300, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive},
    Warnings = 
    {
      function(x) return x < 60, "Low values can have a significant impact on game performance" end
    }
  },
  {
    Name = "KI.Config.IgnoreSaveGroupPrefix", Default = "", Optional = true,
    Rules = { ConfigChecker.IsString }
  },
  {
    Name = "KI.Config.TransportDLLCrashDisableAIDispersionUnderFire", Default = false,
    Rules = { ConfigChecker.IsBoolean }
  },
  { 
    Name = "KI.Config.CPUpdateRate", Default = 10, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive}
  },
  { 
    Name = "KI.Config.PlayerInZoneCheckRate", Default = 3, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive},
    Warnings =
    {
      function(x) return x > 5, "High values will negatively effect the players experience when entering/leaving zones" end
    }
  },
  { 
    Name = "KI.Config.SideMissionUpdateRate", Default = 2700, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive}
  },
  { 
    Name = "KI.Config.SERVERMOD_RECEIVE_PORT", Default = 6005, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive, ConfigChecker.IsPort},
    Warnings = {ConfigChecker.IsReservedPort}
  },
  { 
    Name = "KI.Config.SERVERMOD_SEND_TO_PORT", Default = 6006, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive, ConfigChecker.IsPort},
    Warnings = {ConfigChecker.IsReservedPort}
  },
  { 
    Name = "KI.Config.SERVER_SESSION_RECEIVE_PORT", Default = 6007, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive, ConfigChecker.IsPort},
    Warnings = {ConfigChecker.IsReservedPort}
  },
  
  { 
    Name = "KI.Config.AllySide",
    Rules = 
    {
      ConfigChecker.IsNumber,
      function(x)
        return x == 1 or x == 2, "Invalid value - must be 1 or 2!"
      end,
      function(x)
        if KI.Config.InsurgentSide ~= nil then
          return KI.Config.InsurgentSide ~= x, "Invalid value - you cannot use the same side value for both AllySide and InsurgentSide!"
        else
          return true
        end      
      end
    }
  },
  { 
    Name = "KI.Config.InsurgentSide",
    Rules = 
    {
      ConfigChecker.IsNumber, 
      function(x)
        return x == 1 or x == 2, "Invalid value - must be 1 or 2!"
      end,
      function(x)
        if KI.Config.AllySide ~= nil then
          return KI.Config.AllySide ~= x, "Invalid value - you cannot use the same side value for both AllySide and InsurgentSide!"
        else
          return true
        end      
      end
    }
  },
  { Name = "KI.Config.AllyCountryID", Rules = { ConfigChecker.IsNumber, ConfigChecker.IsNumberPositiveOrZero }},
  { Name = "KI.Config.AllyCountryName", Rules = { ConfigChecker.IsString}},
  
  { Name = "KI.Config.CrateDespawnTime_Depot", Default = 300, Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive}},
  { Name = "KI.Config.CrateDespawnTime_Wild", Default = 14400, Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive}}, 
  { Name = "KI.Config.RespawnTimeBeforeWaypointTasking", Default = 20, Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive}}, 
  { Name = "KI.Config.SideMissionUpdateRateRandom", Default = 900, Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive}},
  { Name = "KI.Config.SideMissionsMax", Default = 3, Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive}},
  
  { 
    Name = "KI.Config.SideMissionMaxTime", Default = 3600, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive},
    Warnings =
    {
      function(x) return x < 1800, "Low values may make it impossible for players to complete the mission in any reasonable amount of time. Please consider using larger value." end
    }
  },

  { Name = "KI.Config.SideMissionsDestroyTime", Default = 600, Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive}},
  { Name = "KI.Config.ParentFolder", Default = "Missions\\\\Kaukasus Insurgency\\\\", 
    Rules = 
    {
      ConfigChecker.IsString, 
      function(x)
        return ConfigChecker.IsPath(lfs.writedir() .. x)
      end    
    }
  },
  { 
    Name = "KI.Config.PathMissionData", 
    Default = lfs.writedir() .. "Missions\\\\Kaukasus Insurgency\\\\KI_Entities.lua", 
    Rules = {ConfigChecker.IsString}
  },
  { 
    Name = "KI.Config.PathGameEvents", 
    Default = lfs.writedir() .. "Missions\\\\Kaukasus Insurgency\\\\GameEvents", 
    Rules = {ConfigChecker.IsString, ConfigChecker.IsPath}
  },
  { 
    Name = "KI.Config.PathSlingloadEvents", 
    Default = lfs.writedir() .. "Missions\\\\Kaukasus Insurgency\\\\SlingloadEvents", 
    Rules = {ConfigChecker.IsString, ConfigChecker.IsPath}
  },
  { 
    Name = "KI.Config.RespawnUnitWaypointDistance", 
    Default = 200, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive},
    Warnings = {function(x) return x < 200, "Groups may get stuck and never complete their waypoints if this value is too small" end}
  },
  { 
    Name = "KI.Config.DepotMinCapacityToResupply", 
    Default = 0.5, 
    Rules = {ConfigChecker.IsNumber, function(x) return x >= 0 and x <= 1, "Value must be between 0 and 1!" end},
    Warnings = 
    {
      function(x) return x >= 0.81, "This may cause performance issues in multiplayer, we recommend reducing this value to at least 0.8." end,
      function(x) return x >= 0 and x <= 0.05, "This is a very low value; resupply convoy may never be called for this depot." end
    }
  },
  { 
    Name = "KI.Config.ResupplyConvoyAmount", 
    Default = 25, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive}
  },
  { 
    Name = "KI.Config.DepotResupplyCheckRate", 
    Default = 600, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive}
  },
  { Name = "KI.Config.ResupplyConvoyCheckRate", Default = 300, Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive}},
  { 
    Name = "KI.Config.ConvoyMinimumDistanceToDepot", 
    Default = 200, 
    Rules = {ConfigChecker.IsNumber, ConfigChecker.IsNumberPositive},
    Warnings = {function(x) return x < 200, "Groups may get stuck and never complete their waypoints if this value is too small" end}
  },

  { Name = "KI.Config.DisplayDepotMarkers", Default = false, Rules = {ConfigChecker.IsBoolean}},
  { Name = "KI.Config.DisplayCapturePointMarkers", Default = true, Rules = {ConfigChecker.IsBoolean}},
  
  { 
    Name = "KI.Config.Depots", 
    Rules = 
    {
      ConfigChecker.IsTable, 
      function(t)
        local msg = ""
        local result = true
        for i = 1, #t do
          local tt = t[i]
          if tt.name == nil then
            msg = msg .. "\n" .. "depot property 'name' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsString(tt.name) then
            msg = msg .. "\n" .. "depot property 'name' must be type string!"
            result = false
          elseif not ConfigChecker.IsStaticObject(tt.name) then
            local _, _innerMsg = ConfigChecker.IsStaticObject(tt.name)
            msg = msg .. "\n" .. _innerMsg
            result = false
          end
          
          if tt.supplier == nil then
            msg = msg .. "\n" .. "depot property 'supplier' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsBoolean(tt.supplier)  then
            msg = msg .. "\n" .. "depot property 'supplier' must be type boolean (true, false)!"
            result = false
          end
        end
        
        return result, msg
      end  
    }
  },
  { 
    Name = "KI.Config.CP", 
    Rules = 
    {
      ConfigChecker.IsTable,
      function(t)
        local msg = ""
        local result = true
        
        for i = 1, #t do
        
          local tt = t[i]
          
          if tt.name == nil then
            msg = msg .. "\n" .. "cp property 'name' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsString(tt.name) then
            msg = msg .. "\n" .. "cp property 'name' must be type string!"
            result = false
          end
          
          if tt.zone == nil then
            msg = msg .. "\n" .. "cp property 'zone' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsString(tt.zone) then
            msg = msg .. "\n" .. "cp property 'zone' must be type string!"
            result = false
          elseif not ConfigChecker.IsZone(tt.zone) then
            local _, _innerMsg = ConfigChecker.IsZone(tt.zone)
            msg = msg .. "\n" .. "cp property 'zone' - " .. _innerMsg
            result = false
          end
          
          if not ( (tt.spawnzone1 == nil and tt.spawnzone2 == nil) or (tt.spawnzone1 ~= nil and tt.spawnzone2 ~= nil) ) then
            msg = msg .. "\n" .. "cp properties 'spawnzone1' 'spawnzone2' can only be nil together, or not nil together!"
            result = false
          end
          
          if tt.spawnzone1 ~= nil and tt.spawnzone2 ~= nil then
            local _zone1exists, _innerMsg1 = ConfigChecker.IsZone(tt.spawnzone1)      
            local _zone2exists, _innerMsg2 = ConfigChecker.IsZone(tt.spawnzone2)
            
            if (not _zone1exists) then
              msg = msg .. "\n" .. "cp property 'spawnzone1' - " .. _innerMsg1
              result = false
            end
            
            if (not _zone2exists) then
              msg = msg .. "\n" .. "cp property 'spawnzone2' - " .. _innerMsg2
              result = false
            end     
          end
          
          if tt.type ~= nil then
            local _inArray, _innerMsg = ConfigChecker.ValueInArray({"AIRPORT", "FARP", "CAPTUREPOINT"}, tt.type)
            if not _inArray then
              msg = msg .. "\n" .. "cp property 'type' - " .. _innerMsg
            end
          else
            msg = msg .. "\n" .. "cp property 'type' cannot be nil!"
            result = false
          end
          
          if tt.type ~= nil and tt.type == "AIRPORT" then
            if tt.airbase == nil then
              msg = msg .. "\n" .. "cp property 'airport' cannot be nil for cp type 'AIRPORT'!"
              result = false
            elseif not ConfigChecker.IsString(tt.airbase) then
              msg = msg .. "\n" .. "cp property 'airbase' must be type string!"
              result = false
            end
          end
          
          if tt.text == nil then

          elseif not ConfigChecker.IsString(tt.text) then
            msg = msg .. "\n" .. "cp property 'text' must be type string!"
            result = false
          end
          
          if tt.capacity == nil then
            msg = msg .. "\n" .. "cp property 'capacity' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsNumber(tt.capacity) then
            msg = msg .. "\n" .. "cp property 'capacity' must be type number!"
            result = false
          elseif not ConfigChecker.IsNumberPositive(tt.capacity) then
            msg = msg .. "\n" .. "cp property 'capacity' must be positive number!"
            result = false
          end
          
          if tt.slots == nil then

          elseif not ConfigChecker.IsTable(tt.slots) then
            msg = msg .. "\n" .. "cp property 'slots' must be type table!"
            result = false
          elseif not ConfigChecker.AreClients(tt.slots) then
            local _, _innerMsg = ConfigChecker.AreClients(tt.slots)
            msg = msg .. "\n" .. "cp property 'slots' - " .. _innerMsg
            result = false
          end
          
        end -- end for
        
        return result, msg
      end
    }
  },
  { 
    Name = "KI.Config.SideMissions", 
    Rules = 
    {
      ConfigChecker.IsTable, 
      function(t)
        local msg = ""
        local result = true
        for i = 1, #t do
          local tt = t[i]
          if tt.name == nil then
            msg = msg .. "\n" .. "sidemission property 'name' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsString(tt.name) then
            msg = msg .. "\n" .. "sidemission property 'name' must be type string!"
            result = false
          end
          
          if tt.desc == nil then
            msg = msg .. "\n" .. "sidemission property 'desc' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsString(tt.desc) then
            msg = msg .. "\n" .. "sidemission property 'desc' must be type string!"
            result = false
          end
          
          if tt.image == nil then
            msg = msg .. "\n" .. "sidemission property 'image' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsString(tt.image) then
            msg = msg .. "\n" .. "sidemission property 'image' must be type string!"
            result = false
          elseif not ConfigChecker.ValueInArray({"camp"}, tt.image) then
            msg = msg .. "\n" .. "sidemission property 'image' has an invalid value, please use valid value!"
            result = false
          end
          
          if tt.rate == nil then
            msg = msg .. "\n" .. "sidemission property 'rate' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsNumber(tt.rate) then
            msg = msg .. "\n" .. "sidemission property 'rate' must be type number!"
            result = false
          elseif not ConfigChecker.IsNumberPositive(tt.rate) then
            msg = msg .. "\n" .. "sidemission property 'rate' must be positive number!"
            result = false
          end
          
          if tt.zones == nil then
            msg = msg .. "\n" .. "sidemission property 'zones' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsTable(tt.zones) then
            msg = msg .. "\n" .. "sidemission property 'zones' must be type table!"
            result = false    
          elseif not ConfigChecker.AreZones(tt.zones) then
            local _, _innerMsg = ConfigChecker.AreZones(tt.zones)
            msg = msg .. "\n" .. _innerMsg
            result = false    
          end
          
          if tt.init == nil then
            msg = msg .. "\n" .. "sidemission property 'init' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsFunction(tt.init) then
            msg = msg .. "\n" .. "sidemission property 'init' must be type function!"
            result = false           
          end
          
          if tt.destroy == nil then
            msg = msg .. "\n" .. "sidemission property 'destroy' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsFunction(tt.destroy) then
            msg = msg .. "\n" .. "sidemission property 'destroy' must be type function!"
            result = false    
          end
          
          if tt.complete == nil then
            msg = msg .. "\n" .. "sidemission property 'complete' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsFunction(tt.complete) then
            msg = msg .. "\n" .. "sidemission property 'complete' must be type function!"
            result = false      
          end
          
          if tt.fail == nil then
            msg = msg .. "\n" .. "sidemission property 'fail' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsFunction(tt.fail) then
            msg = msg .. "\n" .. "sidemission property 'fail' must be type function!"
            result = false    
          end
               
          if tt.oncomplete == nil then
            msg = msg .. "\n" .. "sidemission property 'oncomplete' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsFunction(tt.oncomplete) then
            msg = msg .. "\n" .. "sidemission property 'oncomplete' must be type function!"
            result = false        
          end
          
          if tt.onfail == nil then
            msg = msg .. "\n" .. "sidemission property 'onfail' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsFunction(tt.onfail) then
            msg = msg .. "\n" .. "sidemission property 'onfail' must be type function!"
            result = false
          end
          
          if tt.ontimeout == nil then
            msg = msg .. "\n" .. "sidemission property 'ontimeout' cannot be nil!"
            result = false
          elseif not ConfigChecker.IsFunction(tt.ontimeout) then
            msg = msg .. "\n" .. "sidemission property 'ontimeout' must be type function!"
            result = false
          end -- end if
                         
        end -- end for
        
        return result, msg
      end,
    }
  },
}