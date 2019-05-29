package.path = package.path .. ";C:\\Users\\david\\Documents\\GitHub\\KI\\DCSScripts\\Dependencies\\lualinq.lua"

assert(loadfile("C:\\Users\\david\\Documents\\GitHub\\KI\\DCSScripts\\Mocks\\DCS_Countries.lua"))()
--assert(loadfile("C:\\Users\\david\\Documents\\GitHub\\KI\\DCSScripts\\Mocks\\DCS_G.lua"))()

function Dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k,v in pairs(o) do  
      if k == "__index" then 
        s = s .. '"' .. k .. '" = "table"'
      else
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. Dump(v) .. ','
      end
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

env = {
  info = function(msg) print(msg) end
}

env.info("Starting LuaLinq")

local lualinq = require ("lualinq")
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


KI = {
  Data = {
    Waypoints = {
      ["WP_Group_Far"] = { x = 1, y = 1, z = 1 },
      ["WP_Group_Close"] = { x = 1, y = 1, z = 1 },
      ["NoGroup"] = { x = 1, y = 1, z = 1 }
    }
  }
}

coalitionData =
{
  ['SideMissionGroundObjects'] = {},
  ['GroundGroups'] =
  {
    [1] = {
      ['Coalition'] = 1,
      ['Name'] = 'New Vehicle Group #002',
      ['Category'] = 2,
      ['ID'] = 49,
      ['Units'] = {
      },
      ['Size'] = 0,
    },
    [2] = {
      ['Coalition'] = 1,
      ['Name'] = 'WP_Group_Far',
      ['Category'] = 2,
      ['ID'] = 48,
      ['Country'] = 0,
      ['Units'] = {
        [1] = {
          ['Type'] = 'BTR-80',
          ['Name'] = 'Unit #067',
          ['Position'] = {
            ['y'] = {
              ['y'] = 1,
              ['x'] = 0,
              ['z'] = 0,
            },
            ['x'] = {
              ['y'] = 0,
              ['x'] = -0.28104224801064,
              ['z'] = 0.95969539880753,
            },
            ['p'] = {
              ['y'] = 430,
              ['x'] = -124175.84375,
              ['z'] = 759919.5625,
            },
            ['z'] = {
              ['y'] = 0,
              ['x'] = -0.95969539880753,
              ['z'] = -0.28104224801064,
            },
          },
          ['ID'] = '137',
          ['Heading'] = 1.8556762826387,
        },
      },
      ['Size'] = 1,
    },
    [3] = {
      ['Coalition'] = 1,
      ['Name'] = 'WP_Group_Close',
      ['Category'] = 2,
      ['ID'] = 48,
      ['Country'] = 0,
      ['Units'] = {
        [1] = {
          ['Type'] = 'BTR-80',
          ['Name'] = 'Unit #067',
          ['Position'] = {
            ['y'] = {
              ['y'] = 1,
              ['x'] = 0,
              ['z'] = 0,
            },
            ['x'] = {
              ['y'] = 0,
              ['x'] = -0.28104224801064,
              ['z'] = 0.95969539880753,
            },
            ['p'] = {
              ['y'] = 430,
              ['x'] = -124175.84375,
              ['z'] = 759919.5625,
            },
            ['z'] = {
              ['y'] = 0,
              ['x'] = -0.95969539880753,
              ['z'] = -0.28104224801064,
            },
          },
          ['ID'] = '137',
          ['Heading'] = 1.8556762826387,
        },
      },
      ['Size'] = 1,
    },
  }
}

function PruneDeadGroups(data)
  KI.Data.Waypoints = from(KI.Data.Waypoints)
                      :intersection(data["GroundGroups"], function(a,b) 
                        return a.Name == b.key 
                      end)
                      :toDictionary(function(val) 
                        return val.key, val.value
                      end)
end

for k,v in pairs(KI.Data.Waypoints) do
  env.info(k .. " = " .. tostring(v))
end

PruneDeadGroups(coalitionData)

for k,v in pairs(KI.Data.Waypoints) do
  env.info(k .. " = " .. tostring(v))
end