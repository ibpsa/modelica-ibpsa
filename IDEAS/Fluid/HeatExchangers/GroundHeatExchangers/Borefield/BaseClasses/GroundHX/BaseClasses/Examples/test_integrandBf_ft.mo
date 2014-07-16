within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.GroundHX.BaseClasses.Examples;
model test_integrandBf_ft
  extends Modelica.Icons.Example;

  parameter Integer lim=5;
  Real int;

algorithm
  if time < 0.00785 then
    int := 0;
  else
    int := integrandBf_bt(D=100, rBor=0.1, u=time*lim, nbBh=2, cooBh={{0,0},{1,1}});
  end if;
  annotation (experiment(
      StopTime=1,
      __Dymola_NumberOfIntervals=1000,
      Tolerance=1e-005,
      __Dymola_Algorithm="Dassl"), __Dymola_experimentSetupOutput);
end test_integrandBf_ft;
