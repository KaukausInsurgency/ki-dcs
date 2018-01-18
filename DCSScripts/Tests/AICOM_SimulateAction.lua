-- This code is used to test AICOM.Config.Forces in a quick and easy way
-- Configure your forces as desired, then run this utility from the test mission
-- This will simulate x number of calls to PerformAction, and calculate how often a unit type was picked by the AI


local test_results_path = [[C:\Users\david\Saved Games\DCS\Missions\Kaukasus Insurgency\Tests\AICOM_Simulation_Results.txt]]
local aicom_iterations = 5000
local path = "C:\\Users\\david\\Documents\\GitHub\\KI\\DCSScripts\\"

assert(loadfile(path .. "KI_Toolbox.lua"))()
assert(loadfile(path .. "AICOM_Config_Debug.lua"))()
assert(loadfile(path .. "AICOM.lua"))()

AICOM.Init()


local function SimulateAction(action)
  env.info("SimulateAction called")
  local _willingToPay = AICOM.AnalyzePay(action)
  local _buyAAUnits = AICOM.TryBuyAA(_willingToPay.AA)
  local _buyGNDUnits = AICOM.TryBuyGND(_willingToPay.GND)
  return _buyAAUnits, _buyGNDUnits
end

local function WriteFileTestResults(data, path)
  env.info("WriteFileTestResults called for path: " .. path)
  local _filehandle, _err = io.open(path, "w")
  if _filehandle then
    _filehandle:write(data)
    _filehandle:flush()
    _filehandle:close()
    _filehandle = nil
    return true
  else
    env.info("WriteFileTestResults ERROR: " .. _err)
    return false
  end
end

local function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

local function sortCoverage (a, b )
  local at = (a.ReinforceCount + a.AttackCount + a.AmbushCount) / (aicom_iterations * 3)
  local bt = (b.ReinforceCount + b.AttackCount + b.AmbushCount) / (aicom_iterations * 3)
  return at < bt
end




local forcehash = {}
for i = 1, #AICOM.Config.Forces do
    local f = AICOM.Config.Forces[i]
    forcehash[f.Name] = 
    { 
      AttackCount = 0, 
      ReinforceCount = 0, 
      AmbushCount = 0,
      AACount = 0, 
      GNDCount = 0, 
      Cost = f.Cost, 
      AAStrength = f.AAEffectiveness,
      GNDStrength = f.GNDEffectiveness
    }
end

for j = 1, aicom_iterations do
  local AAUnits, GNDUnits = SimulateAction(AICOM.Enum.Actions.Attack)
  
  for k = 1, #AAUnits do
    local aa = AAUnits[k]
    local ff = forcehash[aa.Name]
    ff.AttackCount = ff.AttackCount + 1
    ff.AACount = ff.AACount + 1
  end
  
  for k = 1, #GNDUnits do
    local gnd = GNDUnits[k]
    local ff = forcehash[gnd.Name]
    ff.AttackCount = ff.AttackCount + 1
    ff.GNDCount = ff.GNDCount + 1
  end
end

for j = 1, aicom_iterations do
  local AAUnits, GNDUnits = SimulateAction(AICOM.Enum.Actions.Reinforce)
  
  for k = 1, #AAUnits do
    local aa = AAUnits[k]
    local ff = forcehash[aa.Name]
    ff.ReinforceCount = ff.ReinforceCount + 1
    ff.AACount = ff.AACount + 1
  end
  
  for k = 1, #GNDUnits do
    local gnd = GNDUnits[k]
    local ff = forcehash[gnd.Name]
    ff.ReinforceCount = ff.ReinforceCount + 1
    ff.GNDCount = ff.GNDCount + 1
  end
end

for j = 1, aicom_iterations do
  local AAUnits, GNDUnits = SimulateAction(AICOM.Enum.Actions.Ambush)
  
  for k = 1, #AAUnits do
    local aa = AAUnits[k]
    local ff = forcehash[aa.Name]
    ff.AmbushCount = ff.AmbushCount + 1
    ff.AACount = ff.AACount + 1
  end
  
  for k = 1, #GNDUnits do
    local gnd = GNDUnits[k]
    local ff = forcehash[gnd.Name]
    ff.AmbushCount = ff.AmbushCount + 1
    ff.GNDCount = ff.GNDCount + 1
  end
end


local keys = {}
for key, stats in pairs(forcehash) do
  stats.key = key
  table.insert(keys, stats)
end
table.sort(keys, sortCoverage)

env.info("AICOM Prepping Results")
local results = "AICOM Results (Iterations: " .. tostring(aicom_iterations) .. ") \n"
for n, stats in ipairs(keys) do
  local t = round((stats.ReinforceCount + stats.AttackCount + stats.AmbushCount) / (aicom_iterations * 3), 4) * 100
  local r = round(stats.ReinforceCount / aicom_iterations, 4) * 100
  local a = round(stats.AttackCount / aicom_iterations, 4) * 100
  local amb = round(stats.AmbushCount / aicom_iterations, 4) * 100
  local aa = round(stats.AACount / aicom_iterations, 4) * 100
  local gnd = round(stats.GNDCount / aicom_iterations, 4) * 100
  results = results .. stats.key .. " [COST: " .. tostring(stats.Cost) .. ", AAStr: " .. tostring(stats.AAStrength) 
            .. ", GNDStr: " .. tostring(stats.GNDStrength) .. "]\nTOTAL = " .. tostring(t) .. "% - REINFORCE = " .. tostring(r)
            .. "% - ATTACK = " .. tostring(a) .. "% - AMBUSH = " .. tostring(amb) .. "% - AA = " .. tostring(aa)
            .. "% - GND = " .. tostring(gnd) .. "% \n"
            
  results = results .. "TOTAL = " .. tostring((stats.ReinforceCount + stats.AttackCount)) .. " - REINFORCE = " 
            .. tostring(stats.ReinforceCount) .. " - ATTACK = " .. tostring(stats.AttackCount) 
            .. " - AMBUSH = " .. tostring(stats.AmbushCount)
            .. " - AA = " .. tostring(stats.AACount)
            .. " - GND = " .. tostring(stats.GNDCount) .. " \n\n"
end

WriteFileTestResults(results, test_results_path)