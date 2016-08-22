within IDEAS.Buildings.Components;
model InternalWall "interior opaque wall between two zones"
  extends IDEAS.Buildings.Components.Interfaces.PartialOpaqueSurface(
  dT_nominal_a=1,
  E(y=layMul.E),
  Qgai(y=(if sim.openSystemConservationOfEnergy
         then 0 else sum(port_emb.Q_flow))),
  final QTra_design=U_value*AWall*(TRef_a - TRef_b),
    intCon_a);

  parameter Boolean linIntCon_b=sim.linIntCon
    "= true, if convective heat transfer should be linearised"
    annotation(Dialog(tab="Convection"));
  parameter Modelica.SIunits.TemperatureDifference dT_nominal_b=1
    "Nominal temperature difference used for linearisation, negative temperatures indicate the solid is colder"
    annotation(Dialog(tab="Convection"));
  parameter Modelica.SIunits.Temperature TRef_b=291.15
    "Reference temperature of zone on side of propsBus_b, for calculation of design heat loss"
     annotation (Dialog(group="Design power",tab="Advanced"));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_emb[constructionType.nGain]
    "port for gains by embedded active layers"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  IDEAS.Buildings.Components.Interfaces.ZoneBus propsBus_b(
    numIncAndAziInBus=sim.numIncAndAziInBus,
    computeConservationOfEnergy=sim.computeConservationOfEnergy,
    each final weaBus(outputAngles=sim.outputAngles)) "If inc = Floor, then propsbus_b should be connected to the zone below this floor.
    If inc = Ceiling, then propsbus_b should be connected to the zone above this ceiling."
        annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-100,20}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-50,20})));

protected
  final parameter Real U_value=1/(1/8 + sum(constructionType.mats.R) + 1/8)
    "Wall U-value";

  IDEAS.Buildings.Components.BaseClasses.ConvectiveHeatTransfer.InteriorConvection
    intCon_b(
    final A=AWall,
    linearise=linIntCon_b or sim.linearise,
    dT_nominal=dT_nominal_b,
    final inc=inc + Modelica.Constants.pi)
    "convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{-22,-10},{-42,10}})));
  Modelica.Blocks.Sources.RealExpression QDesign_b(y=-QTra_design);
  //Negative, because of its losses from zone side b to zone side a, oposite of calculation of QTra_design

  Modelica.Blocks.Sources.RealExpression incExp1(y=inc + Modelica.Constants.pi)
    "Inclination angle";
  Modelica.Blocks.Sources.RealExpression aziExp1(y=azi + Modelica.Constants.pi)
    "Azimuth angle expression";
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow iSolDif1(Q_flow=0);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow iSolDir1(Q_flow=0);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow Qgai_b(final Q_flow=0) if
       sim.computeConservationOfEnergy;
  IDEAS.Buildings.Components.BaseClasses.ConservationOfEnergy.PrescribedEnergy
    E_b if sim.computeConservationOfEnergy;
  Modelica.Blocks.Sources.Constant E0(final k=0)
    "All internal energy is assigned to right side";

equation
  connect(layMul.port_b, propsBus_b.surfRad) annotation (Line(
      points={{-10,0},{-14,0},{-14,20.1},{-100.1,20.1}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(propsBus_b.surfCon, intCon_b.port_b) annotation (Line(
      points={{-100.1,20.1},{-48,20.1},{-48,0},{-42,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_b, intCon_b.port_a) annotation (Line(
      points={{-10,0},{-22,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_b, propsBus_b.epsSw) annotation (Line(
      points={{-10,4},{-18,4},{-18,20.1},{-100.1,20.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_b, propsBus_b.epsLw) annotation (Line(
      points={{-10,8},{-16,8},{-16,20.1},{-100.1,20.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.area, propsBus_b.area) annotation (Line(
      points={{0,10},{0,20.1},{-100.1,20.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(iSolDif1.port, propsBus_b.iSolDif);
  connect(iSolDir1.port, propsBus_b.iSolDir);
  connect(QDesign_b.y, propsBus_b.QTra_design);
  connect(incExp1.y, propsBus_b.inc);
  connect(aziExp1.y, propsBus_b.azi);
  connect(Qgai_b.port, propsBus_b.Qgai);
  connect(E_b.port, propsBus_b.E);
  connect(E_b.E, E0.y);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-60,-100},{60,100}}),
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
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-60,-100},{60,100}})),
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
February 10, 2016, by Filip Jorissen and Damien Picard:<br/>
Revised implementation: cleaned up connections and partials.
</li>
<li>
June 14, 2015, Filip Jorissen:<br/>
Adjusted implementation for computing conservation of energy.
</li>
</ul>
</html>"));
end InternalWall;
