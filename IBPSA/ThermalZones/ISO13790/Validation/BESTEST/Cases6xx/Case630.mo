within IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx;
model Case630 "Case 620, but with added overhang and sidefins"
  extends IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx.Case600(zon5R1C(AWin
        ={0,6,0,6}, shaRedFac=0.846*0.915));
end Case630;
