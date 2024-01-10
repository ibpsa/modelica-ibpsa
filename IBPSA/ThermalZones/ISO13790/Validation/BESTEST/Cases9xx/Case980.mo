within IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Cases9xx;
model Case980 "Case 900, but with increased exterior wall and roof insulation"
  extends Cases6xx.Case680(zon5R1C(redeclare
        IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Data.Case900Mass buiMas));
end Case980;
