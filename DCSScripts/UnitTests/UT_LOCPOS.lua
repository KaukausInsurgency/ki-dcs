-- Unit Tests for Capture Point Class

UT.TestCase("LOCPOS", 
    function()
      UT.ValidateSetup(function() return ZONE:New("TestCPZone") ~= nil end)  -- zone must exist in ME
    end, nil,
    function()  
      local _z = ZONE:New("TestCPZone")
      local _zvec3 = _z:GetVec3(0)
      local _pv = POINT_VEC2:NewFromVec3(_zvec3)
      local _LatLong = _z:GetCoordinate():ToStringLLDDM()
      local _MGRS = _z:GetCoordinate():ToStringMGRS()
      
      -- testing constructor
      UT.TestCompare(function() return LOCPOS:NewFromZone(_z) ~= nil end)
      UT.TestCompare(function() return LOCPOS:NewFromVec3(_zvec3) ~= nil end)
            
      if true then
        local _lp = LOCPOS:NewFromZone(_z)
        UT.TestCompare(function() return _lp.Latitude == _pv:GetLat() end)
        UT.TestCompare(function() return _lp.Longitude == _pv:GetLon() end)
        UT.TestCompare(function() return string.match(_LatLong, _lp.LatLong) end)
        UT.TestCompare(function() return string.match(_MGRS, _lp.MGRS) end)
      end
      
      if true then
        local _lp = LOCPOS:NewFromVec3(_zvec3)
        UT.TestCompare(function() return _lp.Latitude == _pv:GetLat() end)
        UT.TestCompare(function() return _lp.Longitude == _pv:GetLon() end)
        UT.TestCompare(function() return string.match(_LatLong, _lp.LatLong) end)
        UT.TestCompare(function() return string.match(_MGRS, _lp.MGRS) end)
      end    
    end)
  
