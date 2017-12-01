local bd = StaticObject.getByName("Beslan Depot"):getPoint()
env.info(bd.z .. "," .. bd.x)
bd = StaticObject.getByName("Beslan Backup Depot"):getPoint()
env.info(bd.z .. "," .. bd.x)
bd = StaticObject.getByName("Kirovo Depot"):getPoint()
env.info(bd.z .. "," .. bd.x)
bd = StaticObject.getByName("Vladikavkaz Depot"):getPoint()
env.info(bd.z .. "," .. bd.x)
bd = StaticObject.getByName("Alagir Depot"):getPoint()
env.info(bd.z .. "," .. bd.x)
bd = StaticObject.getByName("Buron Depot"):getPoint()
env.info(bd.z .. "," .. bd.x)

if 1 == 1 then
  return
end

require("lfs")
for file in lfs.dir ([[C:\Users\Sapphire\Saved Games\DCS\Missions\Kaukasus Insurgency\GameEvents]]) do
  if string.match(file, ".lua") then 
    print("found file, "..file)  
  end
end


Data = {}

Data.Depots = 
{ 
	[1] = 
	{ 
		["CurrentCapacity"] = 132,
		["ResourceString"] = "DWM - Beslan Depot\nDepot Capacity: 132 / 150\nResource                 |Count\nInfantry                 |34   \nWatchtower Wood          |4    \nFuel \nTanks               |8    \nOutpost Wood             |4    \nOutpost Pipes            |4    \nPower Truck              |4    \nFuel Truck               |4    \nCargo \nCrates             |8    \nWatchtower Supplies      |4    \nCommand Truck            |4    \nTank                     |8    \nOutpost Supplies         |4    \nAmmo \nTruck               |4    \nAPC                      |8    ",			
		["Name"] = "Beslan Depot",
		["MGRS"] = "38T MN 64175 82063",
		["ServerID"] = 4,
		["LatLong"] = "43 11.430'N   44 33.547'E",
		["Capacity"] = 150,
		["Status"] = "Online",
	},
	[2] = 
	{ 
		["CurrentCapacity"] = 148,
		["ResourceString"] = "DWM - Beslan Depot\nDepot Capacity: 148 / 150\nResource                 |Count\nInfantry                 |40   \nWatchtower Wood          |4    \nFuel \nTanks               |8    \nOutpost Wood             |4    \nOutpost Pipes            |4    \nPower Truck              |4    \nFuel Truck               |4    \nCargo \nCrates             |8    \nWatchtower Supplies      |4    \nCommand Truck            |4    \nTank                     |8    \nOutpost Supplies         |4    \nAmmo \nTruck               |4    \nAPC                      |8    ",
		["Name"] = "Kirovo Depot",
		["MGRS"] = "38T MN 53104 80881",
		["ServerID"] = 4,
		["LatLong"] = "43 10.755'N   44 25.379'E",
		["Capacity"] = 150,
		["Status"] = "Online"
	},
	[3] = 
	{ 
		["CurrentCapacity"] = 148,
		["ResourceString"] = "DWM - Beslan Depot\nDepot Capacity: 148 / 150\nResource                 |Count\nInfantry                 |40   \nWatchtower Wood          |4    \nFuel \nTanks               |8    \nOutpost Wood             |4    \nOutpost Pipes            |4    \nPower Truck              |4    \nFuel Truck               |4    \nCargo \nCrates             |8    \nWatchtower Supplies      |4    \nCommand Truck            |4    \nTank                     |8    \nOutpost Supplies         |4    \nAmmo \nTruck               |4    \nAPC                      |8    ",
		["Name"] = "Beslan Backup Depot",
		["MGRS"] = "38T MN 65962 82253",
		["ServerID"] = 4,
		["LatLong"] = "43 11.537'N   44 34.866'E",
		["Capacity"] = 150,
		["Status"] = "Online"
	}
} 




Data.CapturePoints = {
	[1] = {
		["RedUnits"] = 2,
		["Name"] = "Beslan City",
		["MGRS"] = "38T MN 64375 82575",
		["ServerID"] = 4,
		["BlueUnits"] = 0,
		["LatLong"] = "43 11.707 'N   44 33.693' E",
		["Status"] = "Red"
	},
	[2] = {
		["RedUnits"] = 0,
		["Name"] = "Beslan Airport",
		["MGRS"] = "38T MN 68038 83498",
		["ServerID"] = 4,
		["BlueUnits"] = 5,
		["LatLong"] = "43 12.216 'N   44 36.394' E",
		["Status"] = "Blue"
	},
	[3] = {
		["RedUnits"] = 0,
		["Name"] = "Kirovo City",
		["MGRS"] = "38T MN 52028 80182",
		["ServerID"] = 4,
		["BlueUnits"] = 0,
		["LatLong"] = "43 10.373 'N   44 24.588' E",
		["Status"] = "Neutral"
	}
}




