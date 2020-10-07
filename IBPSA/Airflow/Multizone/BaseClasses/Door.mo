within IBPSA.Airflow.Multizone.BaseClasses;
partial model Door
  "Door model for bi-directional flow"
  extends IBPSA.Fluid.Interfaces.PartialFourPortInterface(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    final allowFlowReversal1=true,
    final allowFlowReversal2=true,
    final m1_flow_nominal=10/3600*1.2,
    final m2_flow_nominal=m1_flow_nominal,
    final m1_flow_small=1E-4*abs(m1_flow_nominal),
    final m2_flow_small=1E-4*abs(m2_flow_nominal));

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = IBPSA.Media.Air "Moist air")));

  parameter Modelica.SIunits.Length wOpe=0.9 "Width of opening"
    annotation (Dialog(group="Geometry"));
  parameter Modelica.SIunits.Length hOpe=2.1 "Height of opening"
    annotation (Dialog(group="Geometry"));

  parameter Modelica.SIunits.PressureDifference dp_turbulent(
    min=0,
    displayUnit="Pa") = 0.01
    "Pressure difference where laminar and turbulent flow relation coincide. Recommended: 0.01";

  Modelica.SIunits.VolumeFlowRate VAB_flow(nominal=0.001)
    "Volume flow rate from A to B if positive";
  Modelica.SIunits.VolumeFlowRate VBA_flow(nominal=0.001)
    "Volume flow rate from B to A if positive";
  Modelica.SIunits.MassFlowRate mAB_flow(nominal=0.001)
    "Mass flow rate from A to B if positive";
  Modelica.SIunits.MassFlowRate mBA_flow(nominal=0.001)
    "Mass flow rate from B to A if positive";

  Modelica.SIunits.Velocity vAB(nominal=0.01) "Average velocity from A to B";
  Modelica.SIunits.Velocity vBA(nominal=0.01) "Average velocity from B to A";

protected
  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default);

  parameter Modelica.SIunits.Density rho_default=Medium.density(sta_default)
    "Density";

  Modelica.SIunits.Density rho_a1_inflow
    "Density of air flowing in from port_a1";
  Modelica.SIunits.Density rho_a2_inflow
    "Density of air flowing in from port_a2";

equation
  // Compute the density of the inflowing media.
  rho_a1_inflow = Medium1.density(state_a1_inflow);
  rho_a2_inflow = Medium2.density(state_a2_inflow);

  mAB_flow = rho_a1_inflow*VAB_flow;
  mBA_flow = rho_a2_inflow*VBA_flow;
  // Average velocity (using the whole orifice area)
  vAB = VAB_flow/A;
  vBA = VBA_flow/A;

  port_a1.m_flow = mAB_flow;
  port_a2.m_flow = mBA_flow;

  // Energy balance (no storage, no heat loss/gain)
  port_a1.h_outflow = inStream(port_b1.h_outflow);
  port_b1.h_outflow = inStream(port_a1.h_outflow);
  port_a2.h_outflow = inStream(port_b2.h_outflow);
  port_b2.h_outflow = inStream(port_a2.h_outflow);

  // Mass balance (no storage)
  port_a1.m_flow = -port_b1.m_flow;
  port_a2.m_flow = -port_b2.m_flow;

  port_a1.Xi_outflow = inStream(port_b1.Xi_outflow);
  port_b1.Xi_outflow = inStream(port_a1.Xi_outflow);
  port_a2.Xi_outflow = inStream(port_b2.Xi_outflow);
  port_b2.Xi_outflow = inStream(port_a2.Xi_outflow);

  // Transport of trace substances
  port_a1.C_outflow = inStream(port_b1.C_outflow);
  port_b1.C_outflow = inStream(port_a1.C_outflow);
  port_a2.C_outflow = inStream(port_b2.C_outflow);
  port_b2.C_outflow = inStream(port_a2.C_outflow);

  annotation (
    Icon(graphics={
        Rectangle(
          extent={{-60,80},{60,-84}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={85,75,55},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-54,72},{56,-84}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{56,72},{-36,66},{-36,-90},{56,-84},{56,72}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-30,-10},{-16,-8},{-16,-14},{-30,-16},{-30,-10}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
This is a partial model for the bi-directional air flow through a door.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 6, 2020, by Michael Wetter:<br/>
First implementation for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1353\">#1353</a>.
</li>
</ul>
</html>"));
end Door;
