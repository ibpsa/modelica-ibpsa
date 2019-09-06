within IBPSA.Fluid.FixedResistances;
model CheckValve "Hydraulic one way valve"

  extends IDEAS.Fluid.BaseClasses.PartialResistance(
    final dp_nominal=dpValve_nominal + dpFixed_nominal,
    dp(nominal=6000),
    final m_flow_turbulent=deltaM*abs(m_flow_nominal));
  extends IDEAS.Fluid.Actuators.BaseClasses.ValveParameters(rhoStd=
        Medium.density_pTX(
        101325,
        273.15 + 4,
        Medium.X_default));

  parameter Modelica.SIunits.PressureDifference dpFixed_nominal(
    displayUnit="Pa",
    min=0) = 0 "Pressure drop of pipe and other resistances that are in series"
    annotation (Dialog(group="Nominal condition"));

  parameter Real l(
    min=1e-10,
    max=1) = 0.001 "Valve leakage, l=Kv(y=0)/Kv(y=1)";

  parameter Real kFixed(
    unit="",
    min=0) = if dpFixed_nominal > Modelica.Constants.eps then m_flow_nominal/
    sqrt(dpFixed_nominal) else 0
    "Flow coefficient of fixed resistance that may be in series with valve, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2).";

  Real k(unit="", min=Modelica.Constants.small)
    "Flow coefficient of valve and pipe in series in allowed/forward direction, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2).";

  Real kRev(unit="", min=Modelica.Constants.small)
    "Flow coefficient of valve and pipe in series in restricted/reverse direction, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2).";

protected
  Real a, kstar;

initial equation
  assert(dpFixed_nominal > -Modelica.Constants.eps, "Require dpFixed_nominal >= 0. Received dpFixed_nominal = "
     + String(dpFixed_nominal) + " Pa.");

equation

  if (dpFixed_nominal > Modelica.Constants.eps) then
    k = sqrt(1/(1/kFixed^2 + 1/Kv_SI^2));
  else
    k = Kv_SI;
  end if;
  kRev=k*l;

  a = (1+tanh(dp/dpValve_nominal*5-5))/2;
  kstar = a*k + (1 - a)*kRev;

  m_flow = IDEAS.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(dp = dp, k = kstar, m_flow_turbulent = m_flow_turbulent);

  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
        Line(
          points={{-100,0},{-45,0}},
          color={0,128,255},
          lineThickness=0.2),
        Line(
          points={{0,45},{-45,0}},
          color={0,128,255},
          lineThickness=0.2),
        Line(
          points={{0,-45},{-45,0}},
          color={0,128,255},
          lineThickness=0.2),
        Ellipse(
          extent={{-30,-35},{40,35}},
          lineColor={0,128,255},
          fillColor={255,255,255},
          lineThickness=0.2,
          fillPattern=FillPattern.Solid),
        Line(
          points={{40,0},{100,0}},
          color={0,128,255},
          lineThickness=0.2)}));
end CheckValve;