Data.GameEventQueue = 
{
	[1] = {
		["SortieID"] = 4,
		["WeaponCategory"] = "Cannon",
		["TargetType"] = -9999,
		["SessionID"] = 41,
		["Role"] = "Ka - 50",
		["PlayerSide"] = 1,
		["TargetSide"] = -9999,
		["GameTime"] = 43557.168,
		["RealTime"] = 357.168,
		["TransportUnloadedCount"] = -9999,
		["ServerID"] = 4,
		["PlayerName"] = "TAW - IgZ - IggyZ",
		["Event"] = "SHOOTING_START",
		["UCID"] = "a68afce32e6b1f57a6c8d10da24f1516",
		["TargetCategory"] = -9999,
		["TargetPlayerUCID"] = -9999,
		["TargetModel"] = -9999,
		["TargetName"] = -9999,
		["TargetIsPlayer"] = false,
		["Airfield"] = -9999,
		["TargetPlayerName"] = -9999,
		["Weapon"] = "Cannon",
	},
	[2] = {
		["SortieID"] = 4,
		["WeaponCategory"] = "ROCKET",
		["TargetType"] = "INFANTRY",
		["SessionID"] = 41,
		["Role"] = "Ka - 50",
		["PlayerSide"] = 1,
		["TargetSide"] = 1,
		["GameTime"] = 43557.707,
		["RealTime"] = 357.707,
		["TransportUnloadedCount"] = -9999,
		["ServerID"] = 4,
		["PlayerName"] = "TAW - IgZ - IggyZ",
		["Event"] = "HIT",
		["UCID"] = "a68afce32e6b1f57a6c8d10da24f1516",
		["TargetCategory"] = "HELICOPTER",
		["TargetPlayerUCID"] = -9999,
		["TargetModel"] = "Paratrooper RPG - 16",
		["TargetName"] = "SLC ATINFANTRY 2 # 001 - 02",
		["TargetIsPlayer"] = false,
		["Airfield"] = -9999,
		["TargetPlayerName"] = -9999,
		["Weapon"] = "30mm HE",
	},
	[3] = {
		["SortieID"] = 4,
		["WeaponCategory"] = "ROCKET",
		["TargetType"] = "INFANTRY",
		["SessionID"] = 41,
		["Role"] = "Ka - 50",
		["PlayerSide"] = 1,
		["TargetSide"] = 1,
		["GameTime"] = 43557.8,
		["RealTime"] = 357.8,
		["TransportUnloadedCount"] = -9999,
		["ServerID"] = 4,
		["PlayerName"] = "TAW - IgZ - IggyZ",
		["Event"] = "HIT",
		["UCID"] = "a68afce32e6b1f57a6c8d10da24f1516",
		["TargetCategory"] = "HELICOPTER",
		["TargetPlayerUCID"] = -9999,
		["TargetModel"] = "INFANTRY AK",
		["TargetName"] = "SLC ATINFANTRY 2 # 001 - 01",
		["TargetIsPlayer"] = false,
		["Airfield"] = -9999,
		["TargetPlayerName"] = -9999,
		["Weapon"] = "30mm HE",
	},
	[4] = {
		["SortieID"] = 4,
		["WeaponCategory"] = "ROCKET",
		["TargetType"] = "INFANTRY",
		["SessionID"] = 41,
		["Role"] = "Ka - 50",
		["PlayerSide"] = 1,
		["TargetSide"] = 1,
		["GameTime"] = 43557.8,
		["RealTime"] = 357.8,
		["TransportUnloadedCount"] = -9999,
		["ServerID"] = 4,
		["PlayerName"] = "TAW - IgZ - IggyZ",
		["Event"] = "HIT",
		["UCID"] = "a68afce32e6b1f57a6c8d10da24f1516",
		["TargetCategory"] = "HELICOPTER",
		["TargetPlayerUCID"] = -9999,
		["TargetModel"] = "Paratrooper RPG - 16",
		["TargetName"] = "SLC ATINFANTRY 2 # 001 - 02",
		["TargetIsPlayer"] = false,
		["Airfield"] = -9999,
		["TargetPlayerName"] = -9999,
		["Weapon"] = "30mm HE",
	},
	[5] = {
		["SortieID"] = 4,
		["WeaponCategory"] = "ROCKET",
		["TargetType"] = "INFANTRY",
		["SessionID"] = 41,
		["Role"] = "Ka - 50",
		["PlayerSide"] = 1,
		["TargetSide"] = 1,
		["GameTime"] = 43557.8,
		["RealTime"] = 357.8,
		["TransportUnloadedCount"] = -9999,
		["ServerID"] = 4,
		["PlayerName"] = "TAW - IgZ - IggyZ",
		["Event"] = "HIT",
		["UCID"] = "a68afce32e6b1f57a6c8d10da24f1516",
		["TargetCategory"] = "HELICOPTER",
		["TargetPlayerUCID"] = -9999,
		["TargetModel"] = "INFANTRY AK",
		["TargetName"] = "SLC ATINFANTRY 2 # 001 - 03",
		["TargetIsPlayer"] = false,
		["Airfield"] = -9999,
		["TargetPlayerName"] = -9999,
		["Weapon"] = "30mm HE",
	},
	[6] = {
		["SortieID"] = 4,
		["WeaponCategory"] = "ROCKET",
		["TargetType"] = "INFANTRY",
		["SessionID"] = 41,
		["Role"] = "Ka - 50",
		["PlayerSide"] = 1,
		["TargetSide"] = 1,
		["GameTime"] = 43557.8,
		["RealTime"] = 357.8,
		["TransportUnloadedCount"] = -9999,
		["ServerID"] = 4,
		["PlayerName"] = "TAW - IgZ - IggyZ",
		["Event"] = "HIT",
		["UCID"] = "a68afce32e6b1f57a6c8d10da24f1516",
		["TargetCategory"] = "HELICOPTER",
		["TargetPlayerUCID"] = -9999,
		["TargetModel"] = "Paratrooper RPG - 16",
		["TargetName"] = "SLC ATINFANTRY 2 # 001 - 05",
		["TargetIsPlayer"] = false,
		["Airfield"] = -9999,
		["TargetPlayerName"] = -9999,
		["Weapon"] = "30mm HE",
	},
	[7] = {
		["SortieID"] = 4,
		["WeaponCategory"] = "ROCKET",
		["TargetType"] = "INFANTRY",
		["SessionID"] = 41,
		["Role"] = "Ka - 50",
		["PlayerSide"] = 1,
		["TargetSide"] = 1,
		["GameTime"] = 43557.9,
		["RealTime"] = 357.9,
		["TransportUnloadedCount"] = -9999,
		["ServerID"] = 4,
		["PlayerName"] = "TAW - IgZ - IggyZ",
		["Event"] = "HIT",
		["UCID"] = "a68afce32e6b1f57a6c8d10da24f1516",
		["TargetCategory"] = "HELICOPTER",
		["TargetPlayerUCID"] = -9999,
		["TargetModel"] = "INFANTRY AK",
		["TargetName"] = "SLC ATINFANTRY 2 # 001 - 03",
		["TargetIsPlayer"] = false,
		["Airfield"] = -9999,
		["TargetPlayerName"] = -9999,
		["Weapon"] = "30mm HE",
	},
	[8] = {
		["SortieID"] = 4,
		["WeaponCategory"] = "Cannon",
		["TargetType"] = -9999,
		["SessionID"] = 41,
		["Role"] = "Ka - 50",
		["PlayerSide"] = 1,
		["TargetSide"] = -9999,
		["GameTime"] = 43557.168,
		["RealTime"] = 357.168,
		["TransportUnloadedCount"] = -9999,
		["ServerID"] = 4,
		["PlayerName"] = "TAW - IgZ - IggyZ",
		["Event"] = "SHOOTING_START",
		["UCID"] = "a68afce32e6b1f57a6c8d10da24f1516",
		["TargetCategory"] = -9999,
		["TargetPlayerUCID"] = -9999,
		["TargetModel"] = -9999,
		["TargetName"] = -9999,
		["TargetIsPlayer"] = false,
		["Airfield"] = -9999,
		["TargetPlayerName"] = -9999,
		["Weapon"] = "Cannon",
	},
	[9] = {
		["SortieID"] = 4,
		["WeaponCategory"] = "Cannon",
		["TargetType"] = -9999,
		["SessionID"] = 41,
		["Role"] = "Ka - 50",
		["PlayerSide"] = 1,
		["TargetSide"] = -9999,
		["GameTime"] = 43557.168,
		["RealTime"] = 357.168,
		["TransportUnloadedCount"] = -9999,
		["ServerID"] = 4,
		["PlayerName"] = "TAW - IgZ - IggyZ",
		["Event"] = "SHOOTING_START",
		["UCID"] = "a68afce32e6b1f57a6c8d10da24f1516",
		["TargetCategory"] = -9999,
		["TargetPlayerUCID"] = -9999,
		["TargetModel"] = -9999,
		["TargetName"] = -9999,
		["TargetIsPlayer"] = false,
		["Airfield"] = -9999,
		["TargetPlayerName"] = -9999,
		["Weapon"] = "Cannon",
	},
	[10] = {
		["SortieID"] = 4,
		["WeaponCategory"] = "Cannon",
		["TargetType"] = -9999,
		["SessionID"] = 41,
		["Role"] = "Ka - 50",
		["PlayerSide"] = 1,
		["TargetSide"] = -9999,
		["GameTime"] = 43557.168,
		["RealTime"] = 357.168,
		["TransportUnloadedCount"] = -9999,
		["ServerID"] = 4,
		["PlayerName"] = "TAW - IgZ - IggyZ",
		["Event"] = "SHOOTING_START",
		["UCID"] = "a68afce32e6b1f57a6c8d10da24f1516",
		["TargetCategory"] = -9999,
		["TargetPlayerUCID"] = -9999,
		["TargetModel"] = -9999,
		["TargetName"] = -9999,
		["TargetIsPlayer"] = false,
		["Airfield"] = -9999,
		["TargetPlayerName"] = -9999,
		["Weapon"] = "Cannon",
	},
	[11] = {
		["SortieID"] = 4,
		["WeaponCategory"] = "Cannon",
		["TargetType"] = -9999,
		["SessionID"] = 41,
		["Role"] = "Ka - 50",
		["PlayerSide"] = 1,
		["TargetSide"] = -9999,
		["GameTime"] = 43557.168,
		["RealTime"] = 357.168,
		["TransportUnloadedCount"] = -9999,
		["ServerID"] = 4,
		["PlayerName"] = "TAW - IgZ - IggyZ",
		["Event"] = "SHOOTING_START",
		["UCID"] = "a68afce32e6b1f57a6c8d10da24f1516",
		["TargetCategory"] = -9999,
		["TargetPlayerUCID"] = -9999,
		["TargetModel"] = -9999,
		["TargetName"] = -9999,
		["TargetIsPlayer"] = false,
		["Airfield"] = -9999,
		["TargetPlayerName"] = -9999,
		["Weapon"] = "Cannon",
	},
	[12] = {
		["SortieID"] = 4,
		["WeaponCategory"] = "Cannon",
		["TargetType"] = -9999,
		["SessionID"] = 41,
		["Role"] = "Ka - 50",
		["PlayerSide"] = 1,
		["TargetSide"] = -9999,
		["GameTime"] = 43557.168,
		["RealTime"] = 357.168,
		["TransportUnloadedCount"] = -9999,
		["ServerID"] = 4,
		["PlayerName"] = "TAW - IgZ - IggyZ",
		["Event"] = "SHOOTING_START",
		["UCID"] = "a68afce32e6b1f57a6c8d10da24f1516",
		["TargetCategory"] = -9999,
		["TargetPlayerUCID"] = -9999,
		["TargetModel"] = -9999,
		["TargetName"] = -9999,
		["TargetIsPlayer"] = false,
		["Airfield"] = -9999,
		["TargetPlayerName"] = -9999,
		["Weapon"] = "Cannon",
	},
	[13] = {
		["SortieID"] = 4,
		["WeaponCategory"] = "Cannon",
		["TargetType"] = -9999,
		["SessionID"] = 41,
		["Role"] = "Ka - 50",
		["PlayerSide"] = 1,
		["TargetSide"] = -9999,
		["GameTime"] = 43557.168,
		["RealTime"] = 357.168,
		["TransportUnloadedCount"] = -9999,
		["ServerID"] = 4,
		["PlayerName"] = "TAW - IgZ - IggyZ",
		["Event"] = "SHOOTING_START",
		["UCID"] = "a68afce32e6b1f57a6c8d10da24f1516",
		["TargetCategory"] = -9999,
		["TargetPlayerUCID"] = -9999,
		["TargetModel"] = -9999,
		["TargetName"] = -9999,
		["TargetIsPlayer"] = false,
		["Airfield"] = -9999,
		["TargetPlayerName"] = -9999,
		["Weapon"] = "Cannon",
	},
	[14] = {
		["SortieID"] = 4,
		["WeaponCategory"] = "Cannon",
		["TargetType"] = -9999,
		["SessionID"] = 41,
		["Role"] = "Ka - 50",
		["PlayerSide"] = 1,
		["TargetSide"] = -9999,
		["GameTime"] = 43557.168,
		["RealTime"] = 357.168,
		["TransportUnloadedCount"] = -9999,
		["ServerID"] = 4,
		["PlayerName"] = "TAW - IgZ - IggyZ",
		["Event"] = "SHOOTING_START",
		["UCID"] = "a68afce32e6b1f57a6c8d10da24f1516",
		["TargetCategory"] = -9999,
		["TargetPlayerUCID"] = -9999,
		["TargetModel"] = -9999,
		["TargetName"] = -9999,
		["TargetIsPlayer"] = false,
		["Airfield"] = -9999,
		["TargetPlayerName"] = -9999,
		["Weapon"] = "Cannon",
	},
}
	


