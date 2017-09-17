UT.TestCase("GC", 
    function()
      UT.ValidateSetup(function() return GROUP:FindByName("TestGCGroup1") ~= nil end)
      UT.ValidateSetup(function() return GROUP:FindByName("TestGCGroup2") ~= nil end)
    end, 
    function()
      -- spawn clones of these groups
      CloneGroup1 = SPAWN:New( "TestGCGroup1" )
      CloneGroup2 = SPAWN:New( "TestGCGroup2" )
      CloneGroup1:SpawnWithIndex(1)
      CloneGroup2:SpawnWithIndex(1)
      
      UT.TestData._groups = { "TestGCGroup1#001", "TestGCGroup2#001" }
      UT.TestData._status = ""
      
      UT.TestData._isExist = function(g)
        UT.TestCompare(function() return g ~= nil end)
        return g:IsAlive()
      end
      
      UT.TestData._destroy = function(g)
        UT.TestCompare(function() return g ~= nil end)
        UT.TestData._status = "DESTROYED"
        return g:Destroy()
      end
      
      UT.TestData._onLifeExpired = function(gc_item)
        UT.TestCompare(function() return gc_item ~= nil end)
        UT.TestCompare(function() return gc_item.Object ~= nil end)
        UT.TestCompare(function() return gc_item.PredicateArgs ~= nil end)
        UT.TestCompare(function() return gc_item.PredicateArgs.Val == "TestArgVal" end)
        UT.TestCompare(function() return gc_item.PredicateArgs.Group ~= nil end)
        UT.TestCompare(function() return gc_item.PredicateArgs.Group.GroupName == gc_item.Object.GroupName end)
        UT.TestData._status = "LIFEEXPIRED"
      end
      
      UT.TestData._isIdle = function(args)
        UT.TestCompare(function() return args.Group ~= nil end)
        UT.TestCompare(function() return args.Val == "TestArgVal" end)
        UT.TestCompare(function() return args.Group.GroupName == UT.TestData._groups[1] or args.Group.GroupName == UT.TestData._groups[2] end)
        return true
      end
      
      -- Need to modify configuration of GC.LoopRate for this UT
      GC.LoopRate = 5
    end,
    function()
      
      
      

      -- testing GC ITEM constructor
      UT.TestCompare(function() 
          return GCItem:New("Test Group 1", 
                            GROUP:FindByName(UT.TestData._groups[1]), 
                            UT.TestData._isExist, 
                            UT.TestData._destroy, 
                            UT.TestData._onLifeExpired, 
                            { 
                              Val = "TestArgVal", 
                              Group = GROUP:FindByName(UT.TestData._groups[1])
                            }, 
                            UT.TestData._isIdle, nil, 10) ~= nil 
      end)
    
      local _gi = GCItem:New("Test Group 1", 
                             GROUP:FindByName(UT.TestData._groups[1]), 
                             UT.TestData._isExist, 
                             UT.TestData._destroy, 
                             UT.TestData._onLifeExpired, 
                             { 
                               Val = "TestArgVal", 
                               Group = GROUP:FindByName(UT.TestData._groups[1])
                             }, 
                             UT.TestData._isIdle, nil, 10)
      
      UT.TestCompare(function() return _gi.Name == "Test Group 1" end)
      UT.TestCompare(function() return _gi.Object ~= nil end)
      UT.TestCompare(function() return _gi.Object.GroupName == UT.TestData._groups[1] end)
      UT.TestCompare(function() return _gi.ExpiryTime == 10 end)
      UT.TestCompare(function() return _gi.LifeTime == 0 end)
      
      local _gi2 = GCItem:New("Test Group 2", 
                              GROUP:FindByName(UT.TestData._groups[2]), 
                              UT.TestData._isExist, 
                              UT.TestData._destroy, nil, nil, nil, nil, 20)
      
      UT.TestCompare(function() return _gi2.Name == "Test Group 2" end)
      UT.TestCompare(function() return _gi2.Object ~= nil end)
      UT.TestCompare(function() return _gi2.Object.GroupName == UT.TestData._groups[2] end)
      UT.TestCompare(function() return _gi2.ExpiryTime == 20 end)
      UT.TestCompare(function() return _gi2.LifeTime == 0 end)
      
      
      -- testing GC _monitor method
      table.insert(GC.Queue, _gi)
      table.insert(GC.Queue, _gi2)
      
      GC._Monitor(1, 0)
      UT.TestCompare(function() return _gi.ExpiryTime == 10 end)
      UT.TestCompare(function() return _gi.LifeTime == 5 end)
      GC._Monitor(1, 5)
      UT.TestCompare(function() return UT.TestData._status == "DESTROYED" end)
      
      GC._Monitor(2, 0)
      UT.TestCompare(function() return _gi2.ExpiryTime == 20 end)
      UT.TestCompare(function() return _gi2.LifeTime == 5 end)
      GC._Monitor(2, 5)
      UT.TestCompare(function() return _gi2.ExpiryTime == 20 end)
      UT.TestCompare(function() return _gi2.LifeTime == 10 end)
      GC._Monitor(2, 10)
      UT.TestCompare(function() return _gi2.ExpiryTime == 20 end)
      UT.TestCompare(function() return _gi2.LifeTime == 15 end)
      GC._Monitor(2, 15)
      UT.TestCompare(function() return UT.TestData._status == "DESTROYED" end)
    end)
  
