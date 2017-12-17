if not KI then
  KI = {}
end

if not KI.Toolbox  then
  KI.Toolbox = {}
end


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

local wood = StaticObject.getByName("cargo_wood")
local uh1h = StaticObject.getByName("cargo_uh1h")
local cont = StaticObject.getByName("cargo_cont")
local pipe = StaticObject.getByName("cargo_pipe")

env.info("wood _id: " .. tostring(wood.id_))
env.info("uh1h _id: " .. tostring(uh1h.id_))
env.info("cont _id: " .. tostring(cont.id_))
env.info("pipe _id: " .. tostring(pipe.id_))

env.info("wood desc: " .. KI.Toolbox.Dump(wood))
env.info("uh1h desc: " .. KI.Toolbox.Dump(uh1h))
env.info("cont desc: " .. KI.Toolbox.Dump(cont))
env.info("pipe desc: " .. KI.Toolbox.Dump(pipe))

--AICOM.DoTurn({}, 0)

--KI.Loader.SaveData()
--KI.Loader.LoadData()