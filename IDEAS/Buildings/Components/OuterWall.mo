within IDEAS.Buildings.Components;
model OuterWall "Opaque building envelope construction"

extends IDEAS.Buildings.Components.Interfaces.StateWall;

replaceable Data.Interfaces.Construction constructionType(insulationType=insulationType, insulationTickness=insulationThickness)
    "Type of building construction" annotation (choicesAllMatching = true, Placement(transformation(extent={{-38,72},
            {-34,76}})),Dialog(group="Construction details"));
replaceable Data.Interfaces.Insulation insulationType(d=insulationThickness)
    "Type of thermal insulation" annotation (choicesAllMatching = true, Placement(transformation(extent={{-38,84},
            {-34,88}})),Dialog(group="Construction details"));
parameter Modelica.SIunits.Length insulationThickness
    "Thermal insulation thickness" annotation(Dialog(group="Construction details"));
parameter Modelica.SIunits.Area AWall "Total wall area";
parameter Modelica.SIunits.Angle inc
    "Inclination of the wall, i.e. 90° denotes vertical";
parameter Modelica.SIunits.Angle azi
    "Azimuth of the wall, i.e. 0° denotes South";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_emb
    "port for gains by embedded active layers"
  annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

protected
  IDEAS.Climate.Meteo.Solar.RadSol  radSol(inc=inc,azi=azi,A=AWall)
    "determination of incident solar radiation on wall based on inclination and azimuth"
    annotation (Placement(transformation(extent={{-70,-40},{-50,-20}})));
  IDEAS.Buildings.Components.BaseClasses.MultiLayerOpaque layMul(
    A=AWall,
    inc=inc,
    nLay=constructionType.nLay,
    mats=constructionType.mats)
    "declaration of array of resistances and capacitances for wall simulation"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  IDEAS.Buildings.Components.BaseClasses.ExteriorConvection extCon(A=AWall)
    "convective surface heat transimission on the exterior side of the wall"
    annotation (Placement(transformation(extent={{-20,-60},{-40,-40}})));
  IDEAS.Buildings.Components.BaseClasses.InteriorConvection intCon(A=AWall, inc=inc)
    "convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  IDEAS.Buildings.Components.BaseClasses.ExteriorSolarAbsorption solAbs(A=AWall)
    "determination of absorbed solar radiation by wall based on incident radiation"
 annotation (Placement(transformation(extent={{-20,-40},{-40,-20}})));
  IDEAS.Buildings.Components.BaseClasses.ExteriorHeatRadidation extRad(A=AWall, inc=
        inc)
    "determination of radiant heat exchange with the environment and sky"
    annotation (Placement(transformation(extent={{-20,-20},{-40,0}})));

