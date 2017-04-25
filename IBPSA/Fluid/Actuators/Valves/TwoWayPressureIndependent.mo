within IBPSA.Fluid.Actuators.Valves;
model TwoWayPressureIndependent "Model of a pressure-independent two way valve"
  extends IBPSA.Fluid.Actuators.BaseClasses.PartialTwoWayValve(
            final linearized = false,
            from_dp=true,
            phi=l + y_actual*(1 - l));

  parameter Real l2(min=1e-10) = 0.01
    "Gain for mass flow increase if pressure is above nominal pressure"
    annotation(Dialog(tab="Advanced"));
  parameter Real deltax = 0.1 "Transition interval for flow rate"
    annotation(Dialog(tab="Advanced"));

protected
  parameter Real coeff1 = l2/dp_nominal*m_flow_nominal
    "Parameter for avoiding unnecessary computations";
  parameter Real coeff2 = 1/coeff1
    "Parameter for avoiding unnecessary computations";
  parameter Real y2d = if from_dp then coeff1 else coeff2
    "Derivative at second support point";
  constant Real y2dd = 0
    "Second derivative at second support point";
  Modelica.SIunits.MassFlowRate m_flow_set
    "Requested mass flow rate";
  Modelica.SIunits.PressureDifference dp_min(displayUnit="Pa")
    "Minimum pressure difference required for delivering requested mass flow rate";
  Real x, x1, x2, y2, y1
    "Support points for interpolation flow functions";
  Real y_smooth
    "Smooth interpolation result between two flow regimes";

equation
  m_flow_set = m_flow_nominal*phi;
  kVal = Kv_SI;
  if (dpFixed_nominal > Modelica.Constants.eps) then
    k = sqrt(1/(1/kFixed^2 + 1/kVal^2));
  else
    k = kVal;
  end if;
  dp_min = IBPSA.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
              m_flow=m_flow_set,
              k=k,
              m_flow_turbulent=m_flow_turbulent);

  if from_dp then
    x = dp-dp_min;
    x1 = -x2;
    x2 = deltax*dp_min;
    // min function ensures that y1 does not increase further for x > x1
    y1 = IBPSA.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
                                  dp=min(dp, dp_min+x1),
                                  k=k,
                                  m_flow_turbulent=m_flow_turbulent);
    // max function ensures that y2 does not decrease further for x < x2
    y2 = m_flow_set + coeff1*max(dp-dp_min,x2);
  else
    x = m_flow-m_flow_set;
    x1 = -x2;
    x2 = deltax*m_flow_set;
    // min function ensures that y1 does not increase further for x > x1
    y1 = IBPSA.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
                                     m_flow=min(m_flow, m_flow_set + x1),
                                     k=k,
                                     m_flow_turbulent=m_flow_turbulent);
    // max function ensures that y2 does not decrease further for x < x2
    y2 = dp_min + coeff2*max(x, x2);
  end if;

  // C2 smooth transition between y1 and y2
  y_smooth = noEvent(smooth(2,
        if x <= x1
        then y1
        elseif x >=x2
        then y2
        else IBPSA.Utilities.Math.Functions.quinticHermite(
                 x=x,
                 x1=x1,
                 x2=x2,
                 y1=y1,
                 y2=y2,
                 y1d= if from_dp
                      then IBPSA.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der(
                                     dp=dp_min + x1,
                                     k=k,
                                     m_flow_turbulent=m_flow_turbulent,
                                     dp_der=1)
                      else IBPSA.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_der(
                                     m_flow=m_flow_set + x1,
                                     k=k,
                                     m_flow_turbulent=m_flow_turbulent,
                                     m_flow_der=1),
                 y2d=y2d,
                 y1dd=if from_dp
                      then IBPSA.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der2(
                                     dp=dp_min + x1,
                                     k=k,
                                     m_flow_turbulent=m_flow_turbulent,
                                     dp_der=1,
                                     dp_der2=0)
                      else IBPSA.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_der2(
                                     m_flow=m_flow_set + x1,
                                     k=k,
                                     m_flow_turbulent=m_flow_turbulent,
                                     m_flow_der=1,
                                     m_flow_der2=0),
                 y2dd=y2dd)));

  if homotopyInitialization then
    if from_dp then
      m_flow=homotopy(actual=y_smooth,
                      simplified=m_flow_nominal_pos*dp/dp_nominal_pos);
    else
        dp=homotopy(
           actual=y_smooth,
           simplified=dp_nominal_pos*m_flow/m_flow_nominal_pos);
    end if;
  else
    if from_dp then
      m_flow=y_smooth;
    else
      dp=y_smooth;
    end if;
  end if;
  annotation (defaultComponentName="val",
  Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
            {100,100}}),       graphics={
        Polygon(
          points={{2,-2},{-76,60},{-76,-60},{2,-2}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-50,40},{0,-2},{54,40},{54,40},{-50,40}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-52,-42},{0,-4},{60,40},{60,-42},{-52,-42}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-2},{82,60},{82,-60},{0,-2}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,40},{0,-4}}),
        Line(
          visible=not use_inputFilter,
          points={{0,100},{0,40}})}),
