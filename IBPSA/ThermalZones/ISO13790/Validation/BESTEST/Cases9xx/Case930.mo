within IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Cases9xx;
model Case930 "Case 920, but with added overhang and sidefins"
  extends Cases6xx.Case630(zon5R1C(redeclare
        IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Data.Case900Mass buiMas));
end Case930;
