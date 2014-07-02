within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.BaseClasses.GroundHX.Verification;
model T_rt_bertagnolio_MB_A8
  extends Icons.VerificationModel;

  parameter Data.GenericStepParam.Validation_bertagnolio_SB_A genStePar;
  parameter Data.BorefieldGeometricData.Validation_bertagnolio_MB_A8 bfGeo;
  parameter Data.SoilData.Validation_bertagnolio_SB_A soi;

  Modelica.SIunits.Temperature T_rt;

  Integer timeSca "time step size for simulation";
  Integer timeSca_old;
  Integer i;
  Integer i_old;

  Integer t_old(start=0) "help variable for simulation timestep";
  Integer t_new(start=0) "help variable for simulation timestep";

algorithm
  t_old := t_new;
  t_new := max(t_old, integer(integer(time/timeSca)*timeSca/genStePar.tStep));

algorithm
  when initial() then
    i :=integer(2);
    i_old :=i;
    timeSca :=integer(genStePar.tStep);
    timeSca_old :=timeSca;
  elsewhen sample(genStePar.tStep*10^1,genStePar.tStep*10^i/5) then
    i_old :=i;
    i :=i_old+1;
    timeSca :=integer(timeSca_old*2);
    timeSca_old :=timeSca;
  end when;

equation

  T_rt = BoreFieldWallTemperature(
    t_d=max(t_old, integer(integer(time/timeSca)*timeSca/genStePar.tStep)),
    r=bfGeo.rBor,
    genStePar=genStePar,
    bfGeo=bfGeo,
    soi=soi);
  annotation (experiment(StopTime=2.20752e+009, __Dymola_NumberOfIntervals=
          100), __Dymola_experimentSetupOutput);
end T_rt_bertagnolio_MB_A8;
