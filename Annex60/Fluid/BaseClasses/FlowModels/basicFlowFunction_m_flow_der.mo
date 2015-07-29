within Annex60.Fluid.BaseClasses.FlowModels;
function basicFlowFunction_m_flow_der "Derivative of flow function"
  input Modelica.SIunits.MassFlowRate m_flow
    "Mass flow rate in design flow direction";
  input Real k(unit="")
    "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  input Modelica.SIunits.MassFlowRate m_flow_turbulent(min=0) "Mass flow rate";
  input Real m_flow_der(unit="kg/s2") "Mass flow rate in design flow direction";
  output Real dp_der
    "Derivative of pressure difference between port_a and port_b (= port_a.p - port_b.p)";
algorithm
 dp_der :=(if (m_flow>m_flow_turbulent) then 2 * m_flow/k^2 else
         if (m_flow<-m_flow_turbulent) then -2 * m_flow/k^2 else
            (m_flow_turbulent+3*m_flow^2/m_flow_turbulent)/2/k^2) * m_flow_der;

 annotation (LateInline=true,
             smoothOrder=1,
             Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Line(
          points={{-80,-40},{-80,60},{80,-40},{80,60}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=1), Text(
          extent={{-40,-40},{40,-80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={232,0,0},
          textString="%name")}),
Documentation(info="<html>
<p>
Function that implements the first order derivative of
<a href=\"modelica://Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow\">
Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow</a>
with respect to the mass flow rate.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 29, 2015, by Michael Wetter:<br/>
First implementation to avoid in Dymola 2016 the warning
\"Differentiating ... under the assumption that it is continuous at switching\".
</li>
</ul>
</html>"));
end basicFlowFunction_m_flow_der;
