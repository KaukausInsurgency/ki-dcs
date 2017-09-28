--CiriBob's get groupID function
function getGroupId(_unit)
	local _unitDB =  mist.DBs.unitsById[tonumber(_unit:getID())]
    if _unitDB ~= nil and _unitDB.groupId then
        return _unitDB.groupId
    end

    return nil
end

--CiriBob's get groupName function
function getGroupName(_unit)
    local _unitDB =  mist.DBs.unitsById[tonumber(_unit:getID())]
    if _unitDB ~= nil and _unitDB.groupId then
        return _unitDB.groupName
    end

    return nil
end

-- not working for clients!!!
function getGroupFromUnit(_unit)
	local _groupName = getGroupName(_unit)
	koEngine.debugText("groupname = ".._groupName)
	return Group.getByName(_groupName)
end

-- ciribobs group-check functions
local function isGroupThere(_groupName)
	return Group.getByName(_groupName)
			and Group.getByName(_groupName):isExist()
			and #Group.getByName(_groupName):getUnits() >= 1
			and Group.getByName(_groupName):getUnits()[1]:isActive()
end

local function isAllOfGroupThere(_groupName)
	if not isGroupThere(_groupName) then
		return false
	end

	local _group = Group.getByName(_groupName)

	--check current group size is equal to actual group size
	if _group:getInitialSize() == _group:getSize() then
		return true
	else
		return false
	end
end


-- gets a spawngroup from the savegame and checks if it has losses
-- returns false if there is a loss
local function isAllOfSpawngroupThere(spawnGroup)
	if not isGroupThere(spawnGroup.name) then
		return false
	end

	-- get all alive units from the spawned group 
	local units = Group.getUnits(Group.getByName(spawnGroup.name))
	
	if not units then return false end
	
	-- run through all units in the spawntable
	for i, spawnUnit in pairs(spawnGroup.units) do
		local unitFound = false
		
		-- run through all alive-units to see if theres one unit missing
		for k, unit in pairs(units) do
			local unitName = unit:getName()
			if spawnUnit.name == unitName then
				unitFound = true
				break
			end
		end
		
		if not unitFound then
			return false
		end
	end

	return true
end