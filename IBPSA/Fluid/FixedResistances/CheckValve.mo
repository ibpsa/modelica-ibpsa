within IBPSA.Fluid.FixedResistances;
model CheckValve "Check valve that avoids flow reversal"
  extends IBPSA.Fluid.BaseClasses.PartialResistance(
    dp(nominal=6000),
    final dp_nominal=dpValve_nominal + dpFixed_nominal,
    final m_flow_turbulent=deltaM*abs(m_flow_nominal),
    final from_dp=true,
    final linearized=false,
    allowFlowReversal=true);
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
  Real a = dp/dpValve_nominal
    "Scaled pressure variable"
    annotation(Inline=true);
  Real cv = smooth(2,max(0,min(1,a^3*(10+a*(-15+6*a)))))
    "Twice differentiable Heaviside check valve characteristic"
    annotation(Inline=true);
  Real kCv = Kv_SI*(cv*(1-l) + l)
    "Smoothed restriction characteristic"
    annotation(Inline=true);
initial equation
  assert(dpFixed_nominal > -Modelica.Constants.eps,
    "In " + getInstanceName() + ": We require dpFixed_nominal >= 0. 
    Received dpFixed_nominal = " + String(dpFixed_nominal) + " Pa.");
  assert(l > -Modelica.Constants.eps,
    "In " + getInstanceName() + ": We require l >= 0. Received l = " + String(l));
equation
  if (dpFixed_nominal > Modelica.Constants.eps) then
    k = sqrt(1/(1/kFixed^2 + 1/kCv^2));
  else
    k = kCv;
  end if;

  if homotopyInitialization then
    m_flow = homotopy(
      actual=IBPSA.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
            dp = dp,
            k = k,
            m_flow_turbulent = m_flow_turbulent),
      simplified = m_flow_nominal_pos*dp/dp_nominal_pos);
  else
    m_flow = IBPSA.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
        dp = dp,
        k = k,
        m_flow_turbulent = m_flow_turbulent);
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
        Polygon(
          points={{100,-42},{-100,-42},{-100,40},{100,40},{100,-42}},
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
<p>
Implementation of a hydraulic check valve. 
</p>
<h4>Main equations</h4>
<p>
The basic flow function <a href=\"modelica://IBPSA.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp\">
IBPSA.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp</a> 
is used with a pressure drop dependent flow coefficient <code>k</code>,
which becomes small for negative pressure differences. 
The flow coefficient is computed using a twice differentiable Heaviside function,
which increases the flow coefficient from <code>l*KV_Si</code> to <code>KV_Si</code>.
The flow coefficient saturates to its maximum value at 10 % of <code>dp_nominal</code>.
</p>
<h4>Typical use and important parameters</h4>
<p>
The parameters <code>m_flow_nominal</code> and <code>dp_nominal</code> 
determine the pressure drop of the check valve when it is fully opened. 
<code>dp_nominal</code>  should therefore not have a large value.
The leakage ratio <code>l</code> determines the flow coefficient when a reverse differential pressure exists.
</p>
</html>", revisions="<html>
<ul>
<li>
September 16, 2019, by Kristoff Six and Filip Jorissen:<br/>
Implementation of a hydraulic check valve. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1198\">issue 1198</a>.
</li>
</ul>
</html>"));
end CheckValve;
