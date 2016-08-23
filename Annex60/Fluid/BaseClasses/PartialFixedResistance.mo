within Annex60.Fluid.BaseClasses;
partial model PartialFixedResistance "Partial fixed flow resistance"
  extends Annex60.Fluid.BaseClasses.PartialResistance;

  final parameter Real k(unit="") = if computeFlowResistance then
    m_flow_nominal_pos/sqrt(dp_nominal_pos) else 0
    "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
protected
  final parameter Boolean computeFlowResistance=(dp_nominal_pos > Modelica.Constants.eps)
    "Flag to enable/disable computation of flow resistance"
    annotation (Evaluate=true);
initial equation
  if computeFlowResistance then
    assert(m_flow_turbulent > 0, "m_flow_turbulent must be bigger than zero.");
  end if;

  assert(m_flow_nominal_pos > 0, "m_flow_nominal_pos must be non-zero. Check parameters.");

equation
  // Pressure drop calculation
  if computeFlowResistance then
    if linearized then
      m_flow*m_flow_nominal_pos = k^2*dp;
    else
      if homotopyInitialization then
        if from_dp then
          m_flow = homotopy(actual=
            Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
            dp=dp,
            k=k,
            m_flow_turbulent=m_flow_turbulent), simplified=m_flow_nominal_pos*
            dp/dp_nominal_pos);
        else
          dp = homotopy(actual=
            Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
            m_flow=m_flow,
            k=k,
            m_flow_turbulent=m_flow_turbulent), simplified=dp_nominal_pos*
            m_flow/m_flow_nominal_pos);
        end if;
        // from_dp
      else
        // do not use homotopy
        if from_dp then
          m_flow = Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
            dp=dp,
            k=k,
            m_flow_turbulent=m_flow_turbulent);
        else
          dp = Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
            m_flow=m_flow,
            k=k,
            m_flow_turbulent=m_flow_turbulent);
        end if;
        // from_dp
      end if;
      // homotopyInitialization
    end if;
    // linearized
  else
    // do not compute flow resistance
    dp = 0;
  end if;
  // computeFlowResistance

  annotation (
    defaultComponentName="res",
    Documentation(info="<html>
<p>
This is a model of a resistance with a fixed flow coefficient.
The mass flow rate is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
m&#775; = k
&radic;<span style=\"text-decoration:overline;\">&Delta;P</span>,
</p>
<p>
where
<i>k</i> is a constant and
<i>&Delta;P</i> is the pressure drop.
The constant <i>k</i> is equal to
<code>k=m_flow_nominal/sqrt(dp_nominal)</code>,
where <code>m_flow_nominal</code> and <code>dp_nominal</code>
are parameters.
In the region
<code>abs(m_flow) &lt; m_flow_turbulent</code>,
the square root is replaced by a differentiable function
with finite slope.
The value of 
<code>
m_flow_turbulent</code> is computed in <code>

Annex60.Fluid.FixedResistances.FixedResistance_dp</code> 
or in <code>
Annex60.Fluid.FixedResistances.FixedResistance_dh</code>.
</p>

<p>
If the parameter
<code>show_T</code> is set to <code>true</code>,
then the model will compute the
temperature at its ports. Note that this can lead to state events
when the mass flow rate approaches zero,
which can increase computing time.
</p>
<p>
The parameter <code>from_dp</code> is used to determine
whether the mass flow rate is computed as a function of the
pressure drop (if <code>from_dp=true</code>), or vice versa.
This setting can affect the size of the nonlinear system of equations.
</p>
<p>
If the parameter <code>linearized</code> is set to <code>true</code>,
then the pressure drop is computed as a linear function of the
mass flow rate.
</p>
<p>
Setting <code>allowFlowReversal=false</code> can lead to simpler
equations. However, this should only be set to <code>false</code>
if one can guarantee that the flow never reverses its direction.
This can be difficult to guarantee, as pressure imbalance after
the initialization, or due to medium expansion and contraction,
can lead to reverse flow.
</p>
<h4>Notes</h4>
<p>
For more detailed models that compute the actual flow friction,
models from the package
<a href=\"modelica://Modelica.Fluid\">
Modelica.Fluid</a>
can be used and combined with models from the
<code>Annex60</code> library.
</p>
<h4>Implementation</h4>
<p>
The pressure drop is computed by calling a function in the package
<a href=\"modelica://Annex60.Fluid.BaseClasses.FlowModels\">
Annex60.Fluid.BaseClasses.FlowModels</a>,
This package contains regularized implementations of the equation
</p>
<p align=\"center\" style=\"font-style:italic;\">
  m = sign(&Delta;p) k  &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;
</p>
<p>
and its inverse function.
</p>
<p>
To decouple the energy equation from the mass equations,
the pressure drop is a function of the mass flow rate,
and not the volume flow rate.
This leads to simpler equations.
</p>
</html>", revisions="<html>
<ul>
<li>
July 7, 2016 by Bram van der Heijde:<br/>
Moved from <code>Annex60.Fluid.FixedResistances.FixedResistanceDpM</code> 
to <code>Annex60.Fluid.BaseClasses.PartialFixedResistance</code>. 
Moved parameters <code>ReC</code>, <code>dh</code> and <code>use_dh</code> 
to <code>FixedResistance_dp</code>. Moved parameter <code>Delta_M</code> and 
<code>assert(dh)</code>to <code>FixedResistance_dh</code>.
</li>
<li>
November 26, 2014, by Michael Wetter:<br/>
Added the required <code>annotation(Evaluate=true)</code> so
that the system of nonlinear equations in
<a href=\"modelica://Annex60.Fluid.FixedResistances.Examples.FixedResistancesExplicit\">
Annex60.Fluid.FixedResistances.Examples.FixedResistancesExplicit</a>
remains the same.
</li>
<li>
November 20, 2014, by Michael Wetter:<br/>
Rewrote the warning message using an <code>assert</code> with
<code>AssertionLevel.warning</code>
as this is the proper way to write warnings in Modelica.
</li>
<li>
August 5, 2014, by Michael Wetter:<br/>
Corrected error in documentation of computation of <code>k</code>.
</li>
<li>
May 29, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
October 8, 2013, by Michael Wetter:<br/>
Removed parameter <code>show_V_flow</code>.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li>
January 16, 2012 by Michael Wetter:<br/>
To simplify object inheritance tree, revised base classes
<code>Annex60.Fluid.BaseClasses.PartialResistance</code>,
<code>Annex60.Fluid.Actuators.BaseClasses.PartialTwoWayValve</code>,
<code>Annex60.Fluid.Actuators.BaseClasses.PartialDamperExponential</code>,
<code>Annex60.Fluid.Actuators.BaseClasses.PartialActuator</code>
and model
<code>Annex60.Fluid.FixedResistances.FixedResistanceDpM</code>.
</li>
<li>
May 30, 2008 by Michael Wetter:<br/>
Added parameters <code>use_dh</code> and <code>deltaM</code> for easier parameterization.
</li>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Text(
          extent={{-102,86},{-4,22}},
          lineColor={0,0,255},
          textString="dp_nominal=%dp_nominal"), Text(
          extent={{-106,106},{6,60}},
          lineColor={0,0,255},
          textString="m0=%m_flow_nominal")}));
end PartialFixedResistance;
