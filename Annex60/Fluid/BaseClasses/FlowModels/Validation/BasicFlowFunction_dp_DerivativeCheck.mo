within Annex60.Fluid.BaseClasses.FlowModels.Validation;
model BasicFlowFunction_dp_DerivativeCheck
  "Model that checks the correct implementation of the derivative of the flow function"
  extends Modelica.Icons.Example;

  constant Real gain = 1 "Gain for computing the mass flow rate";

  parameter Real k = 0.35 "Flow coefficient";
  parameter Modelica.SIunits.MassFlowRate m_flow_turbulent = 0.36
    "Mass flow rate where transition to turbulent flow occurs";
  Modelica.SIunits.MassFlowRate m_flow "Mass flow rate";
  Modelica.SIunits.MassFlowRate m_flow_comp "Comparison value for m_flow";
  Modelica.SIunits.Pressure dp "Pressure drop";

initial equation
 m_flow = m_flow_comp;
equation
  dp = time*gain;
  m_flow = Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
    dp=dp,
    k=  k,
    m_flow_turbulent=m_flow_turbulent);
  der(m_flow) = der(m_flow_comp);
  assert(abs(m_flow-m_flow_comp) < 1E-3, "Error in implementation.");
annotation (
experiment(StartTime=-1, StopTime=1.0),
__Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Fluid/BaseClasses/FlowModels/Validation/BasicFlowFunction_dp_DerivativeCheck.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model validates the implementation of
<a href=\"modelica://Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp\">
Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp</a>
and its first order derivative
<a href=\"modelica://Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der\">
Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der</a>.
If the derivative implementation is wrong, the simulation will stop with an error.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 29, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end BasicFlowFunction_dp_DerivativeCheck;
