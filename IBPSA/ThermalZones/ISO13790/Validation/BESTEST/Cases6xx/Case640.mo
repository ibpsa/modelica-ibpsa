within IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx;
model Case640 "Case 600, but with heating schedule"
  extends IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx.Case600(TSetHea(
        table=[0,273.15 + 10; 7*3600,273.15 + 10; 8*3600,273.15 + 20; 23*3600,
          273.15 + 20; 23*3600,273.15 + 10; 24*3600,273.15 + 10],
        extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic));
  annotation (experiment(
      StopTime=31536000,
      Interval=3600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end Case640;
