within Annex60.Fluid.Actuators.Valves;
model ThermostaticThreeWayLinear
  "Thermostatic three way valve with linear characteristics"
    extends BaseClasses.PartialThreeWayValve(
      redeclare TwoWayLinear res1,
      redeclare TwoWayLinear res3,
      final fraK = 1,
      final dpFixed_nominal = {0,0});

    parameter Modelica.SIunits.TemperatureDifference dT_nominal = 50
    "Nominal/maximum temperature difference between inlet ports, used for regularization";
    parameter Boolean dynamicValve = false
    "Set to true to simulate a valve opening delay: typically slower but more robust"
    annotation(Dialog(tab="Dynamics", group="Filter"));
    parameter Real k_start = 0 "Start position of the valve" annotation(Dialog(tab="Dynamics", group="Filter", enable=dynamicValve));
    parameter Real k_min=0.001 "Minimal valve opening";
    parameter Real k_max=0.999 "Maximal valve opening";
    Modelica.Blocks.Interfaces.RealInput TSet(unit="K", displayUnit="degC")
    "Temperature set point"   annotation (Placement(transformation(
      extent={{-20,-20},{20,20}},
      rotation=270,
      origin={0,120}),   iconTransformation(
      extent={{-20,-20},{20,20}},
      rotation=270,
      origin={0,120})));

    Real k "Valve opening";
protected
  Modelica.SIunits.SpecificEnthalpy h_set = Medium.specificEnthalpy(Medium.setState_pTX(port_2.p, TSet, port_2.Xi_outflow))
    "Specific enthalpy of the temperature setpoint";
  Real k_raw(start=0.5)
    "Unbounded help variable for determining fraction of each flow";
  Real k_state(start=k_start) "Variable for introducing a state";
  Real delta_h "Enthalpy difference between port_3 and port_1";
  Real inv_delta_h "Regularized inverse of delta_h";

  final parameter Real delta_h_reg=dT_nominal/200*Medium.specificHeatCapacityCp(Medium.setState_pTX(Medium.p_default,Medium.T_default,Medium.X_default))
    "Enthalpy difference where regularization starts";
public
  Modelica.Blocks.Sources.RealExpression valOpe(y=k) "Valve opening value"
    annotation (Placement(transformation(extent={{-96,16},{-76,36}})));

equation
  der(k_state) = if dynamicValve then (k_raw-k_state)/tau else 0;
  delta_h=inStream(port_3.h_outflow)-inStream(port_1.h_outflow);
  inv_delta_h = Annex60.Utilities.Math.Functions.inverseXRegularized(delta_h, delta=delta_h_reg);

  // Regularization for mass flow rate zero and for small enthalpy difference
  k_raw = Annex60.Utilities.Math.Functions.spliceFunction(x=-port_2.m_flow - m_flow_nominal/10,neg=0.5,
            pos=Annex60.Utilities.Math.Functions.spliceFunction(x=abs(delta_h)-delta_h_reg,
                                                                pos=(h_set-inStream(port_1.h_outflow))*inv_delta_h,
                                                                neg=0.5, deltax=delta_h_reg),
                                                          deltax=m_flow_nominal/10);
  k = Annex60.Utilities.Math.Functions.smoothMin(Annex60.Utilities.Math.Functions.smoothMax(if dynamicValve then k_state else k_raw,k_min,k_min/10),k_max,k_min/10);
  connect(valOpe.y, res3.y) annotation (Line(
      points={{-75,26},{22,26},{22,-50},{12,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(valOpe.y, inv.u2) annotation (Line(
      points={{-75,26},{-68,26},{-68,41.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(inv.y, res1.y) annotation (Line(
      points={{-62.6,46},{-50,46},{-50,12}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (defaultComponentName="val",
Documentation(info="<html>
<p>
Thermostatic three way valve with linear opening characteristic. The valve opening is adjusted so that the desired temperature 
is reached as close as possible.
</p><p>
This model is based on the partial valve models
<a href=\"modelica://Annex60.Fluid.Actuators.BaseClasses.PartialThreeWayValve\">
Annex60.Fluid.Actuators.BaseClasses.PartialThreeWayValve</a> and
<a href=\"modelica://Annex60.Fluid.Actuators.BaseClasses.PartialTwoWayValve\">
Annex60.Fluid.Actuators.BaseClasses.PartialTwoWayValve</a>.
See
<a href=\"modelica://Annex60.Fluid.Actuators.BaseClasses.PartialThreeWayValve\">
Annex60.Fluid.Actuators.BaseClasses.PartialThreeWayValve</a>
for the implementation of the three way valve
and see
<a href=\"modelica://Annex60.Fluid.Actuators.BaseClasses.PartialTwoWayValve\">
Annex60.Fluid.Actuators.BaseClasses.PartialTwoWayValve</a>
for the implementation of the regularization near the origin.
</p>
<p><b>Main equations</b> </p>
<p>Water with enthalpy <i>h</i> needs to be mixed such that:</p>
<pre>
  h<sub>out</sub> = k  h<sub>in1</sub> + (1-k)  h<sub>in2</sub>
</pre>
<p>this equation defines the mass flow rates:</p>
<pre>
  m<sub>flow,in1</sub> = k  m<sub>flow</sub>out
</pre>
<pre>
  m<sub>flow,in2</sub> = (1-k)  m<sub>flow</sub>out
</pre>
<h4>Assumptions and limitations </h4>
<p>This models does not allow different pressure losses in its two legs.</p>
<p>Ideally h<sub>out equals h<sub>set, the enthalpy corresponding to the temperature set point. However, if the desired temperature can not be reached 
through mixing then water from only one stream is used: the stream with the temperature closest to the desired temperature.</p>
<p>The model is not exact around h<sub>in1</sub> = h<sub>in2</sub>. Regularization functions are used to ensure smooth behaviour through 
this transition and to avoid chattering. Finally, the model keeps at fixed valve opening equal to 0.5 during flow reversal.</p>
<h4>Typical use and important parameters</h4>
<ol>
<li>The parameter m sets the mass of the fluid contained by the valve. </li>
<li>Parameter <code>dT_nominal</code> sets the nominal temperature difference of the inlet ports. It provides an estimate for when to 
start regularization: when the temperature difference accross the inlet ports is smaller than <i>dT/200</i>. Small <code>dT_nominal</code> 
values may lead to convergence errors, large <code>dT_nominal</code> values cause a greater error when the inlet temperatures are almost equal.</li>
</ol>
<h4>Options</h4>
<ol>
<li>Typical options inherited through lumpedVolumeDeclarations can be used.</li>
<li>A delayed valve opening can be simulated by setting dynamicValve tot true.</li>
<li>The minimum and maximum valve opening can be adjusted.</li>
</ol>
</html>",
revisions="<html>
<ul>
<li>
November 18, 2014 by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                    graphics));
end ThermostaticThreeWayLinear;
