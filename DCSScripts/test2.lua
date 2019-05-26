function DeepCopy(object)
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

Cargo = {}

function Cargo.New(name, x, y)
  
  local self = DeepCopy(Cargo)

  if self ~= nil then
    setmetatable( self, Cargo )
    self.__index = self 
    self.Name = name
    self.X = x
    self.Y = y
    self.Inner = {}
    self.Inner.Alive = true
  end
  
  return self
end

function Cargo.IsAlive(cargo)
  return cargo.Inner.Alive
end

function Cargo.Destroy(cargo)
  if cargo ~= nil then
    print("Cargo has been destroyed")
    cargo.Inner = nil
  end
end

-- core code above

-- special wrapper/seam code
CargoDestroy = Cargo.Destroy
Cargo.Destroy = function(cargo)
  print("wrapped destroy")
  cargo.IsDead = true
  CargoDestroy(cargo)
end

CargoIsAlive = Cargo.IsAlive
Cargo.IsAlive = function(cargo)
  print("wrapped isalive")
  if cargo.IsDead then
    return false
  else
    return CargoIsAlive(cargo)
  end
end




local cargo1 = Cargo.New("Box", 24, 45)
if cargo1:IsAlive() then
  cargo1:Destroy()
  if not cargo1:IsAlive() then
    print("Box is not alive")
  end
end



