within IDEAS.Buildings.Components;
model Window "Multipane window"

extends IDEAS.Buildings.Components.Interfaces.StateWall;

  parameter Modelica.SIunits.Area A "Total window area";
  parameter Modelica.SIunits.Angle inc
    "Inclination of the window, i.e. 90° denotes vertical";
  parameter Modelica.SIunits.Angle azi
    "Azimuth of the wall, i.e. 0° denotes South";

  replaceable parameter IDEAS.Buildings.Data.Interfaces.Glazing glazing
    "Glazing type" annotation (choicesAllMatching = true,Dialog(group="Construction details"));
  replaceable parameter Interfaces.StateShading shaType
    annotation (Placement(transformation(extent={{-36,-70},{-26,-50}})));
  Modelica.Blocks.Interfaces.RealInput Ctrl if shaType.controled
    "Control signal between 0 and 1, i.e. 1 is fully closed"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-30,-90}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-30,-100})));

Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b iSolDir
    "direct solar gains transmitted by windows"                                                              annotation (Placement(transformation(extent={{-10,
            -110},{10,-90}}), iconTransformation(extent={{-10,-110},{10,-90}})));
Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b iSolDif
    "diffuse solar gains transmitted by windows"                                                              annotation (Placement(transformation(extent={{20,-110},
            {40,-90}}), iconTransformation(extent={{20,-110},{40,-90}})));

protected
  parameter Boolean shading = false "Shading presence, i.e. true if present";
  parameter Modelica.SIunits.Efficiency shaCorr = 0.2
    "Total shading transmittance";

  IDEAS.Climate.Meteo.Solar.ShadedRadSol  radSol(inc=inc,azi=azi,A=A)
    "determination of incident solar radiation on wall based on inclination and azimuth"
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));
  IDEAS.Buildings.Components.BaseClasses.MultiLayerLucent layMul(
    A=A,
    inc=inc,
    nLay=glazing.nLay,
    mats=glazing.mats)
    "declaration of array of resistances and capacitances for wall simulation"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  IDEAS.Buildings.Components.BaseClasses.ExteriorConvection eCon(A=A)
    "convective surface heat transimission on the exterior side of the wall"
    annotation (Placement(transformation(extent={{-20,-40},{-40,-20}})));
  IDEAS.Buildings.Components.BaseClasses.InteriorConvection iCon(A=A, inc=inc)
    "convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  IDEAS.Buildings.Components.BaseClasses.ExteriorHeatRadidation skyRad(A=A, inc=
        inc)
    "determination of radiant heat exchange with the environment and sky"
    annotation (Placement(transformation(extent={{-20,-20},{-40,0}})));
  IDEAS.Buildings.Components.BaseClasses.SwWindowResponse solWin(
    nLay=glazing.nLay,
    SwAbs=glazing.SwAbs,
    SwTrans=glazing.SwTrans)
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));

