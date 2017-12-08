UT.TestCase("KI_Hooks_EH", nil, nil,
function()
      
      -- this is for bug #8 on github
      UT.TestFunction(KI.Hooks.GameEventHandler.onEvent, KI.Hooks.GameEventHandler, { id = world.event.S_EVENT_MISSION_END })
      UT.TestCompare(function() return KI.UT_MISSION_END_CALLED end)
end)
