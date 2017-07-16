--KI.Scheduled.UpdateCPStatus(nil, 10)
--KI.Loader.SaveData()

local _t =
{ 
  {
    CapturePoint = 
          { 
            Defenses = {},     
            Name = "A",            
            Zone = nil,         
            BlueUnits = 5,
            RedUnits = 0,
            Owner = "Blue"
          },
    Action = 1,
    Cost = 10
  },
  {
    CapturePoint = 
          { 
            Defenses = {},     
            Name = "B",            
            Zone = nil,         
            BlueUnits = 0,
            RedUnits = 15,
            Owner = "Red"
          },
    Action = 2,
    Cost = 14
  },
  {
    CapturePoint = 
          { 
            Defenses = {},     
            Name = "C",            
            Zone = nil,         
            BlueUnits = 0,
            RedUnits = 0,
            Owner = "Neutral"
          },
    Action = 1,
    Cost = 1
  },
  {
    CapturePoint = 
          { 
            Defenses = {},     
            Name = "D",            
            Zone = nil,         
            BlueUnits = 0,
            RedUnits = 0,
            Owner = "Neutral"
          },
    Action = 1,
    Cost = 1
  },
  {
    CapturePoint = 
          { 
            Defenses = {},     
            Name = "E",            
            Zone = nil,         
            BlueUnits = 0,
            RedUnits = 0,
            Owner = "Neutral"
          },
    Action = 1,
    Cost = 1
  },
  {
    CapturePoint = 
          { 
            Defenses = {},     
            Name = "F",            
            Zone = nil,         
            BlueUnits = 5,
            RedUnits = 5,
            Owner = "Contested"
          },
    Action = 2,
    Cost = 10
  },
  {
    CapturePoint = 
          { 
            Defenses = {},     
            Name = "G",            
            Zone = nil,         
            BlueUnits = 2,
            RedUnits = 10,
            Owner = "Contested"
          },
    Action = 2,
    Cost = 10
  },
  {
    CapturePoint = 
          { 
            Defenses = {},     
            Name = "H",            
            Zone = nil,         
            BlueUnits = 0,
            RedUnits = 10,
            Owner = "Red"
          },
    Action = 2,
    Cost = 12
  },
  {
    CapturePoint = 
          { 
            Defenses = {},     
            Name = "I",            
            Zone = nil,         
            BlueUnits = 0,
            RedUnits = 5,
            Owner = "Red"
          },
    Action = 2,
    Cost = 9
  },
  {
    CapturePoint = 
          { 
            Defenses = {},     
            Name = "J",            
            Zone = nil,         
            BlueUnits = 15,
            RedUnits = 0,
            Owner = "Blue"
          },
    Action = 1,
    Cost = 20
  }
}

local keys = {}
for k in pairs(_t) do table.insert(keys, k) end
table.sort(keys, function(a, b) return _t[a].Cost < _t[b].Cost end)
for _, k in ipairs(keys) do print(k, _t[k].CapturePoint.Name, _t[k].Action, _t[k].Cost) end
print("Top Key")
print(_t[keys[1]].CapturePoint.Name, _t[keys[1]].Action, _t[keys[1]].Cost)


--[[
function getHeading(unit, rawHeading)
	local unitpos = unit:getPosition()
	if unitpos then
		local Heading = math.atan2(unitpos.x.z, unitpos.x.x)
		if not rawHeading then
			--Heading = Heading + mist.getNorthCorrection(unitpos.p)
		end
		if Heading < 0 then
			Heading = Heading + 2*math.pi  -- put heading in range of 0 to 2*pi
		end
		return Heading
	end
end

env.info(KI.Toolbox.SerializeTable(env.mission.coalition))

local statObjs = coalition.getStaticObjects(2)
for i = 1, #statObjs do
  env.info("STATIC OBJECT Name: " .. statObjs[i]:getName())
  --env.info("STATIC OBJECT Heading: " .. tostring(getHeading(statObjs[i], true)))
  --env.info("STATIC OBJECT Position: " .. KI.Toolbox.Dump(statObjs[i]:getPosition()))
  --env.info("STATIC OBJECT Weight: " .. tostring(statObjs[i]:getCargoWeight()))
  env.info("STATIC OBJECT Category: " .. tostring(statObjs[i]:getCategory()))
  env.info("STATIC OBJECT Desc: " .. KI.Toolbox.Dump(statObjs[i]:getDesc()))
end
--]]--
