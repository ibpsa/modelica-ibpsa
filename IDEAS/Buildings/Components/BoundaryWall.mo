within IDEAS.Buildings.Components;
model BoundaryWall "Opaque wall with optional prescribed heat flow rate or temperature boundary conditions"
  extends IDEAS.Buildings.Components.Interfaces.PartialOpaqueSurface(
     QTra_design=U_value*AWall*(273.15 + 21 - TRef_a),
     dT_nominal_a=-1,
     layMul(monLay(energyDynamics=cat(1, {(if use_T_in and energyDynamics ==  Modelica.Fluid.Types.Dynamics.FixedInitial then Modelica.Fluid.Types.Dynamics.DynamicFreeInitial else energyDynamics)}, fill(energyDynamics, layMul.nLay-1)))));

  parameter Boolean use_T_in = false
    "Get the boundary temperature from the input connector"
    annotation(Dialog(group="Boundary conditions"));
  parameter Boolean use_Q_in = false
    "Get the boundary heat flux from the input connector"
    annotation(Dialog(group="Boundary conditions"));

  Modelica.Blocks.Interfaces.RealInput T if use_T_in annotation (Placement(transformation(
          extent={{-114,10},{-94,30}}),iconTransformation(extent={{-114,10},{
            -94,30}})));
  Modelica.Blocks.Interfaces.RealInput Q_flow if use_Q_in annotation (Placement(
        transformation(extent={{-114,-30},{-94,-10}}),
                                                    iconTransformation(extent={{-114,
            -30},{-94,-10}})));

protected
  final parameter Real U_value=1/(1/8 + sum(constructionType.mats.R) + 1/8)
    "Wall U-value";
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow(
     final alpha=0) if use_Q_in
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature if use_T_in
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));


