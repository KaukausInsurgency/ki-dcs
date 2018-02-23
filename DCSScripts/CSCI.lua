-- Combat Support Call In module otherwise known as CSCI
-- Exposes functions for creating and managing combat support requests

if not CSCI then
  CSCI = {}
end

CSCI.Data = {}

CSCI.AirdropParentMenu = "Airdrop"
CSCI.ActionViewAirdropsRemaining = "View Airdrops Remaining"

function CSCI.Init()
  env.info("CSCI.Init() called")
  for key, droptype in pairs(CSCI.Config.AirdropTypes) do
    local item = 
    {
      CooldownCallsRemaining = droptype.MaxCallsPerCooldown,
      CallsRemaining = droptype.MaxCallsPerSession,
      Cooldown = droptype.Cooldown
    }
    CSCI.Data[key] = item
  end
  env.info("CSCI.Init() complete")
end




function CSCI.CanCall(actionname, capturepoint)
  env.info("CSCI.CanCall() called")
  
  if capturepoint.CSCICalled then
    env.info("CSCI.CanCall - This capture point already has combat support requested, cannot call support again")
    return false, "Cannot call support! There is already active combat support on route to this capture point!"
  end
  
  local supportdata = CSCI.Data[actionname]
  
  if supportdata ~= nil then
    env.info("CSCI.CanCall supportdata found for " .. actionname)
    if supportdata.CooldownCallsRemaining > 0 and supportdata.CallsRemaining > 0 then
      env.info("CSCI.CanCall - Can still call this support type")
      return true
    elseif supportdata.CooldownCallsRemaining <= 0 then
      env.info("CSCI.CanCall - No calls remaining for cooldown period - waiting for cooldown to expire")
      return false, "Cannot call support! On cooldown (" .. tostring(supportdata.Cooldown) .. " seconds remaining)"
    elseif supportdata.CallsRemaining <= 0 then
      env.info("CSCI.CanCall - This support type can no longer be called in this session")
      return false, "Cannot call support! No more requests can be made for this session! Wait until server restart!"
    else
      env.info("CSCI.CanCall ERROR - impossible else statement reached!")
    end
  else
    env.info("CSCI.CanCall ERROR - invalid support type called! (actionname: " .. tostring(actionname) .. ")")
    return false, "Cannot call support! Invalid support type!"
  end
end

function CSCI.CreateCooldownTimer(supportdata, csci_config)
  env.info("CSCI.CreateCooldownTimer() called")
  
  -- reset Cooldown value
  supportdata.Cooldown = csci_config.Cooldown
  
  -- start timer function every 1 second to decrement counter
  timer.scheduleFunction(function(args, t) 
      env.info("CSCI.CooldownTimer - INVOKED SCHEDULE!")
      local ok, result = xpcall(function()
        --env.info("CSCI.CooldownTimer: " .. tostring(args.supportdata.Cooldown))
        args.supportdata.Cooldown = args.supportdata.Cooldown - 1
        if (args.supportdata.Cooldown == 0) then
          env.info("CSCI.CooldownTimer - cooldown for " .. csci_config.MenuName .. " has ended")
          args.supportdata.CooldownCallsRemaining = args.csci_config.MaxCallsPerCooldown
          return nil
        else
          return t + 1
        end    
      end, function(err) env.info("CSCI.CooldownTimer ERROR - " .. err) end)
      
      if not ok then
        return nil
      else
        return result
      end
    end, { supportdata = supportdata, csci_config = csci_config}, timer.getTime() + 1)
end

function CSCI.PerformAction(action, actionname, parentmenu, moosegrp, csci_config, capturepoint)
  xpcall(function()
    env.info("CSCI.PerformAction called (actionname: " .. actionname .. ", parentmenu: " .. parentmenu .. ")")
    
    local _groupID = moosegrp:GetDCSObject():getID()
    
    if actionname == CSCI.ActionViewAirdropsRemaining then
      action(moosegrp)
      return
    end
    
    local cancall, msg = CSCI.CanCall(actionname, capturepoint)
      
    if cancall then
    
      env.info("CSCI.PerformAction - can call this support option")
      
      local isvalid = true
      
      if CSCI.Config.PreOnRadioAction then
        env.info("CSCI.PerformAction - found PreOnRadioAction callback - invoking")
        isvalid = CSCI.Config.PreOnRadioAction(actionname, parentmenu, moosegrp, csci_config, capturepoint)
      end
      
      if isvalid then
        env.info("CSCI.PerformAction - Invoking action")
        action(actionname, parentmenu, csci_config, capturepoint)
           
        -- update the counts
        capturepoint.CSCICalled = true
        
        local supportdata = CSCI.Data[actionname]
        
        if supportdata then
          env.info("CSCI.PerformAction - Updating Remaining Calls")
          supportdata.CooldownCallsRemaining = supportdata.CooldownCallsRemaining - 1
          supportdata.CallsRemaining = supportdata.CallsRemaining - 1
          
          if supportdata.CooldownCallsRemaining ~= csci_config.MaxCallsPerCooldown then  
            env.info("CSCI.PerformAction - Cooldown activated")       
            CSCI.CreateCooldownTimer(supportdata, csci_config)
          end
        else
          env.info("CSCI.PerformAction ERROR - supportdata is nil!")
        end
      end
      
    else
      env.info("CSCI.PerformAction - cannot call this support option")
      trigger.action.outTextForGroup(_groupID, msg, 10, false)
    end
  end,
  function(err) env.info("CSCI.PerformAction ERROR - " .. err) end)   
