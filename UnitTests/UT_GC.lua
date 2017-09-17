UT.TestCase("GC", nil, nil,
    function()
      
      --========================================= START TEST DATA =====================================================
      local _groups = { "TestGCGroup1", "TestGCGroup2" }
      local _status = ""
      
      local _isExist = function(g)
        UT.TestCompare(function() return g ~= nil end)
        return g:IsAlive()
      end
      
      local _destroy = function(g)
        UT.TestCompare(function() return g ~= nil end)
        _status = "DESTROYED"
        return g:Destroy()
      end
      
      local _onLifeExpired = function(gc_item)
        UT.TestCompare(function() return gc_item ~= nil end)
        UT.TestCompare(function() return gc_item.Object ~= nil end)
        UT.TestCompare(function() return gc_item.PredicateArgs ~= nil end)
        UT.TestCompare(function() return gc_item.PredicateArgs.Val == "TestArgVal" end)
        UT.TestCompare(function() return gc_item.PredicateArgs.Group ~= nil end)
        UT.TestCompare(function() return gc_item.PredicateArgs.Group.GroupName == gc_item.Object.GroupName end)
        _status = "LIFEEXPIRED"
      end
      
      local _isIdle = function(args)
        UT.TestCompare(function() return args.Group ~= nil end)
        UT.TestCompare(function() return args.Val == "TestArgVal" end)
        UT.TestCompare(function() return args.Group.GroupName == _groups[1] or args.Group.GroupName == _groups[2] end)
        return true
      end
      
      -- Need to modify configuration of GC.LoopRate for this UT
      GC.LoopRate = 5
      
      
      -- ======================================= END OF TEST DATA ============================================================
      UT.TestCompare(function() 
          return GROUP:FindByName(_groups[1]) ~= nil 
      end)

      -- testing GC ITEM constructor
      UT.TestCompare(function() 
          return GCItem:New("Test Group 1", GROUP:FindByName(_groups[1]), _isExist, _destroy, _onLifeExpired, { Val = "TestArgVal", Group = GROUP:FindByName(_groups[1])}, _isIdle, nil, 10) ~= nil 
      end)
    
      local _gi = GCItem:New("Test Group 1", GROUP:FindByName(_groups[1]), _isExist, _destroy, _onLifeExpired, { Val = "TestArgVal", Group = GROUP:FindByName(_groups[1])}, _isIdle, nil, 10)
      
      UT.TestCompare(function() return _gi.Name == "Test Group 1" end)
      UT.TestCompare(function() return _gi.Object ~= nil end)
      UT.TestCompare(function() return _gi.Object.GroupName == _groups[1] end)
      UT.TestCompare(function() return _gi.ExpiryTime == 10 end)
      UT.TestCompare(function() return _gi.LifeTime == 0 end)
      
      local _gi2 = GCItem:New("Test Group 2", GROUP:FindByName(_groups[2]), _isExist, _destroy, nil, nil, nil, nil, 20)
      
      UT.TestCompare(function() return _gi2.Name == "Test Group 2" end)
      UT.TestCompare(function() return _gi2.Object ~= nil end)
      UT.TestCompare(function() return _gi2.Object.GroupName == _groups[2] end)
      UT.TestCompare(function() return _gi2.ExpiryTime == 20 end)
      UT.TestCompare(function() return _gi2.LifeTime == 0 end)
      
      
      -- testing GC _monitor method
      table.insert(GC.Queue, _gi)
      table.insert(GC.Queue, _gi2)
      
      GC._Monitor(1, 0)
      UT.TestCompare(function() return _gi.ExpiryTime == 10 end)
      UT.TestCompare(function() return _gi.LifeTime == 5 end)
      GC._Monitor(1, 5)
      UT.TestCompare(function() return _status == "DESTROYED" end)
      
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
      UT.TestCompare(function() return _status == "DESTROYED" end)
    end)
  
