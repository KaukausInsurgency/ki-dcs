testHandler = {}
function testHandler:onEvent(event)
if not event.initiator and not event.initiator.getPlayerName then return end
  local playerName = event.initiator:getPlayerName() or nil
  
  -- catch all forms of shooting events from a player
	if (event.id == world.event.S_EVENT_SHOT or
     event.id == world.event.S_EVENT_SHOOTING_START or
     event.id == world.event.S_EVENT_SHOOTING_END) and
     playerName then
    local weaponTable =
    {
      Name = event.weapon:getName(),
      TypeName = event.weapon:getTypeName(),
      Category = event.weapon:getCategory(),
      Desc = event.weapon:getDesc()
    } 
    env.info("WEAPON OBJECT: - " .. KI.Toolbox.Dump(weaponTable))  
  end
end

world.addEventHandler(testHandler)

env.info("Arty1 Name: '" .. Unit.getByName("TestArty"):getTypeName())
env.info("Arty2 Name: '" .. Unit.getByName("TestArty2"):getTypeName())
env.info("Test.lua RUN COMPLETE")