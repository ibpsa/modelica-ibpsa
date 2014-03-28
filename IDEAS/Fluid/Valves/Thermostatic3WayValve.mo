within IDEAS.Fluid.Valves;
model Thermostatic3WayValve "Thermostatic 3-way valve"
  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations;
  parameter Modelica.SIunits.Mass m = 1 "Fluid content of the mixing valve";
  parameter Modelica.SIunits.MassFlowRate mFlowMin=0.01*m_flow_nominal
    "Minimum outlet flowrate for mixing to start";
  Modelica.Blocks.Interfaces.RealInput TMixedSet
    "Mixed outlet temperature setpoint" annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,106}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,100})));

  Modelica.SIunits.SpecificEnthalpy h_set = Medium.specificEnthalpy(Medium.setState_pTX(fluid_hot.p, TMixedSet, Medium.X_default))
    "Specific enthalpy of the temperature setpoint";
  Modelica.Fluid.Interfaces.FluidPort_a fluid_hot(redeclare package Medium =
        Medium) "Hot fluid inlet"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a fluid_cold(redeclare package Medium =
        Medium) "Cold fluid inlet"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b fluid_out(redeclare package Medium =
        Medium) "Fluid outlet"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  MixingVolumes.MixingVolume vol(nPorts=3,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    V=m/2/Medium.density(Medium.setState_pTX(Medium.p_default, Medium.T_default, Medium.X_default)),
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    p_start=p_start,
    T_start=T_start,
    X_start=X_start,
    C_start=C_start,
    C_nominal=C_nominal)
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=m_flowCold/
        m_flow_nominal) "Fraction of nominal mass flow rate"
    annotation (Placement(transformation(extent={{92,-38},{38,-18}})));
      IDEAS.Fluid.Movers.Pump pumpCold(
    useInput=true,
    m_flow_nominal=m_flow_nominal,
    m=m/2,
    redeclare package Medium = Medium,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    p_start=p_start,
    T_start=T_start,
    X_start=X_start,
    C_start=C_start,
    C_nominal=C_nominal)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,-28})));

protected
  Modelica.SIunits.MassFlowRate m_flowMixed=-fluid_out.m_flow
    "mass flowrate of the mixed flow";
  Modelica.SIunits.MassFlowRate m_flowCold(min=0)
    "mass flowrate of cold water to the mixing point";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";

equation
  if noEvent(inStream(fluid_hot.h_outflow) < h_set) then
    // no mixing
    m_flowCold = 0;
  elseif noEvent(inStream(fluid_cold.h_outflow) > h_set) then
    m_flowCold = -fluid_out.m_flow;
  elseif noEvent(fluid_out.m_flow < -mFlowMin) then
    m_flowCold = -(fluid_hot.m_flow*inStream(fluid_hot.h_outflow) + fluid_out.m_flow*h_set)/
      inStream(fluid_cold.h_outflow);
  else
    m_flowCold = 0;
  end if;
  connect(fluid_hot, vol.ports[1]) annotation (Line(
      points={{-100,0},{-2.66667,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fluid_out, vol.ports[2]) annotation (Line(
      points={{100,0},{2.22045e-016,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pumpCold.port_b, vol.ports[3]) annotation (Line(
      points={{0,-18},{0,0},{2.66667,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fluid_cold, pumpCold.port_a) annotation (Line(
      points={{0,-100},{0,-38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pumpCold.m_flowSet, realExpression.y) annotation (Line(
      points={{10,-28},{35.3,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
            graphics),
    Icon(graphics={
        Polygon(
          points={{-60,30},{-60,-30},{0,0},{-60,30}},
          lineColor={100,100,100},
          smooth=Smooth.None),
        Polygon(
          points={{60,30},{60,-30},{0,0},{60,30}},
          lineColor={100,100,100},
          smooth=Smooth.None),
        Polygon(
          points={{-30,30},{-30,-30},{30,0},{-30,30}},
          lineColor={100,100,100},
          smooth=Smooth.None,
          origin={0,-30},
          rotation=90),
        Ellipse(extent={{-20,80},{20,40}}, lineColor={100,100,100}),
        Line(
          points={{0,0},{0,40}},
          color={100,100,100},
          smooth=Smooth.None),
        Text(
          extent={{-10,70},{10,50}},
          lineColor={100,100,100},
          textString="M"),
        Line(
          points={{-70,30},{-70,-30}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{70,30},{70,-30}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-30,-70},{30,-70}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-70,0},{-100,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{70,0},{100,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{0,-70},{0,-100}},
          color={0,0,127},
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>3-way valve with temperature set point for mixing a cold and hot fluid to obtain outlet fluid at the desired temperature. If the desired temperature is higher than the hot fluid, no mixing will occur and the outlet will have the temperature of the hot fluid. </p>
<p>Inside the valve, the cold water flowrate is fixed with a pump component.  The fluid content in the valve is equally split between the mixing volume and this pump.  Without fluid content in the pump, this model does not work in all operating conditions.  </p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>Correct connections of hot and cold fluid to the corresponding flowPorts is NOT CHECKED.</li>
<li>The fluid content m of the valve has to be larger than zero</li>
<li>There is an internal parameter mFlowMin which sets a minimum mass flow rate for mixing to start. </li>
</ol></p>
<p><h4>Model use</h4></p>
<p><ol>
<li>Set medium and the internal fluid content of the valve (too small values of m could increase simulation times)</li>
<li>Set mFlowMin, the minimum mass flow rate for mixing to start. </li>
<li>Supply a set temperature at the outlet</li>
</ol></p>
<p><h4>Validation </h4></p>
<p>None </p>
<p><h4>Example (optional) </h4></p>
<p>Examples of this model can be found in<a href=\"modelica://IDEAS.Thermal.Components.Examples.TempMixingTester\"> IDEAS.Thermal.Components.Examples.TempMixingTester</a> and<a href=\"modelica://IDEAS.Thermal.Components.Examples.RadiatorWithMixingValve\"> IDEAS.Thermal.Components.Examples.RadiatorWithMixingValve</a></p>
</html>", revisions="<html>
<p><ul>
<li>2013 May, Roel De Coninck, documentation</li>
<li>2013 March, Ruben Baetens, graphics</li>
<li>2010, Roel De Coninck, first version</li>
</ul></p>
</html>"));
end Thermostatic3WayValve;
