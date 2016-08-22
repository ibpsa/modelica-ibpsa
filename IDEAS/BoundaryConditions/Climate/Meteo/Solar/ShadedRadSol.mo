within IDEAS.BoundaryConditions.Climate.Meteo.Solar;
model ShadedRadSol "Solar angle to surface"
  extends IDEAS.BoundaryConditions.Climate.Meteo.Solar.RadSol(final remDefVals=
        true);

  final parameter Real Fssky=(1 + cos(inc))/2
    "radiant-interchange configuration factor between surface and sky";
  Modelica.Blocks.Interfaces.RealInput TskyPow4
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-20,106})));
  Modelica.Blocks.Interfaces.RealInput TePow4
    annotation (Placement(transformation(extent={{-18,-18},{18,18}},
        rotation=270,
        origin={40,106})));

protected
  BaseClasses.AngleAzimuth angleAzimuth(
    final lat=lat,
    final azi=azi)
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Modelica.Blocks.Sources.RealExpression TenvExpr(
    y=(Fssky*TskyPow4 + (1 - Fssky)*TePow4)^0.25) "Environment temperature"
    annotation (Placement(transformation(extent={{0,70},{60,90}})));

equation
  connect(angleAzimuth.angDec, angSolar.angDec) annotation (Line(
      points={{0,-44},{-66,-44},{-66,36},{-40,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angleAzimuth.angHou, angSolar.angHou) annotation (Line(
      points={{0,-48},{-64,-48},{-64,32},{-40,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angleAzimuth.angZen, perez.angZen) annotation (Line(
      points={{0,-52},{-54,-52},{-54,-5},{0,-5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TenvExpr.y, solBus.Tenv) annotation (Line(
      points={{63,80},{100.1,80},{100.1,0.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angleAzimuth.angAzi, solBus.angAzi) annotation (Line(
      points={{20,-44},{100.1,-44},{100.1,0.1}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),  Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                      graphics={
        Polygon(
          points={{-90,-80},{-40,-40},{40,-40},{90,-80},{-90,-80}},
          lineColor={95,95,95},
          smooth=Smooth.None),
        Polygon(
          points={{16,-46},{22,-72},{-72,-4},{-18,-22},{16,-46}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Ellipse(
          extent={{88,84},{40,38}},
          lineColor={255,255,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(revisions="<html>
<ul>
<li>
March 25, 2016 by Filip Jorissen:<br/>
Reworked radSol implementation to use RealInputs instead of weaBus.
This simplifies translation and interpretation.
</li>
<li>
February 10, 2015 by Filip Jorissen:<br/>
Adjusted implementation for grouping of solar calculations.
</li>
</ul>
</html>"));
end ShadedRadSol;
