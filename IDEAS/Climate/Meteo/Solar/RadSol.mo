within IDEAS.Climate.Meteo.Solar;
model RadSol "solar angle to surface"

  extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Modelica.SIunits.Angle inc(displayUnit="degree") "inclination";
  parameter Modelica.SIunits.Angle azi(displayUnit="degree") "azimuth";
  parameter Modelica.SIunits.Angle lat(displayUnit="degree") = sim.lat
    "latitude";
  parameter Modelica.SIunits.Area A;

  outer IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Modelica.Blocks.Sources.RealExpression
                        angleHour(y=sim.angHou)
    annotation (Placement(transformation(extent={{-98,-8},{-64,12}})));
  BaseClasses.AngleSolar angSolar(
    inc=inc,
    azi=azi,
    lat=lat) annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  BaseClasses.solDirTil solDirTil(A=A, inc=inc)
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  BaseClasses.solDifTil solDifTil(A=A, inc=inc)
    annotation (Placement(transformation(extent={{0,-2},{20,18}})));
  Modelica.Blocks.Interfaces.RealOutput solDir
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Modelica.Blocks.Interfaces.RealOutput solDif
    annotation (Placement(transformation(extent={{90,10},{110,30}})));
  Modelica.Blocks.Interfaces.RealOutput angInc "Angle of incidence"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Modelica.Blocks.Interfaces.RealOutput angZen "Angle of incidence"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Blocks.Sources.RealExpression declination(y=sim.angDec)
    annotation (Placement(transformation(extent={{-98,26},{-64,46}})));
  Modelica.Blocks.Sources.RealExpression angleZenith(y=sim.angZen)
    annotation (Placement(transformation(extent={{-98,6},{-64,26}})));
equation
  connect(solDirTil.solDirTil, solDir) annotation (Line(
      points={{20,36},{56,36},{56,60},{100,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solDifTil.solDifTil, solDif) annotation (Line(
      points={{20,14},{56,14},{56,20},{100,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angSolar.angInc, solDifTil.angInc) annotation (Line(
      points={{-20,36},{-4,36},{-4,14},{0,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angSolar.angInc, solDirTil.angSol) annotation (Line(
      points={{-20,36},{0,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angSolar.angInc, angInc) annotation (Line(
      points={{-20,36},{-10,36},{-10,-40},{100,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(declination.y, angSolar.angDec) annotation (Line(
      points={{-62.3,36},{-40,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angleHour.y, angSolar.angHou) annotation (Line(
      points={{-62.3,2},{-48,2},{-48,32},{-40,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angleZenith.y, solDifTil.angZen) annotation (Line(
      points={{-62.3,16},{-28,16},{-28,10},{0,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angZen, solDifTil.angZen) annotation (Line(
      points={{100,-60},{-28,-60},{-28,10},{0,10}},
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
end RadSol;