end

function CSCI.ShowAirdropContents(moosegrp)
  env.info("CSCI.ShowAirdropContents() called")
  
  local msg = "Available Airdrops\n"
  msg = msg .. string.format("%-35s|%-35s|%-35s", "Name", "Remaining", "Cooldown") .. "\n"

  for key, data in pairs(CSCI.Data) do
    msg = msg .. string.format("%-35s|%-35d|%-35d", key, data.CallsRemaining, data.Cooldown) .. "\n"
  end
  
  local _groupID = moosegrp:GetDCSObject():getID()
  trigger.action.outTextForGroup(_groupID, msg, 20, false)
end

function CSCI.CreateAirdrop(actionname, parentaction, csci_config, destcp)
  env.info("CSCI.CreateAirdrop() called for " .. actionname)
  local spawncp = KI.Query.FindFriendlyCPAirport()
  
  if spawncp ~= nil then
  
    local SpawnedGroup = CSCI.SpawnAircraft(csci_config.SpawnTemplate, parentaction, spawncp, destcp, csci_config)
    if SpawnedGroup ~= nil then
      if CSCI.Config.OnSupportRequestCalled then
        env.info("CSCI.CreateAirdrop - found callback CSCI.Config.OnSupportRequestCalled - invoking")
        CSCI.Config.OnSupportRequestCalled(actionname, parentaction, spawncp, destcp, csci_config)
      end
      
      CSCI.CreateAirdropManager(SpawnedGroup, csci_config, destcp)
    else
      env.info("CSCI.CreateAirdrop ERROR - SpawnedGroup is nil!")
    end
  else
    env.info("CSCI.CreateAirdrop ERROR - could not find friendly airport CP!")
  end
end

function CSCI.CreateAirdropManager(moosegrp, csci_config, destcp)
  env.info("CSCI.CreateAirdropManager() called")
  
  timer.scheduleFunction(
    function(args, t)
    
      local ok, result = 
      xpcall(function()
      
          if not args.Group:IsAlive() then 
            env.info("CSCI.CreateAirdropManager() - Aircraft is dead - stopping")
            KI.Toolbox.MessageCoalition(KI.Config.AllySide, "Airdrop heading to " .. args.DestinationCP.Name .. " has been shot down!")
            args.DestinationCP.CSCICalled = false
            return nil 
          end
          
          local distance = Spatial.Distance(args.Group:GetVec3(), args.DestinationCP.Zone:GetVec3())
          --env.info("CSCI.CreateAirdropManager - distance: " .. tostring(distance))
          if distance < args.Config.AirdropDistance then
            env.info("CSCI.CreateAirdropManager() - airdrop within zone distance")
            KI.Toolbox.MessageCoalition(KI.Config.AllySide, "Aircraft has started airdrop!")
            CSCI.SpawnCargoInTime(csci_config, destcp)     
            return nil    
          else
            return t + 5     
          end
          
        end, 
      function(err) env.info("CSCI.CreateAirdropManager() ERROR - " .. err) end)
    
      if not ok then
        return nil
      else
        return result
      end
    end, 
    { Group = moosegrp, Config = csci_config, DestinationCP = destcp}, timer.getTime() + 5)
end

function CSCI.OnSpawnGroup(moosegrp, parentAction, spawnzone, destzone, csci_config)
  env.info("CSCI.OnSpawnGroup() called")
  env.info("CSCI.OnSpawnGroup - PlaneCruisingAltitude: " .. tostring(csci_config.PlaneCruisingAltitude))
  env.info("CSCI.OnSpawnGroup - PlaneCruisingSpeed: " .. tostring(csci_config.PlaneCruisingSpeed))
  moosegrp:RouteToVec3(
  { 
    x = destzone:GetVec3().x, 
    y = destzone:GetVec3().y + csci_config.PlaneCruisingAltitude, 
    z = destzone:GetVec3().z 
  }, csci_config.PlaneCruisingSpeed)
  
  KI.Toolbox.TryDisableAIDispersion(moosegrp, "MOOSE")
end

