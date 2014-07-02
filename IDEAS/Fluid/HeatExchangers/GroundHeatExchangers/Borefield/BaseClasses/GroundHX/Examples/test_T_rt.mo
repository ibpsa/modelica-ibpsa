within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.GroundHX.Examples;
model test_T_rt
  extends Modelica.Icons.Example;

  parameter Data.StepResponse.example steRes;
  parameter Data.GeometricData.example geo;
  parameter Data.SoilData.example soi;

  Modelica.SIunits.Temperature T_rt;

equation
  if time < steRes.t_min_d*steRes.tStep then
    T_rt = 273.15;
  else
    T_rt = BoreFieldWallTemperature(
      t_d=integer(time/steRes.tStep),
      r=geo.rBor,
      steRes=steRes,
      geo=geo,
      soi=soi);
  end if;

  annotation (experiment(StopTime=700000, __Dymola_NumberOfIntervals=100),
      __Dymola_experimentSetupOutput);
end test_T_rt;
