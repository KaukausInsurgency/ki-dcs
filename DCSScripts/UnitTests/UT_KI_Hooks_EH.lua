UT.TestCase("KI_Hooks_BugFixes", 
function()
  UT.ValidateSetup(function() return ZONE:New("TestCPZone") ~= nil end)  -- zone must exist in ME
end, 
function()
  UT.TestData.TestCP = CP:New("Test CP", "TestCPZone", CP.Enum.CAPTUREPOINT, "TestCPZone")
end,
function()
      
      -- this is for bug #8 on github
      UT.TestFunction(KI.Hooks.GameEventHandler.onEvent, KI.Hooks.GameEventHandler, { id = world.event.S_EVENT_MISSION_END })
      UT.TestCompare(function() return KI.UTDATA.UT_MISSION_END_CALLED end)
      
      -- This test case is not possible
      -- the MOOSE:SPAWN:OnSpawnGroup handler is deferred execution
      -- This handler will be invoked after the unit tests have finished running, making it impossible to check here
      
      -- this is to confirm that callback KI.Hooks.AICOMOnSpawnGroup is indeed being called and handled
      --[[
      if true then
        local function count_hash(hash)
          local _c = 0
          for i, p in pairs(hash) do
            _c = _c + 1
          end
          return _c
        end
      
        AICOM.Config.OnSpawnGroup = KI.Hooks.AICOMOnSpawnGroup
        AICOM.Spawn({AICOM.Config.Forces[1]}, {}, UT.TestData.TestCP)
        UT.TestCompare(function() return KI.UTDATA.UT_AICOM_ONSPAWNGROUP_CALLED end)  -- this flag should be raised in the hooks call
        UT.TestCompare(function() return KI.Data.Waypoints ~= nil end)                -- KI.Data.Waypoints should not be nil
        UT.TestCompare(function() return count_hash(KI.Data.Waypoints) == 1 end)      -- The size of Waypoints hash should be 1
      end
      ]]--
end,
function()
  AICOM.Config.OnSpawnGroup = nil
end)
