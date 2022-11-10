within IBPSA.ThermalZones.ISO13790.BaseClasses;
model OpaqueElements "Solar heat gains of opaque elements"
  IBPSA.BoundaryConditions.WeatherData.Bus weaBus "weather data" annotation (Placement(
        transformation(extent={{-200,-20},{-160,20}}),iconTransformation(extent={{-230,
            -40},{-210,-20}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
    til=surTil[1],
    azi=surAzi[1]) "Direct solar irradiation on surface 1"
            annotation (Placement(transformation(extent={{-120,160},{-100,180}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil(
    til=surTil[1],
    azi=surAzi[1]) "Diffuse solar irradiation on surface 1"
    annotation (Placement(transformation(extent={{-120,140},{-100,160}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil1(
    til=surTil[2],
    azi=surAzi[2]) "Direct solar irradiation on surface 2"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil1(
    til=surTil[2],
    azi=surAzi[2]) "Diffuse solar irradiation on surface 2"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil2(
    til=surTil[3],
    azi=surAzi[3]) "Direct solar irradiation on surface 3"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil2(
    til=surTil[3],
    azi=surAzi[3]) "Diffuse solar irradiation on surface 3"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil3(
    til=surTil[4],
    azi=surAzi[4]) "Direct solar irradiation on surface 4"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil3(
    til=surTil[4],
    azi=surAzi[4]) "Diffuse solar irradiation on surface 4"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));

  parameter Real groRef = 0.2 "Ground reflectance"
      annotation(Evaluate=true, Dialog(tab = "General", group = "Location"));
  parameter Modelica.Units.SI.Area[4] AWal "Area of opaque constructions"
    annotation (Evaluate=true, Dialog(tab="General", group="Construction data"));

  parameter Real UWal "U-value of walls"
        annotation(Evaluate=true, Dialog(tab = "General", group = "Construction data"));

  parameter Modelica.Units.SI.Area ARoo "Area of opaque constructions"
    annotation (Dialog(tab="General", group="Construction data"));

  parameter Real URoo "U-value of roof"
        annotation(Evaluate=true, Dialog(tab = "General", group = "Construction data"));

   parameter Real eps = 0.9 "Emissivity of external surface"
        annotation(Evaluate=true, Dialog(tab = "General", group = "Construction data"));

  parameter Real alp = 0.6 "Absorption coefficient"
        annotation(Evaluate=true, Dialog(tab = "General", group = "Construction data"));

   parameter Real surRes = 0.04 "External surface heat resistance"
        annotation(Evaluate=true, Dialog(tab = "General", group = "Construction data"));

  parameter Modelica.Units.SI.Angle[5] surTil "Tilt angle of surfaces"
    annotation (Evaluate=true, Dialog(tab="General", group="Window directions"));
  parameter Modelica.Units.SI.Angle[5] surAzi
    "Azimuth angle of surfaces" annotation (Evaluate=true, Dialog(tab="General",
        group="Window directions"));

  Modelica.Blocks.Math.Add irr1
    "total of direct and diffuse radiation on facade 1"
    annotation (Placement(transformation(extent={{-80,150},{-60,170}})));
  Modelica.Blocks.Math.Gain AOpa1(k=AWal[1])
    "Area of opaque elements on facade 1"
    annotation (Placement(transformation(extent={{-40,150},{-20,170}})));
  Modelica.Blocks.Math.Gain alp1(k=alp)
    "dimensionless absoprtion coefficient for solar radiation of the opaque element"
    annotation (Placement(transformation(extent={{0,150},{20,170}})));
  Modelica.Blocks.Math.Gain res1(k=surRes)
    "External surface heat resistance of the opaque element"
    annotation (Placement(transformation(extent={{80,150},{100,170}})));
  Modelica.Blocks.Math.Add irr2
    "total of direct and diffuse radiation on facade 2"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Math.Gain AOpa2(k=AWal[2])
    "Area of opaque elements on the east facade"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Modelica.Blocks.Math.Gain alp2(k=alp)
    "dimensionless absoprtion coefficient for solar radiation of the opaque element"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Modelica.Blocks.Math.Gain res2(k=surRes)
    "External surface heat resistance of the opaque element"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Modelica.Blocks.Math.Add irr3
    "total of direct and diffuse radiation on the south facade"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Math.Gain AOpa3(k=AWal[3])
    "Area of opaque elements on the south facade"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Math.Gain alp3(k=alp)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Math.Gain res3(k=surRes)
    "External surface heat resistance of the opaque element"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Modelica.Blocks.Math.Add irr4
    "total of direct and diffuse radiation on the west facade"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Modelica.Blocks.Math.Gain AOpa4(k=AWal[4])
    "Area of opaque elements on the west facade"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Modelica.Blocks.Math.Gain alp4(k=alp)
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Modelica.Blocks.Math.Gain res4(k=surRes)
    "External surface heat resistance of the opaque element"
    annotation (Placement(transformation(extent={{80,-90},{100,-70}})));
  Modelica.Blocks.Math.Sum sum(nin=5) "Sum of solar gains through opaque surfaces"
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));
  Modelica.Blocks.Interfaces.RealOutput SolRadOpa( unit="W") "Total solar gains through opaque surfaces"
    annotation (Placement(transformation(extent={{220,-10},{240,10}}),
        iconTransformation(extent={{220,-10},{240,10}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil4(
    til=surTil[5],
    azi=surAzi[5])
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));
  IBPSA.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil4(
    til=surTil[5],
    azi=surAzi[5])
    annotation (Placement(transformation(extent={{-120,-180},{-100,-160}})));
  Modelica.Blocks.Math.Add irrRoo
    "total of direct and diffuse radiation on the roof"
    annotation (Placement(transformation(extent={{-80,-170},{-60,-150}})));
  Modelica.Blocks.Math.Gain AOpaRoo(k=ARoo)
    "Area of opaque elements on the roof"
    annotation (Placement(transformation(extent={{-40,-170},{-20,-150}})));
  Modelica.Blocks.Math.Gain alpRoo(k=alp)
    annotation (Placement(transformation(extent={{0,-170},{20,-150}})));
  Modelica.Blocks.Math.Gain resRoof(k=surRes)
    "External surface heat resistance of the opaque element"
    annotation (Placement(transformation(extent={{80,-170},{100,-150}})));
  Modelica.Blocks.Math.Gain U1(k=UWal) "U-value of opaque elements"
    annotation (Placement(transformation(extent={{40,150},{60,170}})));
  Modelica.Blocks.Math.Gain U2(k=UWal) "U-value of opaque elements"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Modelica.Blocks.Math.Gain U3(k=UWal) "U-value of opaque elements"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Math.Gain U4(k=UWal) "U-value of opaque elements"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Modelica.Blocks.Math.Gain U5(k=URoo) "U-value of the roof"
    annotation (Placement(transformation(extent={{40,-170},{60,-150}})));
  Modelica.Blocks.Math.Add phiSol1(k2=-1) "Solar gains through surface 1"
    annotation (Placement(transformation(extent={{120,144},{140,164}})));
  Modelica.Blocks.Sources.RealExpression fac1(y=UWal*AWal[1]*surRes) "factor"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Modelica.Blocks.Math.Gain h1(k=5*eps)
    "External radiative heat transfer coefficient"
    annotation (Placement(transformation(extent={{0,110},{20,130}})));
  Modelica.Blocks.Math.Gain dT1(k=11)
    "Average difference between the external air temperature and the apparent sky temperature"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));
  Modelica.Blocks.Sources.RealExpression fac2(y=UWal*AWal[2]*surRes) "factor"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Modelica.Blocks.Math.Gain h2(k=5*eps)
    "External radiative heat transfer coefficient"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Modelica.Blocks.Math.Gain dT2(k=11)
    "Average difference between the external air temperature and the apparent sky temperature"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Modelica.Blocks.Math.Gain forFac2(k=0.5) "form factor"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Modelica.Blocks.Math.Gain forFac1(k=0.5) "form factor"
    annotation (Placement(transformation(extent={{80,110},{100,130}})));
  Modelica.Blocks.Math.Add phiSol2(k2=-1) "Solar gains through surface 2"
    annotation (Placement(transformation(extent={{120,64},{140,84}})));
  Modelica.Blocks.Sources.RealExpression fac3(y=UWal*AWal[3]*surRes) "factor"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Modelica.Blocks.Math.Gain h3(k=5*eps)
    "External radiative heat transfer coefficient"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Modelica.Blocks.Math.Gain dT3(k=11)
    "Average difference between the external air temperature and the apparent sky temperature"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Modelica.Blocks.Math.Gain forFac3(k=0.5) "form factor"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));
  Modelica.Blocks.Math.Add phiSol3(k2=-1) "Solar gains through surface 3"
    annotation (Placement(transformation(extent={{122,-16},{142,4}})));
  Modelica.Blocks.Sources.RealExpression fac4(y=UWal*AWal[4]*surRes) "factor"
    annotation (Placement(transformation(extent={{-40,-130},{-20,-110}})));
  Modelica.Blocks.Math.Gain h4(k=5*eps)
    "External radiative heat transfer coefficient"
    annotation (Placement(transformation(extent={{0,-130},{20,-110}})));
  Modelica.Blocks.Math.Gain dT4(k=11)
    "Average difference between the external air temperature and the apparent sky temperature"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));
  Modelica.Blocks.Math.Gain forFac4(k=0.5) "form factor"
    annotation (Placement(transformation(extent={{80,-130},{100,-110}})));
  Modelica.Blocks.Math.Add phiSol4(k2=-1) "Solar gains through surface 4"
    annotation (Placement(transformation(extent={{120,-96},{140,-76}})));
  Modelica.Blocks.Math.Add phiSolRoo(k2=-1) "Solar gains through the roof"
    annotation (Placement(transformation(extent={{120,-176},{140,-156}})));
  Modelica.Blocks.Sources.RealExpression facRoo(y=URoo*ARoo*surRes) "factor"
    annotation (Placement(transformation(extent={{-40,-210},{-20,-190}})));
  Modelica.Blocks.Math.Gain hRoo(k=5*eps)
    "External radiative heat transfer coefficient"
    annotation (Placement(transformation(extent={{0,-210},{20,-190}})));
  Modelica.Blocks.Math.Gain dTRoo(k=11)
    "Average difference between the external air temperature and the apparent sky temperature"
    annotation (Placement(transformation(extent={{40,-210},{60,-190}})));
  Modelica.Blocks.Math.Gain forFacRoo(k=1) "form factor"
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
  connect(irr1.u1, HDirTil.H) annotation (Line(points={{-82,166},{-92,166},{-92,
          170},{-99,170}}, color={0,0,127}));
  connect(irr1.u2, HDifTil.H) annotation (Line(points={{-82,154},{-92,154},{-92,
          150},{-99,150}}, color={0,0,127}));
  connect(AOpa1.u, irr1.y)
    annotation (Line(points={{-42,160},{-59,160}}, color={0,0,127}));
  connect(AOpa1.y, alp1.u)
    annotation (Line(points={{-19,160},{-2,160}}, color={0,0,127}));
  connect(alp1.y, U1.u)
    annotation (Line(points={{21,160},{38,160}}, color={0,0,127}));
  connect(U1.y, res1.u)
    annotation (Line(points={{61,160},{78,160}}, color={0,0,127}));
  connect(phiSol1.u1, res1.y)
    annotation (Line(points={{118,160},{101,160}}, color={0,0,127}));
  connect(h1.u, fac1.y)
    annotation (Line(points={{-2,120},{-19,120}}, color={0,0,127}));
  connect(dT1.u, h1.y)
    annotation (Line(points={{38,120},{21,120}}, color={0,0,127}));
  connect(dT1.y, forFac1.u)
    annotation (Line(points={{61,120},{78,120}}, color={0,0,127}));
  connect(forFac1.y, phiSol1.u2) annotation (Line(points={{101,120},{108,120},{108,
          148},{118,148}}, color={0,0,127}));
  connect(irr2.u1, HDirTil1.H) annotation (Line(points={{-82,86},{-92,86},{-92,90},
          {-99,90}}, color={0,0,127}));
  connect(irr2.u2, HDifTil1.H) annotation (Line(points={{-82,74},{-92,74},{-92,70},
          {-99,70}}, color={0,0,127}));
  connect(AOpa2.u, irr2.y)
    annotation (Line(points={{-42,80},{-59,80}}, color={0,0,127}));
  connect(alp2.u, AOpa2.y)
    annotation (Line(points={{-2,80},{-19,80}}, color={0,0,127}));
  connect(U2.u, alp2.y)
    annotation (Line(points={{38,80},{21,80}}, color={0,0,127}));
  connect(res2.u, U2.y)
    annotation (Line(points={{78,80},{61,80}}, color={0,0,127}));
  connect(phiSol2.u1, res2.y)
    annotation (Line(points={{118,80},{101,80}}, color={0,0,127}));
  connect(h2.y, dT2.u)
    annotation (Line(points={{21,40},{38,40}}, color={0,0,127}));
  connect(dT2.y, forFac2.u)
    annotation (Line(points={{61,40},{78,40}}, color={0,0,127}));
  connect(forFac2.y, phiSol2.u2) annotation (Line(points={{101,40},{108,40},{108,
          68},{118,68}}, color={0,0,127}));
  connect(irr3.u1, HDirTil2.H) annotation (Line(points={{-82,6},{-92,6},{-92,10},
          {-99,10}}, color={0,0,127}));
  connect(irr3.u2, HDifTil2.H) annotation (Line(points={{-82,-6},{-92,-6},{-92,-10},
          {-99,-10}}, color={0,0,127}));
  connect(AOpa3.u, irr3.y)
    annotation (Line(points={{-42,0},{-59,0}}, color={0,0,127}));
  connect(alp3.u, AOpa3.y)
    annotation (Line(points={{-2,0},{-19,0}}, color={0,0,127}));
  connect(U3.u, alp3.y)
    annotation (Line(points={{38,0},{21,0}}, color={0,0,127}));
  connect(res3.u, U3.y)
    annotation (Line(points={{78,0},{61,0}}, color={0,0,127}));
  connect(res3.y, phiSol3.u1)
    annotation (Line(points={{101,0},{120,0}}, color={0,0,127}));
  connect(phiSol3.u2, forFac3.y) annotation (Line(points={{120,-12},{110,-12},{110,
          -40},{101,-40}}, color={0,0,127}));
  connect(forFac3.u, dT3.y)
    annotation (Line(points={{78,-40},{61,-40}}, color={0,0,127}));
  connect(dT3.u, h3.y)
    annotation (Line(points={{38,-40},{21,-40}}, color={0,0,127}));
  connect(h3.u, fac3.y)
    annotation (Line(points={{-2,-40},{-19,-40}}, color={0,0,127}));
  connect(HDirTil3.H, irr4.u1) annotation (Line(points={{-99,-70},{-90,-70},{-90,
          -74},{-82,-74}}, color={0,0,127}));
  connect(irr4.u2, HDifTil3.H) annotation (Line(points={{-82,-86},{-92,-86},{-92,
          -90},{-99,-90}}, color={0,0,127}));
  connect(AOpa4.u, irr4.y)
    annotation (Line(points={{-42,-80},{-59,-80}}, color={0,0,127}));
  connect(alp4.u, AOpa4.y)
    annotation (Line(points={{-2,-80},{-19,-80}}, color={0,0,127}));
  connect(U4.u, alp4.y)
    annotation (Line(points={{38,-80},{21,-80}}, color={0,0,127}));
  connect(phiSol4.u2, forFac4.y) annotation (Line(points={{118,-92},{110,-92},{110,
          -120},{101,-120}}, color={0,0,127}));
  connect(forFac4.u, dT4.y)
    annotation (Line(points={{78,-120},{61,-120}}, color={0,0,127}));
  connect(dT4.u, h4.y)
    annotation (Line(points={{38,-120},{21,-120}}, color={0,0,127}));
  connect(h4.u, fac4.y)
    annotation (Line(points={{-2,-120},{-19,-120}}, color={0,0,127}));
  connect(irrRoo.u1, HDirTil4.H) annotation (Line(points={{-82,-154},{-92,-154},
          {-92,-150},{-99,-150}}, color={0,0,127}));
  connect(irrRoo.u2, HDifTil4.H) annotation (Line(points={{-82,-166},{-92,-166},
          {-92,-170},{-99,-170}}, color={0,0,127}));
  connect(AOpaRoo.u, irrRoo.y)
    annotation (Line(points={{-42,-160},{-59,-160}}, color={0,0,127}));
  connect(alpRoo.u, AOpaRoo.y)
    annotation (Line(points={{-2,-160},{-19,-160}}, color={0,0,127}));
  connect(U5.u, alpRoo.y)
    annotation (Line(points={{38,-160},{21,-160}}, color={0,0,127}));
  connect(resRoof.u, U5.y)
    annotation (Line(points={{78,-160},{61,-160}}, color={0,0,127}));
  connect(phiSolRoo.u1, resRoof.y)
    annotation (Line(points={{118,-160},{101,-160}}, color={0,0,127}));
  connect(phiSolRoo.u2, forFacRoo.y) annotation (Line(points={{118,-172},{110,-172},
          {110,-200},{101,-200}}, color={0,0,127}));
  connect(forFacRoo.u, dTRoo.y)
    annotation (Line(points={{78,-200},{61,-200}}, color={0,0,127}));
  connect(dTRoo.u, hRoo.y)
    annotation (Line(points={{38,-200},{21,-200}}, color={0,0,127}));
  connect(hRoo.u, facRoo.y)
    annotation (Line(points={{-2,-200},{-19,-200}}, color={0,0,127}));
  connect(phiSol1.y, sum.u[1]) annotation (Line(points={{141,154},{164,154},{164,
          -1.6},{178,-1.6}}, color={0,0,127}));
  connect(phiSol2.y, sum.u[2]) annotation (Line(points={{141,74},{164,74},{164,-0.8},
          {178,-0.8}}, color={0,0,127}));
  connect(phiSol3.y, sum.u[3]) annotation (Line(points={{143,-6},{166,-6},{166,0},
          {178,0}}, color={0,0,127}));
  connect(phiSol4.y, sum.u[4]) annotation (Line(points={{141,-86},{164,-86},{164,
          0.8},{178,0.8}}, color={0,0,127}));
  connect(phiSolRoo.y, sum.u[5]) annotation (Line(points={{141,-166},{164,-166},
          {164,1.6},{178,1.6}}, color={0,0,127}));
  connect(SolRadOpa, sum.y)
    annotation (Line(points={{230,0},{201,0}}, color={0,0,127}));
  connect(phiSol4.u1, res4.y)
    annotation (Line(points={{118,-80},{101,-80}}, color={0,0,127}));
  connect(res4.u, U4.y)
    annotation (Line(points={{78,-80},{61,-80}}, color={0,0,127}));
  connect(h2.u, fac2.y)
    annotation (Line(points={{-2,40},{-19,40}}, color={0,0,127}));
  annotation (defaultComponentName="opaEle",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-220,-220},
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
          textColor={0,0,255},
          textString="%name")}),Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-220,-220},{220,200}})),
    Documentation(info="<html>
<p>
This model calculates the solar heat gains through opaque elements. The heat flow by solar gains through building element k is given by
<p align=\"center\" style=\"font-style:italic;\">
&Phi;<sub>sol,k</sub> = F<sub>sh,ob,k</sub>A<sub>sol,k</sub>I<sub>sol,k</sub>-F<sub>r,k</sub>&Phi;<sub>r,k</sub>,
</p>
<p>
where <i>F<sub>sh,ob,k</sub></i> is the shading reduction factor for external obstacles,
<i>A<sub>sol,k</sub></i> is the effective collecting area of surface k,
<i>I<sub>sol,k</sub></i> is the solar irradiance per square meter,
<i>F<sub>r,k</sub></i> is the form factor between the building element and the sky, and
<i>&Phi;<sub>r,k</sub></i> is the extra heat flow due to thermal radiation to the sky.
The effective collecting area of opaque elements <i>A<sub>sol</sub></i> is calculated as
</p>
<p align=\"center\" style=\"font-style:italic;\">
A<sub>sol</sub> = &alpha;<sub>s</sub>R<sub>se</sub>U<sub>op</sub>A<sub>op</sub>,
</p>
<p>
where <i>&alpha;<sub>s</sub></i> is the dimensionless absoprtion coefficient for solar radiation of the opaque element,
<i>R<sub>se</sub></i> is the external surface heat resistance of the opaque element,
<i>U<sub>op</sub></i> is the thermal transmittance of the opaque element,
<i>A<sub>op</sub></i> is area of the opaque element. The extra heat flow due to thermal radiation is given by
<p align=\"center\" style=\"font-style:italic;\">
&Phi;<sub>r</sub> = R<sub>se</sub>U<sub>op</sub>A<sub>op</sub>h<sub>r</sub>&#8710;T<sub>es</sub>,
</p>
<p>
where <i>h<sub>r</sub></i> is the external radiative heat transfer coefficient, and
<i>&#8710;T<sub>es</sub></i> is the average difference between the external air temperature and
the apparent sky temperature (assumed equal to <i>11</i> K).
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
end OpaqueElements;
