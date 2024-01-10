within IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx;
model Case695
  extends IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx.Case600(
    zon5R1C(UWal=0.15, URoo=0.1),
    TSetHea(table=[0.0,273.15 + 19.9]),
    TSetCoo(table=[0.0,273.15 + 20.1]));
end Case695;
