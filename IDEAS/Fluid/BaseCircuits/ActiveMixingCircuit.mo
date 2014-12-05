within IDEAS.Fluid.BaseCircuits;
model ActiveMixingCircuit "Active mixing circuit"

  //Extensions
  extends PartialCircuit;

  //Components
  Valves.Thermostatic3WayValve threeWayValveMotor(m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Sensors.TemperatureTwoPort senTem(m_flow_nominal=m_flow_nominal, tau=120,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  FixedResistances.LosslessPipe pip(m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  FixedResistances.LosslessPipe pip1(m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium)
                                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,10})));
  FixedResistances.LosslessPipe pip3(m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{60,-70},{40,-50}})));

  //Interfaces
  Modelica.Blocks.Interfaces.RealOutput T annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,100})));
  Modelica.Blocks.Interfaces.RealInput TMixedSet annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,100}),   iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,100})));
equation
  connect(pip3.port_a, port_a2) annotation (Line(
      points={{60,-60},{100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pip3.port_b, pip1.port_a) annotation (Line(
      points={{40,-60},{-10,-60},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pip3.port_b, port_b2) annotation (Line(
      points={{40,-60},{-100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(threeWayValveMotor.port_a2, pip1.port_b) annotation (Line(
      points={{-10,50},{-10,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_a1, pip.port_a) annotation (Line(
      points={{-100,60},{-60,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pip.port_b, threeWayValveMotor.port_a1) annotation (Line(
      points={{-40,60},{-20,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem.port_b, port_b1) annotation (Line(
      points={{80,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem.T, T) annotation (Line(
      points={{70,71},{70,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(threeWayValveMotor.TMixedSet, TMixedSet) annotation (Line(
      points={{-10,70},{-10,86},{-10,100},{0,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(threeWayValveMotor.port_b, senTem.port_a) annotation (Line(
      points={{0,60},{60,60}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(revisions="<html>
<p><ul>
<li>November 2014 by Filip Jorissen:<br> 
Initial version</li>
</ul></p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
        graphics={
        Line(
          points={{0,100},{6,80},{0,60}},
          color={0,255,128},
          smooth=Smooth.None),
        Line(
          points={{-40,60},{-100,60}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{60,60},{100,60}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-100,-60},{100,-60}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{0,40},{0,20}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{0,-20},{0,-60}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{0,60},{20,60}},
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
          points={{-20,70},{-20,50},{0,60},{-20,70}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{20,70},{20,50},{0,60},{20,70}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{10,-10},{10,10},{-10,0},{10,-10}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          origin={0,50},
          rotation=270),
        Polygon(
          points={{10,-10},{10,10},{-10,0},{10,-10}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          origin={0,-10},
          rotation=270),
        Polygon(
          points={{10,-10},{10,10},{-10,0},{10,-10}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          origin={0,10},
          rotation=90)}));
end ActiveMixingCircuit;
