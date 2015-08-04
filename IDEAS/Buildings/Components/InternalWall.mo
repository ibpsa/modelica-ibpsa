within IDEAS.Buildings.Components;
model InternalWall "interior opaque wall between two zones"

  extends IDEAS.Buildings.Components.Interfaces.StateWallNoSol(
    final QTra_design=U_value*AWall*(TRef_a - TRef_b),
    E(y=layMul.E),
      Qgai(y=if sim.openSystemConservationOfEnergy then 0 else port_emb.Q_flow));

  parameter Modelica.SIunits.Length insulationThickness
    "Thermal insulation thickness"
    annotation (Dialog(group="Construction details"));
  parameter Modelica.SIunits.Temperature T_start=293.15
    "Start temperature for each of the layers";

  parameter Modelica.SIunits.Temperature TRef_a=291.15
    "Reference temperature of zone on side of propsBus_a, for calculation of design heat loss"
                                                                                               annotation (Dialog(group="Design heat loss"));
  parameter Boolean linearise_a=true
    "= true, if convective heat transfer should be linearised"
    annotation(Dialog(tab="Convection"));
  parameter Modelica.SIunits.TemperatureDifference dT_nominal_a=1
    "Nominal temperature difference used for linearisation, negative temperatures indicate the solid is colder"
    annotation(Dialog(tab="Convection"));
  parameter Boolean linearise_b=true
    "= true, if convective heat transfer should be linearised"
    annotation(Dialog(tab="Convection"));
  parameter Modelica.SIunits.TemperatureDifference dT_nominal_b=1
    "Nominal temperature difference used for linearisation, negative temperatures indicate the solid is colder"
    annotation(Dialog(tab="Convection"));
  parameter Modelica.SIunits.Temperature TRef_b=291.15
    "Reference temperature of zone on side of propsBus_b, for calculation of design heat loss"
                                                                                               annotation (Dialog(group="Design heat loss"));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_emb
    "port for gains by embedded active layers"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Interfaces.ZoneBus propsBus_b(numAzi=sim.numAzi,
    computeConservationOfEnergy=sim.computeConservationOfEnergy)
    "Outer side (1st layer)"
        annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-50,40})));

