within IDEAS.Fluid.Examples;
record boiler_validation
  extends Modelica.Icons.Record;

  // T Boundary
  parameter Real TSet = 273.15 + 60;
  parameter Real TFix = 273.15 + 20;
  parameter Real TIni = 273.15 + 20;

  // heater
  parameter Real QNom = 5000;
  parameter Real tau_heatLoss = 3600;
  parameter Real mWater = 10;
  parameter Real cDry = 10000;

  // Saw
  parameter Real ampl_saw = 0.9998;
  parameter Real period_saw = 20000;
  parameter Real  offset_saw = 0.0001;
  parameter Real startTime_saw = 1000;

  // pump
  parameter Real m_pump = 0;
  parameter Real mFlowNom = 120/3600;
  parameter Real mFlowStart = 0.0001;
  parameter Real dpFix = 0;
  parameter Real etaTot = 0.8;

  //pipe
  parameter Real m_pipe = 5;

  //sine
  parameter Real ampl_sine = 20;
  parameter Real freqHz_sine = 1/5000;
  parameter Real offset_sine = 273.15 + 30;
  parameter Real startTime_sine = 20000;

end boiler_validation;
