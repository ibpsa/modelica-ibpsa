within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.BaseClasses.GroundHX.Examples;
model T_ft_noCor_Florian
extends Modelica.Icons.Example;
  Modelica.SIunits.Temperature T(start=steRes.T_ini);
  Real g_val(start=0);
  Real ln_t_ts(start = -10);

  parameter Data.Records.StepResponse steRes=IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Data.StepResponse.example(tStep=  864000*30, T_ini=  273.15);
  parameter Data.Records.Geometry geo=IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Data.GeometricData.example_Florian();
  parameter Data.Records.Soil soi = IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Data.SoilData.example_Florian();

equation
  when sample(steRes.tStep,steRes.tStep) then
    T =  IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.BaseClasses.GroundHX.BoreFieldWallTemperature(
      t_d=integer(time/steRes.tStep),
      r=geo.rBor,
      steRes=steRes,
      geo=geo,
      soi=soi);
    g_val = (T-steRes.T_ini) * 2 * Modelica.Constants.pi * soi.k / steRes.q_ste;
    ln_t_ts = log( time / (geo.hBor^2/9/soi.alp));
  end when;

  annotation (experiment(StopTime=6.3e+008, __Dymola_NumberOfIntervals=1000),
      __Dymola_experimentSetupOutput);
end T_ft_noCor_Florian;
