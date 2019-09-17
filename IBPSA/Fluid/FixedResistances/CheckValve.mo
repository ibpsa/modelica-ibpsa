within IBPSA.Fluid.FixedResistances;
model CheckValve "Hydraulic one way valve"

  extends IBPSA.Fluid.BaseClasses.PartialResistance(
    dp(nominal=6000),
    final dp_nominal=dpValve_nominal + dpFixed_nominal,
    final m_flow_turbulent=deltaM*abs(m_flow_nominal),
    final from_dp=true,
    final linearized=false);

  extends IBPSA.Fluid.Actuators.BaseClasses.ValveParameters(
    rhoStd=Medium.density_pTX(101325, 273.15 + 4, Medium.X_default));

  parameter Modelica.SIunits.PressureDifference dpFixed_nominal(
    displayUnit="Pa", min=0) = 0
    "Pressure drop of pipe and other resistances that are in series"
    annotation (Dialog(group="Nominal condition"));

  parameter Real l(min=1e-10, max=1)=0.001 "Valve leakage, l=Kv(y=0)/Kv(y=1)";

  parameter Real kFixed(unit="", min=0)=
    if dpFixed_nominal > Modelica.Constants.eps then
      m_flow_nominal/sqrt(dpFixed_nominal)
    else 0
    "Flow coefficient of fixed resistance that may be in series with valve, 
    k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2).";

  Real k(unit="", min=Modelica.Constants.small)
    "Flow coefficient of valve and pipe in series in allowed/forward direction, 
    k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2).";

protected
  Real a     "Pressure scaled variable";
  Real cv    "Smoothed heaviside checkvalve characteristic";
  Real kstar "Smoothed restriction characteristic";

initial equation
  assert(dpFixed_nominal > -Modelica.Constants.eps,
    "In " + getInstanceName() + ": Require dpFixed_nominal >= 0. 
    Received dpFixed_nominal = " + String(dpFixed_nominal) + " Pa.");

  assert(l > -Modelica.Constants.eps,
    "In " + getInstanceName() + ": Require l >= 0. Received l = " + String(l));

equation

  a = dp/dpValve_nominal;
  cv = max(0,min(1,a^3*(10+a*(-15+6*a)))); // update this to call
  //IBPSA.Utilities.Math.Functions.smoothHeaviside when issue 1202 is merged
  kstar = Kv_SI*(cv + l);

  // add series restriction when applicable
  if (dpFixed_nominal > Modelica.Constants.eps) then
    k = sqrt(1/(1/kFixed^2 + 1/kstar^2));
  else
    k = kstar;
  end if;

  if homotopyInitialization then m_flow = homotopy(actual=
      IBPSA.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
        dp = dp, k = k, m_flow_turbulent = m_flow_turbulent),
      simplified = if dp > 0 then k*dp else k*l*dp);
  else
    // do not use homotopy
    m_flow = IBPSA.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
      dp = dp, k = k, m_flow_turbulent = m_flow_turbulent);
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
        Polygon(
          points={{-100,-100},{-100,100},{100,100},{100,-100}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,0},{-70,0}},
          color={0,128,255},
          lineThickness=0.5),
        Line(
          points={{0,70},{-70,0}},
          color={0,128,255},
          lineThickness=0.5),
        Line(
          points={{0,-70},{-70,0}},
          color={0,128,255},
          lineThickness=0.5),
        Ellipse(
          extent={{-40,-55},{70,55}},
          lineColor={0,128,255},
          fillColor={255,255,255},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid),
        Line(
          points={{70,0},{100,0}},
          color={0,128,255},
          lineThickness=0.5)}), Documentation(info="<html>
<p>Implementation of a hydraulic check valve. </p>
<h4>Main equations</h4>
<p>The basic flow function <code>IBPSA.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp</code> 
is used with a pressure drop specific <code>k</code> factor. The latter is a combination of the 
actual check valve characteristic <code>kstar</code>, in series with the optional fixed restriction 
<code>kFixed</code>.</p>
<p>
<code>k = sqrt(1/(1/kstar^2 + l/kFixed^2))</code>
</p>
<p><code>kstar</code> is modeled as fixed restriction 
<code>Kv_SI</code> activated only in forward flow direction by a Heaviside function <code>cv</code>, in parallel with a 
very high restriction, defined with the leakage ratio <code>l</code> with respect to the check valve 
restrictive characteristic <code>Kv_SI</code>. The latter achieves a small gradient over the whole characteristic, 
helping the solver.
<p>
<code>kstar = Kv_SI*(cv + l)</code>
</p>
<p>
<code>cv</code> is calculated from a twice differentiable smooth Heaviside function 
<code>IBPSA.Utilities.Math.Functions.smoothHeaviside</code> with the normalized pressure as input.
</p>
<h4>Assumption and limitations</h4>
<p>The cracking pressure of the valve is defined as a fixed ratio defined by the Heaviside function with respect to the nominal pressure.</p>
<h4>Typical use and important parameters</h4>
<p>
<code>m_flow_nominal</code> together with <code>dp_nominal</code> determine where the check valve is completely opened.</p>

The leakage ratio <code>l</code> defines the overall leakage restriction with respect to <code>Kv_SI</code>

<!-- <h4>Validation</h4>
<p>Describe whether the validation was done using analytical validation, comparative model validation or empirical validation. </p>
<h4>Implementation</h4>
<p>xxx </p>
<h4>References</h4>
<p>xxx </p>
-->
</html>", revisions="<html>
<ul>
<li>
September 16, 2019, by Kristoff Six:<br/>
Implementation of a hydraulic check valve. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1198\">issue 1198</a>.
</li>
</ul>
</html>"));
end CheckValve;
