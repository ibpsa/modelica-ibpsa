within IDEAS.Buildings.Components;
model Window "Multipane window"

  extends IDEAS.Buildings.Components.Interfaces.StateWall;

  parameter Modelica.SIunits.Area A "Total window and windowframe area";
  parameter Real frac(
    min=0,
    max=1) = 0.15 "Area fraction of the window frame";

  parameter Modelica.SIunits.Angle inc
    "Inclination of the window, i.e. 90deg denotes vertical";
  parameter Modelica.SIunits.Angle azi
    "Azimuth of the wall, i.e. 0deg denotes South";
  final parameter Modelica.SIunits.Power QNom=glazing.U_value*A*(273.15 + 21 -
      sim.Tdes) "Design heat losses at reference outdoor temperature";

  replaceable IDEAS.Buildings.Data.Glazing.Ins2 glazing
    constrainedby IDEAS.Buildings.Data.Interfaces.Glazing "Glazing type"
    annotation (__Dymola_choicesAllMatching=true, Dialog(group=
          "Construction details"));
  replaceable IDEAS.Buildings.Data.Frames.None fraType
    constrainedby IDEAS.Buildings.Data.Interfaces.Frame "Window frame type"
    annotation (__Dymola_choicesAllMatching=true, Dialog(group=
          "Construction details"));
  replaceable IDEAS.Buildings.Components.Shading.None shaType constrainedby
    Interfaces.StateShading(final azi=azi) "Shading type" annotation (Placement(transformation(extent={{-36,-70},{-26,-50}})),
      __Dymola_choicesAllMatching=true, Dialog(group="Construction details"));

  Modelica.Blocks.Interfaces.RealInput Ctrl if shaType.controlled
    "Control signal between 0 and 1, i.e. 1 is fully closed" annotation (
      Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={-30,-110}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-30,-100})));

