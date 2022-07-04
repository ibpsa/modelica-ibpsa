within IBPSA.ThermalZones.ISO13790.BaseClasses;
model GlazedElements "Solar heat gains of glazed elements"
  IBPSA.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-150,-12},{-110,28}}),iconTransformation(extent={{-150,
            -10},{-130,10}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DirectTiltedSurface     HDirTil(
    til=surfaceTilt[1],
    azi=surfaceAzimuth[1])
            annotation (Placement(transformation(extent={{-90,100},{-70,120}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DiffusePerez     HDifTil(
    til=surfaceTilt[1],
    azi=surfaceAzimuth[1])
    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DirectTiltedSurface     HDirTil1(
    til=surfaceTilt[2],
    azi=surfaceAzimuth[2])
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DiffusePerez     HDifTil1(
    til=surfaceTilt[2],
    azi=surfaceAzimuth[2])
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DirectTiltedSurface     HDirTil2(
    til=surfaceTilt[3],
    azi=surfaceAzimuth[3])
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DiffusePerez     HDifTil2(
    til=surfaceTilt[3],
    azi=surfaceAzimuth[3])
    annotation (Placement(transformation(extent={{-90,-40},{-70,-20}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DirectTiltedSurface     HDirTil3(
    til=surfaceTilt[4],
    azi=surfaceAzimuth[4])
    annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DiffusePerez     HDifTil3(
    til=surfaceTilt[4],
    azi=surfaceAzimuth[4])
    annotation (Placement(transformation(extent={{-90,-100},{-70,-80}})));

  parameter Real groundReflectance = 0.2 "Ground reflectance"
      annotation(Evaluate=true, Dialog(tab = "General", group = "Location"));
  parameter Modelica.Units.SI.Area[4] Awin={0,0,6,0} "Areas of windows"
    annotation (Evaluate=true, Dialog(tab="General", group="Window data"));
  parameter Real winFrame = 0.01 "Frame fraction of windows"
        annotation(Evaluate=true, Dialog(tab = "General", group = "Window data"));
  parameter Real gFactor = 0.5 "Energy transmittance of glazings"
        annotation(Evaluate=true, Dialog(tab = "General", group = "Window data"));
  parameter Modelica.Units.SI.Angle[4] surfaceTilt "Tilt angle of surfaces"
    annotation (Evaluate=true, Dialog(tab="General", group="Window directions"));
  parameter Modelica.Units.SI.Angle[4] surfaceAzimuth
    "Azimuth angle of surfaces" annotation (Evaluate=true, Dialog(tab="General",
        group="Window directions"));

  Modelica.Blocks.Math.Add Irradiance_north
    annotation (Placement(transformation(extent={{-50,90},{-30,110}})));
  Modelica.Blocks.Math.Gain A_win_north(k=Awin[1])
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Modelica.Blocks.Math.Gain g_win_north(k=gFactor)
    annotation (Placement(transformation(extent={{10,90},{30,110}})));
  Modelica.Blocks.Math.Gain frame_win_north(k=1 - winFrame)
    annotation (Placement(transformation(extent={{70,90},{90,110}})));
  Modelica.Blocks.Math.Add Irradiance_east
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Modelica.Blocks.Math.Gain A_win_east(k=Awin[2])
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Modelica.Blocks.Math.Gain g_win_east(k=gFactor)
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  Modelica.Blocks.Math.Gain frame_win_east(k=1 - winFrame)
    annotation (Placement(transformation(extent={{70,30},{90,50}})));
  Modelica.Blocks.Math.Add Irradiance_south
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
  Modelica.Blocks.Math.Gain A_win_south(k=Awin[3])
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Modelica.Blocks.Math.Gain g_win_south(k=gFactor)
    annotation (Placement(transformation(extent={{10,-30},{30,-10}})));
  Modelica.Blocks.Math.Gain frame_win_south(k=1 - winFrame)
    annotation (Placement(transformation(extent={{70,-30},{90,-10}})));
  Modelica.Blocks.Math.Add Irradiance_west
    annotation (Placement(transformation(extent={{-50,-90},{-30,-70}})));
  Modelica.Blocks.Math.Gain A_win_west(k=Awin[4])
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Modelica.Blocks.Math.Gain g_win_west(k=gFactor)
    annotation (Placement(transformation(extent={{10,-90},{30,-70}})));
  Modelica.Blocks.Math.Gain frame_win_west(k=1 - winFrame)
    annotation (Placement(transformation(extent={{72,-90},{92,-70}})));
  Modelica.Blocks.Math.Sum sum1(nin=4)
    annotation (Placement(transformation(extent={{104,-10},{124,10}})));
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{140,-10},{160,10}}),
        iconTransformation(extent={{140,-10},{160,10}})));
  Modelica.Blocks.Math.Gain cFactor_north(k=0.9)
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Modelica.Blocks.Math.Gain cFactor_east(k=0.9)
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Modelica.Blocks.Math.Gain cFactor_south(k=0.9)
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Modelica.Blocks.Math.Gain cFactor_west(k=0.9)
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
equation
  connect(HDirTil.H, Irradiance_north.u1) annotation (Line(points={{-69,110},{-62,
          110},{-62,106},{-52,106}}, color={0,0,127}));
  connect(HDifTil.H, Irradiance_north.u2) annotation (Line(points={{-69,90},{-62,
          90},{-62,94},{-52,94}}, color={0,0,127}));
  connect(Irradiance_north.y, A_win_north.u)
    annotation (Line(points={{-29,100},{-22,100}},
                                                color={0,0,127}));
  connect(A_win_north.y, g_win_north.u)
    annotation (Line(points={{1,100},{8,100}},   color={0,0,127}));
  connect(Irradiance_east.y, A_win_east.u)
    annotation (Line(points={{-29,40},{-22,40}}, color={0,0,127}));
  connect(A_win_east.y, g_win_east.u)
    annotation (Line(points={{1,40},{8,40}},   color={0,0,127}));
  connect(Irradiance_south.y, A_win_south.u)
    annotation (Line(points={{-29,-20},{-22,-20}}, color={0,0,127}));
  connect(A_win_south.y, g_win_south.u)
    annotation (Line(points={{1,-20},{8,-20}},   color={0,0,127}));
  connect(Irradiance_west.y, A_win_west.u)
    annotation (Line(points={{-29,-80},{-22,-80}}, color={0,0,127}));
  connect(A_win_west.y, g_win_west.u)
    annotation (Line(points={{1,-80},{8,-80}},   color={0,0,127}));
  connect(HDirTil3.H, Irradiance_west.u1) annotation (Line(points={{-69,-70},{-62,
          -70},{-62,-74},{-52,-74}}, color={0,0,127}));
  connect(HDifTil3.H, Irradiance_west.u2) annotation (Line(points={{-69,-90},{-62,
          -90},{-62,-86},{-52,-86}}, color={0,0,127}));
  connect(HDirTil2.H, Irradiance_south.u1) annotation (Line(points={{-69,-10},{-62,
          -10},{-62,-14},{-52,-14}}, color={0,0,127}));
  connect(HDifTil2.H, Irradiance_south.u2) annotation (Line(points={{-69,-30},{-60,
          -30},{-60,-26},{-52,-26}}, color={0,0,127}));
  connect(HDirTil1.H, Irradiance_east.u1) annotation (Line(points={{-69,50},{-60,
          50},{-60,46},{-52,46}}, color={0,0,127}));
  connect(HDifTil1.H, Irradiance_east.u2) annotation (Line(points={{-69,30},{-60,
          30},{-60,34},{-52,34}}, color={0,0,127}));
  connect(frame_win_north.y, sum1.u[1]) annotation (Line(points={{91,100},{98,
          100},{98,-1.5},{102,-1.5}},
                                 color={0,0,127}));
  connect(frame_win_east.y, sum1.u[2]) annotation (Line(points={{91,40},{98,40},
          {98,-0.5},{102,-0.5}}, color={0,0,127}));
  connect(frame_win_south.y, sum1.u[3]) annotation (Line(points={{91,-20},{100,-20},
          {100,0.5},{102,0.5}}, color={0,0,127}));
  connect(frame_win_west.y, sum1.u[4]) annotation (Line(points={{93,-80},{100,
          -80},{100,1.5},{102,1.5}},
                                color={0,0,127}));
  connect(sum1.y, y)
    annotation (Line(points={{125,0},{150,0}}, color={0,0,127}));
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
  connect(g_win_north.y, cFactor_north.u)
    annotation (Line(points={{31,100},{38,100}}, color={0,0,127}));
  connect(frame_win_north.u, cFactor_north.y)
    annotation (Line(points={{68,100},{61,100}}, color={0,0,127}));
  connect(g_win_east.y, cFactor_east.u)
    annotation (Line(points={{31,40},{38,40}}, color={0,0,127}));
  connect(cFactor_east.y, frame_win_east.u)
    annotation (Line(points={{61,40},{68,40}}, color={0,0,127}));
  connect(cFactor_south.u, g_win_south.y)
    annotation (Line(points={{38,-20},{31,-20}}, color={0,0,127}));
  connect(cFactor_south.y, frame_win_south.u)
    annotation (Line(points={{61,-20},{68,-20}}, color={0,0,127}));
  connect(cFactor_west.u, g_win_west.y)
    annotation (Line(points={{38,-80},{31,-80}}, color={0,0,127}));
  connect(cFactor_west.y, frame_win_west.u)
    annotation (Line(points={{61,-80},{70,-80}}, color={0,0,127}));
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
          lineColor={0,0,255},
          textString="%name")}),Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-140,-140},{140,140}})),
         Documentation(info="<html>
<p>
This model calculates the solar heat gains through glazed elements. The heat flow by solar gains through building element k is given by
<p align=\"center\" style=\"font-style:italic;\">
&Phi;<sub>sol,k</sub> = F<sub>sh,ob,k</sub>A<sub>sol,k</sub>I<sub>sol,k</sub>-F<sub>r,k</sub>&Phi;<sub>r,k</sub>
</p>
where <i>F<sub>sh,ob,k</sub></i> is the shading reduction factor for external obstacles, 
<i>A<sub>sol,k</sub></i> is the effective collecting area of surface k,
<i>I<sub>sol,k</sub></i> is the solar irradiance per square meter, 
<i>F<sub>r,k</sub></i> is the form factor between the building element and the sky, and 
<i>&Phi;<sub>r,k</sub></i> is the extra heat flow due to thermal radiation to the sky. 
The effective collecting area of glazed elements <i>A<sub>sol</sub></i> is calculated as
<p align=\"center\" style=\"font-style:italic;\">
A<sub>sol</sub> = F<sub>sh,gl</sub>F<sub>w</sub>g<sub>n</sub>(1-F<sub>f</sub>)A<sub>w</sub>
</p>
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
</html>",
        info="<html>
<p>
Mass data for heavy building
</p>
</html>"));
end GlazedElements;
