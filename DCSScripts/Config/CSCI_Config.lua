if not CSCI then
  CSCI = {}
end

CSCI.Config = {}

-- Callback that is invoked before an f10 menu action is performed
-- Passed parameters actionname, parentmenu, moosegrp, supporttype, capturepoint
-- must return true / false
CSCI.Config.PreOnRadioAction = nil


-- if this is set to true, the CSCI menu will only be available for clients with a unit name that contains 'CSCIPilot'
-- otherwise it will be available to all client units
CSCI.Config.RestrictToCSCIPilot = false

CSCI.Config.AirdropTypes =
{
  ["Infantry Paradrop"] = 
  {
    MenuName = "Infantry Paradrop",
    SpawnTemplate = "C130",
    SpawnIn = "Ramp Hot",
    Cooldown = 1800,
    MaxCallsPerCooldown = 3,
    MaxCallsPerSession = 15,
    PlaneCruisingSpeed = 600,
    PlaneCruisingAltitude = 2000,
    AirdropDistance = 10000,
    ParachuteTime = 120,
    CargoTemplate = {"Airborne1", "Airborne2"} 
  },
  ["Vehicle Airdrop"] = 
  {
    MenuName = "Vehicle Airdrop",
    SpawnTemplate = "C130",
    SpawnIn = "Ramp Hot",
    Cooldown = 1200,
    MaxCallsPerCooldown = 3,
    MaxCallsPerSession = 20,
    PlaneCruisingSpeed = 600,
    PlaneCruisingAltitude = 2000,
    AirdropDistance = 10000,
    ParachuteTime = 120,
    CargoTemplate = {"Humvee"} 
  },
  ["Supply Airdrop"] = 
  {
    MenuName = "Supply Airdrop",
    SpawnTemplate = "C130",
    SpawnIn = "Ramp Hot",
    Cooldown = 900,
    MaxCallsPerCooldown = 3,
    MaxCallsPerSession = 25,
    PlaneCruisingSpeed = 600,
    PlaneCruisingAltitude = 2000,
    AirdropDistance = 10000,
    ParachuteTime = 120,
    CargoTemplate = {"Supply Crate"} 
  }, 
  ["FARP Support Airdrop"] = 
  {
    MenuName = "FARP Support Airdrop",
    SpawnTemplate = "C130",
    SpawnIn = "Ramp Hot",
    Cooldown = 600,
    MaxCallsPerCooldown = 1,
    MaxCallsPerSession = 4,
    PlaneCruisingSpeed = 600,
    PlaneCruisingAltitude = 2000,
    AirdropDistance = 10000,
    ParachuteTime = 120,
    CargoTemplate = {"FARP Power", "FARP Ammo"} 
  },

}

CSCI.Config.AirdropTypesOrder =
{
  "Infantry Paradrop",
  "Vehicle Airdrop",
  "Supply Airdrop",
  "FARP Support Airdrop"
}