function CSCI.SpawnCargoInTime(csci_config, destcp)
  env.info("CSCI.SpawnCargoInTime() called")
  timer.scheduleFunction(function(args, t)
    xpcall(function()
        for _, template in pairs(args.Config.CargoTemplate) do
          local SpawnObj = SPAWN:NewWithAlias(template, KI.GenerateName(template))
          local NewGroup = SpawnObj:SpawnInZone(args.DestinationCP.Zone, true)
          if NewGroup ~= nil then
            env.info("CSCI.SpawnCargoInTime - Successfully spawned group " .. template .. " in zone " .. args.DestinationCP.Name)
            KI.Toolbox.MessageCoalition(KI.Config.AllySide, "Airdrop landed at " .. args.DestinationCP.Name)
            KI.Toolbox.TryDisableAIDispersion(NewGroup, "MOOSE")
          else
            env.info("CSCI.SpawnCargoInTime - ERROR - Failed to spawn group " .. template .. " in zone " .. args.DestinationCP.Name)
          end
        end
    end,
    function(err) env.info("CSCI.SpawnCargoInTime - ERROR - " .. err) end)
    
    args.DestinationCP.CSCICalled = false
    return nil    
  end, { Config = csci_config, DestinationCP = destcp}, timer.getTime() + csci_config.ParachuteTime)
end

function CSCI.SpawnAircraft(template, parentAction, spawncp, destcp, csci_config)
  env.info("CSCI.SpawnAircraft() called")
  local SpawnObj = SPAWN:NewWithAlias(template, KI.GenerateName(template))
                    :OnSpawnGroup(function( spawngrp, parentAction, spawnzone, destzone, config ) 
                        xpcall(function() 
                                  CSCI.OnSpawnGroup(spawngrp, parentAction, spawnzone, destzone, config) 
                               end,
                               function(err) env.info("CSCI.SpawnAircraft:OnSpawnGroup ERROR - " .. err) end)
                    end, parentAction, spawncp.Zone, destcp.Zone, csci_config)
  local NewGroup = SpawnObj:SpawnAtAirbase(AIRBASE:FindByName(spawncp.Airbase), nil, 3000)
  if NewGroup ~= nil then
    env.info("CSCI.SpawnAircraft - Successfully spawned group " .. template .. " in zone " .. spawncp.Name)
  else
    env.info("CSCI.SpawnAircraft - ERROR - Failed to spawn group " .. template .. " in zone " .. spawncp.Name)
  end
  
  return NewGroup
end

--AddCSCIRadioItems
--Adds the necessary CSCI Radio Menu Options for the group
--Accepts parameter MOOSE:GROUP Object
function CSCI.AddCSCIRadioItems(moosegrp)
  env.info("CSCI.AddCSCIRadioItems Group name - " .. moosegrp.GroupName)
  local m_main = MENU_GROUP:New(moosegrp, "CSCI Menu")
  
  -- Airdrop Sub Menu
  local m_airdrop = MENU_GROUP:New(moosegrp, CSCI.AirdropParentMenu, m_main)
  
  -- Inject view airdrops menu item
  MENU_GROUP_COMMAND:New(moosegrp, CSCI.ActionViewAirdropsRemaining, m_airdrop,
                           CSCI.PerformAction,
                           CSCI.ShowAirdropContents, CSCI.ActionViewAirdropsRemaining, CSCI.AirdropParentMenu, moosegrp, nil)
  
  for _, comp in pairs(CSCI.Config.AirdropTypes) do
    env.info("CSCI.AddCSCIRadioItems - looping through component types for " .. comp.MenuName)

    local submenu = MENU_GROUP:New(moosegrp, comp.MenuName, m_airdrop)
    
    local menucount = 0
      
    for __, cp in pairs(KI.Data.CapturePoints) do
      
      -- radio items f1 to f8 can be used (f9, f10, f11, f12 are to be avoided as other functions are reserved here)
      -- so spawn new sub menu when 7 items are populated in current menu
      -- DCS already has 'Previous...' implemented as f11, so this allows navigation back and forth between sub menus
      if menucount == 7 then
        local innersubmenu = MENU_GROUP:New(moosegrp, "Next Page", submenu)
        submenu = innersubmenu
        menucount = 0
      end
      
      MENU_GROUP_COMMAND:New(moosegrp, cp.Name, submenu,
                           CSCI.PerformAction,
                           CSCI.CreateAirdrop, comp.MenuName, CSCI.AirdropParentMenu, moosegrp, comp, cp)
      
      menucount = menucount + 1
    end
  end

  env.info("CSCI.AddCSCIRadioItems Items Added")
end

-- Init CSCI by pilotname
function CSCI.InitCSCIForUnit(unit_name)
  env.info("CSCI.InitCSCIForUnit called")
  local u = Unit.getByName(unit_name)
  if not u then 
	env.info("CSCI.InitCSCIForUnit - unit does not exist - aborting")
	return false 
  end
  
  -- Issue #208 workaround
  local groupname = u:getGroup():getName()
  
  if CSCI.Config.RestrictToCSCIPilot then
    if string.match(unit_name, "CSCIPilot") then
      env.info("CSCI Pilot " .. unit_name .. " found, initializing")
      CSCI.AddCSCIRadioItems(GROUP:Register(groupname))
      return true
    else
      env.info("CSCI.InitCSCIForUnit - Pilot Name does not match 'CSCIPilot' aborting")
      return false
    end 
  else
    env.info("CSCI.InitCSCIForUnit - no restictions - adding to client")
    CSCI.AddCSCIRadioItems(GROUP:Register(groupname))
    return true
  end
end
