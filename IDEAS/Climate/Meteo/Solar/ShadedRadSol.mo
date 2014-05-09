within IDEAS.Climate.Meteo.Solar;
model ShadedRadSol "Solar angle to surface"

  extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Modelica.SIunits.Angle inc(displayUnit="degree") "Inclination";
  parameter Modelica.SIunits.Angle azi(displayUnit="degree") "Azimuth";
  parameter Modelica.SIunits.Angle lat(displayUnit="degree") = sim.lat
    "Latitude";
  parameter Modelica.SIunits.Area A;

  outer IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  BaseClasses.Declination declination
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  BaseClasses.AngleHour angleHour
    annotation (Placement(transformation(extent={{-80,-2},{-60,18}})));
  BaseClasses.AngleSolar angSolar(
    inc=inc,
    azi=azi,
    lat=lat) annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  BaseClasses.solDirTil solDirTil(A=A, inc=inc)
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  BaseClasses.solDifTil solDifTil(A=A, inc=inc)
    annotation (Placement(transformation(extent={{0,-2},{20,18}})));
  BaseClasses.solradExtraTerra extraTerra
    annotation (Placement(transformation(extent={{-80,-24},{-60,-4}})));
  Modelica.Blocks.Interfaces.RealOutput solDir
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Modelica.Blocks.Interfaces.RealOutput solDif
    annotation (Placement(transformation(extent={{90,10},{110,30}})));
  BaseClasses.AngleZenith angleZenith(lat=lat)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Interfaces.RealOutput angInc "Angle of incidence"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Modelica.Blocks.Interfaces.RealOutput angZen "Angle of incidence"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Blocks.Interfaces.RealOutput angAzi "Azimuth angle"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));
  BaseClasses.AngleAzimuth angleAzimuth(lat=lat, azi=azi)
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
equation
  connect(declination.delta, angSolar.angDec) annotation (Line(
      points={{-60,36},{-40,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angleHour.angHou, angSolar.angHou) annotation (Line(
      points={{-60,14},{-48,14},{-48,32},{-40,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solDirTil.solDirTil, solDir) annotation (Line(
      points={{20,36},{56,36},{56,60},{100,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solDifTil.solDifTil, solDif) annotation (Line(
      points={{20,14},{56,14},{56,20},{100,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(declination.delta, angleZenith.angDec) annotation (Line(
      points={{-60,36},{-50,36},{-50,6},{-40,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angleHour.angHou, angleZenith.angHou) annotation (Line(
      points={{-60,14},{-50,14},{-50,2},{-40,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angleZenith.angZen, solDifTil.angZen) annotation (Line(
      points={{-20,6},{-6,6},{-6,10},{0,10}},
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
  connect(angleZenith.angZen, angZen) annotation (Line(
      points={{-20,6},{-12,6},{-12,-60},{100,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angleZenith.angZen, angleAzimuth.angZen) annotation (Line(
      points={{-20,6},{-18,6},{-18,-12},{-46,-12},{-46,-32},{-40,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angleHour.angHou, angleAzimuth.angHou) annotation (Line(
      points={{-60,14},{-52,14},{-52,-28},{-40,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(declination.delta, angleAzimuth.angDec) annotation (Line(
      points={{-60,36},{-50,36},{-50,-24},{-40,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angleAzimuth.angAzi, angAzi) annotation (Line(
      points={{-20,-24},{-14,-24},{-14,-80},{100,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics={
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
