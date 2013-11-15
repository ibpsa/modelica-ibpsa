within IDEAS.Thermal.Components.BaseClasses;
model Thermostatic3WayValve "Thermostatic 3-way valve"

  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water();
  parameter Modelica.SIunits.Mass m=1 "Fluid content of the mixing valve";
  parameter Modelica.SIunits.MassFlowRate mFlowMin = 0.01
    "Minimum outlet flowrate for mixing to start";
  Modelica.Blocks.Interfaces.RealInput TMixedSet
    "Mixed outlet temperature setpoint" annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,106}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,100})));

  Modelica.SIunits.Temperature TCold=pumpCold.T;
  Modelica.SIunits.Temperature THot=mixingVolumeHot.T
    "Temperature of the hot source";
  Modelica.SIunits.Temperature TMixed(start=273.15 + 20)=flowPortMixed.h
    /medium.cp "Temperature of the mixed water";

protected
  Modelica.SIunits.MassFlowRate m_flowMixed=-flowPortMixed.m_flow
    "mass flowrate of the mixed flow";
  Modelica.SIunits.MassFlowRate m_flowCold(min=0)
    "mass flowrate of cold water to the mixing point";
  parameter Modelica.SIunits.MassFlowRate m_flowNom=100
    "Just a large nominal flowrate";
  Real m_flowColdInput(min=0) = m_flowCold/m_flowNom;
//  Real m_flowHotInput = m_flowHot/m_flowNom;

  Pump pumpCold(
    useInput=true,
    medium=medium,
    m_flowNom=m_flowNom,
    m=m/2)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,-28})));

public
  Thermal.Components.Interfaces.FlowPort_a flowPortHot(medium=medium, h(
      start=293.15*medium.cp,
      min=1140947,
      max=1558647))
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));

  Thermal.Components.Interfaces.FlowPort_a flowPortCold(medium=medium, h(
      start=293.15*medium.cp,
      min=1140947,
      max=1558647))
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{-10,-110},{10,-90}})));

  Thermal.Components.Interfaces.FlowPort_a flowPortMixed(medium=medium, h(
      start=293.15*medium.cp,
      min=1140947,
      max=1558647))
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));

protected
  MixingVolume mixingVolumeHot(
    medium=medium,
    nbrPorts=2,
    m=m/2)
    annotation (Placement(transformation(extent={{-22,30},{-2,50}})));
equation
  //m_flowTotal = table.y[profileType] * VDayAvg * medium.rho;
  pumpCold.m_flowSet = m_flowColdInput;
//  pumpHot.m_flowSet = m_flowHotInput;

    if noEvent(THot < TMixedSet) then
      // no mixing
      m_flowCold =  0;
    elseif noEvent(TCold > TMixedSet) then
       m_flowCold = m_flowMixed;
    elseif noEvent(flowPortMixed.m_flow < -mFlowMin) then
      m_flowCold =  - (flowPortHot.m_flow * THot + flowPortMixed.m_flow * TMixedSet) / TCold;
    else
      m_flowCold =  0;
    end if;

//m_flowCold = max(0, -(flowPortHot.m_flow*THot + flowPortMixed.m_flow* TMixedSet)/TCold);

//  flowPortMixed.p = 300000;
//  flowPortMixed.H_flow = semiLinear(flowPortMixed.m_flow,flowPortMixed.h,ambient.T*medium.cp);

  connect(flowPortCold, pumpCold.flowPort_a) annotation (Line(
      points={{0,-100},{0,-38},{-1.83697e-015,-38}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(flowPortHot, mixingVolumeHot.flowPorts[1]) annotation (Line(
      points={{-100,0},{-24,0},{-24,30},{-12,30},{-12,29.5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(mixingVolumeHot.flowPorts[2], flowPortMixed) annotation (Line(
      points={{-12,30.5},{0,30.5},{0,0},{100,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pumpCold.flowPort_b, flowPortMixed) annotation (Line(
      points={{1.83697e-015,-18},{0,-18},{0,0},{100,0}},
      color={255,0,0},
      smooth=Smooth.None));

  annotation (Diagram(graphics), Icon(graphics={
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
