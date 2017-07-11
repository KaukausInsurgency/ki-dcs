Spatial = {}

function Spatial.Distance(p1, p2)
  env.info("Spatial.Distance Called")
  return math.sqrt( (math.abs(p2.x - p1.x) ^ 2) + ( (math.abs(p2.y - p1.y) ^ 2)) )
end

function Spatial.RelativePositionFromHeading(p, heading, distance)
  env.info("Spatial.RelativePositionFromHeading Called")
  env.info("Spatial.RelativePositionFromHeading - Original Position (" .. tostring(p.x) .. ", " .. tostring(p.y) .. ", " .. tostring(p.z) .. ")")

  local nx = p.x + (distance * math.cos(- heading + 90))
  local ny = p.y + (distance * math.sin(- heading + 90))
  env.info("Spatial.RelativePositionFromHeading - New Position (" .. tostring(nx) .. ", " .. tostring(ny) .. ", " .. tostring(p.z) .. ")")
  return {x = nx, y = ny, z = p.z}
end

function Spatial.PositionAt12Oclock(g, _offset)
  env.info("Spatial.PositionAt12Oclock called")
    local _unit = g:GetDCSUnit(1)
    local _position = _unit:getPosition()
    local _angle = math.atan2(_position.x.z, _position.x.x)
    local _xOffset = math.cos(_angle) * _offset
    local _yOffset = math.sin(_angle) * _offset

    local _point = _unit:getPoint()
    return { x = _point.x + _xOffset, z = _point.z + _yOffset, y = _point.y }
end

function Spatial.RelativeHeading(p1, p2)
  env.info("Spatial.RelativeHeading Called")
  return math.atan2(math.abs(p2.y - p1.y), math.abs(p2.x - p1.x))
end

function Spatial.GetHeading(dcsobj)
	local unitpos = dcsobj:getPosition()
	if objpos then
		local Heading = math.atan2(objpos.x.z, objpos.x.x)
		if Heading < 0 then
			Heading = Heading + 2*math.pi  -- put heading in range of 0 to 2*pi
		end
		return Heading
	end
end