within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.Records;
record StepResponse
  "Parameter for the calculation of the step response of the borefield"
  extends Modelica.Icons.Record;
  import SI = Modelica.SIunits;

  parameter String path="IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.Records.StepResponse";

  parameter SI.Time tStep=3600 "[s] time resolution of the step-response";
  parameter Integer t_min_d=1 "[-] Mininum simulation discrete time";
  final parameter Integer tSteSta_d=integer(3600*24*365*30/tStep)
    "[-] discrete time to reach steady state (default = 30 years)";
  parameter Integer tBre_d=100
    "[-] discrete time upper boundary for saving results (tBre_d * tStep) should be > 100 hours";
  parameter Real q_ste(unit="W/m") = 30
    "Power per length borehole of step load input";
  parameter SI.MassFlowRate m_flow=0.3 "Flow through the pipe";
  parameter SI.Temperature T_ini=273.15 "Initial temperature";
end StepResponse;
