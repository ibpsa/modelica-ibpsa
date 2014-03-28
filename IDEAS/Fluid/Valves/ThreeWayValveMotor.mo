within IDEAS.Fluid.Valves;
model ThreeWayValveMotor
  "Ideal three way valve with a krane controlled with a Real input with value between 0 and 1"

  parameter IDEAS.Thermal.Data.Interfaces.Medium medium=IDEAS.Thermal.Data.Media.Water();

public
  IDEAS.Thermal.Components.Interfaces.FlowPort_a                    flowPort_a1(medium=medium, h(
      start=293.15*medium.cp,
      min=1140947,
      max=1558647)) "= ctrl * flowPort_a"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));

  IDEAS.Thermal.Components.Interfaces.FlowPort_a                    flowPort_a2(medium=medium, h(
      start=293.15*medium.cp,
      min=1140947,
      max=1558647)) "=(1-ctrl)"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{-10,-110},{10,-90}})));

  IDEAS.Thermal.Components.Interfaces.FlowPort_b                    flowPort_b(medium=medium, h(
      start=293.15*medium.cp,
      min=1140947,
      max=1558647))
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));

  Modelica.Blocks.Interfaces.RealInput ctrl(min=0, max=1)
    "procentage of flow from flowPort_a1" annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,104}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-10,94})));

  parameter Modelica.SIunits.MassFlowRate m_flowNom = 10;

  IDEAS.Fluid.Movers.Pump pumpFlow(
    useInput=true,
    medium=medium,
    m=0,
    m_flowNom=m_flowNom,
    dpFix=0) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-44,0})));
protected
  IDEAS.Thermal.Components.BaseClasses.MixingVolume                          mixingVolume(
    medium=medium,
    nbrPorts=3,
    m=0.01)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={10,-40})));
equation
  pumpFlow.m_flowSet = - ctrl * flowPort_b.m_flow / m_flowNom;

  connect(flowPort_a1, pumpFlow.flowPort_a) annotation (Line(
      points={{-100,0},{-54,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pumpFlow.flowPort_b,flowPort_b)  annotation (Line(
      points={{-34,0},{100,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(flowPort_a2, mixingVolume.flowPorts[1]) annotation (Line(
      points={{0,-100},{0,-40},{-0.666667,-40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(mixingVolume.flowPorts[2], flowPort_b) annotation (Line(
      points={{0,-40},{0,0},{100,0}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=false,
                   extent={{-100,-100},{100,100}}),
                                      graphics={
        Polygon(
          points={{-60,30},{-60,-30},{0,0},{-60,30}},
          lineColor={100,100,100},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{60,30},{60,-30},{0,0},{60,30}},
          lineColor={100,100,100},
          smooth=Smooth.None),
        Polygon(
          points={{-30,30},{-30,-30},{30,0},{-30,30}},
          lineColor={100,100,100},
          smooth=Smooth.None,
          origin={0,-30},
          rotation=90,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
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
          smooth=Smooth.None),
        Line(
          points={{-40,10},{-52,-14},{-52,-14},{-52,-14}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=1),
        Ellipse(extent={{-54,10},{-48,2}}, lineColor={0,0,0},
          lineThickness=1),
        Ellipse(extent={{-46,-6},{-40,-14}}, lineColor={0,0,0},
          lineThickness=1),
        Rectangle(extent={{-20,80},{20,40}}, lineColor={100,100,100}),
        Text(
          extent={{-20,80},{20,40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="M"),
        Line(
          points={{0,40},{0,-2},{0,0}},
          color={100,100,100},
          smooth=Smooth.None),
        Text(
          extent={{-100,-56},{100,-100}},
          lineColor={0,0,255},
          textString="%name")}),
    Documentation(revisions="<html>
<p><ul>
<li>January 2014, Damien Picard<br/><i>First implementation</i></li>
</ul></p>
</html>"));
end ThreeWayValveMotor;
