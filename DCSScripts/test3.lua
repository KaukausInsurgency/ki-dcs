package.path = package.path .. ";C:\\Users\\david\\Documents\\GitHub\\KI\\DCSScripts\\Dependencies\\lualinq.lua"

assert(loadfile("C:\\Users\\david\\Documents\\GitHub\\KI\\DCSScripts\\Mocks\\DCS_Countries.lua"))()
--assert(loadfile("C:\\Users\\david\\Documents\\GitHub\\KI\\DCSScripts\\Mocks\\DCS_G.lua"))()

env = {
  info = function(msg) print(msg) end
}

env.info("Starting LuaLinq")


local lualinq = require ("lualinq")

if lualinq == nil then
  env.info("lualinq is nil")
end
if from == nil then
  env.info("from is nil")
end
env.info("Running LuaLinq Query...")
xpcall(function()
  local airs = from(country.by_country)
  :select(function(o) return o.value end) -- select coalitions
  :selectManyUnion(function(o) return o.Units.Planes.Plane end, function(o) return o.Units.Helicopters.Helicopter end)
  :distinct(function(a,b) return a.Name == b.Name end)
  :select(function(o) return o.Name end)
  :toArray()
  
  for i,v in pairs(airs) do
    env.info(v)
  end
end, function(err) env.info("LuaLinq ERROR: " .. err) end)