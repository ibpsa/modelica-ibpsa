within IDEAS.Climate.Meteo.Solar;
model ShadedRadSol "Solar angle to surface"

  extends IDEAS.Climate.Meteo.Solar.RadSol;

  Modelica.Blocks.Interfaces.RealOutput angAzi "Azimuth angle"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));
  BaseClasses.AngleAzimuth angleAzimuth(lat=lat, azi=azi)
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
equation
  connect(angleAzimuth.angAzi, angAzi) annotation (Line(
      points={{-20,-24},{-14,-24},{-14,-80},{100,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angleAzimuth.angDec, angSolar.angDec) annotation (Line(
      points={{-40,-24},{-54,-24},{-54,36},{-40,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angleAzimuth.angHou, angSolar.angHou) annotation (Line(
      points={{-40,-28},{-48,-28},{-48,32},{-40,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angleAzimuth.angZen, solDifTil.angZen) annotation (Line(
      points={{-40,-32},{-46,-32},{-46,16},{-28,16},{-28,10},{0,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(graphics={
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
          fillPattern=FillPattern.Solid)}));
end ShadedRadSol;
