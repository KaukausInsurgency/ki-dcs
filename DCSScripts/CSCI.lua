-- Combat Support Call In module otherwise known as CSCI
-- Exposes functions for creating and managing combat support requests

if not CSCI then
  CSCI = {}
end

if not CSCI.Config then
  CSCI.Config = {}
end

CSCI.Config.AirdropTypesOrder =
{
  "Infantry Paradrop",
  "Vehicle Airdrop",
  "Supply Airdrop",
  "FARP Support Airdrop"
}

CSCI.Config.AirdropTypes =
{
  ["Infantry Paradrop"] = {
    MenuName = "Infantry Paradrop",
    SpawnTemplate = "C130",
    SpawnIn = "Ramp Hot",
    Cooldown = 1800,
    MaxCallsPerCooldown = 3,
    MaxCallsPerSession = 15,
    PlaneCruisingSpeed = 600,
    PlaneCruisingAltitude = 2000,
    AirdropDistance = 10000,
    ParachuteTime = 120,
    CargoTemplate = {"Airborne1", "Airborne2"} 
  }


}


if not CSCI.Data then
  CSCI.Data = {}
end

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
    return false, "Cannot call suppoort! Invalid support type!"
  end
end

function CSCI.PerformAction(action, actionname, parentmenu, moosegrp, supporttype, capturepoint)
  env.info("CSCI.PerformAction called (actionname: " .. actionname .. ", parentmenu: " .. parentmenu .. ")")
  
  local _groupID = moosegrp:GetDCSObject():getID()
  local cancall, msg = CSCI.CanCall(actionname)
    
  if cancall then
  
    env.info("CSCI.PerformAction - can call this support option")
    
    if parentmenu == CSCI.AirdropParentMenu then
      CSCI.CreateAirdrop(actionname, supporttype, capturepoint)
      
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
    
end

function CSCI.ShowAirdropContents(moosegrp)
  env.info("CSCI.ShowAirdropContents() called")
  
  local msg = "Available Airdrops\n"
  msg = msg .. string.format("%-25s|%-15s|%-15s", "Name", "Remaining", "Cooldown") .. "\n"

  for key, data in pairs(CSCI.Data) do
    msg = msg .. string.format("%-25s|%-15d|%-15d", key, data.CallsRemaining, data.Cooldown) .. "\n"
  end
  
  local _groupID = moosegrp:GetDCSObject():getID()
  trigger.action.outTextForGroup(_groupID, msg, 20, false)
end

function CSCI.CreateAirdrop(actionname, supporttype, capturepoint)
  env.info("CSCI.CreateAirdrop() called for " .. actionname)
end

--AddCSCIRadioItems
--Adds the necessary CSCI Radio Menu Options for the group
--Accepts parameter MOOSE:GROUP Object
function CSCI.AddCSCIRadioItems(moosegrp, pilotname)
  env.info("CSCI.AddCSCIRadioItems Group name - " .. g.GroupName)
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
                           
    for __, cp in pairs(KI.Data.CapturePoints) do
      MENU_GROUP_COMMAND:New(moosegrp, cp.Name, submenu,
                           CSCI.PerformAction,
                           CSCI.CreateAirdrop, comp.MenuName, CSCI.AirdropParentMenu, moosegrp, comp, cp)
    end
  end

  env.info("CSCI.AddCSCIRadioItems Items Added")
end
