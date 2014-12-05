within IDEAS.Fluid.BaseCircuits;
model PumpSupply "Pump on supply duct"
  //Extensions
  extends PartialCircuit;

  Sensors.TemperatureTwoPort senTem(m_flow_nominal=m_flow_nominal, redeclare
      package Medium = Medium,
    tau=120)
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  FixedResistances.LosslessPipe pip(m_flow_nominal=m_flow_nominal, redeclare
      package Medium = Medium)
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  FixedResistances.LosslessPipe pip3(m_flow_nominal=m_flow_nominal, redeclare
      package Medium = Medium)
    annotation (Placement(transformation(extent={{60,-70},{40,-50}})));
  Modelica.Blocks.Interfaces.RealOutput T annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,100})));
  Modelica.Blocks.Interfaces.RealInput m_flow_in annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={30,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,100})));
  Movers.FlowMachine_m_flow pump(
    motorCooledByFluid=false,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
equation
  connect(pip3.port_a, port_a2) annotation (Line(
      points={{60,-60},{100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pip3.port_b, port_b2) annotation (Line(
      points={{40,-60},{-100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_a1, pip.port_a) annotation (Line(
      points={{-100,60},{-60,60}},
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
  connect(pip.port_b, pump.port_a) annotation (Line(
      points={{-40,60},{20,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump.port_b, senTem.port_a) annotation (Line(
      points={{40,60},{60,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(m_flow_in, pump.m_flow_in) annotation (Line(
      points={{30,100},{30,72},{29.8,72}},
      color={0,0,127},
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
        Ellipse(extent={{20,80},{60,40}}, lineColor={0,0,127},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{60,60},{100,60}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-100,-60},{100,-60}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-100,60},{20,60}},
          color={0,0,127},
          smooth=Smooth.None),
        Ellipse(
          extent={{72,62},{76,58}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{70,100},{76,80},{74,60}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{40,100},{44,86},{40,70}},
          color={0,255,128},
          smooth=Smooth.None),
        Polygon(
          points={{28,76},{28,44},{60,60},{28,76}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end PumpSupply;
