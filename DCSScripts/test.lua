

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
   local function addtocart (value, name, indent, field)
      indent = indent or ""
      field = field or name
      cart = cart .. indent .. field
      if type(value) ~= "table" then
         cart = cart .. " = " .. basicSerialize(value) .. ";\n"
      else
        if isemptytable(value) then
           cart = cart .. " = {};\n"
        else
           cart = cart .. " = {\n"
           for k, v in pairs(value) do
              k = basicSerialize(k)
              local fname = string.format("%s[%s]", name, k)
              field = string.format("[%s]", k)
              addtocart(v, fname, indent .. "   ", field)
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
   name = name or "__unnamed__"
   if type(t) ~= "table" then
      return name .. " = " .. basicSerialize(t)
   end
   cart, autoref = "", ""
   addtocart(t, name, indent)
   dumpGfile:write(cart)
   return cart .. autoref
end

table.show(country, "country")
dumpGfile:close()
dumpGfile  = nil
--env.info("GLOBAL _G DUMPED")