equation
  if use_Q_in then
    connect(Q_flow, prescribedHeatFlow.Q_flow) annotation (Line(
      points={{-104,-20},{-60,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  if use_T_in then
    connect(T, prescribedTemperature.T) annotation (Line(
      points={{-104,20},{-62,20}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  connect(layMul.port_b, prescribedHeatFlow.port) annotation (Line(points={{-10,0},
          {-10,0},{-20,0},{-20,-20},{-40,-20}},  color={191,0,0}));
  connect(prescribedTemperature.port, layMul.port_b) annotation (Line(points={{-40,20},
          {-20,20},{-20,0},{-10,0}},     color={191,0,0}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}})),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-50,-100},{50,100}}),
        graphics={
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
        Rectangle(
          extent={{-10,100},{10,-90}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None),
        Line(
          points={{-10,80},{-10,-70}},
          smooth=Smooth.None,
          color={175,175,175}),
        Line(
          points={{10,80},{10,-70}},
          smooth=Smooth.None,
          color={0,0,0},
          thickness=0.5)}),
    Documentation(info="<html>
<p><h4><font color=\"#008000\">General description</font></h4></p>
<p><h5>Goal</h5></p>
<p>The <code>CommonWall.mo</code> model describes the transient behaviour of builiding constructions separating a thermal zone with a non-simulated heated thermal zone of another building. The description of the thermal response of a wall is structured as in the 3 different occurring processes, i.e. the heat balance of the outer surface, heat conduction between both surfaces and the heat balance of the interior surface.</p>
<p><h5>Description</h5></p>
<p>For the purpose of dynamic building simulation, the partial differential equation of the continuous time and space model of heat transport through a solid is most often simplified into ordinary differential equations with a finite number of parameters representing only one-dimensional heat transport through a construction layer. Within this context, the wall is modeled with lumped elements, i.e. a model where temperatures and heat fluxes are determined from a system composed of a sequence of discrete resistances and capacitances R_{n+1}, C_{n}. The number of capacitive elements $n$ used in modeling the transient thermal response of the wall denotes the order of the lumped capacitance model.</p>
<p>The heat balance of the interior surface is determined as Q_{net} = Q_{c} + Sum(Q_{SW,i}) + Sum(Q_{LW,i}) where Q_{net} denotes the heat flow into the wall, Q_{c} denotes heat transfer by convection, Q_{SW,i} denotes short-wave absorption of direct and diffuse solar light netering the interior zone through windows and Q_{LW,i} denotes long-wave heat exchange with the surrounding interior surfaces. </p>
<p>The surface heat resistances <img src=\"modelica://IDEAS/Images/equations/equation-mp9YB9Y0.png\"/> for the exterior and interior surface respectively are determined as 1/R_{s} = A.h_{c} where A is the surface area and where h_ {c} is the exterior and interior convective heat transfer coefficient. The interior natural convective heat transfer coefficient h_{c,i} <img src=\"modelica://IDEAS/Images/equations/equation-eZGZlJrg.png\"/> is computed for each interior surface as h_{c,i} = n1.D^{n2}.(T_{a}-T_{s})^{n3} where D is the characteristic length of the surface, T_{a} is the indoor air temperature and n are correlation coefficients. These parameters {n1, n2, n3} are identical to {1.823,-0.121,0.293} for vertical surfaces <a href=\"IDEAS.Buildings.UsersGuide.References\">[Khalifa 2001]</a>, {2.175,-0.076,0.308} for horizontal surfaces wherefore the heat flux is in the same direction as the buoyancy force <a href=\"IDEAS.Buildings.UsersGuide.References\">[Khalifa 2001]</a>, and {2.72,-,0.13} for horizontal surfaces wherefore the heat flux is in the opposite direction as the buoyancy force <a href=\"IDEAS.Buildings.UsersGuide.References\">[Awbi 1999]</a>. The interior natural convective heat transfer coefficient is only described as function of the temperature difference. </p>
<p>Similar to the thermal model for heat transfer through a wall, a thermal circuit formulation for the direct radiant exchange between surfaces can be derived <a href=\"IDEAS.Buildings.UsersGuide.References\">[Buchberg 1955, Oppenheim 1956]</a>. The resulting heat exchange by longwave radiation between two surface s_{i} and s_{j} can be described as Q_{si,sj} = sigma.A_{si}.(T_{si}^{4}-T_{sj}^{4})/((1-e_{si})/e_{si} + 1/F_{si,sj} + A_{si}/sum(A_{si}) ) as derived from the Stefan-Boltzmann law wherefore e_{si} and e_{sj} are the emissivity of surfaces s_{i} and s_{j} respectively, F_{si,sj} is radiant-interchange configuration factor <a href=\"IDEAS.Buildings.UsersGuide.References\">[Hamilton 1952]</a> between surfaces s_{i} and s_{j} , A_{i} and A_{j} are the areas of surfaces s_{i} and s_{j} respectively, sigma is the Stefan-Boltzmann constant <a href=\"IDEAS.Buildings.UsersGuide.References\">[Mohr 2008]</a> and R_{i} and T_{j} are the surface temperature of surfaces s_{i} and s_{j} respectively. The above description of longwave radiation for a room or thermal zone results in the necessity of a very detailed input, i.e. the configuration between all surfaces needs to be described by their shape, position and orientation in order to define F_{si,sj}, and difficulties to introduce windows and internal gains in the zone of interest. Simplification is achieved by means of a delta-star transformation <a href=\"IDEAS.Buildings.UsersGuide.References\">[Kenelly 1899]</a> and by definition of a (fictive) radiant star node in the zone model. Literature <a href=\"IDEAS.Buildings.UsersGuide.References\">[Liesen 1997]</a> shows that the overall model is not significantly sensitive to this assumption. The heat exchange by longwave radiation between surface <img src=\"modelica://IDEAS/Images/equations/equation-Mjd7rCtc.png\"/> and the radiant star node in the zone model can be described as Q_{si,sj} = sigma.A_{si}.(T_{si}^{4}-T_{sr}^{4})/((1-e_{si})/e_{si} + A_{si}/sum(A_{si}) ) = sigma where e_{si} is the emissivity of surface s_{i}, A_{si} is the area of surface s_{i}, sum(A_{si}) is the sum of areas for all surfaces s_{i} of the thermal zone, sigma is the Stefan-Boltzmann constant <a href=\"IDEAS.Buildings.UsersGuide.References\">[Mohr 2008]</a> and T_{si} and T_{sr} are the temperatures of surfaces <img src=\"modelica://IDEAS/Images/equations/equation-olgnuMEg.png\"/> and the radiant star node respectively. Absorption of shortwave solar radiation on the interior surface is handled equally as for the outside surface. Determination of the receiving solar radiation on the interior surface after passing through windows is dealt with in the zone model.</p>
<p><h5>Assumptions and limitations</h5></p>
<p><ol>
<li>Current heat balance of the exterior surface is equal to the heat balance of the interior heat balance, but assumes a stable indoor temperature at the exterior side of the wall of 19&deg;C. So far, this is no input variable.</li>
</ol></p>
<p><h4><font color=\"#008000\">Validation </font></h4></p>
<p>By means of the <code>BESTEST.mo</code> examples in the <code>Validation.mo</code> package.</p>
</html>", revisions="<html>
<ul>
<li>
March 8, 2016, by Filip Jorissen:<br/>
Fixed energyDynamics when using fixed temperature boundary condition input.
This is discussed in issue 462.
</li>
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
end BoundaryWall;
