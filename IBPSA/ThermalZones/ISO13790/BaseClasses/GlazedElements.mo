within IBPSA.ThermalZones.ISO13790.BaseClasses;
model GlazedElements
  parameter Integer n;
  parameter Real AWin[:] "Area of windows";
  parameter Real surTil[:] "Tilt angle of surfaces";
  parameter Real surAzi[:] "Azimuth angle of surfaces";
  parameter Real gFac "Energy transmittance of glazings";
  parameter Real winFra "Frame fraction of windows";

  IBPSA.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-120,-20},{-80,20}}), iconTransformation(extent=
           {{-110,-10},{-90,10}})));
  BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[n](til=surTil, azi=surAzi)
    "Direct solar irradiation on surface"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Math.Gain solRad[n](k=AWin*gFac*0.9*(1 - winFra))
    "Solar radiation"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=n) "Sum of all orientations"
    annotation (Placement(transformation(extent={{62,-6},{74,6}})));
  Modelica.Blocks.Interfaces.RealOutput solRadWin
    "Solar radiation through windows"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil [n](til=surTil, azi=surAzi)
    "Diffuse solar irradiation on surface"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Math.Add irr [n]
    "Total of direct and diffuse radiation on surface"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
equation
  for i in 1:n loop
  connect(weaBus,HDifTil [i].weaBus) annotation (Line(
      points={{-100,0},{-72,0},{-72,-30},{-60,-30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  end for;

  for i in 1:n loop
  connect(weaBus,HDirTil [i].weaBus) annotation (Line(
      points={{-100,0},{-72,0},{-72,30},{-60,30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  end for;
  connect(solRad.y, multiSum.u)
    annotation (Line(points={{41,0},{62,0}}, color={0,0,127}));
  connect(multiSum.y, solRadWin)
    annotation (Line(points={{75.02,0},{110,0}}, color={0,0,127}));
  connect(HDirTil.H,irr. u1) annotation (Line(points={{-39,30},{-30,30},{-30,6},
          {-22,6}}, color={0,0,127}));
  connect(HDifTil.H,irr. u2) annotation (Line(points={{-39,-30},{-30,-30},{-30,-6},
          {-22,-6}}, color={0,0,127}));

  connect(irr.y, solRad.u)
    annotation (Line(points={{1,0},{18,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-34,88},{-84,38}},
          lineColor={255,255,0},
          lineThickness=0.5,
          fillColor={244,125,35},
          fillPattern=FillPattern.Sphere),
        Polygon(
          points={{22,88},{-18,68},{-18,-92},{22,-52},{22,88}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Text(
          extent={{-108,148},{114,116}},
          textColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GlazedElements;
