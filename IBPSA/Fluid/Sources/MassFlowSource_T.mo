within IBPSA.Fluid.Sources;
model MassFlowSource_T
  "Ideal flow source that produces a prescribed mass flow with prescribed temperature, mass fraction and trace substances"
  extends IBPSA.Fluid.Sources.BaseClasses.PartialSource_m_flow;
  parameter Boolean use_T_in= false
    "Get the temperature from the input connector"
    annotation(Evaluate=true, HideResult=true);
  parameter Medium.Temperature T = Medium.T_default
    "Fixed value of temperature"
    annotation (Dialog(enable = not use_T_in));
  Modelica.Blocks.Interfaces.RealInput T_in(final unit="K",
                                            displayUnit="degC") if use_T_in
    "Prescribed fluid temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}), iconTransformation(extent={{-140,20},{-100,60}})));
protected
  Modelica.Blocks.Interfaces.RealInput T_in_internal(final unit="K",
                                                     displayUnit="degC")
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput h_internal = Medium.specificEnthalpy(Medium.setState_pTX(p_internal, T_in_internal, X_in_internal));

equation
  connect(T_in, T_in_internal);
  if not use_T_in then
    T_in_internal = T;
  end if;
  for i in 1:nPorts loop
     ports[i].h_outflow  = h_internal;
  end for;
  medium.T = T_in_internal;
  annotation (defaultComponentName="boundary",
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Rectangle(
          extent={{35,45},{100,-45}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Ellipse(
          extent={{-100,80},{60,-80}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-60,70},{60,0},{-60,-68},{-60,70}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-54,32},{16,-30}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          textString="m"),
        Text(
          extent={{-150,130},{150,170}},
          textString="%name",
          lineColor={0,0,255}),
        Ellipse(
          extent={{-26,30},{-18,22}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          visible=use_m_flow_in,
          extent={{-185,132},{-45,100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="m_flow"),
        Text(
          visible=use_T_in,
          extent={{-111,71},{-71,37}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="T"),
        Text(
          visible=use_X_in,
          extent={{-153,-44},{-33,-72}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="X"),
        Text(
          visible=use_C_in,
          extent={{-155,-98},{-35,-126}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="C")}),
    Documentation(info="<html>
<p>
Models an ideal flow source, with prescribed values of flow rate, temperature, composition and trace substances:
</p>
<ul>
<li> Prescribed mass flow rate.</li>
<li> Prescribed temperature.</li>
<li> Boundary composition (only for multi-substance or trace-substance flow).</li>
</ul>
<p>If <code>use_m_flow_in</code> is false (default option), the <code>m_flow</code> parameter
is used as boundary pressure, and the <code>m_flow_in</code> input connector is disabled; if <code>use_m_flow_in</code> is true, then the <code>m_flow</code> parameter is ignored, and the value provided by the input connector is used instead.</p>
<p>The same applies to the temperature, composition and trace substances.</p>
<p>
Note, that boundary temperature,
mass fractions and trace substances have only an effect if the mass flow
is from the boundary into the port. If mass is flowing from
the port into the boundary, the boundary definitions,
with exception of boundary flow rate, do not have an effect.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 2nd, 2018 by Filip Jorissen<br/>
Made <code>medium</code> conditional and refactored inputs.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/882\">#882</a>.
</li>
<li>
April 18, 2017, by Filip Jorissen:<br/>
Changed <code>checkBoundary</code> implementation
such that it is run as an initial equation
when it depends on parameters only.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/728\">#728</a>.
</li>
<li>
January 26, 2016, by Michael Wetter:<br/>
Added <code>unit</code> and <code>quantity</code> attributes.
</li>
<li>
September 29, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end MassFlowSource_T;
