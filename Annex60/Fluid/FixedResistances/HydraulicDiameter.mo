within Annex60.Fluid.FixedResistances;
model HydraulicDiameter "Fixed flow resistance with hydraulic diameter and m_flow as parameter"
  extends Annex60.Fluid.FixedResistances.FixedResistanceDpM(
    final deltaM =  eta_default*dh/4*Modelica.Constants.pi*ReC/m_flow_nominal_pos,
    final dp_nominal=fac*dpStraightPipe_nominal);

  parameter Modelica.SIunits.Length dh=sqrt(4*m_flow_nominal/rho_default/v_nominal/Modelica.Constants.pi)
    "Hydraulic diameter (assuming a round cross section area)";

  parameter Modelica.SIunits.Length length "Length of the pipe";

  parameter Real ReC(min=0)=4000
    "Reynolds number where transition to turbulent starts";

  parameter Modelica.SIunits.Velocity v_nominal = 0.15
    "Velocity at m_flow_nominal (used to compute default diameter)"
    annotation(Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.Length roughness(min=0) = 2.5e-5
    "Absolute roughness of pipe, with a default for a smooth steel pipe (dummy if use_roughness = false)";

  parameter Real fac(min=1) = 2
    "Factor to take into account resistance of bends etc., fac=dp_nominal/dpStraightPipe_nominal";

  final parameter Modelica.SIunits.PressureDifference dpStraightPipe_nominal(displayUnit="Pa")=
      Modelica.Fluid.Pipes.BaseClasses.WallFriction.Detailed.pressureLoss_m_flow(
      m_flow=m_flow_nominal,
      rho_a=rho_default,
      rho_b=rho_default,
      mu_a=mu_default,
      mu_b=mu_default,
      length=length,
      diameter=dh,
      roughness=roughness,
      m_flow_small=m_flow_small)
    "Pressure loss of a straight pipe at m_flow_nominal";

protected
  parameter Modelica.Media.Interfaces.PartialMedium.ThermodynamicState state_default=
    Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default[1:Medium.nXi]) "Default state";

  parameter Modelica.SIunits.Density rho_default = Medium.density(state_default)
    "Density at nominal condition";

  parameter Modelica.SIunits.DynamicViscosity mu_default = Medium.dynamicViscosity(
      state_default)
    "Dynamic viscosity at nominal condition";

initial equation
 assert(m_flow_nominal_pos > m_flow_turbulent,
   "In FixedResistanceDpM, m_flow_nominal is smaller than m_flow_turbulent.
  m_flow_nominal = " + String(m_flow_nominal) + "
  dh      = " + String(dh) + "
 To correct it, set dh < " +
     String(     4*m_flow_nominal/eta_default/Modelica.Constants.pi/ReC) + "
  Suggested value:   dh = " +
                String(1/10*4*m_flow_nominal/eta_default/Modelica.Constants.pi/ReC),
                AssertionLevel.warning);

annotation (defaultComponentName="res",
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
where <code>m_flow_nominal</code> is a parameter
are parameters.
By default, the parameter <code>dp_nominal = fac * dpStraightPipe_nominal</code>,
where <code>dpStraightPipe_nominal</code> is a parameter that is automatically computed
based on the
nominal mass flow rate, hydraulic diameter and pipe roughness.
The factor <code>fac</code> takes into account additional resistances such as
from bends, and can be changed by the user.
</p>
<p>
In the region
<code>abs(m_flow) &lt; m_flow_turbulent</code>,
the square root is replaced by a differentiable function
with finite slope.
The value of <code>m_flow_turbulent</code> is
computed as
<code>m_flow_turbulent = eta_nominal*dh/4*&pi;*ReC</code>,
where
<code>eta_nominal</code> is the dynamic viscosity, obtained from
the medium model. The parameter
<code>dh</code> is the hydraulic diameter and
<code>ReC=4000</code> is the critical Reynolds number, which both
can be set by the user.
</li>
</ul>
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
<p>
For a model that uses <code>dp_nominal</code> as a parameter rather than
geoemetric data, use
<a href=\"modelica://Annex60.Fluid.FixedResistances.FixedResistanceDpM\">
Annex60.Fluid.FixedResistances.FixedResistanceDpM</a>.
</p>
<h4>Implementation</h4>
<p>
The pressure drop is computed by calling a function in the package
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels\">
Buildings.Fluid.BaseClasses.FlowModels</a>,
This package contains regularized implementations of the equation
</p>
<p align=\"center\" style=\"font-style:italic;\">
  m = sign(&Delta;p) k  &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;</span>
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
December 1, 2016, by Michael Wetter:<br/>
First implementation for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/480\">#480</a>.
</li>
</ul>
</html>"),
  Icon(graphics={Text(
          extent={{-40,24},{38,-14}},
          lineColor={255,255,255},
          textString="dh")}));
end HydraulicDiameter;
