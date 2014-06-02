within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.GroundHX.BaseClasses.Examples;
model test_ierf
  extends Modelica.Icons.Example;

  parameter Integer lim=5000;
  Real y_ierf;

algorithm
  y_ierf := ierf(u=time*lim);
  annotation (experiment(
      StopTime=1,
      __Dymola_NumberOfIntervals=1000,
      Tolerance=1e-005,
      __Dymola_Algorithm="Dassl"), __Dymola_experimentSetupOutput);
end test_ierf;
