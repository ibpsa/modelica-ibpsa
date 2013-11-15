within IDEAS.Thermal.Components.Distribution;
model ThreeWayValve "Temperature based ideal mixer"

  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water();

public
  Thermal.Components.Interfaces.FlowPort_a flowPort_a(medium=medium, h(
      start=293.15*medium.cp,
      min=1140947,
      max=1558647))
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));

  Thermal.Components.Interfaces.FlowPort_a flowPort_b2(medium=medium, h(
      start=293.15*medium.cp,
      min=1140947,
      max=1558647))
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{-10,-110},{10,-90}})));

  Thermal.Components.Interfaces.FlowPort_a flowPort_b1(medium=medium, h(
      start=293.15*medium.cp,
      min=1140947,
      max=1558647))
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));

equation
  connect(flowPort_a, flowPort_b1) annotation (Line(
      points={{-100,0},{100,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(flowPort_a, flowPort_b2) annotation (Line(
      points={{-100,0},{0,0},{0,-100}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics={
        Polygon(
          points={{-60,30},{-60,-30},{0,0},{-60,30}},
          lineColor={100,100,100},
          smooth=Smooth.None),
        Polygon(
          points={{60,30},{60,-30},{0,0},{60,30}},
          lineColor={100,100,100},
          smooth=Smooth.None),
        Polygon(
          points={{-30,30},{-30,-30},{30,0},{-30,30}},
          lineColor={100,100,100},
          smooth=Smooth.None,
          origin={0,-30},
          rotation=90),
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
          smooth=Smooth.None)}));
end ThreeWayValve;
