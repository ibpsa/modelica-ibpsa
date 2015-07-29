within Annex60.Fluid.BaseClasses.FlowModels.Validation;
model BasicFlowFunction_m_flow_DerivativeCheck
  "Model that checks the correct implementation of the derivative of the flow function"
  extends Modelica.Icons.Example;

  constant Real gain = 1 "Gain for computing the mass flow rate";

  parameter Real k = 0.35 "Flow coefficient";
  parameter Modelica.SIunits.MassFlowRate m_flow_turbulent = 0.36
    "Mass flow rate where transition to turbulent flow occurs";
  Modelica.SIunits.MassFlowRate m_flow "Mass flow rate";
  Modelica.SIunits.Pressure dp "Pressure drop";
  Modelica.SIunits.Pressure dp_comp "Comparison value for dp";

initial equation
 dp = dp_comp;
equation
  m_flow = time*gain;
  dp = Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
    m_flow=m_flow,
    k=  k,
    m_flow_turbulent=m_flow_turbulent);
  der(dp) = der(dp_comp);
  assert(abs(dp-dp_comp) < 1E-3, "Error in implementation.");
annotation (
experiment(StartTime=-1, StopTime=1.0),
__Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Fluid/BaseClasses/FlowModels/Validation/BasicFlowFunction_m_flow_DerivativeCheck.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model validates the implementation of
<a href=\"modelica://Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow\">
Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow</a>
and its first order derivative
<a href=\"modelica://Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_der\">
Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_der</a>.
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
end BasicFlowFunction_m_flow_DerivativeCheck;
