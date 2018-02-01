if not KI then
  KI = {}
end

KI.Toolbox = {}

-- TablesEqual
-- Taken from stack overflow example
function KI.Toolbox.TablesEqual(t1,t2,ignore_mt)
   local ty1 = type(t1)
   local ty2 = type(t2)
   if ty1 ~= ty2 then return false end
   -- non-table types can be directly compared
   if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
   -- as well as tables which have the metamethod __eq
   local mt = getmetatable(t1)
   if not ignore_mt and mt and mt.__eq then return t1 == t2 end
   for k1,v1 in pairs(t1) do
      local v2 = t2[k1]
      if v2 == nil or not KI.Toolbox.TablesEqual(v1,v2) then return false end
   end
   for k2,v2 in pairs(t2) do
      local v1 = t1[k2]
      if v1 == nil or not KI.Toolbox.TablesEqual(v1,v2) then return false end
   end
   return true
end

-- Deep Copy a table
-- Taken from stack overflow example
function KI.Toolbox.DeepCopy(object)
	local lookup_table = {}
	local function _copy(object)
		if type(object) ~= "table" then
			return object
		elseif lookup_table[object] then
			return lookup_table[object]
		end
		local new_table = {}
		lookup_table[object] = new_table
		for index, value in pairs(object) do
			new_table[_copy(index)] = _copy(value)
		end
		return setmetatable(new_table, getmetatable(object))
	end
	return _copy(object)
end

--dump table contents to string (debugging purposes)
function KI.Toolbox.Dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k,v in pairs(o) do  
      if k == "__index" then 
        s = s .. '"' .. k .. '" = "table"'
      else
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. KI.Toolbox.Dump(v) .. ','
      end
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

------------------------------------------------
--[[ string koEngine.TableSerialization(table)
--
-- makes string from table
-- taken from XComs blueflag
-- taken from Kaukasus Offensive
------------------------------------------------]]
--function to turn a table into a string (works to transmutate strings, numbers and sub-tables)
function KI.Toolbox.SerializeTable(t, i)													
	if not i then
		i = 0
	end
	if not t then 
		return "nil"
	end
	if type(t) == "string" then
		return "!String! t =" .. t
	end
	
	local text = "{\n"
	local tab = ""
	for n = 1, i + 1 do																	--controls the indent for the current text line
		tab = tab .. "\t"
	end
	for k,v in pairs(t) do
		if type(k) == "string" and type(v) ~= "function" then
			text = text .. tab .. "[\"" .. k .. "\"]" .. " = "
			if type(v) == "string" then
				text = text .. "\"" .. v .. "\",\n"
			elseif type(v) == "number" then
				text = text .. v .. ",\n"
      elseif k == "__index" then
        text = text .. "\"table\",\n"
			elseif type(v) == "table" then
				text = text .. KI.Toolbox.SerializeTable(v, i + 1)
			elseif type(v) == "boolean" then
				text = text .. tostring(v) .. ",\n"
			end
		elseif type(k) == "number" and type(v) ~= "function" then
			text = text .. tab .. "[" .. k .. "] = "
			if type(v) == "string" then
				text = text .. "\"" .. v .. "\",\n"
			elseif type(v) == "number" then
				text = text .. v .. ",\n"
			elseif type(v) == "table" then
				text = text .. KI.Toolbox.SerializeTable(v, i + 1)
			elseif type(v) == "boolean" then
				text = text .. tostring(v) .. ",\n"
			end	
		end
	end
	tab = ""
	for n = 1, i do											--indent for closing bracket is one less then previous text line
		tab = tab .. "\t"
	end
	if i == 0 then
		text = text .. tab .. "}\n"				--the last bracket should not be followed by an comma
	else
		text = text .. tab .. "},\n"			--all brackets with indent higher than 0 are followed by a comma
	end
	return text
end

function KI.Toolbox.WriteFile(data, path)
  env.info("KI.Toolbox.SafeWriteFile called for path: " .. path)
	local _exportData = "local t = " .. KI.Toolbox.SerializeTable(data) .. "return t"				
	env.info("KI.Toolbox.SafeWriteFile - Data serialized")
	local _filehandle, _err = io.open(path, "w")
  if _filehandle then
    _filehandle:write(_exportData)
    _filehandle:flush()
    _filehandle:close()
    _filehandle = nil
    return true
  else
    env.info("KI.Toolbox.SafeWriteFile ERROR: " .. _err)
    return false
  end
end


-- rounds a number to the nearest decimal places
function KI.Toolbox.Round(val, decimal)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end


-- Converts hours into equivalent time in seconds
function KI.Toolbox.HoursToSeconds(h)
  if not h then return nil end
  return h * 3600
end

-- Converts seconds into equivalent time in hours
function KI.Toolbox.SecondsToHours(s)
  if not s then return nil end
  return s / 3600
end

-- Converts minutes into equivalent time in seconds
function KI.Toolbox.MinutesToSeconds(m)
  if not m then return nil end
  return m * 60
end

-- Converts seconds into equivalent time in minutes
function KI.Toolbox.SecondsToMinutes(s)
  if not s then return nil end
  return s / 60
end

-- Messages entire coalition
function KI.Toolbox.MessageCoalition(side, msg, t)
  local msgtime = t or 30
  trigger.action.outTextForCoalition(side, msg, msgtime)
end

