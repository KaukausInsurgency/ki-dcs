--Depot Warehouse Management
DWM = 
{
  Resources = {},       -- map based on key["ResourceName"] = [qty, cap]
  Name = "",            -- name of the depot in mission editor
  Object = nil,         -- the static object found from the name
  Zone = nil,           -- Mission Editor Trigger Zone
  SupplyCheckRate = 0,  -- the rate at which supplies are checked and whether the depot should call for a convoy
  Capacity = 0,         -- the maximum capacity the warehouse can hold
  CurrentCapacity = 0,
  IsSupplier = false,   -- whether this depot can resupply other depots
  Suppliers = {},       -- list of suppliers
  Position = {}
}

function DWM:New(staticName, zone, checkRate, capacity, isSupplier)
  local self = KI.Toolbox.DeepCopy( DWM )

	if self ~= nil then
		setmetatable( self, DWM )
		self.__index = self	
	end
  
  self.Name = staticName
  self.Object = StaticObject.getByName(staticName)
  if self.Object == nil then
    env.info("DWM:New Error - StaticObject " .. staticName .. " does not exist in mission!")
    return nil
  end
  
  self.Zone = ZONE:New(zone)
  self.Position = LOCPOS:NewFromZone(self.Zone)
  if not capacity then
    capacity = 100
  end
  
  if not isSupplier then
    isSupplier = false
  end
  
  if not checkRate then
    checkRate = 600
  end
  
  self.Capacity = capacity
  self.CurrentCapacity = 0
  self.IsSupplier = isSupplier
  self.SupplyCheckRate = checkRate
  
  return self
end

function DWM:SetResource(keyRes, valCount, capPerUnit)
  if not capPerUnit then
    capPerUnit = 1
  end
  self.Resources[keyRes] = { qty = valCount, cap = capPerUnit }
  self.CurrentCapacity = self.CurrentCapacity + (valCount * capPerUnit)
end
  
function DWM:Take(resource, count)
  local msg = ""
  local result = false
  if self.Resources[resource] then
    -- if depot is set as supplier, it has infinite resources so perform no checks
    if self.IsSupplier then
      result = true
      msg = "Depot resource (" .. resource .. ") taken! (Remaining: infinite, Capacity: infinite / infinite)"
    else
      local _rqty = self.Resources[resource].qty
      local _cap = self.Resources[resource].cap
      if _rqty > 0 then
        if count <= _rqty then
          _rqty = _rqty - count
          self.Resources[resource] = { qty = _rqty, cap = _cap }
          self.CurrentCapacity = self.CurrentCapacity - (count * _cap)
          result = true
          msg = "Depot resource (" .. resource .. ") taken! (Remaining: " .. _rqty .. ", Capacity: " .. tostring(self.CurrentCapacity) .. " / " .. tostring(self.Capacity) .. ")"
        else
          msg = "Depot only has " .. _rqty .. " of this resource (" .. resource .. "), cannot take!"
        end
      else
        msg = "Depot has run out of this resource (" .. resource .. ")!"
      end
    end
  else
    msg = "Depot does not carry this type of resource!"
  end
  return result, msg
end

function DWM:Give(resource, count)
  local msg = ""
  local result = false
  if self.Resources[resource] then
    if self.IsSupplier then
      msg = "Resource (" .. resource .. ") given to " .. self.Name .. "! (Remaining: infinite, Capacity: infinite / infinite)"
      result = true
    else
      local _rqty = self.Resources[resource].qty
      local _cap = self.Resources[resource].cap
      -- if the depot has enough capacity to store the resource, do so
      if (self.CurrentCapacity + (count * _cap)) <= self.Capacity then
        env.info("DWM:Give - Depot has enough capacity to accept this resource")
        _rqty = _rqty + count
        self.Resources[resource] = { qty = _rqty, cap = _cap }
        self.CurrentCapacity = self.CurrentCapacity + (count * _cap)
        result = true
        msg = "Resource (" .. resource .. ") given to " .. self.Name .. "! (Remaining: " .. _rqty .. ", Capacity: " .. tostring(self.CurrentCapacity) .. " / " .. tostring(self.Capacity) .. ")"
      else
        msg = "Depot does not have enough capacity to take this resource! (Capacity: " .. tostring(self.CurrentCapacity) .. " / " .. tostring(self.Capacity) .. ")"
      end
    end   
  else
    msg = "Depot does not accept this type of resource!"
  end
  return result, msg
end
  
function DWM:ViewResources()
  local msg = "DWM - " .. self.Name .. "\n"
  if self.IsSupplier then
    msg = msg .. "Depot Capacity: infinite / infinite\n"
    msg = msg .. string.format("%-25s|%-5s", "Resource", "Count") .. "\n"
    for res, val in pairs(self.Resources) do
      msg = msg .. string.format("%-25s|%-5d", res, "infinite") .. "\n"
    end
  else
    msg = msg .. "Depot Capacity: " .. self.CurrentCapacity .. " / " .. self.Capacity .. "\n"
    msg = msg .. string.format("%-25s|%-5s", "Resource", "Count") .. "\n"
    for res, val in pairs(self.Resources) do
      msg = msg .. string.format("%-25s|%-5d", res, val.qty) .. "\n"
    end
  end
  
  return msg
end

function DWM:GetResourceEncoded()
  local msg = "Resource|Count\n"
  if self.IsSupplier then
    for res, val in pairs(self.Resources) do
      msg = msg .. res .. "|" .. "infinite" .. "\n"
    end
  else
    for res, val in pairs(self.Resources) do
      msg = msg .. res .. "|" .. val.qty .. "\n"
    end
  end
  
  return msg
end
  