equation
  connect(radSol.solDir, solAbs.solDir) annotation (Line(
      points={{-50,-24},{-40,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSol.solDif, solAbs.solDif) annotation (Line(
      points={{-50,-28},{-40,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(extCon.port_a, layMul.port_a)          annotation (Line(
      points={{-20,-50},{-16,-50},{-16,-30},{-10,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(solAbs.port_a, layMul.port_a)        annotation (Line(
      points={{-20,-30},{-10,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(extRad.port_a, layMul.port_a)        annotation (Line(
      points={{-20,-10},{-16,-10},{-16,-30},{-10,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_b, intCon.port_a)
                                      annotation (Line(
      points={{10,-30},{20,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_a, solAbs.epsSw) annotation (Line(
      points={{-10,-26},{-14,-26},{-14,-24},{-20,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_a,extRad. epsLw) annotation (Line(
      points={{-10,-22},{-14,-22},{-14,-4},{-20,-4}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(port_emb, layMul.port_gain[constructionType.locGain]) annotation (Line(
      points={{0,-100},{0,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intCon.port_b, surfCon_a) annotation (Line(
      points={{40,-30},{50,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_b, surfRad_a) annotation (Line(
      points={{10,-30},{16,-30},{16,-60},{50,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_b, iEpsLw_a) annotation (Line(
      points={{10,-22},{14,-22},{14,30},{56,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_b, iEpsSw_a) annotation (Line(
      points={{10,-26},{16,-26},{16,0},{56,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.area, area_a) annotation (Line(
      points={{0,-20},{0,60},{56,60}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-50,-100},
            {50,100}}),
                   graphics={
        Polygon(
          points={{-50,60},{-30,60},{-30,80},{50,80},{50,100},{-50,100},{-50,60}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          smooth=Smooth.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-30,-70},{-50,-20}},
          lineThickness=0.5,
          fillColor={175,175,175},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None),
        Line(
          points={{-50,60},{-50,66},{-50,100},{50,100}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-50,60},{-30,60},{-30,80},{50,80}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-50,-20},{-30,-20},{-30,-70},{-30,-70},{52,-70}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-50,-20},{-50,-90},{50,-90}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-44,60},{-30,60},{-30,80},{-28,80},{50,80}},
          pattern=LinePattern.None,
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-44,-20},{-30,-20},{-30,-70}},
          pattern=LinePattern.None,
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-44,60},{-44,-20}},
          smooth=Smooth.None,
          color={175,175,175})}),Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}),
                                         graphics),
    Documentation(info="<html>
<p>The <code>OuterWall</code> model describes the transient behaviour of opaque builiding enelope constructions. The description of the thermal response of a wall is structured as in the 3 different occurring processes, i.e. the heat balance of the exterior surface, heat conduction between both surfaces and the heat balance of the interior surface.</p>
<p><h4><font color=\"#008000\">Exterior surface heat balance </font></h4></p>
<p>The heat balance of the exterior surface is determined as </p>
<p align=\"center\"><img src=\"modelica://IDEAS/Images/equations/equation-ic4BqEOK.png\" alt=\"Q_net = Q_c + Q_SW + Q_LWe  + Q_LWsky\"/></p>
<p>where <img src=\"modelica://IDEAS/Images/equations/equation-isLu8did.png\" alt=\"Q_net\"/> denotes the heat flow into the wall, <img src=\"modelica://IDEAS/Images/equations/equation-5rp8SIb9.png\" alt=\"Q_c\"/> denotes heat transfer by convection, <img src=\"modelica://IDEAS/Images/equations/equation-VfYhZoRc.png\" alt=\"Q_SW\"/> denotes short-wave absorption of direct and diffuse solar light, <img src=\"modelica://IDEAS/Images/equations/equation-zh8V5q0N.png\" alt=\"Q_LWe\"/> denotes long-wave heat exchange with the environment and <img src=\"modelica://IDEAS/Images/equations/equation-ClZCaUVP.png\" alt=\"Q_LWsky\"/> denotes long-wave heat exchange with the sky. The exterior convective heat flow is computed as </p>
<p align=\"center\"><img src=\"modelica://IDEAS/Images/equations/equation-dlroqBUD.png\" alt=\"Q_c = 5.01*v_10^0.85*A (T_db - T_s) \"/></p>
<p>where <img src=\"modelica://IDEAS/Images/equations/equation-pvb42RGk.png\" alt=\"A\"/> is the surface area, <img src=\"modelica://IDEAS/Images/equations/equation-EFr6uClx.png\" alt=\"T_db\"/> is the dry-bulb exterior air temperature, <img src=\"modelica://IDEAS/Images/equations/equation-9BU57cj4.png\" alt=\"T_s\"/> is the surface temperature and <img src=\"modelica://IDEAS/Images/equations/equation-HvwkeunV.png\" alt=\"v_10\"/> is the wind speed in the undisturbed flow at 10 meter above the ground and where the stated correlation is valid for a <img src=\"modelica://IDEAS/Images/equations/equation-HvwkeunV.png\" alt=\"v_10\"/> range of [0.15,7.5] meter per second <a href=\"IDEAS.Buildings.UsersGuide.References\">[Defraeye 2011]</a>. The <img src=\"modelica://IDEAS/Images/equations/equation-HvwkeunV.png\" alt=\"v_10\"/>-dependent term denoting the exterior convective heat transfer coefficient <img src=\"modelica://IDEAS/Images/equations/equation-W7Ft8vaa.png\" alt=\"h_ce\"/> is determined as <img src=\"modelica://IDEAS/Images/equations/equation-aZcbMNkz.png\" alt=\"max(f(v_10),5.6)\"/> in order to take into account buoyancy effects at low wind speeds <a href=\"IDEAS.Buildings.UsersGuide.References\">[Jurges 1924]</a>. Longwave radiation between the surface and environment <img src=\"modelica://IDEAS/Images/equations/equation-AMjoTx5S.png\" alt=\"Q_LWe\"/> is determined as</p>
<p align=\"center\"><img src=\"modelica://IDEAS/Images/equations/equation-nt0agyic.png\" alt=\"Q_LWe = sigma*epsilon*A*(T_s^4-F_sky*T_sky^4-(1-F_sky)*T_db^4)\"/></p>
<p>as derived from the Stefan-Boltzmann law wherefore <img src=\"modelica://IDEAS/Images/equations/equation-C6ZFvd5P.png\" alt=\"sigma\"/> the Stefan-Boltzmann constant <a href=\"IDEAS.Buildings.UsersGuide.References\">[Mohr 2008]</a>, <img src=\"modelica://IDEAS/Images/equations/equation-sLNH0zgx.png\" alt=\"epsilon\"/> the longwave emissivity of the exterior surface, <img src=\"modelica://IDEAS/Images/equations/equation-Q5X4Yht9.png\" alt=\"F_sky\"/> the radiant-interchange configuration factor between the surface and sky <a href=\"IDEAS.Buildings.UsersGuide.References\">[Hamilton 1952]</a>, and the surface and the environment respectively and <img src=\"modelica://IDEAS/Images/equations/equation-k2V39u5g.png\" alt=\"T_s\"/> and <img src=\"modelica://IDEAS/Images/equations/equation-GuSnzLxW.png\" alt=\"T_sky\"/> are the exterior surface and sky temperature respectively. Shortwave solar irradiation absorbed by the exterior surface is determined as </p>
<p align=\"center\"><img src=\"modelica://IDEAS/Images/equations/equation-cISf3Itz.png\" alt=\"Q_SW = epsilon_SW*A*E_SW\"/></p>
<p>where <img src=\"modelica://IDEAS/Images/equations/equation-IKuIUMef.png\" alt=\"epsilon_SW\"/> is the shortwave absorption of the surface and <img src=\"modelica://IDEAS/Images/equations/equation-Vuo4fgcb.png\" alt=\"E_SW\"/> the total irradiation on the depicted surface. </p>
<p><h4><font color=\"#008000\">Wall conduction process </font></h4></p>
<p>For the purpose of dynamic building simulation, the partial differential equation of the continuous time and space model of heat transport through a solid is most often simplified into ordinary differential equations with a finite number of parameters representing only one-dimensional heat transport through a construction layer. Within this context, the wall is modeled with lumped elements, i.e. a model where temperatures and heat fluxes are determined from a system composed of a sequence of discrete resistances and capacitances R_{n+1}, C_{n}. The number of capacitive elements $n$ used in modeling the transient thermal response of the wall denotes the order of the lumped capacitance model.</p>
<p align=\"center\"><img src=\"modelica://IDEAS/Images/equations/equation-pqp0E04K.png\" alt=\"dT_c/dt*C=sum_i^n*Q_resi+Q_source\"/></p>
<p>where <img src=\"modelica://IDEAS/Images/equations/equation-I7KXJhSH.png\" alt=\"Q_source\"/> is the added energy to the lumped capacity, <img src=\"modelica://IDEAS/Images/equations/equation-B0HPmGTu.png\" alt=\"T_c\"/> is the temperature of the lumped capacity, <img src=\"modelica://IDEAS/Images/equations/equation-t7aqbnLB.png\" alt=\"C_c\"/> is the thermal capacity of the lumped capacity equal to<img src=\"modelica://IDEAS/Images/equations/equation-JieDs0oi.png\" alt=\"rho*c*d_c*A\"/> for which rho denotes the density and <img src=\"modelica://IDEAS/Images/equations/equation-ml5CM4zK.png\" alt=\"c\"/> is the specific heat capacity of the material and <img src=\"modelica://IDEAS/Images/equations/equation-hOGNA6h5.png\" alt=\"d_c\"/> the equivalent thickness of the lumped element, where <img src=\"modelica://IDEAS/Images/equations/equation-1pDREAb7.png\" alt=\"Q_res\"/> the heat flux through the lumped resistance and <img src=\"modelica://IDEAS/Images/equations/equation-XYf3O3hw.png\" alt=\"R_res\"/> is the total thermal resistance of the lumped resistance and where <img src=\"modelica://IDEAS/Images/equations/equation-dgS5sGAN.png\" alt=\"Q_source\"/> are internal thermal source.</p>
<p><h4><font color=\"#008000\">Interior surface heat balance </font></h4></p>
<p>The heat balance of the interior surface is determined as </p>
<p align=\"center\"><img src=\"modelica://IDEAS/Images/equations/equation-omuYJaBt.png\" alt=\"Q_net=Q_c+sum_i^N*Q_SWi+sum_i^N*Q_LWi\"/></p>
<p>where <img src=\"modelica://IDEAS/Images/equations/equation-VQ2Uq5yQ.png\" alt=\"Q_net\"/> denotes the heat flow into the wall, <img src=\"modelica://IDEAS/Images/equations/equation-jFQh4YxC.png\" alt=\"Q_c\"/> denotes heat transfer by convection, <img src=\"modelica://IDEAS/Images/equations/equation-0lIKQUO2.png\" alt=\"Q_SW\"/> denotes short-wave absorption of direct and diffuse solar light netering the interior zone through windows and <img src=\"modelica://IDEAS/Images/equations/equation-jJJ8CeIr.png\" alt=\"Q_LWi\"/> denotes long-wave heat exchange with the surounding interior surfaces. The surface heat resistances <img src=\"modelica://IDEAS/Images/equations/equation-mp9YB9Y0.png\" alt=\"R_s\"/> for the exterior and interior surface respectively are determined as <img src=\"modelica://IDEAS/Images/equations/equation-heVSJm8U.png\" alt=\"R_s^(-1)=A*h_c\"/> where <img src=\"modelica://IDEAS/Images/equations/equation-81IuiWJg.png\" alt=\"A\"/> is the surface area and where <img src=\"modelica://IDEAS/Images/equations/equation-HcrpB4Mx.png\" alt=\"h_c\"/> is the exterior and interior convective heat transfer coefficient. The interior natural convective heat transfer coefficient <img src=\"modelica://IDEAS/Images/equations/equation-eZGZlJrg.png\" alt=\"h_ci\"/> is computed for each interior surface as </p>
<p align=\"center\"><img src=\"modelica://IDEAS/Images/equations/equation-KNBSKUDK.png\" alt=\"h_ci=n_1*D^(n_2)*(T_a-T_s)^(n_3)\"/></p>
<p>where <img src=\"modelica://IDEAS/Images/equations/equation-W5kvS3SS.png\" alt=\"D\"/> is the characteristic length of the surface, <img src=\"modelica://IDEAS/Images/equations/equation-jhC1rqax.png\" alt=\"T_a\"/> is the indoor air temperature and <img src=\"modelica://IDEAS/Images/equations/equation-sbXAgHuQ.png\" alt=\"n_i\"/> are correlation coefficients. These parameters {<img src=\"modelica://IDEAS/Images/equations/equation-nHmmePq5.png\" alt=\"n_1\"/>,<img src=\"modelica://IDEAS/Images/equations/equation-zJZmNUzp.png\" alt=\"n_2\"/>,<img src=\"modelica://IDEAS/Images/equations/equation-7nwXbcLp.png\" alt=\"n_3\"/>} are identical to {1.823,-0.121,0.293} for vertical surfaces <a href=\"IDEAS.Buildings.UsersGuide.References\">[Khalifa 2001]</a>, {2.175,-0.076,0.308} for horizontal surfaces wherefore the heat flux is in the same direction as the buoyancy force <a href=\"IDEAS.Buildings.UsersGuide.References\">[Khalifa 2001]</a>, and {2.72,-,0.13} for horizontal surfaces wherefore the heat flux is in the opposite direction as the buoyancy force <a href=\"IDEAS.Buildings.UsersGuide.References\">[Awbi 1999]</a>. The interior natural convective heat transfer coefficient is only described as function of the temperature difference. Similar to the thermal model for heat transfer through a wall, a thermal circuit formulation for the direct radiant exchange between surfaces can be derived <a href=\"IDEAS.Buildings.UsersGuide.References\">[ Buchberg 1955, Oppenheim 1956]</a>. The resulting heat exchange by longwave radiation between two surface <img src=\"modelica://IDEAS/Images/equations/equation-u44Z52zq.png\" alt=\"s_i\"/> and <img src=\"modelica://IDEAS/Images/equations/equation-1i2Mx4Ca.png\" alt=\"s_j\"/> can be described as</p>
<p align=\"center\"><img src=\"modelica://IDEAS/Images/equations/equation-ULwzvhTg.png\" alt=\"Q_sisj=sigma*((1-epsilon_si)/(epsilon_si)+1/F_sisj+A_si/(sum_i*A_si))^(-1)*A_si*(T_si^4-T_sj^4)\"/></p>
<p>as derived from the Stefan-Boltzmann law wherefore <img src=\"modelica://IDEAS/Images/equations/equation-uDITjyTv.png\" alt=\"epsilon_si\"/> and <img src=\"modelica://IDEAS/Images/equations/equation-zRzZUsty.png\" alt=\"epsilon_sj\"/> are the emissivity of surfaces <img src=\"modelica://IDEAS/Images/equations/equation-AtoPkohW.png\" alt=\"s_i\"/> and <img src=\"modelica://IDEAS/Images/equations/equation-XBM6Gmdj.png\" alt=\"s_j\"/> respectively, <img src=\"modelica://IDEAS/Images/equations/equation-l77CVDpb.png\" alt=\"F_sisj\"/> is radiant-interchange configuration factor <a href=\"IDEAS.Buildings.UsersGuide.References\">[Hamilton 1952]</a> between surfaces <img src=\"modelica://IDEAS/Images/equations/equation-40yn0CNI.png\" alt=\"s_i\"/> and <img src=\"modelica://IDEAS/Images/equations/equation-8AtnOwyb.png\" alt=\"s_j\"/>, <img src=\"modelica://IDEAS/Images/equations/equation-RBEWjWKa.png\" alt=\"A_si\"/> and <img src=\"modelica://IDEAS/Images/equations/equation-fxxW5qJd.png\" alt=\"A_sj\"/> are the areas of surfaces <img src=\"modelica://IDEAS/Images/equations/equation-OM5mvW83.png\" alt=\"s_i\"/> and <img src=\"modelica://IDEAS/Images/equations/equation-2vsckTJX.png\" alt=\"s_j\"/> respectively, sigma is the Stefan-Boltzmann constant <a href=\"IDEAS.Buildings.UsersGuide.References\">[Mohr 2008]</a> and <img src=\"modelica://IDEAS/Images/equations/equation-I8IpXvtl.png\" alt=\"T_si\"/> and <img src=\"modelica://IDEAS/Images/equations/equation-HjTUUaGT.png\" alt=\"T_sj\"/> are the surface temperature of surfaces <img src=\"modelica://IDEAS/Images/equations/equation-pkFYc6TO.png\" alt=\"s_i\"/> and <img src=\"modelica://IDEAS/Images/equations/equation-sbLFxSp8.png\" alt=\"s_j\"/> respectively. The above description of longwave radiation as mentioned above for a room or thermal zone results in the necessity of a very detailed input, i.e. the configuration between all needs to be described by their shape, position and orientation in order to define <img src=\"modelica://IDEAS/Images/equations/equation-MRIBXe5x.png\" alt=\"F_sisj\"/>, and difficulties to introduce windows and internal gains in the zone of interest. Simplification is achieved by means of a <img src=\"modelica://IDEAS/Images/equations/equation-tEXNH19s.png\" alt=\"Delta*Y\"/> or delta-star transformation <a href=\"IDEAS.Buildings.UsersGuide.References\">[Kenelly 1899]</a> and by definition of a (fictive) radiant star node in the zone model. Literature <a href=\"IDEAS.Buildings.UsersGuide.References\">[Liesen 1997]</a> shows that the overall model is not significantly sensitive to this assumption. The heat exchange by longwave radiation between surface <img src=\"modelica://IDEAS/Images/equations/equation-Mjd7rCtc.png\" alt=\"s_i\"/> and the radiant star node in the zone model can be described as</p>
<p align=\"center\"><img src=\"modelica://IDEAS/Images/equations/equation-DsCmBlzm.png\" alt=\"Q_sisj=sigma*((1-epsilon_si)/epsilon_si+A_si/(sum_i*A_si))^(-1)*A_si*(T_si^4-T_rs^4)\"/></p>
<p>where <img src=\"modelica://IDEAS/Images/equations/equation-kKTzmHby.png\" alt=\"epsilon_si\"/> is the emissivity of surface <img src=\"modelica://IDEAS/Images/equations/equation-QxeNUrgq.png\" alt=\"s_i\"/>, <img src=\"modelica://IDEAS/Images/equations/equation-ERb44Mb3.png\" alt=\"A_si\"/> is the area of surface <img src=\"modelica://IDEAS/Images/equations/equation-XF12EapA.png\" alt=\"s_i\"/>, <img src=\"modelica://IDEAS/Images/equations/equation-yyuov0Oi.png\" alt=\"sum_i*A_si\"/> is the sum of areas for all surfaces <img src=\"modelica://IDEAS/Images/equations/equation-yRwsej2e.png\" alt=\"s_i\"/> of the thermal zone, <img src=\"modelica://IDEAS/Images/equations/equation-BmOQFx4B.png\" alt=\"sigma\"/> is the Stefan-Boltzmann constant <a href=\"IDEAS.Buildings.UsersGuide.References\">[Mohr 2008]</a> and <img src=\"modelica://IDEAS/Images/equations/equation-kDraFb4h.png\" alt=\"T_si\"/> and <img src=\"modelica://IDEAS/Images/equations/equation-suo6xr9a.png\" alt=\"T_rs\"/> are the temperatures of surfaces <img src=\"modelica://IDEAS/Images/equations/equation-olgnuMEg.png\" alt=\"s_i\"/> and the radiant star node respectively. Absorption of shortwave solar radiation on the interior surface is handled equally as for the outside surface. Determination of the receiving solar radiation on the interior surface after passing through windows is dealt with in the zone model.</p>
</html>"));
end OuterWall;
