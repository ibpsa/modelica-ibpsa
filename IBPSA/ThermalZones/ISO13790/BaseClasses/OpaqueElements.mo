within IBPSA.ThermalZones.ISO13790.BaseClasses;
model OpaqueElements
  parameter Integer n;
  parameter Real AWal[:] "Area of external walls";
  parameter Real ARoo "Area of roof";
  parameter Real UWal "U-value of external walls";
  parameter Real URoo "U-value of roof";
  parameter Real surTil[:] "Tilt angle of surfaces";
  parameter Real surAzi[:] "Azimuth angle of surfaces";
  parameter Real eps=0.9 "Emissivity of external surface";
  parameter Real alp=0.6 "Absorption coefficient";
  parameter Real surRes=0.04 "External surface heat resistance";

  IBPSA.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-120,-20},{-80,20}}), iconTransformation(extent=
           {{-110,-10},{-90,10}})));
  BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[n](til=surTil, azi=surAzi)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Math.Gain solRadOpa[n](k=AWal*alp*UWal*surRes)
    "Solar radiation on vertical opaque surfaces"
    annotation (Placement(transformation(extent={{-8,60},{12,80}})));
  Modelica.Blocks.Interfaces.RealOutput y "Solar radiation through windows"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil [n](til=surTil, azi=surAzi)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Math.Add irr [n]
    "Total of direct and diffuse radiation on surface"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Math.Add add1[n](each k2=-1)
    "Total of direct and diffuse radiation on the south facade"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.Blocks.Math.Gain theRadOpa[n](each k=5*eps*11*0.5)
    "Extra thermal radiation through walls"
    annotation (Placement(transformation(extent={{-8,10},{12,30}})));
  Modelica.Blocks.Math.Add irrRoo
    "Total of direct and diffuse radiation on the south facade"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.Math.Gain solRadRoo(k=ARoo*alp*URoo*surRes)
    "Solar radiation on roof"
    annotation (Placement(transformation(extent={{-8,-40},{12,-20}})));
  Modelica.Blocks.Math.Gain theRadRoo(k=5*eps*11*1)
    "Extra thermal radiation through roof"
    annotation (Placement(transformation(extent={{-8,-90},{12,-70}})));
  Modelica.Blocks.Math.Add add2(k2=-1)
    "Total of direct and diffuse radiation on the south facade"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=n)
    annotation (Placement(transformation(extent={{48,44},{60,56}})));
  Modelica.Blocks.Math.Add add3
    "Total of direct and diffuse radiation on the south facade"
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));
protected
  Modelica.Blocks.Sources.RealExpression fac[n](y=UWal*AWal*surRes) "factor"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTilRoo(til=0, azi=
       0) annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  BoundaryConditions.SolarIrradiation.DiffusePerez HDifTilRof(til=0, azi=0)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
protected
  Modelica.Blocks.Sources.RealExpression facRoo(y=URoo*ARoo*surRes) "factor"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
equation
  for i in 1:n loop
  connect(weaBus,HDifTil [i].weaBus) annotation (Line(
      points={{-100,0},{-90,0},{-90,30},{-80,30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  end for;

  for i in 1:n loop
  connect(weaBus,HDirTil [i].weaBus) annotation (Line(
      points={{-100,0},{-90,0},{-90,70},{-80,70}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  end for;
  connect(HDirTil.H,irr. u1) annotation (Line(points={{-59,70},{-50,70},{-50,76},
          {-42,76}},color={0,0,127}));
  connect(HDifTil.H,irr. u2) annotation (Line(points={{-59,30},{-48,30},{-48,64},
          {-42,64}}, color={0,0,127}));

  connect(irr.y, solRadOpa.u)
    annotation (Line(points={{-19,70},{-10,70}}, color={0,0,127}));
  connect(HDirTilRoo.H, irrRoo.u1) annotation (Line(points={{-59,-30},{-50,-30},
          {-50,-24},{-42,-24}}, color={0,0,127}));
  connect(HDifTilRof.H, irrRoo.u2) annotation (Line(points={{-59,-70},{-48,-70},
          {-48,-36},{-42,-36}}, color={0,0,127}));
  connect(HDirTilRoo.weaBus, weaBus) annotation (Line(
      points={{-80,-30},{-90,-30},{-90,0},{-100,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(HDifTilRof.weaBus, weaBus) annotation (Line(
      points={{-80,-70},{-90,-70},{-90,0},{-100,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(irrRoo.y, solRadRoo.u)
    annotation (Line(points={{-19,-30},{-10,-30}}, color={0,0,127}));
  connect(facRoo.y, theRadRoo.u)
    annotation (Line(points={{-19,-80},{-10,-80}}, color={0,0,127}));
  connect(add1.y, multiSum.u)
    annotation (Line(points={{41,50},{48,50}}, color={0,0,127}));
  connect(solRadOpa.y, add1.u1) annotation (Line(points={{13,70},{14,70},{14,56},
          {18,56}}, color={0,0,127}));
  connect(theRadRoo.y, add2.u2) annotation (Line(points={{13,-80},{12,-80},{12,-56},
          {18,-56}}, color={0,0,127}));
  connect(solRadRoo.y, add2.u1) annotation (Line(points={{13,-30},{12,-30},{12,-44},
          {18,-44}}, color={0,0,127}));
  connect(add3.y, y)
    annotation (Line(points={{93,0},{110,0}}, color={0,0,127}));
  connect(add2.y, add3.u2) annotation (Line(points={{41,-50},{64,-50},{64,-6},{70,
          -6}}, color={0,0,127}));
  connect(multiSum.y, add3.u1) annotation (Line(points={{61.02,50},{64,50},{64,6},
          {70,6}}, color={0,0,127}));
  connect(fac.y, theRadOpa.u)
    annotation (Line(points={{-19,20},{-10,20}}, color={0,0,127}));
  connect(theRadOpa.y, add1.u2) annotation (Line(points={{13,20},{14,20},{14,44},
          {18,44}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-34,88},{-84,38}},
          lineColor={255,255,0},
          lineThickness=0.5,
          fillColor={244,125,35},
          fillPattern=FillPattern.Sphere),                        Rectangle(
    extent={{-84,28},{-64,-6}},       fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-58,28},{-4,-6}},       fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{2,28},{56,-6}},       fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{62,28},{88,-6}},       fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{34,-12},{88,-46}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}),  Rectangle(
    extent={{-26,-12},{28,-46}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-84,-12},{-32,-46}},      fillColor = {255, 213, 170},
   fillPattern =  FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-84,-52},{-64,-86}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-58,-52},{-4,-86}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{2,-52},{56,-86}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{62,-52},{88,-84}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}),
        Text(
          extent={{-110,148},{112,116}},
          textColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OpaqueElements;
