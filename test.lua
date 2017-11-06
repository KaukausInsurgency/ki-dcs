env.info("Creating StaticObject Instance 'TESTCARGO'")
local function PositionAt12Oclock(_unit, _offset)
    local _position = _unit:getPosition()
    local _angle = math.atan2(_position.x.z, _position.x.x)
    local _xOffset = math.cos(_angle) * _offset
    local _yOffset = math.sin(_angle) * _offset

    local _point = _unit:getPoint()
    return { x = _point.x + _xOffset, z = _point.z + _yOffset, y = _point.y }
end

local pos = PositionAt12Oclock(Unit.getByName("SLCPilot1"), 30)
local test_cargo_obj = coalition.addStaticObject(country.id.RUSSIA, {
		country = "Russia",
		category = "Cargos",
		x = pos.x,
		y = pos.z,
		type = "ammo_cargo",
		name = "TESTCARGO",
		mass = 1000,
		canCargo = true
	})
env.info("TESTCARGO - Is ALIVE? (StaticObject.getByName():isExist()) : " .. tostring(StaticObject.getByName("TESTCARGO"):isExist()))
env.info("TESTCARGO - Is ALIVE? (test_cargo_obj:isExist()) : " .. tostring(test_cargo_obj:isExist()))
env.info("Destroying Crate TESTCARGO (using obj:destroy())")
test_cargo_obj:destroy()
env.info("TESTCARGO - Is ALIVE? (test_cargo_obj:isExist()) : " .. tostring(test_cargo_obj:isExist()))
env.info("TESTCARGO - Is ALIVE? (StaticObject.getByName():isExist()) : " .. tostring(StaticObject.getByName("TESTCARGO"):isExist()))
--env.info("Destroying Crate TESTCARGO (StaticObject.getByName():destroy()")
--StaticObject.getByName("TESTCARGO"):destroy()
--env.info("TESTCARGO - Is ALIVE? (test_cargo_obj:isExist()) : " .. tostring(test_cargo_obj:isExist()))
--env.info("TESTCARGO - Is ALIVE? (StaticObject.getByName():isExist()) : " .. tostring(StaticObject.getByName("TESTCARGO"):isExist()))

env.info("Unit.getType NIL? : " .. tostring(Unit.getByName("SLCPilot1").getType == nil))
env.info("TestKIScoreEnemyAir1 TYPE : " .. Unit.getByName("TestKIScoreEnemyAir1"):getTypeName())