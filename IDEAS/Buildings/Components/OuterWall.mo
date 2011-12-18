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
<p>The description of the thermal response of a wall or a structure of parallel opaque layers in general) is structured as in the 3 different occurring processes, i.e. the heat balance of the exterior surface, heat conduction between both surfaces and the heat balance of the interior surface.</p>
<p><h4><font color=\"#008000\">Exterior surface heat balance </font></h4></p>
<p>The heat balance of the exterior surface is determined as </p>
<p align=\"center\">Q_{net} = Q_{c} + Q_{SW} + Q_{LW,e} + Q_{LW,sky}</p>
<p>where Q_{net} denotes the heat flow into the wall, Q_{c} denotes heat transfer by convection, Q_{SW} denotes short-wave absorption of direct and diffuse solar light, Q_{LW,e} denotes long-wave heat exchange with the environment and Q_{LW,sky} denotes long-wave heat exchange with the sky. The exterior convective heat flow Q_{c} is computed as </p>
<p align=\"center\">Q_{c} = 5.01 v_{10}^{0.85} A [T_{db} - T_{s}] </p>
<p>where A(x) is the surface area, T_{db} is the dry-bulb exterior air temperature, T_{s} is the surface temperature and v_{10} is the wind speed in the undisturbed flow at 10 meter above the ground and where the stated correlation is valid for a v_{10} range of [0.15,7.5] meter per second <a href=\"IDEAS.Buildings.UsersGuide.References\">[Defraeye2011]</a>. The v_{10}-dependent term denoting the exterior convective heat transfer coefficient h_{ce} is determined as max{f(v_{10}),5.6} in order to take into account buoyancy effects at low wind speeds <a href=\"IDEAS.Buildings.UsersGuide.References\">[Jurges1924]</a>. Longwave radiation between the surface and environment Q_{LW,e} is determined as </p>
<p align=\"center\">Q_{LW,e} = sigma epsilon_{LW} A [T_{s}^{4} - F_{sky}T_{sky}^{4} - (1-F_{sky})T_{db}^{4}] </p>
<p>as derived from the Stefan-Boltzmann law <a href=\"IDEAS.Buildings.UsersGuide.References\">[Stefan1879,Boltzmann1884]</a> wherefore sigma the Stefan-Boltzmann constant <a href=\"IDEAS.Buildings.UsersGuide.References\">[Mohr2008]</a>, epsilon_{LW} the longwave emissivity of the exterior surface, A is the surface area, F_{sky} the radiant-interchange configuration factor between the surface and sky <a href=\"IDEAS.Buildings.UsersGuide.References\">[Hamilton1952]</a>, and the surface and the environment respectively and T_{s} and T_{sky} are the exterior surface and sky temperature respectively. Shortwave solar irradiation absorbed by the exterior surface Q_{SW} is determined as </p>
<p align=\"center\">Q_{SW} = epsilon_{SW} A E_{S} </p>
<p>where epsilon_{SW} is the shortwave absorption of the surface, A the surface area and E_{S} the total irradiation on the depicted surface. </p>
<p><h4><font color=\"#008000\">Wall conduction process </font></h4></p>
<p>For the purpose of dynamic building simulation, the partial differential equation of the continuous time and space model of heat transport through a solid is most often simplified into ordinary differential equations with a finite number of parameters representing only one-dimensional heat transport through a construction layer. Within this context, the wall is modeled with lumped elements, i.e. a model where temperatures and heat fluxes are determined from a system composed of a sequence of discrete resistances and capacitances R_{n+1}, C_{n}. The number of capacitive elements $n$ used in modeling the transient thermal response of the wall denotes the order of the lumped capacitance model. </p>
<p align=\"center\">Q_{net} = C dT_{c}/ dt = \\sum_{i}^{n} Q_{res,i} + Q_{source} </p>
<p>where Q_{net} is the added energy to the lumped capacity, T_{c} is the temperature of the lumped capacity, C_{c} is the thermal capacity of the lumped capacity equal to rho c d_{c} A for which rho denotes the density and c is the specific heat capacity of the material, d_{c} the equivalent thickness of the lumped element and A the surface of the modeled layer, where Q_{res} the heat flux through the lumped resistance and R_{r} is the total thermal resistance of the lumped resistance equal to d_{r}(lambda A)^{-1}$ for which d_{r} denotes the equivalent thickness of the lumped element and where Q_{source} are internal thermal source, e.g. from embedded systems.</p>
<p><h4><font color=\"#008000\">Interior surface heat balance </font></h4></p>
<p>The heat balance of the interior surface is determined as </p>
<p align=\"center\">Q_{net} = Q_{c} + \\sum_{i}^{N} Q_{SW,i} + \\sum_{i}^{N} Q_{LW,i}</p>
<p>where Q_{net} denotes the heat flow into the wall, Q_{c} denotes heat transfer by convection, Q_{SW} denotes short-wave absorption of direct and diffuse solar light netering the interior zone through windows and Q_{LW,i} denotes long-wave heat exchange with the surounding interior surfaces. The surface heat resistances R_{s} for the exterior and interior surface respectively are determined as R_{s}^{-1}=A h_{c} where A is the surface area and where h_{c} is the exterior and interior convective heat transfer coefficient. The interior natural convective heat transfer coefficient h_{ci} is computed for each interior surface as </p>
<p align=\"center\">h_{ci} = n_{1} D^{n_{2}} |T_{a}-T_{s}|^{n_{3}} </p>
<p>where D is the characteristic length of the surface, T_{a} is the indoor air temperature T_{s}, and n_{i} are correlation coefficients. These parameters {n_{1},n_{2},n_{3}} are identical to {1.823,-0.121,0.293} for vertical surfaces <a href=\"IDEAS.Buildings.UsersGuide.References\">[Khalifa2001]</a>, {2.175,-0.076,0.308} for horizontal surfaces wherefore the heat flux is in the same direction as the buoyancy force <a href=\"IDEAS.Buildings.UsersGuide.References\">[Khalifa2001]</a>, and {2.72,-,0.13} for horizontal surfaces wherefore the heat flux is in the opposite direction as the buoyancy force <a href=\"IDEAS.Buildings.UsersGuide.References\">[Awbi1999]</a>. The interior natural convective heat transfer coefficient is only described as function of the temperature difference. Similar to the thermal model for heat transfer through a wall, a thermal circuit formulation for the direct radiant exchange between surfaces can be derived <a href=\"IDEAS.Buildings.UsersGuide.References\">[Buchberg1954,Buchberg1955,Oppenheim1956]</a>. The resulting heat exchange by longwave radiation between two surface s_{i} and s_{j} can be described as</p>
<p align=\"center\">Q_{s_{i},s_{j}}=sigma [(1-\\epsilon_{s_{i}})/(\\epsilon_{s_{i}}) + 1/(F_{s_{i},s_{j}}) + A_{s_{i}} / sum_{i} A_{s_{i}}}]^{-1} A_{s_{i}} [T_{s_{i}}^{4}-T_{s_{j}}^{4}\\right]</p>
<p align=\"center\">F_{s_{i},s_{j}} = \\int_{s_{j}} cos(theta_{p}) cos(theta_{s}) pi^{-1} S_{s_{i},s_{j}}^{-2} ds_{j}</p>
<p>as derived from the Stefan-Boltzmann law <a href=\"IDEAS.Buildings.UsersGuide.References\">[Stefan1879,Boltzmann1884]</a> wherefore epsilon_{s_{i}} and epsilon_{s_{j}} are the emissivity of surfaces s_{i} and s_{j} respectively, F_{s_{i},s_{j}} is radiant-interchange configuration factor <a href=\"IDEAS.Buildings.UsersGuide.References\">[Hamilton1952]</a> between surfaces s_{i} and s_{j}, A_{s_{i}} and A_{s_{j}} are the areas of surfaces s_{i} and s_{j} respectively, sigma is the Stefan-Boltzmann constant <a href=\"IDEAS.Buildings.UsersGuide.References\">[Mohr2008]</a> and T_{s_{i}} and T_{s_{j}} are the surface temperature of surfaces s_{i} and s_{j} respectively. The above description of longwave radiation as mentioned above for a room or thermal zone results in the necessity of a very detailed input, i.e. the configuration between all needs to be described by their shape, position and orientation in order to define F_{s_{i},s_{j}}, and difficulties to introduce windows and internal gains in the zone of interest. Simplification is achieved by means of a Delta Y or delta-star transformation <a href=\"IDEAS.Buildings.UsersGuide.References\">[Kenelly1899]</a> and by definition of a (fictive) radiant star node in the zone model. Literature <a href=\"IDEAS.Buildings.UsersGuide.References\">[Liesen1997]</a> shows that the overall model is not significantly sensitive to this assumption. The heat exchange by longwave radiation between surface s_{i} and the radiant star node in the zone model can be described as</p>
<p align=\"center\">Q_{s_{i},rs}=sigma [(1-\\epsilon_{s_{i}})/(\\epsilon_{s_{i}}) + A_{s_{i}} / \\sum_{i} A_{s_{i}}}]^{-1} A_{s_{i}} [T_{s_{i}}^{4}-T_{rs}^{4}]</p>
<p>where epsilon_{s_{i}} is the emissivity of surface s_{i}, A_{s_{i}} is the area of surface s_{i}, sum_{i}A_{s_{i}} is the sum of areas for all surfaces s_{i} of the thermal zone, sigma is the Stefan-Boltzmann constant <a href=\"IDEAS.Buildings.UsersGuide.References\">[Mohr2008]</a> and T_{s_{i}} and T_{rs} are the temperatures of surfaces s_{1} and the radiant star node respectively. Absorption of shortwave solar radiation on the interior surface is handled equally as for the outside surface. Determination of the receiving solar radiation on the interior surface after passing through windows is dealt with in the zone model.</p>
</html>"));
end OuterWall;
