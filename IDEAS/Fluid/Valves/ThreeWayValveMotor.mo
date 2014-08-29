within IDEAS.Fluid.Valves;
model ThreeWayValveMotor
  "Ideal three way valve with a krane controlled with a Real input with value between 0 and 1"
  extends BaseClasses.Partial3WayValve;

public
  Modelica.Blocks.Interfaces.RealInput ctrl(min=0, max=1)
    "procentage of flow through flowPort_a1" annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,106}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-10,96})));

  Modelica.Blocks.Sources.RealExpression realExpression(y=-(1 - ctrl)*port_b.m_flow)
    annotation (Placement(transformation(extent={{92,-60},{28,-40}})));
equation

  connect(realExpression.y, idealSource.m_flow_in) annotation (Line(
      points={{24.8,-50},{8,-50}},
      color={0,0,127},
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
        Line(
          points={{0,40},{0,-2},{0,0}},
          color={100,100,100},
          smooth=Smooth.None),
        Text(
          extent={{-100,-56},{100,-100}},
          lineColor={0,0,255},
          textString="%name")}),
    Documentation(revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Annex60 compatibility
</li>
<li>January 2014, Damien Picard:<br/> 
First implementation
</li>
</ul>
</html>
"));
end ThreeWayValveMotor;
