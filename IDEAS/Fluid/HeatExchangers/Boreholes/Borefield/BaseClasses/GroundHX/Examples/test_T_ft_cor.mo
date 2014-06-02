within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.BaseClasses.GroundHX.Examples;
model test_T_ft_cor
  extends Modelica.Icons.Example;
  import SI = Modelica.SIunits;

  parameter Data.StepResponse.example steRes;
  parameter Data.GeometricData.example geo;
  parameter Data.SoilData.example soi;
  parameter Data.Records.ShortTermResponse shoTerRes=
      Data.ShortTermResponse.example();

  SI.Temperature T_fts_cor;

  Integer timeSca "time step size for simulation";
  Integer timeSca_old;
  Integer i;
  Integer i_old;

  Integer t_old(start=0) "help variable for simulation timestep";
  Integer t_new(start=0) "help variable for simulation timestep";

algorithm
  t_old := t_new;
  t_new := max(t_old, integer(integer(time/timeSca)*timeSca/steRes.tStep));

algorithm
  when initial() then
    i :=integer(2);
    i_old :=i;
    timeSca :=integer(steRes.tStep);
    timeSca_old :=timeSca;
  elsewhen sample(steRes.tStep*10^1,steRes.tStep*10^i/5) then
    i_old :=i;
    i :=i_old+1;
    timeSca :=integer(timeSca_old*2);
    timeSca_old :=timeSca;
  end when;

equation
  T_fts_cor = HeatCarrierFluidStepTemperature(
    t_d=max(t_old, integer(integer(time/timeSca)*timeSca/steRes.tStep)),
    steRes=steRes,
    geo=geo,
    soi=soi,
    shoTerRes=shoTerRes);

  annotation (experiment(StopTime=720000, __Dymola_NumberOfIntervals=10),
      __Dymola_experimentSetupOutput);
end test_T_ft_cor;
