within IBPSA.Fluid.BaseClasses.FlowModels;
function basicFlowFunction_inv
  "Inverse of flow function that computes the flow coefficient"

  input Modelica.SIunits.MassFlowRate m_flow
    "Mass flow rate in design flow direction";
  input Modelica.SIunits.PressureDifference dp
    "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";
  input Modelica.SIunits.MassFlowRate m_flow_small
    "Minimal value of mass flow rate guarding against k=(0)/sqrt(dp)";
  input Modelica.SIunits.PressureDifference dp_small
    "Minimal value of pressure drop guarding against k=m_flow/(0)";
  output Real k
    "Flow coefficient";
protected
  Modelica.SIunits.PressureDifference dpSqrt
    "Regularized square root value of pressure drop";
  Modelica.SIunits.MassFlowRate mPos_flow
    "Regularized absolute value of mass flow rate";
algorithm
  dpSqrt := IBPSA.Utilities.Math.Functions.regNonZeroPower(
    dp, 0.5, dp_small);
  mPos_flow := IBPSA.Utilities.Math.Functions.regNonZeroPower(
    dp, 1, m_flow_small);
  k := mPos_flow / dpSqrt;
annotation (
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
  -100},{100,100}}), graphics={Line(
  points={{-80,-40},{-80,60},{80,-40},{80,60}},
  color={0,0,255},
  thickness=1), Text(
  extent={{-40,-40},{40,-80}},
  lineColor={0,0,0},
  fillPattern=FillPattern.Sphere,
  fillColor={232,0,0},
  textString="%name")}),
Documentation(info="<html>
<p>
Function that computes the flow coefficient from the flow rate and pressure drop values.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 19, 2019, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end basicFlowFunction_inv;