Documentation(info="<html>
<p>
Two way valve with a pressure-independent valve opening characteristic.
The mass flow rate is controlled such that it is nearly equal to its
set point <code>y*m_flow_nominal</code>, unless the pressure
<code>dp</code> is too low, in which case a regular <code>Kv</code>
characteristic is used.
</p>
<h4>Main equations</h4>
<p>
First the minimum pressure head <code>dp_min</code>
required for delivering the requested mass flow rate
<code>y*m_flow_nominal</code> is computed. If
<code>dp &gt; dp_min</code> then the requested mass flow
rate is supplied. If <code>dp &lt; dp_min</code> then
<code>m_flow = Kv/sqrt(dp)</code>. Transition between
these two flow regimes happens in a smooth way.
</p>
<h4>Typical use and important parameters</h4>
<p>
This model is configured by setting <code>m_flow_nominal</code>
to the mass flow rate that the valve should supply when it is
completely open, i.e., <code>y = 1</code>. The pressure drop corresponding
to this working point can be set using <code>dpValve_nominal</code>,
or using a <code>Kv</code>, <code>Cv</code> or <code>Av</code>
value. The parameter <code>dpValve_fixed</code> can be used to add
additional pressure drops, although in this valve it is equivalent to
add these to <code>dpValve_nominal</code>.
</p>
<p>
The parameter <code>l2</code> represents the non-ideal
leakage behaviour of this valve for high pressures.
It is assumed that the mass flow rate will rise beyond
the requested mass flow rate <code>y*m_flow_nominal</code>
if <code>dp &gt; dpValve_nominal+dpFixed_nominal</code>.
The parameter <code>l2</code> represents the slope
of this rise:
<code>d(m_flow)/d(dp) = l2* m_flow_nominal/dp_nominal</code>.
In the ideal case <code>l2=0</code>, but
this may introduce singularities, for instance when
connecting this component with a fixed mass flow source.
</p>
<h4>Options</h4>
<p>
Parameter <code>deltax</code> sets the duration of
the transition region between the two flow regimes
as a fraction of <code>dp_nominal</code> or <code>m_flow_nominal</code>,
depending on the value of <code>from_dp</code>.
</p>
<h4>Implementation</h4>
<p>
Note that the result in the transition region when
using <code>from_dp = true</code> is not identical to
the result when using <code>from_dp = false</code>.
</p>
<p>
Variables <code>y1</code> and <code>y2</code>
serve a dual use. 
They are used to 
1) compute the support points at <code>x1</code> and <code>x2</code>,
which should not depend on <code>m_flow</code> or <code>dp</code> and
2) to compute the flow functions when outside of this regime, 
which does depend on <code>m_flow</code> or <code>dp</code>.
Min and max functions are therefore used such that one equation
can serve both puroposes.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 14, 2017, by Filip Jorissen:<br/>
Revised implementation using <code>cubicHermite</code> 
such that it does not have a local maximum
and such that it is C2-continuous.
See <a href=https://github.com/ibpsa/modelica-ibpsa/issues/156>#156</a>.
</li>
<li>
March 24, 2017, by Michael Wetter:<br/>
Renamed <code>filteredInput</code> to <code>use_inputFilter</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/665\">#665</a>.
</li>
<li>
March 15, 2016, by Michael Wetter:<br/>
Replaced <code>spliceFunction</code> with <code>regStep</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/300\">issue 300</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
January 29, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end TwoWayPressureIndependent;
