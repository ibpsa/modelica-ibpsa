within IDEAS.Fluid.Actuators.Valves.Simplified.BaseClasses;
model Partial3WayValve "Partial for 3-way valves"
  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations;
  parameter Real tau = 1 "Valve opening time constant"
    annotation(Dialog(enable=dynamicValve,tab="Dynamics", group="Filter"));
  final parameter Modelica.SIunits.Mass m = m_flow_nominal*tau
    "Fluid content of the mixing valve";

  Modelica.Fluid.Interfaces.FluidPort_a port_a1(redeclare package Medium =
        Medium) "Hot fluid inlet"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(redeclare package Medium =
        Medium) "Cold fluid inlet"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium) "Fluid outlet"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  MixingVolumes.MixingVolume vol(nPorts=2,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    p_start=p_start,
    T_start=T_start,
    X_start=X_start,
    C_start=C_start,
    C_nominal=C_nominal,
    V=m/Medium.density(Medium.setState_pTX(
        Medium.p_default,
        Medium.T_default,
        Medium.X_default)),
    allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";

  Interfaces.IdealSource idealSource(redeclare package Medium = Medium,
      control_m_flow=true,
    allowFlowReversal=allowFlowReversal)
                           annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={0,-44})));
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal in medium, false restricts to design direction (ports[1] -> ports[2]). Used only if model has two ports.";
equation
  connect(port_a1, vol.ports[1]) annotation (Line(
      points={{-100,0},{-2,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_b, vol.ports[2]) annotation (Line(
      points={{100,0},{2,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(idealSource.port_a, port_a2) annotation (Line(
      points={{0,-54},{4.44089e-16,-54},{4.44089e-16,-100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(idealSource.port_b, vol.ports[1]) annotation (Line(
      points={{0,-34},{0,-4.44089e-16},{-2,-4.44089e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
            graphics),
    Icon(graphics={
        Polygon(
          points={{-60,30},{-60,-30},{0,0},{-60,30}},
          lineColor={0,0,127},
          smooth=Smooth.None),
        Polygon(
          points={{60,30},{60,-30},{0,0},{60,30}},
          lineColor={0,0,127},
          smooth=Smooth.None),
        Polygon(
          points={{-30,30},{-30,-30},{30,0},{-30,30}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          origin={0,-30},
          rotation=90),
        Ellipse(extent={{-20,80},{20,40}}, lineColor={0,0,127}),
        Line(
          points={{0,0},{0,40}},
          color={0,0,127},
          smooth=Smooth.None),
        Text(
          extent={{-10,70},{10,50}},
          lineColor={0,0,127},
          textString="M"),
        Line(
          points={{-70,30},{-70,-30}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{70,30},{70,-30}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-30,-70},{30,-70}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-70,0},{-100,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{70,0},{100,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{0,-70},{0,-100}},
          color={0,0,127},
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>3-way valve with temperature set point for mixing a cold and hot fluid to obtain outlet fluid at the desired temperature. If the desired temperature is higher than the hot fluid, no mixing will occur and the outlet will have the temperature of the hot fluid. </p>
<p>Inside the valve, the cold water flowrate is fixed with a pump component.  The fluid content in the valve is equally split between the mixing volume and this pump.  Without fluid content in the pump, this model does not work in all operating conditions.  </p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>Correct connections of hot and cold fluid to the corresponding flowPorts is NOT CHECKED.</li>
<li>The fluid content m of the valve has to be larger than zero</li>
<li>There is an internal parameter mFlowMin which sets a minimum mass flow rate for mixing to start. </li>
</ol></p>
<p><h4>Model use</h4></p>
<p><ol>
<li>Set medium and the internal fluid content of the valve (too small values of m could increase simulation times)</li>
<li>Set mFlowMin, the minimum mass flow rate for mixing to start. </li>
<li>Supply a set temperature at the outlet</li>
</ol></p>
<p><h4>Validation </h4></p>
<p>None </p>
<p><h4>Example (optional) </h4></p>
<p>Examples of this model can be found in<a href=\"modelica://IDEAS.Thermal.Components.Examples.TempMixingTester\"> IDEAS.Thermal.Components.Examples.TempMixingTester</a> and<a href=\"modelica://IDEAS.Thermal.Components.Examples.RadiatorWithMixingValve\"> IDEAS.Thermal.Components.Examples.RadiatorWithMixingValve</a></p>
</html>", revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Initial implementation
</li>
</ul>
</html>
"));
end Partial3WayValve;