local CapturePointSegments = { }
table.insert(CapturePointSegments, {})  -- create an inner array
  
  if true then
    local index = 1
    for i = 1, #Data.CapturePoints do
      -- segment capture points every 6 elements
      if i % 6 == 0 then
        index = index + 1
        table.insert(CapturePointSegments, {})
      end
        
      local data = 
      { 
        ServerID = 4, 
        Name = Data.CapturePoints[i].Name,
        Status = "",
        BlueUnits = Data.CapturePoints[i].BlueUnits,
        RedUnits = Data.CapturePoints[i].RedUnits,
        LatLong = Data.CapturePoints[i].LatLong,
        MGRS = Data.CapturePoints[i].MGRS
      }
      table.insert(CapturePointSegments[index], data)
    end
  end



local require = require
local loadfile = loadfile
local JSON = loadfile("S:\\Eagle Dynamics\\DCS World\\DCS World\\Scripts\\JSON.lua")()
package.path = package.path..";.\\LuaSocket\\?.lua"
package.cpath = package.cpath..";.\\LuaSocket\\?.dll"

local socket = require("socket")

UDPSendSocket = socket.udp()








































--print(string.format("%-25s|%-5s|%-5s", "Defense", "Count", "limit") .. "\n")
--print(string.format("%-25s|%-5d|%-5d", "T-90", 15, 30) .. "\n")

