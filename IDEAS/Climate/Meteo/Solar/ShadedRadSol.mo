within IDEAS.Climate.Meteo.Solar;
model ShadedRadSol "Solar angle to surface"

  extends IDEAS.Climate.Meteo.Solar.RadSol(remDefVals=true);
    final parameter Real Fssky=(1 + cos(inc))/2
    "radiant-interchange configuration factor between surface and sky";
  BaseClasses.AngleAzimuth angleAzimuth(lat=lat, azi=azi)
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.Routing.RealPassThrough TskyPow4
    annotation (Placement(transformation(extent={{-78,42},{-64,56}})));
  Modelica.Blocks.Routing.RealPassThrough TePow4
    annotation (Placement(transformation(extent={{-78,22},{-64,36}})));
  Modelica.Blocks.Sources.RealExpression TenvExpr(y=(Fssky*TskyPow4.y + (1 -
        Fssky)*TePow4.y)^0.25) "Environment temperature"
    annotation (Placement(transformation(extent={{-36,80},{52,100}})));
equation
  connect(angleAzimuth.angDec, angSolar.angDec) annotation (Line(
      points={{-40,-24},{-52,-24},{-52,36},{-40,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angleAzimuth.angHou, angSolar.angHou) annotation (Line(
      points={{-40,-28},{-52,-28},{-52,32},{-40,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angleAzimuth.angZen, perez.angZen) annotation (Line(
      points={{-40,-32},{-52,-32},{-52,7},{0,7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TskyPow4.u, weaBus.TskyPow4) annotation (Line(
      points={{-79.4,49},{-100,49},{-100,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TePow4.u, weaBus.TePow4) annotation (Line(
      points={{-79.4,29},{-100,29},{-100,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TenvExpr.y, solBus.Tenv) annotation (Line(
      points={{56.4,90},{100,90},{100,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angleAzimuth.angAzi, solBus.angAzi) annotation (Line(
      points={{-20,-24},{100,-24},{100,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=false,
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
February 10, 2015 by Filip Jorissen:<br/>
Adjusted implementation for grouping of solar calculations.
</li>
</ul>
</html>"));
end ShadedRadSol;