equation
  connect(eCon.port_a, layMul.port_a)            annotation (Line(
      points={{-20,-30},{-10,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(skyRad.port_a, layMul.port_a)        annotation (Line(
      points={{-20,-10},{-16,-10},{-16,-30},{-10,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(solWin.iSolDir, iSolDir)      annotation (Line(
      points={{-2,-70},{-2,-80},{0,-80},{0,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(solWin.iSolDif, iSolDif)      annotation (Line(
      points={{2,-70},{0,-70},{0,-80},{30,-80},{30,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(solWin.iSolAbs, layMul.port_gain) annotation (Line(
      points={{0,-50},{0,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_a, skyRad.epsLw) annotation (Line(
      points={{-10,-22},{-14,-22},{-14,-4},{-20,-4}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(layMul.port_b, surfRad_a) annotation (Line(
      points={{10,-30},{16,-30},{16,-60},{50,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(iCon.port_b, surfCon_a) annotation (Line(
      points={{40,-30},{50,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_b, iEpsLw_a) annotation (Line(
      points={{10,-22},{14,-22},{14,30},{56,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.port_b, iCon.port_a) annotation (Line(
      points={{10,-30},{20,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_b, iEpsSw_a) annotation (Line(
      points={{10,-26},{18,-26},{18,0},{56,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.area, area_a) annotation (Line(
      points={{0,-20},{0,60},{56,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSol.solDir, shaType.solDir)  annotation (Line(
      points={{-50,-54},{-36,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSol.solDif, shaType.solDif)  annotation (Line(
      points={{-50,-58},{-36,-58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSol.angInc, shaType.angInc)  annotation (Line(
      points={{-50,-64},{-36,-64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSol.angZen, shaType.angZen)  annotation (Line(
      points={{-50,-66},{-36,-66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSol.angAzi, shaType.angAzi)  annotation (Line(
      points={{-50,-68},{-36,-68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaType.iSolDir, solWin.solDir)  annotation (Line(
      points={{-26,-54},{-10,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaType.iSolDif, solWin.solDif)  annotation (Line(
      points={{-26,-58},{-10,-58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaType.iAngInc, solWin.angInc)  annotation (Line(
      points={{-26,-66},{-10,-66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaType.Ctrl, Ctrl)  annotation (Line(
      points={{-31,-70},{-30,-70},{-30,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-50,-100},
            {50,100}}),
                   graphics={
        Polygon(
          points={{-46,60},{50,24},{50,-50},{-30,-20},{-46,-20},{-46,60}},
          smooth=Smooth.None,
          pattern=LinePattern.None,
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Line(
          points={{-50,60},{-30,60},{-30,80},{50,80}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-50,-20},{-30,-20},{-30,-70},{-30,-70},{52,-70}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-50,60},{-50,66},{-50,100},{50,100}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-50,-20},{-50,-90},{50,-90}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-46,60},{-46,-20}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None)}),            Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                                                                   graphics),
    Documentation(info="<html>
<p>The <code>Window</code> model describes the transient behaviour of translucent builiding enelope constructions. The description of the thermal response of a wall is structured as in the 4 different occurring processes, i.e. the transmittance and absorptance of shortwave solar radiation, heat balance of the exterior surface, heat conduction between both surfaces and the heat balance of the interior surface.</p>
<p><h4><font color=\"#008000\">Shortwave solar radiation transmission and absorption </font></h4></p>
<p>The properties for absorption by and transmission through the glazingare taken into account depending on the angle of incidence of solar irradiation and are based on the output of the <a href=\"IDEAS.Buildings.UsersGuide.References\">[WINDOW 6.3]</a> software, i.e. the shortwave properties itselves based on the layers in the window are not calculated in the model but are input parameters. </p>
<p><h4><font color=\"#008000\">Exterior surface heat balance </font></h4></p>
<p>The heat balance of the exterior surface is determined as </p>
<p align=\"center\"><img src=\"modelica://IDEAS/Images/equations/equation-ic4BqEOK.png\"/></p>
<p>where <img src=\"modelica://IDEAS/Images/equations/equation-isLu8did.png\"/> denotes the heat flow into the wall, <img src=\"modelica://IDEAS/Images/equations/equation-5rp8SIb9.png\"/> denotes heat transfer by convection, <img src=\"modelica://IDEAS/Images/equations/equation-VfYhZoRc.png\"/> denotes short-wave absorption of direct and diffuse solar light, <img src=\"modelica://IDEAS/Images/equations/equation-zh8V5q0N.png\"/> denotes long-wave heat exchange with the environment and <img src=\"modelica://IDEAS/Images/equations/equation-ClZCaUVP.png\"/> denotes long-wave heat exchange with the sky. The exterior convective heat flow is computed as </p>
<p align=\"center\"><img src=\"modelica://IDEAS/Images/equations/equation-dlroqBUD.png\"/></p>
<p>where <img src=\"modelica://IDEAS/Images/equations/equation-pvb42RGk.png\"/> is the surface area, <img src=\"modelica://IDEAS/Images/equations/equation-EFr6uClx.png\"/> is the dry-bulb exterior air temperature, <img src=\"modelica://IDEAS/Images/equations/equation-9BU57cj4.png\"/> is the surface temperature and <img src=\"modelica://IDEAS/Images/equations/equation-HvwkeunV.png\"/> is the wind speed in the undisturbed flow at 10 meter above the ground and where the stated correlation is valid for a <img src=\"modelica://IDEAS/Images/equations/equation-HvwkeunV.png\"/> range of [0.15,7.5] meter per second <a href=\"IDEAS.Buildings.UsersGuide.References\">[Defraeye 2011]</a>. The <img src=\"modelica://IDEAS/Images/equations/equation-HvwkeunV.png\"/>-dependent term denoting the exterior convective heat transfer coefficient <img src=\"modelica://IDEAS/Images/equations/equation-W7Ft8vaa.png\"/> is determined as <img src=\"modelica://IDEAS/Images/equations/equation-aZcbMNkz.png\"/> in order to take into account buoyancy effects at low wind speeds <a href=\"IDEAS.Buildings.UsersGuide.References\">[Jurges 1924]</a>. Longwave radiation between the surface and environment <img src=\"modelica://IDEAS/Images/equations/equation-AMjoTx5S.png\"/> is determined as</p>
<p align=\"center\"><img src=\"modelica://IDEAS/Images/equations/equation-nt0agyic.png\"/></p>
<p>as derived from the Stefan-Boltzmann law wherefore <img src=\"modelica://IDEAS/Images/equations/equation-C6ZFvd5P.png\"/> the Stefan-Boltzmann constant <a href=\"IDEAS.Buildings.UsersGuide.References\">[Mohr 2008]</a>, <img src=\"modelica://IDEAS/Images/equations/equation-sLNH0zgx.png\"/> the longwave emissivity of the exterior surface, <img src=\"modelica://IDEAS/Images/equations/equation-Q5X4Yht9.png\"/> the radiant-interchange configuration factor between the surface and sky <a href=\"IDEAS.Buildings.UsersGuide.References\">[Hamilton 1952]</a>, and the surface and the environment respectively and <img src=\"modelica://IDEAS/Images/equations/equation-k2V39u5g.png\"/> and <img src=\"modelica://IDEAS/Images/equations/equation-GuSnzLxW.png\"/> are the exterior surface and sky temperature respectively. Shortwave solar irradiation absorbed by the exterior surface is determined as </p>
<p align=\"center\"><img src=\"modelica://IDEAS/Images/equations/equation-cISf3Itz.png\"/></p>
<p>where <img src=\"modelica://IDEAS/Images/equations/equation-IKuIUMef.png\"/> is the shortwave absorption of the surface and <img src=\"modelica://IDEAS/Images/equations/equation-Vuo4fgcb.png\"/> the total irradiation on the depicted surface. </p>
<p><h4><font color=\"#008000\">Wall conduction process </font></h4></p>
<p>For the purpose of dynamic building simulation, the partial differential equation of the continuous time and space model of heat transport through a solid is most often simplified into ordinary differential equations with a finite number of parameters representing only one-dimensional heat transport through a construction layer. Within this context, the wall is modeled with lumped elements, i.e. a model where temperatures and heat fluxes are determined from a system composed of a sequence of discrete resistances and capacitances R_{n+1}, C_{n}. The number of capacitive elements $n$ used in modeling the transient thermal response of the wall denotes the order of the lumped capacitance model.</p>
<p align=\"center\"><img src=\"modelica://IDEAS/Images/equations/equation-pqp0E04K.png\"/></p>
<p>where <img src=\"modelica://IDEAS/Images/equations/equation-I7KXJhSH.png\"/> is the added energy to the lumped capacity, <img src=\"modelica://IDEAS/Images/equations/equation-B0HPmGTu.png\"/> is the temperature of the lumped capacity, <img src=\"modelica://IDEAS/Images/equations/equation-t7aqbnLB.png\"/> is the thermal capacity of the lumped capacity equal to<img src=\"modelica://IDEAS/Images/equations/equation-JieDs0oi.png\"/> for which rho denotes the density and <img src=\"modelica://IDEAS/Images/equations/equation-ml5CM4zK.png\"/> is the specific heat capacity of the material and <img src=\"modelica://IDEAS/Images/equations/equation-hOGNA6h5.png\"/> the equivalent thickness of the lumped element, where <img src=\"modelica://IDEAS/Images/equations/equation-1pDREAb7.png\"/> the heat flux through the lumped resistance and <img src=\"modelica://IDEAS/Images/equations/equation-XYf3O3hw.png\"/> is the total thermal resistance of the lumped resistance and where <img src=\"modelica://IDEAS/Images/equations/equation-dgS5sGAN.png\"/> are internal thermal source.</p>
<p><h4><font color=\"#008000\">Interior surface heat balance </font></h4></p>
<p>The heat balance of the interior surface is determined as </p>
<p align=\"center\"><img src=\"modelica://IDEAS/Images/equations/equation-omuYJaBt.png\"/></p>
<p>where <img src=\"modelica://IDEAS/Images/equations/equation-VQ2Uq5yQ.png\"/> denotes the heat flow into the wall, <img src=\"modelica://IDEAS/Images/equations/equation-jFQh4YxC.png\"/> denotes heat transfer by convection, <img src=\"modelica://IDEAS/Images/equations/equation-0lIKQUO2.png\"/> denotes short-wave absorption of direct and diffuse solar light netering the interior zone through windows and <img src=\"modelica://IDEAS/Images/equations/equation-jJJ8CeIr.png\"/> denotes long-wave heat exchange with the surounding interior surfaces. The surface heat resistances <img src=\"modelica://IDEAS/Images/equations/equation-mp9YB9Y0.png\"/> for the exterior and interior surface respectively are determined as <img src=\"modelica://IDEAS/Images/equations/equation-heVSJm8U.png\"/> where <img src=\"modelica://IDEAS/Images/equations/equation-81IuiWJg.png\"/> is the surface area and where <img src=\"modelica://IDEAS/Images/equations/equation-HcrpB4Mx.png\"/> is the exterior and interior convective heat transfer coefficient. The interior natural convective heat transfer coefficient <img src=\"modelica://IDEAS/Images/equations/equation-eZGZlJrg.png\"/> is computed for each interior surface as </p>
<p align=\"center\"><img src=\"modelica://IDEAS/Images/equations/equation-KNBSKUDK.png\"/></p>
<p>where <img src=\"modelica://IDEAS/Images/equations/equation-W5kvS3SS.png\"/> is the characteristic length of the surface, <img src=\"modelica://IDEAS/Images/equations/equation-jhC1rqax.png\"/> is the indoor air temperature and <img src=\"modelica://IDEAS/Images/equations/equation-sbXAgHuQ.png\"/> are correlation coefficients. These parameters {<img src=\"modelica://IDEAS/Images/equations/equation-nHmmePq5.png\"/>,<img src=\"modelica://IDEAS/Images/equations/equation-zJZmNUzp.png\"/>,<img src=\"modelica://IDEAS/Images/equations/equation-7nwXbcLp.png\"/>} are identical to {1.823,-0.121,0.293} for vertical surfaces <a href=\"IDEAS.Buildings.UsersGuide.References\">[Khalifa 2001]</a>, {2.175,-0.076,0.308} for horizontal surfaces wherefore the heat flux is in the same direction as the buoyancy force <a href=\"IDEAS.Buildings.UsersGuide.References\">[Khalifa 2001]</a>, and {2.72,-,0.13} for horizontal surfaces wherefore the heat flux is in the opposite direction as the buoyancy force <a href=\"IDEAS.Buildings.UsersGuide.References\">[Awbi 1999]</a>. The interior natural convective heat transfer coefficient is only described as function of the temperature difference. Similar to the thermal model for heat transfer through a wall, a thermal circuit formulation for the direct radiant exchange between surfaces can be derived <a href=\"IDEAS.Buildings.UsersGuide.References\">[Buchberg 1955, Oppenheim 1956]</a>. The resulting heat exchange by longwave radiation between two surface <img src=\"modelica://IDEAS/Images/equations/equation-u44Z52zq.png\"/> and <img src=\"modelica://IDEAS/Images/equations/equation-1i2Mx4Ca.png\"/> can be described as</p>
<p align=\"center\"><img src=\"modelica://IDEAS/Images/equations/equation-ULwzvhTg.png\"/></p>
<p>as derived from the Stefan-Boltzmann law wherefore <img src=\"modelica://IDEAS/Images/equations/equation-uDITjyTv.png\"/> and <img src=\"modelica://IDEAS/Images/equations/equation-zRzZUsty.png\"/> are the emissivity of surfaces <img src=\"modelica://IDEAS/Images/equations/equation-AtoPkohW.png\"/> and <img src=\"modelica://IDEAS/Images/equations/equation-XBM6Gmdj.png\"/> respectively, <img src=\"modelica://IDEAS/Images/equations/equation-l77CVDpb.png\"/> is radiant-interchange configuration factor <a href=\"IDEAS.Buildings.UsersGuide.References\">[Hamilton 1952]</a> between surfaces <img src=\"modelica://IDEAS/Images/equations/equation-40yn0CNI.png\"/> and <img src=\"modelica://IDEAS/Images/equations/equation-8AtnOwyb.png\"/>, <img src=\"modelica://IDEAS/Images/equations/equation-RBEWjWKa.png\"/> and <img src=\"modelica://IDEAS/Images/equations/equation-fxxW5qJd.png\"/> are the areas of surfaces <img src=\"modelica://IDEAS/Images/equations/equation-OM5mvW83.png\"/> and <img src=\"modelica://IDEAS/Images/equations/equation-2vsckTJX.png\"/> respectively, sigma is the Stefan-Boltzmann constant <a href=\"IDEAS.Buildings.UsersGuide.References\">[Mohr 2008]</a> and <img src=\"modelica://IDEAS/Images/equations/equation-I8IpXvtl.png\"/> and <img src=\"modelica://IDEAS/Images/equations/equation-HjTUUaGT.png\"/> are the surface temperature of surfaces <img src=\"modelica://IDEAS/Images/equations/equation-pkFYc6TO.png\"/> and <img src=\"modelica://IDEAS/Images/equations/equation-sbLFxSp8.png\"/> respectively. The above description of longwave radiation as mentioned above for a room or thermal zone results in the necessity of a very detailed input, i.e. the configuration between all needs to be described by their shape, position and orientation in order to define <img src=\"modelica://IDEAS/Images/equations/equation-MRIBXe5x.png\"/>, and difficulties to introduce windows and internal gains in the zone of interest. Simplification is achieved by means of a <img src=\"modelica://IDEAS/Images/equations/equation-tEXNH19s.png\"/> or delta-star transformation <a href=\"IDEAS.Buildings.UsersGuide.References\">[Kenelly 1899]</a> and by definition of a (fictive) radiant star node in the zone model. Literature <a href=\"IDEAS.Buildings.UsersGuide.References\">[Liesen 1997]</a> shows that the overall model is not significantly sensitive to this assumption. The heat exchange by longwave radiation between surface <img src=\"modelica://IDEAS/Images/equations/equation-Mjd7rCtc.png\"/> and the radiant star node in the zone model can be described as</p>
<p align=\"center\"><img src=\"modelica://IDEAS/Images/equations/equation-DsCmBlzm.png\"/></p>
<p>where <img src=\"modelica://IDEAS/Images/equations/equation-kKTzmHby.png\"/> is the emissivity of surface <img src=\"modelica://IDEAS/Images/equations/equation-QxeNUrgq.png\"/>, <img src=\"modelica://IDEAS/Images/equations/equation-ERb44Mb3.png\"/> is the area of surface <img src=\"modelica://IDEAS/Images/equations/equation-XF12EapA.png\"/>, <img src=\"modelica://IDEAS/Images/equations/equation-yyuov0Oi.png\"/> is the sum of areas for all surfaces <img src=\"modelica://IDEAS/Images/equations/equation-yRwsej2e.png\"/> of the thermal zone, <img src=\"modelica://IDEAS/Images/equations/equation-BmOQFx4B.png\"/> is the Stefan-Boltzmann constant <a href=\"IDEAS.Buildings.UsersGuide.References\">[Mohr 2008]</a> and <img src=\"modelica://IDEAS/Images/equations/equation-kDraFb4h.png\"/> and <img src=\"modelica://IDEAS/Images/equations/equation-suo6xr9a.png\"/> are the temperatures of surfaces <img src=\"modelica://IDEAS/Images/equations/equation-olgnuMEg.png\"/> and the radiant star node respectively. Absorption of shortwave solar radiation on the interior surface is handled equally as for the outside surface. Determination of the receiving solar radiation on the interior surface after passing through windows is dealt with in the zone model.</p>
</html>"));
end Window;
