if not KI then
  KI = {}
end

KI.Defines = {}

KI.Defines.EventNames = 
{
  [world.event.S_EVENT_SHOT] = "SHOT",
  [world.event.S_EVENT_SHOOTING_START] = "SHOOTING_START",
  [world.event.S_EVENT_SHOOTING_END] = "SHOOTING_END",
  [world.event.S_EVENT_HIT] = "HIT",
  [world.event.S_EVENT_TAKEOFF] = "TAKEOFF",
  [world.event.S_EVENT_LAND] = "LAND",
  [world.event.S_EVENT_CRASH] = "CRASH",
  [world.event.S_EVENT_DEAD] = "DEAD",
  [world.event.S_EVENT_EJECTION] = "EJECTION",
  [world.event.S_EVENT_PILOT_DEAD] = "PILOT_DEAD",
  [world.event.S_EVENT_PLAYER_LEAVE_UNIT] = "PLAYER_LEAVE_UNIT",
  [world.event.S_EVENT_REFUELING] = "REFUELING",
  [world.event.S_EVENT_REFUELING_STOP] = "REFUELING_STOP"
}

KI.Defines.WeaponCategories =
{
  [Weapon.Category.SHELL] = "SHELL",
  [Weapon.Category.MISSILE] = "MISSILE",
  [Weapon.Category.ROCKET] = "ROCKET",
  [Weapon.Category.BOMB] = "BOMB"
}

KI.Defines.UnitCategories =
{
  [Unit.Category.AIRPLANE] = "AIR",
  [Unit.Category.HELICOPTER] = "HELICOPTER",
  [Unit.Category.GROUND_UNIT] = "GROUND",
  [Unit.Category.SHIP] = "SHIP",
  [Unit.Category.STRUCTURE] = "STRUCTURE"
}

KI.Defines.UnitTypes =
{
  ["Su-25T"] = "STRIKER",
  
  ["KA50"] = "ATTACK_HELO",
  
  ["UH1H"] = "TRANSPORT_HELO",
  
  ["T-55"] = "TANK",
  ["T72"] = "TANK",
  ["T90"] = "TANK",
  ["BTR80"] = "APC",
  ["SA11"] = "SAM",
  ["EWR"] = "RADAR",
  ["MANPAD"] = "MANPAD",
  ["Rifleman"] = "INFANTRY"
  
}










