within IDEAS.Fluid.BaseCircuits;
model ActiveMixingCircuit "Active mixing circuit"

  //Extensions
  extends Interfaces.Circuit;
  extends IDEAS.Fluid.Actuators.BaseClasses.ValveParameters;
  //Interfaces
  Modelica.Blocks.Interfaces.RealOutput T "Supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,100})));
  Modelica.Blocks.Interfaces.RealInput TMixedSet
    "Setpoint for the supply temperature"                                              annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,100})));
  Modelica.Blocks.Interfaces.RealInput m_flow_in "Mass flow rate set point" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,104})));

  //Components
  Valves.Thermostatic3WayValve threeWayValveMotor(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-30,50},{-10,70}})));

  Sensors.TemperatureTwoPort senTem(
    m_flow_nominal=m_flow_nominal,
    tau=120,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

  Movers.FlowMachine_m_flow pump(
    motorCooledByFluid=false,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{18,50},{38,70}})));

  replaceable FixedResistances.LosslessPipe mixPipe(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium)              constrainedby
    IDEAS.Fluid.Interfaces.Partials.PipeTwoPort
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-20,10})), choicesAllMatching=true);

equation
  connect(senTem.port_b, port_b1) annotation (Line(
      points={{80,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem.T, T) annotation (Line(
      points={{70,71},{70,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(threeWayValveMotor.TMixedSet, TMixedSet) annotation (Line(
      points={{-20,70},{-20,100},{-40,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(threeWayValveMotor.port_b, pump.port_a) annotation (Line(
      points={{-10,60},{18,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump.port_b, senTem.port_a) annotation (Line(
      points={{38,60},{60,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(m_flow_in, pump.m_flow_in) annotation (Line(
      points={{20,100},{20,82},{27.8,82},{27.8,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pip2.port_b, threeWayValveMotor.port_a2) annotation (Line(
      points={{-20,20},{-20,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pip2.port_a, pipeReturn.port_b) annotation (Line(
      points={{-20,0},{-20,-60},{60,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_b2, pipeReturn.port_b) annotation (Line(
      points={{-100,-60},{60,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipeSupply.port_b, threeWayValveMotor.port_a1) annotation (Line(
      points={{-60,60},{-30,60}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
Documentation(
info="<html><p>
This model is the base circuit implementation of an active mixing circuit and makes use of <a href=\"modelica://IDEAS.Fluid.Valves.Thermostatic3WayValve\">IDEAS.Fluid.Valves.Thermostatic3WayValve</a>. 
The flow is regulated by a mass-flow controlled pump after the mixing point.
</p></html>",
revisions="<html>
<p><ul>
<li>November 2014 by Filip Jorissen:<br> 
Initial version</li>
</ul></p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Line(
          points={{-40,100},{-34,80},{-40,60}},
          color={0,255,128},
          smooth=Smooth.None),
        Line(
          points={{-40,40},{-40,-60}},
          color={0,0,127},
          smooth=Smooth.None,
          pattern=LinePattern.Dash),
        Line(
          points={{-40,60},{-20,60}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{70,100},{76,80},{74,60}},
          color={255,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{72,62},{76,58}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-60,70},{-60,50},{-40,60},{-60,70}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,70},{-20,50},{-40,60},{-20,70}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{10,-10},{10,10},{-10,0},{10,-10}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          origin={-40,50},
          rotation=270),
        Ellipse(extent={{0,80},{40,40}},  lineColor={0,0,127},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{20,104},{26,84},{18,64}},
          color={0,255,128},
          smooth=Smooth.None),
        Polygon(
          points={{8,76},{8,44},{40,60},{8,76}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end ActiveMixingCircuit;
