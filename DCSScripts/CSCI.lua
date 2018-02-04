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




function CSCI.CanCall(actionname, supportypes)
  env.info("CSCI.CanCall() called")
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

function CSCI.PerformAction(action, actionname, parentmenu, moosegrp, supporttype, capturepoint)
  xpcall(function()
    env.info("CSCI.PerformAction called (actionname: " .. actionname .. ", parentmenu: " .. parentmenu .. ")")
    
    local _groupID = moosegrp:GetDCSObject():getID()
    
    if actionname == CSCI.ActionViewAirdropsRemaining then
      action(moosegrp)
      return
    end
    
    local cancall, msg = CSCI.CanCall(actionname)
      
    if cancall then
    
      env.info("CSCI.PerformAction - can call this support option")
      
      local isvalid = true
      
      if CSCI.Config.PreOnRadioAction then
        env.info("CSCI.PerformAction - found PreOnRadioAction callback - invoking")
        isvalid = CSCI.Config.PreOnRadioAction(actionname, parentmenu, moosegrp, supporttype, capturepoint)
      end
      
      if isvalid then
        env.info("CSCI.PerformAction - Invoking action")
        action(actionname, supporttype, capturepoint)
        
        env.info("CSCI.PerformAction - Updating Remaining Calls")
        -- update the counts
        local supportdata = CSCI.Data[actionname]
        
        if supportdata then
          supportdata.CooldownCallsRemaining = supportdata.CooldownCallsRemaining - 1
          supportdata.CallsRemaining = supportdata.CallsRemaining - 1
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

function CSCI.CreateAirdrop(actionname, supporttype, capturepoint)
  env.info("CSCI.CreateAirdrop() called for " .. actionname)
  local spawncp = KI.Query.FindFriendlyCPAirport()
  
  if spawncp ~= nil then
    
  end
end

function CSCI.OnSpawnGroup(moosegrp, parentAction, spawnzone, destzone)
  local wp = COORDINATE:WaypointAir
end

function CSCI.SpawnVehicle(template, parentAction, spawncp, destcp)
  local SpawnObj = SPAWN:New(template)
                    :OnSpawnGroup(function( spawngrp, parentAction, spawnzone, destzone ) 
                        CSCI.Config.OnSpawnGroup(spawngrp, parentAction, spawnzone, destzone)
                    end, parentAction, spawncp.Zone, destcp.Zone)
  local NewGroup = SpawnObj:SpawnInZone(spawncp.Zone, true)
  if NewGroup ~= nil then
    env.info("AICOM._SpawnGroups - Successfully spawned group " .. _template .. " in zone " .. spawnzone:GetName())
  else
    env.info("AICOM._SpawnGroups - ERROR - Failed to spawn group " .. _template .. " in zone " .. spawnzone:GetName())
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
  local u = UNIT:FindByName(unit_name)
  if not u then 
    env.info("CSCI.InitCSCIForUnit - unit does not exist - aborting")
    return false 
  end
  
  if CSCI.Config.RestrictToCSCIPilot then
    if string.match(unit_name, "CSCIPilot") then
      env.info("CSCI Pilot " .. unit_name .. " found, initializing")
      CSCI.AddCSCIRadioItems(u:GetGroup())
      return true
    else
      env.info("CSCI.InitCSCIForUnit - Pilot Name does not match 'CSCIPilot' aborting")
      return false
    end 
  else
    env.info("CSCI.InitCSCIForUnit - no restictions - adding to client")
    CSCI.AddCSCIRadioItems(u:GetGroup())
    return true
  end
end
