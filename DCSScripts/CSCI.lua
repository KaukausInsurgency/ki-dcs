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

-- internal functions

function CSCI.CheckPreCondition(actionname, parentmenu, moosegrp, csci_config, capturepoint)
  env.info("CSCI.CheckPreCondition called")  
  local _isvalid = true
      
  if CSCI.Config.PreOnRadioAction then
    env.info("CSCI.CheckPreCondition - found PreOnRadioAction callback - invoking")
    _isvalid = CSCI.Config.PreOnRadioAction(actionname, parentmenu, moosegrp, csci_config, capturepoint)
  end
  
  return _isvalid
end

function CSCI.TryGetActionData(actionname)
  env.info("CSCI.TryGetActionData called")
  local _data = CSCI.Data[actionname]
  
  if _data == nil then
    env.info("CSCI.TryGetActionData - action '" .. actionname .. "' not found!")
  end
        
  return _data ~= nil, _data
end

function CSCI.ModifyState(actionData, capturePoint, csciConfig)
  env.info("CSCI.ModifyState called")
  -- update the state of capture point and actionData
  capturePoint.CSCICalled = true
  
  env.info("CSCI.PerformAction - Updating Remaining Calls")
  actionData.CooldownCallsRemaining = actionData.CooldownCallsRemaining - 1
  actionData.CallsRemaining = actionData.CallsRemaining - 1
  
  if actionData.CooldownCallsRemaining ~= csciConfig.MaxCallsPerCooldown then  
    env.info("CSCI.PerformAction - Cooldown activated")       
    CSCI.CreateCooldownTimer(actionData, csciConfig)
  end
end

function CSCI.IsValidCSCIUnit(unitName)
  env.info("CSCI.IsValidCSCIUnit called")
  local _dcsUnit = Unit.getByName(unitName)
  
  if not _dcsUnit then 
    env.info("CSCI.IsValidCSCIUnit - unit does not exist")
    return false 
  end
  
  if CSCI.Config.RestrictToCSCIPilot then
    if string.match(unitName, "CSCIPilot") then
      env.info("CSCI.IsValidCSCIUnit - CSCI Pilot '" .. unitName .. "' found")
      return true
    else
      env.info("CSCI.IsValidCSCIUnit - Pilot Name '" .. unitName .. "' does not match 'CSCIPilot' aborting")
      return false
    end 
  else
    env.info("CSCI.IsValidCSCIUnit - no restictions")
    return true
  end
end

-- returns 2 values, bool whether action can be called, string message if it cannot
function CSCI.CanCall(actionData, capturepoint)
  env.info("CSCI.CanCall() called")
  
  if actionData == nil then 
    return false, "Cannot call support! Invalid support type!"
  end
  
  if capturepoint.CSCICalled then
    env.info("CSCI.CanCall - This capture point already has combat support requested, cannot call support again")
    return false, "Cannot call support! There is already active combat support on route to this capture point!"
  end
  
  if actionData.CooldownCallsRemaining > 0 and actionData.CallsRemaining > 0 then
    env.info("CSCI.CanCall - Can call this support type")
    return true
  elseif actionData.CooldownCallsRemaining <= 0 then
    env.info("CSCI.CanCall - No calls remaining for cooldown period - waiting for cooldown to expire")
    return false, "Cannot call support! On cooldown (" .. tostring(actionData.Cooldown) .. " seconds remaining)"
  elseif actionData.CallsRemaining <= 0 then
    env.info("CSCI.CanCall - This support type can no longer be called in this session")
    return false, "Cannot call support! No more requests can be made for this session! Wait until server restart!"
  end
end

function CSCI.CreateCooldownTimer(actionData, csciConfig)
  env.info("CSCI.CreateCooldownTimer() called")
  
  -- reset Cooldown value
  actionData.Cooldown = csciConfig.Cooldown
  
  -- start timer function every 1 second to decrement counter
  timer.scheduleFunction(function(args, t) 
    local ok, result = xpcall(function()
      local _actionData = args.actionData
      _actionData.Cooldown = _actionData.Cooldown - 1
      if (_actionData.Cooldown == 0) then
        env.info("CSCI.CooldownTimer - cooldown for " .. csciConfig.MenuName .. " has ended")
        args.supportdata.CooldownCallsRemaining = args.csciConfig.MaxCallsPerCooldown
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
  end, { actionData = actionData, csciConfig = csciConfig}, timer.getTime() + 1)
end

function CSCI.PerformAction(action, actionName, parentmenu, moosegrp, csciConfig, capturepoint)
  xpcall(function()
    env.info("CSCI.PerformAction called (actionname: " .. actionName .. ", parentmenu: " .. parentmenu .. ")")
    
    if actionName == CSCI.ActionViewAirdropsRemaining then
      action(moosegrp)
      return
    end
    
    local _notNil, _actionData = CSCI.TryGetActionData(actionName)
    local _cancall, _msg = CSCI.CanCall(_actionData, capturepoint)
      
    if _cancall and _notNil then
      env.info("CSCI.PerformAction - can call this support option")    
      if CSCI.CheckPreCondition(actionName, parentmenu, moosegrp, csciConfig, capturepoint) then
        env.info("CSCI.PerformAction - Invoking action")
        action(actionName, parentmenu, csciConfig, capturepoint)           
        CSCI.ModifyState(_actionData, capturepoint, csciConfig)
      else
        env.info("CSCI.PerformAction - PreCondition returned false - action was not executed")
      end      
    else
      local _groupID = moosegrp:GetDCSObject():getID()
      env.info("CSCI.PerformAction - cannot call this support option")
      trigger.action.outTextForGroup(_groupID, _msg, 10, false)
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
            KI.GameUtils.MessageCoalition(KI.Config.AllySide, "Airdrop heading to " .. args.DestinationCP.Name .. " has been shot down!")
            args.DestinationCP.CSCICalled = false
            return nil 
          end
          
          local distance = Spatial.Distance(args.Group:GetVec3(), args.DestinationCP.Zone:GetVec3())
          --env.info("CSCI.CreateAirdropManager - distance: " .. tostring(distance))
          if distance < args.Config.AirdropDistance then
            env.info("CSCI.CreateAirdropManager() - airdrop within zone distance")
            KI.GameUtils.MessageCoalition(KI.Config.AllySide, "Aircraft has started airdrop!")
            CSCI.SpawnCargoInTime(csci_config, destcp)     
            return nil    
          end
          
          return t + 5             
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
  
  KI.GameUtils.TryDisableAIDispersion(moosegrp)
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
            KI.GameUtils.MessageCoalition(KI.Config.AllySide, "Airdrop landed at " .. args.DestinationCP.Name)
            KI.GameUtils.TryDisableAIDispersion(NewGroup)
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
function CSCI.InitCSCIForUnit(unitName)
  env.info("CSCI.InitCSCIForUnit called")
  
  if not CSCI.IsValidCSCIUnit(unitName) then 
    env.info("CSCI.InitCSCIForUnit - unit is invalid - aborting")
    return false 
  end
  
  local _dcsUnit = Unit.getByName(unitName) 
  local _mooseGroup = KI.GameUtils.SyncWithMoose(_dcsUnit)  -- Issue #208 workaround
  CSCI.AddCSCIRadioItems(_mooseGroup)
  
  return true
end