protected
  IDEAS.Climate.Meteo.Solar.ShadedRadSol radSol(
    final inc=inc,
    final azi=azi,
    final A=A*(1 - frac))
    "determination of incident solar radiation on wall based on inclination and azimuth"
    annotation (Placement(transformation(extent={{-72,-70},{-52,-50}})));
  IDEAS.Buildings.Components.BaseClasses.MultiLayerLucent layMul(
    final A=A*(1 - frac),
    final inc=inc,
    final nLay=glazing.nLay,
    final mats=glazing.mats)
    "declaration of array of resistances and capacitances for wall simulation"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  IDEAS.Buildings.Components.BaseClasses.ExteriorConvection eCon(final A=A*(1
         - frac))
    "convective surface heat transimission on the exterior side of the wall"
    annotation (Placement(transformation(extent={{-20,-40},{-40,-20}})));
  IDEAS.Buildings.Components.BaseClasses.InteriorConvectionWindow iCon(final A=
        A*(1 - frac), final inc=inc)
    "convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  IDEAS.Buildings.Components.BaseClasses.ExteriorHeatRadiation skyRad(final A=A
        *(1 - frac), final inc=inc)
    "determination of radiant heat exchange with the environment and sky"
    annotation (Placement(transformation(extent={{-20,-20},{-40,0}})));
  IDEAS.Buildings.Components.BaseClasses.SwWindowResponse solWin(
    final nLay=glazing.nLay,
    final SwAbs=glazing.SwAbs,
    final SwTrans=glazing.SwTrans,
    final SwTransDif=glazing.SwTransDif,
    final SwAbsDif=glazing.SwAbsDif)
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));

  IDEAS.Buildings.Components.BaseClasses.InteriorConvection iConFra(A=A*frac,
      inc=inc) if fraType.present
    "convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  IDEAS.Buildings.Components.BaseClasses.ExteriorHeatRadiation skyRadFra(final
      A=A*frac, final inc=inc) if       fraType.present
    "determination of radiant heat exchange with the environment and sky"
    annotation (Placement(transformation(extent={{-20,80},{-40,100}})));
  IDEAS.Buildings.Components.BaseClasses.ExteriorConvection eConFra(final A=A*
        frac) if fraType.present
    "convective surface heat transimission on the exterior side of the wall"
    annotation (Placement(transformation(extent={{-20,60},{-40,80}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor layFra(final G=
        fraType.U_value*A*frac) if fraType.present
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
equation
  connect(eCon.port_a, layMul.port_a) annotation (Line(
      points={{-20,-30},{-10,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(skyRad.port_a, layMul.port_a) annotation (Line(
      points={{-20,-10},{-16,-10},{-16,-30},{-10,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(solWin.iSolDir, propsBus_a.iSolDir) annotation (Line(
      points={{-2,-70},{-2,-80},{50,-80},{50,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(solWin.iSolDif, propsBus_a.iSolDif) annotation (Line(
      points={{2,-70},{0,-70},{0,-80},{50,-80},{50,40}},
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

  connect(layMul.port_b, propsBus_a.surfRad) annotation (Line(
      points={{10,-30},{16,-30},{16,40},{50,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(iCon.port_b, propsBus_a.surfCon) annotation (Line(
      points={{40,-30},{46,-30},{46,40},{50,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_b, iCon.port_a) annotation (Line(
      points={{10,-30},{20,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radSol.solDir, shaType.solDir) annotation (Line(
      points={{-52,-54},{-36,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSol.solDif, shaType.solDif) annotation (Line(
      points={{-52,-58},{-36,-58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSol.angInc, shaType.angInc) annotation (Line(
      points={{-52,-64},{-36,-64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSol.angZen, shaType.angZen) annotation (Line(
      points={{-52,-66},{-36,-66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSol.angAzi, shaType.angAzi) annotation (Line(
      points={{-52,-68},{-36,-68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaType.iSolDir, solWin.solDir) annotation (Line(
      points={{-26,-54},{-10,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaType.iSolDif, solWin.solDif) annotation (Line(
      points={{-26,-58},{-10,-58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaType.iAngInc, solWin.angInc) annotation (Line(
      points={{-26,-66},{-10,-66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaType.Ctrl, Ctrl) annotation (Line(
      points={{-31,-70},{-30,-70},{-30,-110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(iConFra.port_b, propsBus_a.surfCon) annotation (Line(
      points={{40,80},{44,80},{44,40},{50,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layFra.port_b, iConFra.port_a) annotation (Line(
      points={{10,80},{20,80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(skyRadFra.port_a, layFra.port_a) annotation (Line(
      points={{-20,90},{-16,90},{-16,80},{-10,80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(eConFra.port_a, layFra.port_a) annotation (Line(
      points={{-20,70},{-16,70},{-16,80},{-10,80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_a, skyRadFra.epsLw) annotation (Line(
      points={{-10,-22},{-14,-22},{-14,96},{-20,96}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_b, propsBus_a.epsSw) annotation (Line(
      points={{10,-26},{14,-26},{14,40},{50,40}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(layMul.iEpsLw_b, propsBus_a.epsLw) annotation (Line(
      points={{10,-22},{12,-22},{12,40},{50,40}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(layMul.area, propsBus_a.area) annotation (Line(
      points={{0,-20},{0,40},{50,40}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-50,-100},{50,100}}),
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
          smooth=Smooth.None)}),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}), graphics),
    Documentation(info="<html>
<p><h4><font color=\"#008000\">General description</font></h4></p>
<p><h5>Goal</h5></p>
<p>The <code>Window</code> model describes the transient behaviour of translucent builiding enelope constructions. The description of the thermal response of a wall is structured as in the 4 different occurring processes, i.e. the transmittance and absorptance of shortwave solar radiation, heat balance of the exterior surface, heat conduction between both surfaces and the heat balance of the interior surface.</p>
<p><h5>Description</h5></p>
<p>For the purpose of dynamic building simulation, the partial differential equation of the continuous time and space model of heat transport through a solid is most often simplified into ordinary differential equations with a finite number of parameters representing only one-dimensional heat transport through a construction layer. Within this context, the wall is modeled with lumped elements, i.e. a model where temperatures and heat fluxes are determined from a system composed of a sequence of discrete resistances and capacitances R_{n+1}, C_{n}. The number of capacitive elements $n$ used in modeling the transient thermal response of the wall denotes the order of the lumped capacitance model.</p>
<p><br/>The heat balance of the exterior surface is determined as Q_{net} = Q_{c} + Q_{SW} + Q_{LW,e} + Q_{LW,sky} where Q_{net} denotes the heat flow into the wall, Q_{c} denotes heat transfer by convection, Q_{SW} denotes short-wave absorption of direct and diffuse solar light, Q_{LW,e} denotes long-wave heat exchange with the environment and Q_{nLW,sky} denotes long-wave heat exchange with the sky. The exterior convective heat flow is computed as Q_{c} = 5,01.A.v_{10}^{0.85}.(T_{db}-T{s}) where A is the surface area, T_{db} is the dry-bulb exterior air temperature, T_{s} is the surface temperature and v_{10} is the wind speed in the undisturbed flow at 10 meter above the ground and where the stated correlation is valid for a v_{10} range of [0.15,7.5] meter per second <a href=\"IDEAS.Buildings.UsersGuide.References\">[Defraeye 2011]</a>. The v_{10}-dependent term denoting the exterior convective heat transfer coefficient h_{ce} is determined as max(f(v_{10}), 5.6) in order to take into account buoyancy effects at low wind speeds <a href=\"IDEAS.Buildings.UsersGuide.References\">[Jurges 1924]</a>. Longwave radiation between the surface and environment Q_{LW,e} is determined as Q_{LW,e} = sigma.e.A.( T_{s}^4 - F_{sky}.T_{sky}^4 - (1-F_{sky})T_{db}^4 ) as derived from the Stefan-Boltzmann law wherefore sigma the Stefan-Boltzmann constant <a href=\"IDEAS.Buildings.UsersGuide.References\">[Mohr 2008]</a>, e the longwave emissivity of the exterior surface, F_{sky} the radiant-interchange configuration factor between the surface and sky <a href=\"IDEAS.Buildings.UsersGuide.References\">[Hamilton 1952]</a>, and the surface and the environment respectively and T_{s} and T_{sky} are the exterior surface and sky temperature respectively. Shortwave solar irradiation absorbed by the exterior surface is determined as Q_{SW} = e_{SW}.A.E_{SW} where e_{SW} is the shortwave absorption of the surface and E_{SW} the total irradiation on the depicted surface. </p>
<p>The properties for absorption by and transmission through the glazingare taken into account depending on the angle of incidence of solar irradiation and are based on the output of the <a href=\"IDEAS.Buildings.UsersGuide.References\">[WINDOW 6.3]</a> software, i.e. the shortwave properties itselves based on the layers in the window are not calculated in the model but are input parameters. </p>
<p>The heat balance of the interior surface is determined as Q_{net} = Q_{c} + Sum(Q_{SW,i}) + Sum(Q_{LW,i}) where Q_{net} denotes the heat flow into the wall, Q_{c} denotes heat transfer by convection, Q_{SW,i} denotes short-wave absorption of direct and diffuse solar light netering the interior zone through windows and Q_{LW,i} denotes long-wave heat exchange with the surounding interior surfaces. </p>
<p>The surface heat resistances <img src=\"modelica://IDEAS/Images/equations/equation-mp9YB9Y0.png\"/> for the exterior and interior surface respectively are determined as 1/R_{s} = A.h_{c} where A is the surface area and where h_ {c} is the exterior and interior convective heat transfer coefficient. The interior natural convective heat transfer coefficient h_{c,i} <img src=\"modelica://IDEAS/Images/equations/equation-eZGZlJrg.png\"/> is computed for each interior surface as h_{c,i} = n1.D^{n2}.(T_{a}-T_{s})^{n3} where D is the characteristic length of the surface, T_{a} is the indoor air temperature and n are correlation coefficients. These parameters {n1, n2, n3} are identical to {1.823,-0.121,0.293} for vertical surfaces <a href=\"IDEAS.Buildings.UsersGuide.References\">[Khalifa 2001]</a>, {2.175,-0.076,0.308} for horizontal surfaces wherefore the heat flux is in the same direction as the buoyancy force <a href=\"IDEAS.Buildings.UsersGuide.References\">[Khalifa 2001]</a>, and {2.72,-,0.13} for horizontal surfaces wherefore the heat flux is in the opposite direction as the buoyancy force <a href=\"IDEAS.Buildings.UsersGuide.References\">[Awbi 1999]</a>. The interior natural convective heat transfer coefficient is only described as function of the temperature difference. </p>
<p>Similar to the thermal model for heat transfer through a wall, a thermal circuit formulation for the direct radiant exchange between surfaces can be derived <a href=\"IDEAS.Buildings.UsersGuide.References\">[Buchberg 1955, Oppenheim 1956]</a>. The resulting heat exchange by longwave radiation between two surface s_{i} and s_{j} can be described as Q_{si,sj} = sigma.A_{si}.(T_{si}^{4}-T_{sj}^{4})/((1-e_{si})/e_{si} + 1/F_{si,sj} + A_{si}/sum(A_{si}) ) as derived from the Stefan-Boltzmann law wherefore e_{si} and e_{sj} are the emissivity of surfaces s_{i} and s_{j} respectively, F_{si,sj} is radiant-interchange configuration factor <a href=\"IDEAS.Buildings.UsersGuide.References\">[Hamilton 1952]</a> between surfaces s_{i} and s_{j} , A_{i} and A_{j} are the areas of surfaces s_{i} and s_{j} respectively, sigma is the Stefan-Boltzmann constant <a href=\"IDEAS.Buildings.UsersGuide.References\">[Mohr 2008]</a> and R_{i} and T_{j} are the surface temperature of surfaces s_{i} and s_{j} respectively. The above description of longwave radiation for a room or thermal zone results in the necessity of a very detailed input, i.e. the configuration between all surfaces needs to be described by their shape, position and orientation in order to define F_{si,sj}, and difficulties to introduce windows and internal gains in the zone of interest. Simplification is achieved by means of a delta-star transformation <a href=\"IDEAS.Buildings.UsersGuide.References\">[Kenelly 1899]</a> and by definition of a (fictive) radiant star node in the zone model. Literature <a href=\"IDEAS.Buildings.UsersGuide.References\">[Liesen 1997]</a> shows that the overall model is not significantly sensitive to this assumption. The heat exchange by longwave radiation between surface <img src=\"modelica://IDEAS/Images/equations/equation-Mjd7rCtc.png\"/> and the radiant star node in the zone model can be described as Q_{si,sj} = sigma.A_{si}.(T_{si}^{4}-T_{sr}^{4})/((1-e_{si})/e_{si} + A_{si}/sum(A_{si}) ) = sigma where e_{si} is the emissivity of surface s_{i}, A_{si} is the area of surface s_{i}, sum(A_{si}) is the sum of areas for all surfaces s_{i} of the thermal zone, sigma is the Stefan-Boltzmann constant <a href=\"IDEAS.Buildings.UsersGuide.References\">[Mohr 2008]</a> and T_{si} and T_{sr} are the temperatures of surfaces <img src=\"modelica://IDEAS/Images/equations/equation-olgnuMEg.png\"/> and the radiant star node respectively. Absorption of shortwave solar radiation on the interior surface is handled equally as for the outside surface. Determination of the receiving solar radiation on the interior surface after passing through windows is dealt with in the zone model.</p>
<p><h4><font color=\"#008000\">Validation </font></h4></p>
<p>By means of the <code>BESTEST.mo</code> examples in the <code>Validation.mo</code> package.</p>
</html>"));
end Window;
