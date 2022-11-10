within IBPSA.ThermalZones.ISO13790.BaseClasses;
model GlazedElements "Solar heat gains of glazed elements"
  parameter Real groRef = 0.2 "Ground reflectance"
    annotation(Evaluate=true, Dialog(tab = "General", group = "Location"));
  parameter Modelica.Units.SI.Area[4] AWin={0,0,6,0} "Areas of windows"
    annotation (Evaluate=true, Dialog(tab="General", group="Window data"));
  parameter Real winFra = 0.01 "Frame fraction of windows"
    annotation(Evaluate=true, Dialog(tab = "General", group = "Window data"));
  parameter Real gFac = 0.5 "Energy transmittance of glazings"
    annotation(Evaluate=true, Dialog(tab = "General", group = "Window data"));
  parameter Modelica.Units.SI.Angle[4] surTil "Tilt angle of surfaces"
    annotation (Evaluate=true, Dialog(tab="General", group="Window directions"));
  parameter Modelica.Units.SI.Angle[4] surAzi
    "Azimuth angle of surfaces" annotation (Evaluate=true, Dialog(tab="General",
        group="Window directions"));
  Modelica.Blocks.Interfaces.RealOutput solRadWin( unit="W") "Total solar irradiation through windows"
    annotation (Placement(transformation(extent={{140,-10},{160,10}}),
        iconTransformation(extent={{140,-10},{160,10}})));
  IBPSA.BoundaryConditions.WeatherData.Bus weaBus "Weather data" annotation (Placement(
        transformation(extent={{-150,-12},{-110,28}}),iconTransformation(extent={{-150,
            -10},{-130,10}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(til=surTil[1], azi=surAzi[1]) "Direct solar irradiation on surface 1"
    annotation (Placement(transformation(extent={{-90,100},{-70,120}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil(til=surTil[1],azi=surAzi[1]) "Diffuse solar irradiation on surface 1"
    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil1(til=surTil[2],azi=surAzi[2]) "Direct solar irradiation on surface 2"
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil1(til=surTil[2],azi=surAzi[2]) "Diffuse solar irradiation on surface 2"
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil2(til=surTil[3],azi=surAzi[3]) "Direct solar irradiation on surface 3"
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil2(til=surTil[3],azi=surAzi[3]) "Diffuse solar irradiation on surface 3"
    annotation (Placement(transformation(extent={{-90,-40},{-70,-20}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil3(til=surTil[4],azi=surAzi[4]) "Direct solar irradiation on surface 4"
    annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil3(til=surTil[4],azi=surAzi[4]) "Diffuse solar irradiation on surface 4"
    annotation (Placement(transformation(extent={{-90,-100},{-70,-80}})));
  Modelica.Blocks.Math.Add irrN1
    "Total of direct and diffuse radiation on surface 1"
    annotation (Placement(transformation(extent={{-50,90},{-30,110}})));
  Modelica.Blocks.Math.Gain AWin1(k=AWin[1])
    "Windows area on surface 1"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Modelica.Blocks.Math.Gain g1(k=gFac)
    "Windows g-factor on surface 1"
    annotation (Placement(transformation(extent={{10,90},{30,110}})));
  Modelica.Blocks.Math.Gain fraWin1(k=1 - winFra)
    "Frame fraction of the windows on surface 1"
    annotation (Placement(transformation(extent={{70,90},{90,110}})));
  Modelica.Blocks.Math.Add irr2
    "Total of direct and diffuse radiation on surface 2"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Modelica.Blocks.Math.Gain AWin2(k=AWin[2])
    "Windows area on surface 2"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Modelica.Blocks.Math.Gain g2(k=gFac)
    "Windows g-factor on surface 2"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  Modelica.Blocks.Math.Gain fraWin2(k=1 - winFra)
    "Frame fraction of the windows on surface1 2"
    annotation (Placement(transformation(extent={{70,30},{90,50}})));
  Modelica.Blocks.Math.Add irr3
    "Total of direct and diffuse radiation on surface 3"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
  Modelica.Blocks.Math.Gain AWin3(k=AWin[3])
    "Windows area on surface 3"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Modelica.Blocks.Math.Gain g3(k=gFac)
    "Windows g-factor on surface 3"
    annotation (Placement(transformation(extent={{10,-30},{30,-10}})));
  Modelica.Blocks.Math.Gain fraWin3(k=1 - winFra)
    "Frame fraction of the windows on surface 3"
    annotation (Placement(transformation(extent={{70,-30},{90,-10}})));
  Modelica.Blocks.Math.Add irr4
    "Total of direct and diffuse radiation on surface 4"
    annotation (Placement(transformation(extent={{-50,-90},{-30,-70}})));
  Modelica.Blocks.Math.Gain AWin4( k=AWin[4])
    "Windows area on surface 4"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Modelica.Blocks.Math.Gain g4(k=gFac)
    "Windows g-factor on surface 4"
    annotation (Placement(transformation(extent={{10,-90},{30,-70}})));
  Modelica.Blocks.Math.Gain fraWin4(k=1 - winFra)
    "Frame fraction of the windows on surface 4"
    annotation (Placement(transformation(extent={{72,-90},{92,-70}})));
  Modelica.Blocks.Math.Sum sum(nin=4) "Sum of solar irradiation through windows"
    annotation (Placement(transformation(extent={{104,-10},{124,10}})));

  Modelica.Blocks.Math.Gain corFac1(k=0.9) "Correction factor surface 1"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Modelica.Blocks.Math.Gain corFac2(k=0.9) "Correction factor surface 2"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Modelica.Blocks.Math.Gain corFac3(k=0.9) "Correction factor surface 3"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Modelica.Blocks.Math.Gain corFac4(k=0.9) "Correction factor surface 4"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
equation
  connect(weaBus, HDirTil.weaBus) annotation (Line(
      points={{-130,8},{-130,112},{-90,112},{-90,110}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(HDifTil.weaBus, weaBus) annotation (Line(
      points={{-90,90},{-130,90},{-130,8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(HDirTil1.weaBus, weaBus) annotation (Line(
      points={{-90,50},{-130,50},{-130,8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(HDifTil1.weaBus, weaBus) annotation (Line(
      points={{-90,30},{-130,30},{-130,8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(HDirTil2.weaBus, weaBus) annotation (Line(
      points={{-90,-10},{-130,-10},{-130,8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(HDifTil2.weaBus, weaBus) annotation (Line(
      points={{-90,-30},{-130,-30},{-130,8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(HDirTil3.weaBus, weaBus) annotation (Line(
      points={{-90,-70},{-130,-70},{-130,8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(HDifTil3.weaBus, weaBus) annotation (Line(
      points={{-90,-90},{-130,-90},{-130,8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(HDirTil.H, irrN1.u1) annotation (Line(points={{-69,110},{-60,110},{
          -60,106},{-52,106}}, color={0,0,127}));
  connect(HDifTil.H, irrN1.u2) annotation (Line(points={{-69,90},{-58,90},{-58,
          94},{-52,94}}, color={0,0,127}));
  connect(HDirTil1.H, irr2.u1) annotation (Line(points={{-69,50},{-60,50},{-60,
          46},{-52,46}}, color={0,0,127}));
  connect(irr2.u2, HDifTil1.H) annotation (Line(points={{-52,34},{-62,34},{-62,
          30},{-69,30}}, color={0,0,127}));
  connect(HDirTil2.H, irr3.u1) annotation (Line(points={{-69,-10},{-60,-10},{
          -60,-14},{-52,-14}}, color={0,0,127}));
  connect(irr3.u2, HDifTil2.H) annotation (Line(points={{-52,-26},{-62,-26},{
          -62,-30},{-69,-30}}, color={0,0,127}));
  connect(irr4.u1, HDirTil3.H) annotation (Line(points={{-52,-74},{-62,-74},{
          -62,-70},{-69,-70}}, color={0,0,127}));
  connect(irr4.u2, HDifTil3.H) annotation (Line(points={{-52,-86},{-62,-86},{
          -62,-90},{-69,-90}}, color={0,0,127}));
  connect(AWin1.u, irrN1.y)
    annotation (Line(points={{-22,100},{-29,100}}, color={0,0,127}));
  connect(g1.u, AWin1.y)
    annotation (Line(points={{8,100},{1,100}}, color={0,0,127}));
  connect(corFac1.u, g1.y)
    annotation (Line(points={{38,100},{31,100}}, color={0,0,127}));
  connect(fraWin1.u, corFac1.y)
    annotation (Line(points={{68,100},{61,100}}, color={0,0,127}));
  connect(fraWin1.y, sum.u[1]) annotation (Line(points={{91,100},{98,100},{98,-1.5},
          {102,-1.5}},       color={0,0,127}));
  connect(irr2.y, AWin2.u)
    annotation (Line(points={{-29,40},{-22,40}}, color={0,0,127}));
  connect(AWin2.y, g2.u)
    annotation (Line(points={{1,40},{8,40}}, color={0,0,127}));
  connect(g2.y, corFac2.u)
    annotation (Line(points={{31,40},{38,40}}, color={0,0,127}));
  connect(corFac2.y, fraWin2.u)
    annotation (Line(points={{61,40},{68,40}}, color={0,0,127}));
  connect(fraWin2.y, sum.u[2]) annotation (Line(points={{91,40},{98,40},{98,-0.5},
          {102,-0.5}},       color={0,0,127}));
  connect(AWin3.u, irr3.y)
    annotation (Line(points={{-22,-20},{-29,-20}}, color={0,0,127}));
  connect(g3.u, AWin3.y)
    annotation (Line(points={{8,-20},{1,-20}}, color={0,0,127}));
  connect(corFac3.u, g3.y)
    annotation (Line(points={{38,-20},{31,-20}}, color={0,0,127}));
  connect(fraWin3.u, corFac3.y)
    annotation (Line(points={{68,-20},{61,-20}}, color={0,0,127}));
  connect(fraWin3.y, sum.u[3]) annotation (Line(points={{91,-20},{98,-20},{98,0.5},
          {102,0.5}},      color={0,0,127}));
  connect(AWin4.u, irr4.y)
    annotation (Line(points={{-22,-80},{-29,-80}}, color={0,0,127}));
  connect(g4.u, AWin4.y)
    annotation (Line(points={{8,-80},{1,-80}}, color={0,0,127}));
  connect(corFac4.u, g4.y)
    annotation (Line(points={{38,-80},{31,-80}}, color={0,0,127}));
  connect(fraWin4.u, corFac4.y)
    annotation (Line(points={{70,-80},{61,-80}}, color={0,0,127}));
  connect(fraWin4.y, sum.u[4]) annotation (Line(points={{93,-80},{98,-80},{98,1.5},
          {102,1.5}},      color={0,0,127}));
  connect(solRadWin, sum.y)
    annotation (Line(points={{150,0},{125,0}}, color={0,0,127}));
  annotation (defaultComponentName="glaEle",Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},
            {140,140}}), graphics={
        Rectangle(
          extent={{-140,140},{140,-142}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-140,140},{140,-142}}, lineColor={95,95,95}),
        Polygon(
          points={{20,100},{-20,80},{-20,-80},{20,-40},{20,100}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Ellipse(
          extent={{-74,128},{-124,78}},
          lineColor={255,255,0},
          lineThickness=0.5,
          fillColor={244,125,35},
          fillPattern=FillPattern.Sphere),
        Text(
          extent={{-110,198},{112,166}},
          textColor={0,0,255},
          textString="%name")}),Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-140,-140},{140,140}})),
         Documentation(info="<html>
<p>
This model calculates the solar heat gains through glazed elements. The heat flow by solar gains through building element k is given by
<p align=\"center\" style=\"font-style:italic;\">
&Phi;<sub>sol,k</sub> = F<sub>sh,ob,k</sub>A<sub>sol,k</sub>I<sub>sol,k</sub>-F<sub>r,k</sub>&Phi;<sub>r,k</sub>,
</p>
<p>
where <i>F<sub>sh,ob,k</sub></i> is the shading reduction factor for external obstacles,
<i>A<sub>sol,k</sub></i> is the effective collecting area of surface k,
<i>I<sub>sol,k</sub></i> is the solar irradiance per square meter,
<i>F<sub>r,k</sub></i> is the form factor between the building element and the sky, and
<i>&Phi;<sub>r,k</sub></i> is the extra heat flow due to thermal radiation to the sky.
The effective collecting area of glazed elements <i>A<sub>sol</sub></i> is calculated as
<p align=\"center\" style=\"font-style:italic;\">
A<sub>sol</sub> = F<sub>sh,gl</sub>F<sub>w</sub>g<sub>n</sub>(1-F<sub>f</sub>)A<sub>w</sub>,
</p>
<p>
where <i>F<sub>sh,gl</sub></i> is the shading reduction factor for venetian blind or shades (equal to 1 in this model implementation),
<i>F<sub>w</sub></i> is a correction factor (equal to 0.9 in this model implementation),
<i>g<sub>n</sub></i> is the solar energy transmittance for radiation perpendicular to the window,
<i>F<sub>f</sub></i> is the frame fraction, and
<i>A<sub>w</sub></i> is the window area.
In this model implementation, the extra radiative heat flow due to thermal radiation to the sky was neglected.
</p>
</html>",
revisions="<html>
<ul>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>"));
end GlazedElements;
