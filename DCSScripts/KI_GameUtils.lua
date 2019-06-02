if not KI then
  KI = {}
end

KI.GameUtils = {}

-- private scoped variables
local __DCSUnit = "Unit"
local __DCSGroup = "Group"
local __MOOSEGroup = "GROUP"
local __AIOptionDisperseOnAttack = AI.Option.Ground.id.DISPERSE_ON_ATTACK
local __envInfo = env.info
local __outTextForCoalition = trigger.action.outTextForCoalition

-- Will try to disable AI Dispersion under fire if the config setting is turned on
-- This is to help get around transport.dll crashes that appear to be linked to this setting
-- If this is ever patched by ED this setting can be turned off
function KI.GameUtils.TryDisableAIDispersion(group)
  __envInfo("KI.GameUtils.TryDisableAIDispersion called")
  
  if KI.Config.TransportDLLCrashDisableAIDispersionUnderFire then
    __envInfo("KI.GameUtils.TryDisableAIDispersion - disabling dispersion")
    local _controller = nil
    if group.ClassName == __MOOSEGroup then
      _controller = group:GetDCSObject():getController()
    elseif group.className_ == __DCSGroup then
      _controller = group:getController()
    else
      local _group = Group.getByName(group)
      _controller = _group:getController()
    end
    
    Controller.setOption(_controller, __AIOptionDisperseOnAttack, false)
  end
end

-- Messages entire coalition
function KI.GameUtils.MessageCoalition(side, msg, t)
  __envInfo("KI.GameUtils.MessageCoalition called")
  local msgtime = t or 30
  __outTextForCoalition(side, msg, msgtime)
end

function KI.GameUtils.SyncWithMoose(dcsEntity)
  __envInfo("KI.GameUtils.SyncWithMoose called")
  
  -- need to properly register this group and units with MOOSE in order for GROUP to work
  -- this is caused by another DCS timing issue, where-by event-birth is called a few frames after some code has executed
  -- MOOSE actually auto handles this by registering any units created via event-birth 
  -- in this case here the event birth has not fired when the group was spawned above
  -- therefore MOOSE does not know about it and it has not been registered
  -- this work around addresses this issue
  local _dcsGroup
  
  if dcsEntity.className_ == __DCSUnit then
    _dcsGroup = dcsEntity:getGroup()
  elseif dcsEntity.className_ == __DCSGroup then   
    _dcsGroup = dcsEntity
  else
    __envInfo("KI.GameUtils.SyncWithMoose - invalid argument")
    return nil
  end 
  
  local _mooseGroup = GROUP:Find(_dcsGroup)
  if _mooseGroup == nil then
    local _groupName = _dcsGroup:getName()
    __envInfo("KI.GameUtils.SyncWithMoose - group '" .. _groupName .. "' not found in MOOSE Database - syncing")
    _DATABASE:AddGroup(_groupName)
    for _, _unit in pairs(_dcsGroup:getUnits()) do
      _DATABASE:AddUnit(_unit:getName())                
    end             
    _mooseGroup = GROUP:Find(_dcsGroup)
  end
  
  return _mooseGroup
end

