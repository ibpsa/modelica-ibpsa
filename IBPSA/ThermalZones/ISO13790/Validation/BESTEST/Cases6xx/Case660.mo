within IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx;
model Case660 "Case 600, but with low-emissivity windows with Argon gas"
  extends IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx.Case600(zon5R1C(
      UWin=1.45,
      gFac=0.44,
      coeFac={1,-0.152,0.51,-0.526}));
end Case660;
