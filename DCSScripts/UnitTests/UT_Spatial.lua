UT.TestCase("KI_Spatial", 
function()
  UT.ValidateSetup(function() return Unit.getByName("SpatialUnitA") ~= nil end)
  UT.ValidateSetup(function() return Unit.getByName("SpatialUnitB") ~= nil end)
  UT.ValidateSetup(function() return Unit.getByName("SpatialUnitC") ~= nil end)
end, nil,
function()
  if true then
    -- Test Spatial.Distance
    local p1 = Unit.getByName("SpatialUnitA"):getPoint()
    local p2 = Unit.getByName("SpatialUnitB"):getPoint()
    local p3 = Unit.getByName("SpatialUnitC"):getPoint()
    local d = Spatial.Distance(p1, p2)
    local d2 = Spatial.Distance(p2, p1)
    local d3 = Spatial.Distance(p3, p1)
    local d4 = Spatial.Distance(p3, p2)
    UT.Log("d3 = " .. tostring(d3))
    UT.Log("d4 = " .. tostring(d4))
    UT.TestCompare(function() return d >= 9050 and d < 9150 end) -- check that the distance is approx 9km
    UT.TestCompare(function() return d2 >= 9050 and d2 < 9150 end) -- check that the distance is approx 9km
    UT.TestCompare(function() return d3 >= 11050 and d3 < 11150 end) -- check that the distance is approx 11km
    UT.TestCompare(function() return d4 >= 13650 and d4 < 13750 end) -- check that the distance is approx 13.6km
    UT.TestCompare(function() return Spatial.Distance(p1, p1) == 0 end) 
    
    local g1 = GROUP:Find(Group.getByName("SpatialUnitA"))
    local p4 = Spatial.PositionAt12Oclock(g1, 20)
    UT.TestCompare(function() return Spatial.Distance(p4, p1) > 19.95 and Spatial.Distance(p4, p1) < 20.05 end) 
  end
      
end)
