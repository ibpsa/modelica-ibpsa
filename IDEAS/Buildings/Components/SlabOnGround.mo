within IDEAS.Buildings.Components;
model SlabOnGround "opaque floor on ground slab"
   extends IDEAS.Buildings.Components.Interfaces.PartialOpaqueSurface(
     QTra_design=UEqui*AWall*(273.15 + 21 - sim.Tdes), layMul(
        placeCapacityAtSurf_b=false),
        dT_nominal_a=-3,
    redeclare replaceable Data.Constructions.FloorOnGround constructionType);

  parameter Modelica.SIunits.Length PWall = 4*sqrt(AWall)
    "Total floor slab perimeter";
  parameter Modelica.SIunits.Temperature TeAvg = 273.15+10.8
    "Annual average outdoor temperature";
  parameter Modelica.SIunits.Temperature TiAvg = 273.15+22
    "Annual average indoor temperature";
  parameter Modelica.SIunits.TemperatureDifference dTeAvg = 4
    "Amplitude of variation of monthly average outdoor temperature";
  parameter Modelica.SIunits.TemperatureDifference dTiAvg = 2
    "Amplitude of variation of monthly average indoor temperature";
  parameter Boolean linearise=true
    "= true, if convective heat transfer should be linearised"
    annotation(Dialog(tab="Convection"));
  Modelica.SIunits.HeatFlowRate Qm = UEqui*AWall*(TiAvg - TeAvg) - Lpi*dTiAvg*cos(2*3.1415/12*(m- 1 + alfa)) + Lpe*dTeAvg*cos(2*3.1415/12*(m - 1 - beta))
    "Two-dimensionl correction for edge flow";

//Calculation of heat loss based on ISO 13370
protected
  final parameter IDEAS.Buildings.Data.Materials.Ground ground1(final d=0.50);
  final parameter IDEAS.Buildings.Data.Materials.Ground ground2(final d=0.33);
  final parameter IDEAS.Buildings.Data.Materials.Ground ground3(final d=0.17);
  final parameter Real U_value=1/(1/6 + sum(constructionType.mats.R) + 0)
    "Floor theoretical U-value";

  final parameter Modelica.SIunits.Length B=AWall/(0.5*PWall + 1E-10)
    "Characteristic dimension of the slab on ground";
  final parameter Modelica.SIunits.Length dt=sum(constructionType.mats.d) + ground1.k*1/U_value
    "Equivalent thickness";//Thickness of basement walls assumed to be as the thickness of the slab
  final parameter Real UEqui=if (dt<B) then (2*ground1.k/(Modelica.Constants.pi*B+dt)*Modelica.Math.log(Modelica.Constants.pi*B/dt+1)) else (ground1.k/(0.457*B + dt))
    "Equivalent thermal transmittance coefficient";
  final parameter Real alfa=1.5 - 12/(2*3.14)*atan(dt/(dt + delta));
  final parameter Real beta=1.5 - 0.42*log(delta/(dt + 1));
  final parameter Real delta=sqrt(3.15*10^7*ground1.k/3.14/ground1.rho/ground1.c);
  final parameter Real Lpi=AWall*ground1.k/dt*sqrt(1/((1 + delta/dt)^2 + 1));
  final parameter Real Lpe=0.37*PWall*ground1.k*log(delta/dt + 1);
  Real m = sim.timCal/3.1536e7*12 "time in months";

  BaseClasses.ConductiveHeatTransfer.MultiLayer layGro(
    final A=AWall,
    final inc=inc,
    final nLay=3,
    final mats={ground1,ground2,ground3},
    final T_start={TeAvg,TeAvg,TeAvg})
    "Declaration of array of resistances and capacitances for ground simulation"
    annotation (Placement(transformation(extent={{-20,-10},{-40,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow periodicFlow(T_ref=284.15)
                annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-30,22})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow adiabaticBoundary(Q_flow=0,
      T_ref=285.15)
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
public
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{-30,36},{-38,44}})));
  Modelica.Blocks.Sources.RealExpression Qm_val(y=-Qm)
    annotation (Placement(transformation(extent={{0,50},{-20,70}})));
equation

  connect(periodicFlow.port, layMul.port_b) annotation (Line(points={{-20,22},{
          -14,22},{-14,0},{-10,0}}, color={191,0,0}));
  connect(layGro.port_a, layMul.port_b)
    annotation (Line(points={{-20,0},{-15,0},{-10,0}}, color={191,0,0}));
  connect(layGro.port_b, adiabaticBoundary.port)
    annotation (Line(points={{-40,0},{-45,0},{-50,0}}, color={191,0,0}));
  connect(Qm_val.y, product.u1) annotation (Line(points={{-21,60},{-26,60},{-26,
          42.4},{-29.2,42.4}}, color={0,0,127}));
  connect(product.u2, propsBus_a.weaBus.dummy) annotation (Line(points={{-29.2,37.6},
          {100.1,37.6},{100.1,19.9}}, color={0,0,127}));
  connect(product.y, periodicFlow.Q_flow) annotation (Line(points={{-38.4,40},{-50,
          40},{-50,22},{-40,22}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-50,-100},{50,100}}),
        graphics={
        Rectangle(
          extent={{-50,-90},{50,-70}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Line(
          points={{-50,-20},{-30,-20},{-30,-70},{-30,-70},{-30,-70}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-50,-20},{-50,-90},{-50,-90}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-50,60},{-30,60},{-30,80},{50,80}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-50,60},{-50,66},{-50,100},{50,100}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-44,60},{-44,-20}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-50,-70},{50,-70}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None)}),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-60,-100},{60,100}})),
    Documentation(info="<html>
<p><h4><font color=\"#008000\">General description</font></h4></p>
<p><h5>Goal</h5></p>
<p>The <code>SlabOnGround.mo</code> model describes the transient behaviour of a builiding envelope constructions separating a thermal zone with ground massive. The description of the thermal response of a wall is structured as in the 3 different occurring processes, i.e. the heat balance of the outer surface, heat conduction between both surfaces and the heat balance of the interior surface.</p>
<p><h5>Description</h5></p>
<p>For the purpose of dynamic building simulation, the partial differential equation of the continuous time and space model of heat transport through a solid is most often simplified into ordinary differential equations with a finite number of parameters representing only one-dimensional heat transport through a construction layer. Within this context, the wall is modeled with lumped elements, i.e. a model where temperatures and heat fluxes are determined from a system composed of a sequence of discrete resistances and capacitances R_{n+1}, C_{n}. The number of capacitive elements $n$ used in modeling the transient thermal response of the wall denotes the order of the lumped capacitance model.</p>
<p>The heat balance of the outer surface in contact to the ground is approximated based on <a href=\"IDEAS.Buildings.UsersGuide.References\">[ISO 13370]</a> based on a steady-state and periodic coupling coefficient. </p>
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
end SlabOnGround;
