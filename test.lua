--KI.Scheduled.UpdateCPStatus(nil, 10)
KI.Loader.SaveData()


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