env.info("Creating StaticObject Instance 'TESTCARGO'")
local function PositionAt12Oclock(_unit, _offset)
    local _position = _unit:getPosition()
    local _angle = math.atan2(_position.x.z, _position.x.x)
    local _xOffset = math.cos(_angle) * _offset
    local _yOffset = math.sin(_angle) * _offset

    local _point = _unit:getPoint()
    return { x = _point.x + _xOffset, z = _point.z + _yOffset, y = _point.y }
end

local pos = PositionAt12Oclock(Unit.getByName("SLCPilot1"), 30)
local test_cargo_obj = coalition.addStaticObject(country.id.RUSSIA, {
		country = "Russia",
		category = "Cargos",
		x = pos.x,
		y = pos.z,
		type = "ammo_cargo",
		name = "TESTCARGO",
		mass = 1000,
		canCargo = true
	})
env.info("TESTCARGO - Is ALIVE? (StaticObject.getByName():isExist()) : " .. tostring(StaticObject.getByName("TESTCARGO"):isExist()))
env.info("TESTCARGO - Is ALIVE? (test_cargo_obj:isExist()) : " .. tostring(test_cargo_obj:isExist()))
env.info("Destroying Crate TESTCARGO (using obj:destroy())")
test_cargo_obj:destroy()
env.info("TESTCARGO - Is ALIVE? (test_cargo_obj:isExist()) : " .. tostring(test_cargo_obj:isExist()))
env.info("TESTCARGO - Is ALIVE? (StaticObject.getByName():isExist()) : " .. tostring(StaticObject.getByName("TESTCARGO"):isExist()))
--env.info("Destroying Crate TESTCARGO (StaticObject.getByName():destroy()")
--StaticObject.getByName("TESTCARGO"):destroy()
--env.info("TESTCARGO - Is ALIVE? (test_cargo_obj:isExist()) : " .. tostring(test_cargo_obj:isExist()))
--env.info("TESTCARGO - Is ALIVE? (StaticObject.getByName():isExist()) : " .. tostring(StaticObject.getByName("TESTCARGO"):isExist()))

env.info("Unit.getType NIL? : " .. tostring(Unit.getByName("SLCPilot1").getType == nil))
env.info("TestKIScoreEnemyAir1 TYPE : " .. Unit.getByName("TestKIScoreEnemyAir1"):getTypeName())