protected
  final parameter Real U_value=1/(1/8 + sum(constructionType.mats.R) + 1/8)
    "Wall U-value";

  IDEAS.Buildings.Components.BaseClasses.InteriorConvection intCon_b(
    final A=AWall,
    final inc=inc,
    linearise=linearise_b,
    dT_nominal=dT_nominal_b)
    "convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{-20,-40},{-40,-20}})));
  IDEAS.Buildings.Components.BaseClasses.InteriorConvection intCon_a(
    final A=AWall,
    final inc=inc + Modelica.Constants.pi,
    linearise=linearise_a,
    dT_nominal=dT_nominal_a)
    "convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  IDEAS.Buildings.Components.BaseClasses.MultiLayerOpaque layMul(
    final A=AWall,
    final inc=inc,
    final nLay=constructionType.nLay,
    final mats=constructionType.mats,
    final locGain=constructionType.locGain,
    T_start=ones(constructionType.nLay)*T_start)
    "declaration of array of resistances and capacitances for wall simulation"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Modelica.Blocks.Sources.RealExpression QDesign_b(y=-QTra_design)  annotation (Placement(transformation(extent={{-16,36},{-36,56}})));
  //Negative, because it's losses from zone side b to zone side a, oposite of calculation of QTra_design
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow iSolDif1(Q_flow=0)
    annotation (Placement(transformation(extent={{-102,70},{-82,90}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow iSolDir1(Q_flow=0)
    annotation (Placement(transformation(extent={{-102,56},{-82,76}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow Qgai_b(Q_flow=0) if
       sim.computeConservationOfEnergy
    annotation (Placement(transformation(extent={{-102,24},{-82,44}})));
  BaseClasses.PrescribedEnergy E_b if
       sim.computeConservationOfEnergy
    annotation (Placement(transformation(extent={{-102,42},{-82,62}})));
  Modelica.Blocks.Sources.Constant E0(k=0)
    "All internal energy is assigned to right side"
    annotation (Placement(transformation(extent={{-126,42},{-106,62}})));
equation
  connect(layMul.port_b, propsBus_a.surfRad) annotation (Line(
      points={{10,-30},{14,-30},{14,39.9},{50.1,39.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_a, propsBus_b.surfRad) annotation (Line(
      points={{-10,-30},{-12,-30},{-12,40.1},{-50.1,40.1}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(propsBus_b.surfCon, intCon_b.port_b) annotation (Line(
      points={{-50.1,40.1},{-46,40.1},{-46,-30},{-40,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(propsBus_a.surfCon, intCon_a.port_b) annotation (Line(
      points={{50.1,39.9},{46,39.9},{46,-30},{40,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_gain, port_emb) annotation (Line(
      points={{0,-40},{0,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intCon_b.port_a, layMul.port_a) annotation (Line(
      points={{-20,-30},{-10,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_b, intCon_a.port_a) annotation (Line(
      points={{10,-30},{20,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_b, propsBus_a.epsSw) annotation (Line(
      points={{10,-26},{18,-26},{18,39.9},{50.1,39.9}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(layMul.iEpsLw_b, propsBus_a.epsLw) annotation (Line(
      points={{10,-22},{14,-22},{14,39.9},{50.1,39.9}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(layMul.area, propsBus_a.area) annotation (Line(
      points={{0,-20},{0,39.9},{50.1,39.9}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(layMul.area, propsBus_b.area) annotation (Line(
      points={{0,-20},{0,40.1},{-50.1,40.1}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(layMul.iEpsSw_a, propsBus_b.epsSw) annotation (Line(
      points={{-10,-26},{-18,-26},{-18,40.1},{-50.1,40.1}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(layMul.iEpsLw_a, propsBus_b.epsLw) annotation (Line(
      points={{-10,-22},{-14,-22},{-14,40.1},{-50.1,40.1}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(iSolDif1.port, propsBus_b.iSolDif) annotation (Line(
      points={{-82,80},{-50,80},{-50,56},{-50.1,56},{-50.1,40.1}},
      color={191,0,0},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(iSolDir1.port, propsBus_b.iSolDir) annotation (Line(
      points={{-82,66},{-50,66},{-50,58},{-50.1,58},{-50.1,40.1}},
      color={191,0,0},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));

  connect(QDesign_b.y, propsBus_b.QTra_design) annotation (Line(
      points={{-37,46},{-44,46},{-44,40.1},{-50.1,40.1}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(Qgai_b.port, propsBus_b.Qgai) annotation (Line(points={{-82,34},{-66,
          34},{-66,40.1},{-50.1,40.1}}, color={191,0,0}));
  connect(E_b.port, propsBus_b.E) annotation (Line(points={{-82,52},{-50.1,52},
          {-50.1,40.1}}, color={191,0,0}));
  connect(E_b.E, E0.y)
    annotation (Line(points={{-102,52},{-105,52}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-50,-100},{50,100}}),
        graphics={
        Rectangle(
          extent={{-10,80},{10,-70}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None),
        Line(
          points={{-50,80},{50,80}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-50,-70},{50,-70}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-50,-90},{50,-90}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-50,100},{50,100}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-10,80},{-10,-70}},
          smooth=Smooth.None,
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{10,80},{10,-70}},
          smooth=Smooth.None,
          color={0,0,0},
          thickness=0.5)}),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-50,-100},{50,
            100}})),
    Documentation(info="<html>
<p><h4><font color=\"#008000\">General description</font></h4></p>
<p><h5>Goal</h5></p>
<p>The <code>InternalWall.mo</code> model describes the transient behaviour of opaque builiding constructions separating two thermal zones. The description of the thermal response of a wall is structured as in the 2 different occurring processes, i.e. heat conduction between both surfaces and the heat balance of the interior surfaces.</p>
<p><h5>Description</h5></p>
<p>For the purpose of dynamic building simulation, the partial differential equation of the continuous time and space model of heat transport through a solid is most often simplified into ordinary differential equations with a finite number of parameters representing only one-dimensional heat transport through a construction layer. Within this context, the wall is modeled with lumped elements, i.e. a model where temperatures and heat fluxes are determined from a system composed of a sequence of discrete resistances and capacitances R_{n+1}, C_{n}. The number of capacitive elements $n$ used in modeling the transient thermal response of the wall denotes the order of the lumped capacitance model.</p>
<p>The heat balance of the interior surface is determined as Q_{net} = Q_{c} + Sum(Q_{SW,i}) + Sum(Q_{LW,i}) where Q_{net} denotes the heat flow into the wall, Q_{c} denotes heat transfer by convection, Q_{SW,i} denotes short-wave absorption of direct and diffuse solar light netering the interior zone through windows and Q_{LW,i} denotes long-wave heat exchange with the surrounding interior surfaces. </p>
<p>The surface heat resistances <img src=\"modelica://IDEAS/Images/equations/equation-mp9YB9Y0.png\"/> for the exterior and interior surface respectively are determined as 1/R_{s} = A.h_{c} where A is the surface area and where h_ {c} is the exterior and interior convective heat transfer coefficient. The interior natural convective heat transfer coefficient h_{c,i} <img src=\"modelica://IDEAS/Images/equations/equation-eZGZlJrg.png\"/> is computed for each interior surface as h_{c,i} = n1.D^{n2}.(T_{a}-T_{s})^{n3} where D is the characteristic length of the surface, T_{a} is the indoor air temperature and n are correlation coefficients. These parameters {n1, n2, n3} are identical to {1.823,-0.121,0.293} for vertical surfaces <a href=\"IDEAS.Buildings.UsersGuide.References\">[Khalifa 2001]</a>, {2.175,-0.076,0.308} for horizontal surfaces wherefore the heat flux is in the same direction as the buoyancy force <a href=\"IDEAS.Buildings.UsersGuide.References\">[Khalifa 2001]</a>, and {2.72,-,0.13} for horizontal surfaces wherefore the heat flux is in the opposite direction as the buoyancy force <a href=\"IDEAS.Buildings.UsersGuide.References\">[Awbi 1999]</a>. The interior natural convective heat transfer coefficient is only described as function of the temperature difference. </p>
<p>Similar to the thermal model for heat transfer through a wall, a thermal circuit formulation for the direct radiant exchange between surfaces can be derived <a href=\"IDEAS.Buildings.UsersGuide.References\">[Buchberg 1955, Oppenheim 1956]</a>. The resulting heat exchange by longwave radiation between two surface s_{i} and s_{j} can be described as Q_{si,sj} = sigma.A_{si}.(T_{si}^{4}-T_{sj}^{4})/((1-e_{si})/e_{si} + 1/F_{si,sj} + A_{si}/sum(A_{si}) ) as derived from the Stefan-Boltzmann law wherefore e_{si} and e_{sj} are the emissivity of surfaces s_{i} and s_{j} respectively, F_{si,sj} is radiant-interchange configuration factor <a href=\"IDEAS.Buildings.UsersGuide.References\">[Hamilton 1952]</a> between surfaces s_{i} and s_{j} , A_{i} and A_{j} are the areas of surfaces s_{i} and s_{j} respectively, sigma is the Stefan-Boltzmann constant <a href=\"IDEAS.Buildings.UsersGuide.References\">[Mohr 2008]</a> and R_{i} and T_{j} are the surface temperature of surfaces s_{i} and s_{j} respectively. The above description of longwave radiation for a room or thermal zone results in the necessity of a very detailed input, i.e. the configuration between all surfaces needs to be described by their shape, position and orientation in order to define F_{si,sj}, and difficulties to introduce windows and internal gains in the zone of interest. Simplification is achieved by means of a delta-star transformation <a href=\"IDEAS.Buildings.UsersGuide.References\">[Kenelly 1899]</a> and by definition of a (fictive) radiant star node in the zone model. Literature <a href=\"IDEAS.Buildings.UsersGuide.References\">[Liesen 1997]</a> shows that the overall model is not significantly sensitive to this assumption. The heat exchange by longwave radiation between surface <img src=\"modelica://IDEAS/Images/equations/equation-Mjd7rCtc.png\"/> and the radiant star node in the zone model can be described as Q_{si,sj} = sigma.A_{si}.(T_{si}^{4}-T_{sr}^{4})/((1-e_{si})/e_{si} + A_{si}/sum(A_{si}) ) = sigma where e_{si} is the emissivity of surface s_{i}, A_{si} is the area of surface s_{i}, sum(A_{si}) is the sum of areas for all surfaces s_{i} of the thermal zone, sigma is the Stefan-Boltzmann constant <a href=\"IDEAS.Buildings.UsersGuide.References\">[Mohr 2008]</a> and T_{si} and T_{sr} are the temperatures of surfaces <img src=\"modelica://IDEAS/Images/equations/equation-olgnuMEg.png\"/> and the radiant star node respectively. Absorption of shortwave solar radiation on the interior surface is handled equally as for the outside surface. Determination of the receiving solar radiation on the interior surface after passing through windows is dealt with in the zone model.</p>
<p><h4><font color=\"#008000\">Validation </font></h4></p>
<p>By means of the <code>BESTEST.mo</code> examples in the <code>Validation.mo</code> package.</p>
</html>", revisions="<html>
<ul>
<li>
June 14, 2015, Filip Jorissen:<br/>
Adjusted implementation for computing conservation of energy.
</li>
</ul>
</html>"));
end InternalWall;
