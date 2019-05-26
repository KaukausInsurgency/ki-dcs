env.info("Starting Test")

env.info("DCSStructure typename: " .. Unit.getByName("DCSStructure"):getTypeName())


if 1 == 2 then

local AGGRESSORS = country:get("AGGRESSORS")

if AGGRESSORS == nil then
  env.info("AGGR is NIL")
else
  env.info("AGGR IS NOT NIL")
  --merge_all_units_to_AGGRESSORS()
end

CATEGORIES = {}

local function BuildCategoriesDB()
  for _,v in pairs(AGGRESSORS.Units.Cars.Car) do
    CATEGORIES[v.Name] = Unit.Category.GROUND_UNIT
  end
  for _,v in pairs(AGGRESSORS.Units.Planes.Plane) do
    CATEGORIES[v.Name] = Unit.Category.AIRPLANE
  end
  for _,v in pairs(AGGRESSORS.Units.Helicopters.Helicopter) do
    CATEGORIES[v.Name] = Unit.Category.HELICOPTER
  end
  for _,v in pairs(AGGRESSORS.Units.Ships.Ship) do
    CATEGORIES[v.Name] = Unit.Category.SHIP
  end
  for _,v in pairs(AGGRESSORS.Units.Fortifications.Fortification) do
    CATEGORIES[v.Name] = Unit.Category.STRUCTURE
  end
end

BuildCategoriesDB()

local function GetCategory(unit)
  return CATEGORIES[unit:getTypeName()]
end

env.info("DCSPlane Cat: " .. GetCategory(Unit.getByName("DCSPlane")))
env.info("DCSGroundUnit Cat: " .. GetCategory(Unit.getByName("DCSGroundUnit")))
env.info("DCSHelo Cat: " .. GetCategory(Unit.getByName("DCSHelo")))
env.info("DCSStructure Cat: " .. GetCategory(Unit.getByName("DCSStructure")))






local dumpGfile = io.open('C:\\Users\\david\\Documents\\GitHub\\dcs_Countries.lua', 'w')
function table.show(t, name, indent)
   local testcounter = 1
   local cart     
   local autoref 
   local function isemptytable(t) return next(t) == nil end
   local function basicSerialize (o)
      local so = tostring(o)
      if type(o) == "function" then
         local info = debug.getinfo(o, "S")
         if info.what == "C" then
            return string.format("%q", so .. ", C function")
         else 
            return string.format("%q", so .. ", defined in (" ..
                info.linedefined .. "-" .. info.lastlinedefined ..
                ")" .. info.source)
         end
      elseif type(o) == "number" then
         return so
      else
         return string.format("%q", so)
      end
   end
   local function addtocart (value, name, indent, saved, field)
      indent = indent or ""
      saved = saved or {}
      field = field or name
      cart = cart .. indent .. field
      if type(value) ~= "table" then
         cart = cart .. " = " .. basicSerialize(value) .. ";\n"
      else
         if saved[value] then
            cart = cart .. " = {}; -- " .. saved[value] 
                        .. " (self reference)\n"
            autoref = autoref ..  name .. " = " .. saved[value] .. ";\n"
         else
            saved[value] = name
            if isemptytable(value) then
               cart = cart .. " = {};\n"
            else
               cart = cart .. " = {\n"
               for k, v in pairs(value) do
          --print(testcounter)
                  k = basicSerialize(k)
                  local fname = string.format("%s[%s]", name, k)
                  field = string.format("[%s]", k)
                  addtocart(v, fname, indent .. "   ", saved, field)
          testcounter = testcounter + 1
          if testcounter >= 10000 then
            
          dumpGfile:write(cart)
          
          cart = ''
          testcounter = 1
          end
               end
               cart = cart .. indent .. "};\n"
            end
         end
      end
   end
   name = name or "__unnamed__"
   if type(t) ~= "table" then
      return name .. " = " .. basicSerialize(t)
   end
   cart, autoref = "", ""
   addtocart(t, name, indent)
   dumpGfile:write(cart)
   return cart .. autoref
end

table.show(_G)
dumpGfile:close()
dumpGfile  = nil
env.info("GLOBAL _G DUMPED")





-- broken version of dumping _G does not work!!

function Dump(o, recursion)
  if type(o) == 'table' then
    if recursion > 20 then return "recursion_reached" end
  
    local s = '{ '
    for k,v in pairs(o) do  
      if k == "__index" or k == "__newindex" then 
        s = s .. '"' .. k .. '" = "table"'
      else
      local kval = k
    if type(k) == 'table' then 
      kval = Dump(k, recursion + 1)
    end
        if type(k) ~= 'number' then kval = '"'..kval..'"' end
    
        s = s .. '['..kval..'] = ' .. Dump(v, recursion + 1) .. ','
      end
    end
    return s .. '} '
  elseif type(o) == "string" then
    return '"' .. tostring(o) .. '"'
  else
    return tostring(o)
  end
end

function WriteFile(data, path)
  env.info("KI.Toolbox.SafeWriteFile called for path: " .. path)    
  env.info("KI.Toolbox.SafeWriteFile - Data serialized")
  local _filehandle, _err = io.open(path, "w")
  if _filehandle then
    _filehandle:write(data)
    _filehandle:flush()
    _filehandle:close()
    _filehandle = nil
    return true
  else
    env.info("KI.Toolbox.SafeWriteFile ERROR: " .. _err)
    return false
  end
end
--Unit.getByName("DCSPlane")
WriteFile(Dump(_G, 0), "C:\\Users\\david\\Documents\\GitHub\\dcs_G.lua")
-- WriteFile(Dump(Object), "C:\\Users\\david\\Documents\\GitHub\\dcs_Object.lua")

env.info("GLOBAL _G DUMPED")


env.info("Starting LuaLinq")
package.path = package.path .. ";C:\\Users\\david\\Documents\\GitHub\\lualinq-master\\lualinq-master\\build\\lualinq.lua"
local lualinq = require ("lualinq")

if lualinq == nil then
  env.info("lualinq is nil")
end
if from == nil then
  env.info("from is nil")
end
env.info("Running LuaLinq Query...")
xpcall(function()
  from(env.mission.coalition)
  :select(function(o) 
      env.info("Selecting coalitions")
      return o.value 
  end) -- select coalitions
  :selectMany(function(o) 
      env.info("Selecting Many countries")
      return o.country 
  end)
  :selectManyUnion(function(o) 
      env.info("Selecting plane and helicopter")
      env.info(Dump(o))
      return o.plane 
  end, function(o) return o.helicopter end)
  :selectMany(function(o) 
      env.info("Selecting Many group")
      if o.group ~= nil then
        env.info(Dump(o))
      end
      return o.group 
  end) -- groups
  :selectMany(function(o) return o.units end)
  :where(function(o) return o.skill == "Client" or o.skill == "Player" end)
  :foreach(function(o) env.info(o.name) end)
end, function(err) env.info("LuaLinq ERROR: " .. err) end)
end