within IBPSA.Fluid.Actuators.Dampers;
model Exponential
  "Air damper with exponential opening characteristics"
  extends IBPSA.Fluid.Actuators.BaseClasses.PartialDamperExponential;
equation
  // Pressure drop calculation
  if linearized then
    m_flow*m_flow_nominal_pos = k^2*dp;
  else
    if homotopyInitialization then
      if from_dp then
        m_flow=homotopy(
            actual=IBPSA.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
                  dp=dp, k=k,
                  m_flow_turbulent=m_flow_turbulent),
            simplified=m_flow_nominal_pos*dp/dp_nominal_pos);
      else
        dp=homotopy(
            actual=IBPSA.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
                  m_flow=m_flow, k=k,
                  m_flow_turbulent=m_flow_turbulent),
            simplified=dp_nominal_pos*m_flow/m_flow_nominal_pos);
        end if;  // from_dp
    else // do not use homotopy
      if from_dp then
        m_flow=IBPSA.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
                  dp=dp, k=k, m_flow_turbulent=m_flow_turbulent);
      else
        dp=IBPSA.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
                  m_flow=m_flow, k=k, m_flow_turbulent=m_flow_turbulent);
      end if;  // from_dp
    end if; // homotopyInitialization
  end if; // linearized
annotation (
defaultComponentName="dam",
Documentation(info="<html>
<p>
Model of two flow resistances in series:
</p>
<ul>
<li>
one resistance has a fixed flow coefficient;
</li>
<li>
the other resistance represents a damper whose flow coefficient is an
exponential function of the opening angle.
</li>
</ul>
<p>
The damper model is as in ASHRAE 825-RP except that a control signal of
<code>y=0</code> means the damper is closed, and <code>y=1</code> means the damper
is open. This is opposite of the implementation of ASHRAE 825-RP, but used here
for consistency within this library.
</p>
<p>
For <code>yL &lt; y &lt; yU</code>, the damper characteristics is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  k<sub>d</sub>(y) = exp(a+b (1-y)).
</p>
<p>
Outside this range, the damper characteristics is defined by a quadratic polynomial that
matches the damper resistance at <code>y=0</code> and <code>y=yL</code> or <code>y=yU</code> and
<code>y=1</code>, respectively. In addition, the polynomials are such that
<i>k<sub>d</sub>(y)</i> is
differentiable in <i>y</i> and the derivative is continuous.
</p>
<p>
The damper characteristics <i>k<sub>d</sub>(y)</i> is then used to
compute the flow coefficient <i>k(y)</i> as
</p>
<p align=\"center\" style=\"font-style:italic;\">
k(y) = (2 &rho; &frasl; k<sub>d</sub>(y))<sup>1/2</sup> A,
</p>
<p>
where <i>A</i> is the face area, which is computed using the nominal
mass flow rate <code>m_flow_nominal</code>, the nominal velocity
<code>v_nominal</code> and the density of the medium. The flow coefficient <i>k(y)</i>
is used to compute the mass flow rate versus pressure
drop relation as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  m&#775; = sign(&Delta;p) k(y)  &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;</span>
</p>
<p>
with regularization near the origin.
</p>
<p>
ASHRAE 825-RP lists the following parameter values as typical:
<br />
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<td></td><th>opposed blades</th><th>single blades</th>
</tr>
<tr>
<td>yL</td><td>15/90</td><td>15/90</td>
</tr>
<tr>
<td>yU</td><td>55/90</td><td>65/90</td>
</tr>
<tr>
<td>k0</td><td>1E6</td><td>1E6</td>
</tr>
<tr>
<td>k1</td><td>0.2 to 0.5</td><td>0.2 to 0.5</td>
</tr>
<tr>
<td>a</td><td>-1.51</td><td>-1.51</td>
</tr>
<tr>
<td>b</td><td>0.105*90</td><td>0.0842*90</td>
</tr>
</table>
<br />
<h4>References</h4>
<p>
P. Haves, L. K. Norford, M. DeSimone and L. Mei,
<i>A Standard Simulation Testbed for the Evaluation of Control Algorithms &amp; Strategies</i>,
ASHRAE Final Report 825-RP, Atlanta, GA.
</p>
</html>", revisions="<html>
<ul>
<li>
December 23, 2019, by Antoine Gautier:<br/>
Added the pressure drop calculation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1188\">#1188</a>.
</li>
<li>
March 22, 2017, by Michael Wetter:<br/>
Updated documentation.
</li>
<li>
April 14, 2014 by Michael Wetter:<br/>
Improved documentation.
</li>
<li>
September 26, 2013 by Michael Wetter:<br/>
Moved assignment of <code>kDam_default</code> and <code>kThetaSqRt_default</code>
from <code>initial algorithm</code> to the variable declaration, to avoid a division
by zero in OpenModelica.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li>
June 22, 2008 by Michael Wetter:<br/>
Extended range of control signal from 0 to 1 by implementing the function
<a href=\"modelica://IBPSA.Fluid.Actuators.BaseClasses.exponentialDamper\">
IBPSA.Fluid.Actuators.BaseClasses.exponentialDamper</a>.
</li>
<li>
June 10, 2008 by Michael Wetter:<br/>
Introduced new partial base class,
<a href=\"modelica://IBPSA.Fluid.Actuators.BaseClasses.PartialDamperExponential\">
PartialDamperExponential</a>.
</li>
<li>
June 30, 2007 by Michael Wetter:<br/>
Introduced new partial base class,
<a href=\"modelica://IBPSA.Fluid.Actuators.BaseClasses.PartialActuator\">PartialActuator</a>.
</li>
<li>
July 27, 2007 by Michael Wetter:<br/>
Introduced partial base class.
</li>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-100,22},{100,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),  Polygon(
          points={{-26,12},{22,54},{22,42},{-26,0},{-26,12}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid), Polygon(
          points={{-22,-32},{26,10},{26,-2},{-22,-44},{-22,-32}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end Exponential;
