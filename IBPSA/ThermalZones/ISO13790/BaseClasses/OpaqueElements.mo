within IBPSA.ThermalZones.ISO13790.BaseClasses;
model OpaqueElements "Solar heat gains of opaque elements"
  IBPSA.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-200,-20},{-160,20}}),iconTransformation(extent={{-230,
            -40},{-210,-20}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
    til=surfaceTilt[1],
    azi=surfaceAzimuth[1])
            annotation (Placement(transformation(extent={{-120,160},{-100,180}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil(
    til=surfaceTilt[1],
    azi=surfaceAzimuth[1])
    annotation (Placement(transformation(extent={{-120,140},{-100,160}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil1(
    til=surfaceTilt[2],
    azi=surfaceAzimuth[2])
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil1(
    til=surfaceTilt[2],
    azi=surfaceAzimuth[2])
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil2(
    til=surfaceTilt[3],
    azi=surfaceAzimuth[3])
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil2(
    til=surfaceTilt[3],
    azi=surfaceAzimuth[3])
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil3(
    til=surfaceTilt[4],
    azi=surfaceAzimuth[4])
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil3(
    til=surfaceTilt[4],
    azi=surfaceAzimuth[4])
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));

  parameter Real groundReflectance = 0.2 "Ground reflectance"
      annotation(Evaluate=true, Dialog(tab = "General", group = "Location"));
  parameter Modelica.Units.SI.Area[4] Awal "Area of opaque constructions"
    annotation (Evaluate=true, Dialog(tab="General", group="Construction data"));

  parameter Real Uwal "U-value of walls"
        annotation(Evaluate=true, Dialog(tab = "General", group = "Construction data"));

  parameter Modelica.Units.SI.Area Aroo "Area of opaque constructions"
    annotation (Dialog(tab="General", group="Construction data"));

  parameter Real Uroo "U-value of roof"
        annotation(Evaluate=true, Dialog(tab = "General", group = "Construction data"));

   parameter Real eps = 0.9 "Emissivity of external surface"
        annotation(Evaluate=true, Dialog(tab = "General", group = "Construction data"));

  parameter Real alpha = 0.6 "Absorption coefficient"
        annotation(Evaluate=true, Dialog(tab = "General", group = "Construction data"));

   parameter Real R_se = 0.04 "External surface heat resistance"
        annotation(Evaluate=true, Dialog(tab = "General", group = "Construction data"));

  parameter Modelica.Units.SI.Angle[5] surfaceTilt "Tilt angle of surfaces"
    annotation (Evaluate=true, Dialog(tab="General", group="Window directions"));
  parameter Modelica.Units.SI.Angle[5] surfaceAzimuth
    "Azimuth angle of surfaces" annotation (Evaluate=true, Dialog(tab="General",
        group="Window directions"));

  Modelica.Blocks.Math.Add Irradiance_north
    annotation (Placement(transformation(extent={{-80,150},{-60,170}})));
  Modelica.Blocks.Math.Gain A_op_north(k=Awal[1])
    annotation (Placement(transformation(extent={{-40,150},{-20,170}})));
  Modelica.Blocks.Math.Gain alpha_north(k=alpha)
    annotation (Placement(transformation(extent={{0,150},{20,170}})));
  Modelica.Blocks.Math.Gain Res_north(k=R_se)
    annotation (Placement(transformation(extent={{80,150},{100,170}})));
  Modelica.Blocks.Math.Add Irradiance_north1
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Math.Gain A_op_east(k=Awal[2])
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Modelica.Blocks.Math.Gain alpha_east(k=alpha)
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Modelica.Blocks.Math.Gain Res_east(k=R_se)
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Modelica.Blocks.Math.Add Irradiance_north2
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Math.Gain A_op_south(k=Awal[3])
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Math.Gain alpha_south(k=alpha)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Math.Gain Res_south(k=R_se)
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Modelica.Blocks.Math.Add Irradiance_north3
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Modelica.Blocks.Math.Gain A_op_west(k=Awal[4])
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Modelica.Blocks.Math.Gain alpha_west(k=alpha)
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Modelica.Blocks.Math.Gain Res_west(k=R_se)
    annotation (Placement(transformation(extent={{80,-90},{100,-70}})));
  Modelica.Blocks.Math.Sum sum1(nin=5)
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{220,-10},{240,10}}),
        iconTransformation(extent={{220,-10},{240,10}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil4(
    til=surfaceTilt[5],
    azi=surfaceAzimuth[5])
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil4(
    til=surfaceTilt[5],
    azi=surfaceAzimuth[5])
    annotation (Placement(transformation(extent={{-120,-180},{-100,-160}})));
  Modelica.Blocks.Math.Add Irradiance_roof
    annotation (Placement(transformation(extent={{-80,-170},{-60,-150}})));
  Modelica.Blocks.Math.Gain A_op_roof(k=Aroo)
    annotation (Placement(transformation(extent={{-40,-170},{-20,-150}})));
  Modelica.Blocks.Math.Gain alpha_roof(k=alpha)
    annotation (Placement(transformation(extent={{0,-170},{20,-150}})));
  Modelica.Blocks.Math.Gain Res_roof(k=R_se)
    annotation (Placement(transformation(extent={{80,-170},{100,-150}})));
  Modelica.Blocks.Math.Gain U_north(k=Uwal)
    annotation (Placement(transformation(extent={{40,150},{60,170}})));
  Modelica.Blocks.Math.Gain U_east(k=Uwal)
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Modelica.Blocks.Math.Gain U_south(k=Uwal)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Math.Gain U_west(k=Uwal)
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Modelica.Blocks.Math.Gain U_top(k=Uroo)
    annotation (Placement(transformation(extent={{40,-170},{60,-150}})));
  Modelica.Blocks.Math.Add q_sol_op_north(k2=-1)
    annotation (Placement(transformation(extent={{120,144},{140,164}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=Uwal*Awal[1]*R_se)
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Modelica.Blocks.Math.Gain h_r_north(k=5*eps)
    annotation (Placement(transformation(extent={{0,110},{20,130}})));
  Modelica.Blocks.Math.Gain dT_se(k=11)
    annotation (Placement(transformation(extent={{40,110},{60,130}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=Uwal*Awal[2]*R_se)
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Modelica.Blocks.Math.Gain h_r_east(k=5*eps)
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Modelica.Blocks.Math.Gain dT_se1(k=11)
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Modelica.Blocks.Math.Gain F_r(k=0.5)
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Modelica.Blocks.Math.Gain F_r1(k=0.5)
    annotation (Placement(transformation(extent={{80,110},{100,130}})));
  Modelica.Blocks.Math.Add q_sol_op_east(k2=-1)
    annotation (Placement(transformation(extent={{120,64},{140,84}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=Uwal*Awal[3]*R_se)
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Modelica.Blocks.Math.Gain h_r_east1(k=5*eps)
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Modelica.Blocks.Math.Gain dT_se2(k=11)
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Modelica.Blocks.Math.Gain F_r2(k=0.5)
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));
  Modelica.Blocks.Math.Add q_sol_op_south(k2=-1)
    annotation (Placement(transformation(extent={{122,-16},{142,4}})));
  Modelica.Blocks.Sources.RealExpression realExpression3(y=Uwal*Awal[4]*R_se)
    annotation (Placement(transformation(extent={{-40,-130},{-20,-110}})));
  Modelica.Blocks.Math.Gain h_r_east2(k=5*eps)
    annotation (Placement(transformation(extent={{0,-130},{20,-110}})));
  Modelica.Blocks.Math.Gain dT_se3(k=11)
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));
  Modelica.Blocks.Math.Gain F_r3(k=0.5)
    annotation (Placement(transformation(extent={{80,-130},{100,-110}})));
  Modelica.Blocks.Math.Add q_sol_op_south1(k2=-1)
    annotation (Placement(transformation(extent={{120,-96},{140,-76}})));
  Modelica.Blocks.Math.Add q_sol_op_south2(k2=-1)
    annotation (Placement(transformation(extent={{120,-176},{140,-156}})));
  Modelica.Blocks.Sources.RealExpression realExpression4(y=Uroo*Aroo*R_se)
    annotation (Placement(transformation(extent={{-40,-210},{-20,-190}})));
  Modelica.Blocks.Math.Gain h_r_east3(k=5*eps)
    annotation (Placement(transformation(extent={{0,-210},{20,-190}})));
  Modelica.Blocks.Math.Gain dT_se4(k=11)
    annotation (Placement(transformation(extent={{40,-210},{60,-190}})));
  Modelica.Blocks.Math.Gain F_r4(k=1)
    annotation (Placement(transformation(extent={{80,-210},{100,-190}})));
equation
  connect(weaBus, HDirTil.weaBus) annotation (Line(
      points={{-180,0},{-180,170},{-120,170}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(HDirTil3.weaBus, weaBus) annotation (Line(
      points={{-120,-70},{-180,-70},{-180,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(HDifTil3.weaBus, weaBus) annotation (Line(
      points={{-120,-90},{-180,-90},{-180,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(HDirTil.H, Irradiance_north.u1) annotation (Line(points={{-99,170},{-90,
          170},{-90,166},{-82,166}}, color={0,0,127}));
  connect(HDifTil.H, Irradiance_north.u2) annotation (Line(points={{-99,150},{-90,
          150},{-90,154},{-82,154}},
                                  color={0,0,127}));
  connect(Irradiance_north.y, A_op_north.u)
    annotation (Line(points={{-59,160},{-42,160}}, color={0,0,127}));
  connect(A_op_north.y,alpha_north. u)
    annotation (Line(points={{-19,160},{-2,160}},color={0,0,127}));
  connect(Irradiance_north1.y, A_op_east.u)
    annotation (Line(points={{-59,80},{-42,80}}, color={0,0,127}));
  connect(A_op_east.y, alpha_east.u)
    annotation (Line(points={{-19,80},{-2,80}}, color={0,0,127}));
  connect(Irradiance_north2.y, A_op_south.u)
    annotation (Line(points={{-59,0},{-42,0}},     color={0,0,127}));
  connect(A_op_south.y, alpha_south.u)
    annotation (Line(points={{-19,0},{-2,0}},     color={0,0,127}));
  connect(Irradiance_north3.y, A_op_west.u)
    annotation (Line(points={{-59,-80},{-42,-80}}, color={0,0,127}));
  connect(A_op_west.y, alpha_west.u)
    annotation (Line(points={{-19,-80},{-2,-80}}, color={0,0,127}));
  connect(HDirTil3.H, Irradiance_north3.u1) annotation (Line(points={{-99,-70},{
          -88,-70},{-88,-74},{-82,-74}}, color={0,0,127}));
  connect(HDifTil3.H, Irradiance_north3.u2) annotation (Line(points={{-99,-90},{
          -88,-90},{-88,-86},{-82,-86}}, color={0,0,127}));
  connect(HDirTil2.H, Irradiance_north2.u1) annotation (Line(points={{-99,10},{-90,
          10},{-90,6},{-82,6}},          color={0,0,127}));
  connect(HDifTil2.H, Irradiance_north2.u2) annotation (Line(points={{-99,-10},{
          -88,-10},{-88,-6},{-82,-6}},   color={0,0,127}));
  connect(HDirTil1.H, Irradiance_north1.u1) annotation (Line(points={{-99,90},{-90,
          90},{-90,86},{-82,86}}, color={0,0,127}));
  connect(HDifTil1.H, Irradiance_north1.u2) annotation (Line(points={{-99,70},{-90,
          70},{-90,74},{-82,74}}, color={0,0,127}));
  connect(sum1.y, y)
    annotation (Line(points={{201,0},{230,0}}, color={0,0,127}));
  connect(Irradiance_roof.y, A_op_roof.u)
    annotation (Line(points={{-59,-160},{-42,-160}}, color={0,0,127}));
  connect(A_op_roof.y, alpha_roof.u)
    annotation (Line(points={{-19,-160},{-2,-160}}, color={0,0,127}));
  connect(HDirTil4.H, Irradiance_roof.u1) annotation (Line(points={{-99,-150},{-90,
          -150},{-90,-154},{-82,-154}}, color={0,0,127}));
  connect(HDifTil4.H, Irradiance_roof.u2) annotation (Line(points={{-99,-170},{-90,
          -170},{-90,-166},{-82,-166}}, color={0,0,127}));
  connect(HDirTil4.weaBus, weaBus) annotation (Line(
      points={{-120,-150},{-180,-150},{-180,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(HDifTil4.weaBus, weaBus) annotation (Line(
      points={{-120,-170},{-180,-170},{-180,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(alpha_north.y, U_north.u)
    annotation (Line(points={{21,160},{38,160}}, color={0,0,127}));
  connect(U_north.y, Res_north.u)
    annotation (Line(points={{61,160},{78,160}}, color={0,0,127}));
  connect(alpha_east.y, U_east.u)
    annotation (Line(points={{21,80},{38,80}}, color={0,0,127}));
  connect(U_east.y, Res_east.u)
    annotation (Line(points={{61,80},{78,80}}, color={0,0,127}));
  connect(alpha_south.y, U_south.u)
    annotation (Line(points={{21,0},{38,0}},     color={0,0,127}));
  connect(U_south.y, Res_south.u)
    annotation (Line(points={{61,0},{78,0}},     color={0,0,127}));
  connect(alpha_west.y, U_west.u)
    annotation (Line(points={{21,-80},{38,-80}}, color={0,0,127}));
  connect(U_west.y, Res_west.u)
    annotation (Line(points={{61,-80},{78,-80}}, color={0,0,127}));
  connect(alpha_roof.y, U_top.u)
    annotation (Line(points={{21,-160},{38,-160}}, color={0,0,127}));
  connect(U_top.y, Res_roof.u)
    annotation (Line(points={{61,-160},{78,-160}}, color={0,0,127}));
  connect(Res_north.y, q_sol_op_north.u1)
    annotation (Line(points={{101,160},{118,160}}, color={0,0,127}));
  connect(realExpression.y, h_r_north.u)
    annotation (Line(points={{-19,120},{-2,120}}, color={0,0,127}));
  connect(h_r_north.y, dT_se.u)
    annotation (Line(points={{21,120},{38,120}}, color={0,0,127}));
  connect(realExpression1.y, h_r_east.u)
    annotation (Line(points={{-19,40},{-2,40}}, color={0,0,127}));
  connect(h_r_east.y, dT_se1.u)
    annotation (Line(points={{21,40},{38,40}}, color={0,0,127}));
  connect(dT_se1.y, F_r.u)
    annotation (Line(points={{61,40},{78,40}}, color={0,0,127}));
  connect(dT_se.y, F_r1.u)
    annotation (Line(points={{61,120},{78,120}}, color={0,0,127}));
  connect(Res_east.y, q_sol_op_east.u1)
    annotation (Line(points={{101,80},{118,80}}, color={0,0,127}));
  connect(F_r1.y, q_sol_op_north.u2) annotation (Line(points={{101,120},{110,120},
          {110,148},{118,148}}, color={0,0,127}));
  connect(F_r.y, q_sol_op_east.u2) annotation (Line(points={{101,40},{110,40},{110,
          68},{118,68}}, color={0,0,127}));
  connect(realExpression2.y, h_r_east1.u)
    annotation (Line(points={{-19,-40},{-2,-40}}, color={0,0,127}));
  connect(h_r_east1.y, dT_se2.u)
    annotation (Line(points={{21,-40},{38,-40}}, color={0,0,127}));
  connect(dT_se2.y, F_r2.u)
    annotation (Line(points={{61,-40},{78,-40}}, color={0,0,127}));
  connect(Res_south.y, q_sol_op_south.u1)
    annotation (Line(points={{101,0},{120,0}}, color={0,0,127}));
  connect(F_r2.y, q_sol_op_south.u2) annotation (Line(points={{101,-40},{110,-40},
          {110,-12},{120,-12}}, color={0,0,127}));
  connect(realExpression3.y, h_r_east2.u)
    annotation (Line(points={{-19,-120},{-2,-120}}, color={0,0,127}));
  connect(h_r_east2.y, dT_se3.u)
    annotation (Line(points={{21,-120},{38,-120}}, color={0,0,127}));
  connect(dT_se3.y, F_r3.u)
    annotation (Line(points={{61,-120},{78,-120}}, color={0,0,127}));
  connect(Res_west.y, q_sol_op_south1.u1)
    annotation (Line(points={{101,-80},{118,-80}}, color={0,0,127}));
  connect(F_r3.y, q_sol_op_south1.u2) annotation (Line(points={{101,-120},{110,-120},
          {110,-92},{118,-92}}, color={0,0,127}));
  connect(HDifTil.weaBus, weaBus) annotation (Line(
      points={{-120,150},{-180,150},{-180,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(HDirTil1.weaBus, weaBus) annotation (Line(
      points={{-120,90},{-180,90},{-180,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(HDifTil1.weaBus, weaBus) annotation (Line(
      points={{-120,70},{-180,70},{-180,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(HDirTil2.weaBus, weaBus) annotation (Line(
      points={{-120,10},{-180,10},{-180,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(HDifTil2.weaBus, weaBus) annotation (Line(
      points={{-120,-10},{-180,-10},{-180,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(Res_roof.y, q_sol_op_south2.u1)
    annotation (Line(points={{101,-160},{118,-160}}, color={0,0,127}));
  connect(realExpression4.y, h_r_east3.u)
    annotation (Line(points={{-19,-200},{-2,-200}}, color={0,0,127}));
  connect(h_r_east3.y, dT_se4.u)
    annotation (Line(points={{21,-200},{38,-200}}, color={0,0,127}));
  connect(dT_se4.y, F_r4.u)
    annotation (Line(points={{61,-200},{78,-200}}, color={0,0,127}));
  connect(F_r4.y, q_sol_op_south2.u2) annotation (Line(points={{101,-200},{110,-200},
          {110,-172},{118,-172}}, color={0,0,127}));
  connect(q_sol_op_north.y, sum1.u[1]) annotation (Line(points={{141,154},{160,
          154},{160,-1.6},{178,-1.6}}, color={0,0,127}));
  connect(q_sol_op_east.y, sum1.u[2]) annotation (Line(points={{141,74},{160,74},
          {160,-0.8},{178,-0.8}}, color={0,0,127}));
  connect(q_sol_op_south.y, sum1.u[3]) annotation (Line(points={{143,-6},{160,
          -6},{160,0},{178,0}}, color={0,0,127}));
  connect(q_sol_op_south1.y, sum1.u[4]) annotation (Line(points={{141,-86},{160,
          -86},{160,0.8},{178,0.8}}, color={0,0,127}));
  connect(q_sol_op_south2.y, sum1.u[5]) annotation (Line(points={{141,-166},{
          160,-166},{160,1.6},{178,1.6}}, color={0,0,127}));
  annotation (defaultComponentName="opaEle",Icon(coordinateSystem(preserveAspectRatio=false, extent={{-220,-220},
            {220,200}}),       graphics={
        Rectangle(
          extent={{-220,160},{220,-220}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),                         Rectangle(
    extent={{-84,68},{-64,34}},       fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-58,68},{-4,34}},       fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{2,68},{56,34}},       fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{62,68},{88,34}},       fillColor = {255, 213, 170},
   fillPattern =  FillPattern.Solid, lineColor = {175, 175, 175}),Rectangle(
    extent={{34,28},{88,-6}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-26,28},{28,-6}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}),
                                        Rectangle(extent={{-84,28},{-32,-6}},
   fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-84,-12},{-64,-46}},     fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-58,-12},{-4,-46}},     fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{2,-12},{56,-46}},     fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{62,-12},{88,-46}},     fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{34,-52},{88,-86}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}),  Rectangle(
    extent={{-26,-52},{28,-86}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-84,-52},{-32,-86}},      fillColor = {255, 213, 170},
   fillPattern =  FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-84,-92},{-64,-126}},     fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-58,-92},{-4,-126}},     fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{2,-92},{56,-126}},     fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{62,-92},{88,-124}},     fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}),
        Ellipse(
          extent={{-126,136},{-198,72}},
          lineColor={255,255,0},
          lineThickness=0.5,
          fillColor={244,125,35},
          fillPattern=FillPattern.Sphere),
        Text(
          extent={{-110,218},{112,186}},
          lineColor={0,0,255},
          textString="%name")}),Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-220,-220},{220,200}})),
    Documentation(info="<html>
<p>
This model calculates the solar heat gains through opaque elements. The heat flow by solar gains through building element k is given by
<p align=\"center\" style=\"font-style:italic;\">
&Phi;<sub>sol,k</sub> = F<sub>sh,ob,k</sub>A<sub>sol,k</sub>I<sub>sol,k</sub>-F<sub>r,k</sub>&Phi;<sub>r,k</sub>
</p>
where <i>F<sub>sh,ob,k</sub></i> is the shading reduction factor for external obstacles, 
<i>A<sub>sol,k</sub></i> is the effective collecting area of surface k,
<i>I<sub>sol,k</sub></i> is the solar irradiance per square meter, 
<i>F<sub>r,k</sub></i> is the form factor between the building element and the sky, and 
<i>&Phi;<sub>r,k</sub></i> is the extra heat flow due to thermal radiation to the sky. 
The effective collecting area of opaque elements <i>A<sub>sol</sub></i> is calculated as
<p align=\"center\" style=\"font-style:italic;\">
A<sub>sol</sub> = &alpha;<sub>s</sub>R<sub>se</sub>U<sub>op</sub>A<sub>op</sub>
</p>
where <i>&alpha;<sub>s</sub></i> is the dimensionless absoprtion coefficient for solar radiation of the opaque element,
<i>R<sub>se</sub></i> is the external surface heat resistance of the opaque element,
<i>U<sub>op</sub></i> is the thermal transmittance of the opaque element,
<i>A<sub>op</sub></i> is area of the opaque element. The extra heat flow due to thermal radiation is given by
<p align=\"center\" style=\"font-style:italic;\">
&Phi;<sub>r</sub> = R<sub>se</sub>U<sub>op</sub>A<sub>op</sub>h<sub>r</sub>∆T<sub>es</sub>
</p>
where <i>h<sub>r</sub></i> is the external radiative heat transfer coefficient, and
<i>∆T<sub>es</sub></i> is the average difference between the external air temperature and 
the apparent sky temperature (assumed equal to 11 K)


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
end OpaqueElements;
