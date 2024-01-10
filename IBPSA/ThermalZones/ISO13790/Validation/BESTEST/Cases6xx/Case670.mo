within IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx;
model Case670 "Case 600, but has single pane window with clear glass"
  extends IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx.Case600(zon5R1C(
      UWin=7.8,
      gFac=0.864,
      coeFac={0.998,0.137,-0.745,1.21,-0.668}));
end Case670;
