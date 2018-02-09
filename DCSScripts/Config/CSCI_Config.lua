if not CSCI then
  CSCI = {}
end

CSCI.Config = {}

-- Callback that is invoked before an f10 menu action is performed
-- Passed parameters actionname, parentmenu, moosegrp, supporttype, capturepoint
-- must return true / false
CSCI.Config.PreOnRadioAction = nil

-- Passed parameters actionname, parentaction, spawncp, destcp, supporttype
CSCI.Config.OnSupportRequestCalled = nil

-- if this is set to true, the CSCI menu will only be available for clients with a unit name that contains 'CSCIPilot'
-- otherwise it will be available to all client units
CSCI.Config.RestrictToCSCIPilot = false

CSCI.Config.AirdropTypes =
{
  ["Infantry Paradrop"] = 
  {
    MenuName = "Infantry Paradrop",
    SpawnTemplate = "C130",
    Cooldown = 1800,
    MaxCallsPerCooldown = 1,
    MaxCallsPerSession = 15,
    PlaneCruisingSpeed = 700,
    PlaneCruisingAltitude = 2000,
    AirdropDistance = 12000,
    ParachuteTime = 30,
    CargoTemplate = {"InfantrySquadTemplate", "InfantrySquadTemplate"} 
  },
  ["Supply Airdrop"] = 
  {
    MenuName = "Supply Airdrop",
    SpawnTemplate = "C130",
    Cooldown = 900,
    MaxCallsPerCooldown = 3,
    MaxCallsPerSession = 25,
    PlaneCruisingSpeed = 600,
    PlaneCruisingAltitude = 2000,
    AirdropDistance = 10000,
    ParachuteTime = 30,
    CargoTemplate = {"InfantrySquadTemplate"} 
  }, 

}

CSCI.Config.AirdropTypesOrder =
{
  "Infantry Paradrop",
  "Vehicle Airdrop",
  "Supply Airdrop",
  "FARP Support Airdrop"
}