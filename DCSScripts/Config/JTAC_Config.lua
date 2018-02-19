-- CONFIG
JTAC_maxDistance = 5000 -- How far a JTAC can "see" in meters (with LOS)

JTAC_laserCode = 1688 -- if no laser code passed in, the default code to use

JTAC_smokeOn = true -- enables marking of target with smoke, can be overriden by the JTACAutoLase in editor

JTAC_smokeColour = 1 -- Green = 0 , Red = 1, White = 2, Orange = 3, Blue = 4

JTAC_jtacStatusF10 = true -- enables F10 JTAC Status menu

JTAC_location = true -- shows location in JTAC message, can be overriden by the JTACAutoLase in editor

JTAC_lock =  "all" -- "vehicle" OR "troop" OR "all" forces JTAC to only lock vehicles or troops or all ground units 

JTAC_AllySide = KI.Config.AllySide

JTAC_EnemySide = KI.Config.InsurgentSide

-- END CONFIG