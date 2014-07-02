within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.VerticalSingleBorehole.BoreholeComponents;
model PipeHeatExchange
  "Pipe with heat exchange with surroundings on constant temperature"

  parameter Modelica.SIunits.ThermalConductance UAflowing
    "UA-value of the heat-transfer between the fluid and the surroundings on constant temperature, when there is a mass flow rate";

  parameter Modelica.SIunits.ThermalConductance UAstationary
    "UA-value of the heat-transfer between the fluid and the surroundings on constant temperature, when the fluid is stationary";

  Modelica.SIunits.ThermalConductance cMin
    "Heat capacity rate of the fluid, kg/s * J/kgK";
  Real NTU "Number of transfer units, dimensionless";
  Modelica.SIunits.HeatFlowRate Qmax "Maximal possible heatflow";
  Modelica.SIunits.Temperature Tinlet=if noEvent(flowPort_a.m_flow >= 0) then
      T_a else T_b "Inlet temperature";

  extends IDEAS.Thermal.Components.Interfaces.Partials.TwoPort;

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation (
      Placement(transformation(extent={{-10,-110},{10,-90}}, rotation=0)));
equation

  cMin = medium.cp*flowPort_a.m_flow;
  Qmax = cMin*(Tinlet - heatPort.T);

  // Calculation based on p662 of book "fundamentals of heat and mass transfer" by Frank P. Incroprera
  // Case: Cr = 0 , one fluid is at constant temperature: the ground

  if noEvent(abs(flowPort_a.m_flow) > 0.001) then
    NTU = UAflowing/cMin;
    Q_flow = (-1)*Qmax*(1 - exp(-NTU));

  else
    NTU = 0;
    Q_flow = UAstationary*(heatPort.T - T);

  end if;

  // energy exchange with medium
  Q_flow = heatPort.Q_flow;
  // defines heatPort's temperature
  //heatPort.T = T;
  // pressure drop = none
  flowPort_a.p = flowPort_b.p;
  annotation (
    Documentation(info="<html>
<p>Dieter Patteeuw. March April 2012.</p>
<p><b>Description</b> </p>
<p>Pipe with heat exchange. Based on the eta-NTU model.</p>
<p>If the fluid is flowing: use the eta-NTU model.</p>
<p>If the fluid is stationary: use a conductance model.</p>
<p><h4>Assumptions and limitations </h4></p>
<p>1. Under a certain threshold of mass flow rate, the fluid is modelled as stationary.</p>
<p><b>Model use</b> </p>
<p>1.&nbsp;Sub-model. Only use in <a href=\"VerticalSingleBorehole.SingleBorehole\">SingleBorehole</a>.</p>
<p><h4>Validation </h4></p>
<p>See description in <a href=\"VerticalSingleBorehole.SingleBorehole\">SingleBorehole</a></p>
<p><b>Example</b> </p>
<p>An example of this model can be found in the validation models (VerticalSingleBorehole.TestSpitlerConstant and VerticalSingleBorehole.TestSpitlerInterrupted)</p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-90,20},{90,-20}},
          lineColor={255,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),Text(extent={{-150,100},{150,40}},
          textString="%name"),Line(
          points={{-72,-20},{-8,-92},{-6,-92},{-48,-20},{-28,-20},{-4,-90},{-10,
            -20},{6,-20},{0,-90},{2,-92},{24,-20},{42,-20},{6,-90},{62,-20},{78,
            -20},{6,-94},{-2,-94}},
          color={255,0,0},
          smooth=Smooth.None)}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics));
end PipeHeatExchange;
